import unittest
from decimal import Decimal
from unittest.mock import Mock, patch

from app import app as flask_app, crear_cotizacion_operativa_acordada


class FakeCursor:
    def __init__(self, quote):
        self.quote = quote
        self.statement = ""
        self.statements = []

    def execute(self, statement, params=None):
        self.statement = statement
        self.statements.append((statement, params))

    def fetchone(self):
        if "SELECT id_lote" in self.statement:
            return {"id_lote": self.quote["id_lote"]}
        if "SELECT estado, produccion_max" in self.statement:
            return {
                "estado": "DISPONIBLE",
                "produccion_max": Decimal("1000"),
            }
        if "SELECT *" in self.statement and "cotizaciones_comerciales" in self.statement:
            return self.quote.copy()
        if "SELECT l.produccion_max" in self.statement:
            return {
                "produccion_max": Decimal("1000"),
                "id_usuario_comprador": 1,
                "id_usuario_productor": 2,
            }
        if "SELECT id_cotizacion_comercial" in self.statement:
            return None
        return None

    def close(self):
        pass


class OperationalQuoteCursor:
    def __init__(self):
        self.statement = ""
        self.statements = []
        self.rows = [
            {"id_direccion": 7},
            {"comision": Decimal("5"), "margen_cosecha": Decimal("5"),
             "margen_transporte": Decimal("5")},
        ]
        self.lastrowid = 987

    def execute(self, statement, params=None):
        self.statement = statement
        self.statements.append((statement, params))

    def fetchone(self):
        return self.rows.pop(0)


class ReservationCursor:
    def __init__(self):
        self.statement = ""
        self.statements = []
        self.rowcount = 0

    def execute(self, statement, params=None):
        self.statement = statement
        self.statements.append((statement, params))
        self.rowcount = 1 if "UPDATE lotes" in statement else 0

    def fetchone(self):
        if "SELECT estado" in self.statement and "FROM lotes" in self.statement:
            return {"estado": "DISPONIBLE"}
        if "FROM cotizaciones_operacion" in self.statement:
            if len([
                sql for sql, _ in self.statements
                if "FROM cotizaciones_operacion" in sql
            ]) == 1:
                return None
            return {
                "id_cotizacion_operacion": 123,
                "fecha_vencimiento": "2099-01-01 00:00:00",
            }
        if "SELECT id_cotizacion_comercial, id_lote" in self.statement:
            return {
                "id_cotizacion_comercial": 31,
                "id_lote": 9,
                "id_comprador": 4,
                "cantidad_kg": Decimal("100"),
                "precio_unitario_kg": Decimal("5"),
            }
        return None

    def close(self):
        pass


class CommercialQuoteTests(unittest.TestCase):
    def setUp(self):
        flask_app.config["TESTING"] = True
        self.client = flask_app.test_client()
        with self.client.session_transaction() as user_session:
            user_session["user_id"] = 1
            user_session["_csrf_token"] = "test-csrf-token"

    @staticmethod
    def identity():
        return [{"nombre_rol": "COMPRADOR", "codigo_permiso": None}]

    @staticmethod
    def quote():
        return {
            "id_cotizacion_comercial": 31,
            "id_lote": 9,
            "id_comprador": 4,
            "id_cotizacion_operacion": None,
            "cantidad_kg": Decimal("100"),
            "precio_unitario_kg": Decimal("5"),
            "version": 1,
            "ultimo_ofertante": "PRODUCTOR",
            "aceptacion_comprador_version": None,
            "aceptacion_productor_version": 1,
            "estado": "NEGOCIACION",
        }

    @patch("app.query", return_value=[])
    def test_lot_search_is_available_in_english(self, query):
        with self.client.session_transaction() as user_session:
            user_session["idioma"] = "en"

        response = self.client.get("/lotes?buscar=potato")
        page = response.get_data(as_text=True)

        self.assertEqual(response.status_code, 200)
        self.assertIn("Browse available products and see who is offering them.", page)
        self.assertIn("Product or producer", page)
        self.assertIn("Category", page)
        self.assertIn("Location", page)
        self.assertEqual(
            query.call_args_list[0].args[1],
            (
                "potato", "%potato%", "%potato%", "%potato%",
                None, None, "", "%%", None, None,
            )
        )

    @patch("app.query")
    def test_quote_inbox_is_available_in_english(self, query):
        with self.client.session_transaction() as user_session:
            user_session["idioma"] = "en"
        query.side_effect = [self.identity(), []]

        response = self.client.get("/mis-cotizaciones")
        page = response.get_data(as_text=True)

        self.assertEqual(response.status_code, 200)
        self.assertIn("My quotes", page)
        self.assertIn("Review requests, offers, and agreements with the other party.", page)

    def test_operational_quote_insert_has_matching_placeholders(self):
        cursor = OperationalQuoteCursor()
        agreement = {
            "id_comprador": 4,
            "id_lote": 9,
            "cantidad_kg": Decimal("100"),
            "precio_unitario_kg": Decimal("5"),
        }

        result = crear_cotizacion_operativa_acordada(cursor, agreement)

        statement, params = cursor.statements[-1]
        self.assertEqual(result, 987)
        self.assertEqual(statement.count("%s"), len(params))

    @patch("app.crear_cotizacion_operativa_acordada", return_value=123)
    @patch("app.get_connection")
    @patch("app.query")
    def test_expired_quote_can_be_rebuilt_from_the_agreement_for_reservation(
        self, query, get_connection, create_quote
    ):
        query.side_effect = [
            self.identity(),
            {"id_comprador": 4},
        ]
        cursor = ReservationCursor()
        connection = Mock()
        connection.cursor.return_value = cursor
        get_connection.return_value = connection

        response = self.client.post(
            "/lotes/9/reservar",
            data={"csrf_token": "test-csrf-token"},
        )

        self.assertEqual(response.status_code, 302)
        create_quote.assert_called_once()
        self.assertTrue(any("INSERT INTO reservas_lote" in sql for sql, _ in cursor.statements))
        connection.commit.assert_called_once()

    @patch("app.crear_notificacion")
    @patch("app.crear_cotizacion_operativa_acordada", return_value=456)
    @patch("app.get_connection")
    @patch("app.query")
    def test_second_party_acceptance_records_the_bilateral_agreement(
        self, query, get_connection, create_quote, notify
    ):
        query.side_effect = [
            self.identity(),
            {
                **self.quote(),
                "codigo_cotizacion": "NEG-TEST",
                "codigo_lote": "LOT-1",
                "producto": "Papa",
                "comprador": "Comprador",
                "productor": "Productor",
                "id_usuario_comprador": 1,
                "id_usuario_productor": 2,
            },
        ]
        cursor = FakeCursor(self.quote())
        connection = Mock()
        connection.cursor.return_value = cursor
        get_connection.return_value = connection

        response = self.client.post(
            "/cotizaciones/31",
            data={"csrf_token": "test-csrf-token", "accion": "aceptar"},
        )

        self.assertEqual(response.status_code, 302)
        create_quote.assert_called_once()
        connection.commit.assert_called_once()
        self.assertTrue(any(
            "SET aceptacion_comprador_version = %s, estado = %s" in statement
            and params[1] == "ACORDADA"
            and params[2] == 456
            for statement, params in cursor.statements
        ))
        notify.assert_called_once()

    @patch("app.get_connection")
    @patch("app.query")
    def test_buyer_cannot_reject_a_quote(self, query, get_connection):
        query.side_effect = [
            self.identity(),
            {
                **self.quote(),
                "codigo_cotizacion": "NEG-TEST",
                "codigo_lote": "LOT-1",
                "producto": "Papa",
                "comprador": "Comprador",
                "productor": "Productor",
                "id_usuario_comprador": 1,
                "id_usuario_productor": 2,
            },
        ]
        cursor = FakeCursor(self.quote())
        connection = Mock()
        connection.cursor.return_value = cursor
        get_connection.return_value = connection

        response = self.client.post(
            "/cotizaciones/31",
            data={"csrf_token": "test-csrf-token", "accion": "rechazar"},
        )

        self.assertEqual(response.status_code, 403)
        connection.rollback.assert_called_once()
        connection.commit.assert_not_called()


if __name__ == "__main__":
    unittest.main()

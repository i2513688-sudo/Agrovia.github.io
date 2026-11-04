import unittest
from decimal import Decimal
from unittest.mock import patch

from app import app as flask_app


class LotRegistrationTests(unittest.TestCase):
    def setUp(self):
        flask_app.config["TESTING"] = True
        self.client = flask_app.test_client()
        with self.client.session_transaction() as user_session:
            user_session["user_id"] = 12
            user_session["_csrf_token"] = "test-csrf-token"

    @staticmethod
    def identity():
        return [{"nombre_rol": "PRODUCTOR", "codigo_permiso": None}]

    @staticmethod
    def producer():
        return {"id_productor": 7}

    @staticmethod
    def valid_submission(**overrides):
        data = {
            "csrf_token": "test-csrf-token",
            "id_producto": "3",
            "modo_predio": "nuevo",
            "nombre_predio": "Parcela Norte",
            "referencia_predio": "A 2 km del pueblo",
            "area_total": "5",
            "unidad_area": "HECTAREA",
            "latitud": "-12.0464",
            "longitud": "-77.0428",
            "area_cultivada": "2",
            "precio_propuesto_kg": "4.25",
            "fecha_siembra": "2026-10-01",
            "fecha_cosecha_estimada_inicio": "",
            "fecha_cosecha_estimada_fin": "",
            "descripcion": "Cultivo de prueba",
        }
        data.update(overrides)
        return data

    @patch("app.query")
    def test_registration_form_includes_map_and_product_quote(self, query):
        query.side_effect = [
            self.identity(),
            self.producer(),
            [{"id_producto": 3, "nombre": "Choclo"}],
            [],
        ]

        response = self.client.get("/solicitar-lote")
        page = response.get_data(as_text=True)

        self.assertEqual(response.status_code, 200)
        self.assertIn('id="parcel-map"', page)
        self.assertIn("precio_propuesto_kg", page)
        self.assertIn("/api/productos/0/cotizacion", page)
        self.assertIn('name="latitud"', page)

    @patch("app.query", return_value=[
        {"nombre_rol": "PRODUCTOR", "codigo_permiso": None}
    ])
    def test_old_farm_page_redirects_to_integrated_lot_form(self, query):
        response = self.client.get("/predios")

        self.assertEqual(response.status_code, 302)
        self.assertEqual(response.location, "/solicitar-lote")
        query.assert_called_once()

    @patch("app.registrar_historial_estado")
    @patch("app.notificar_administradores")
    @patch("app.execute", side_effect=[101, 202])
    @patch("app.query")
    def test_submission_creates_predio_and_saves_proposed_price(
        self, query, execute, notify_admins, history
    ):
        query.side_effect = [
            self.identity(),
            self.producer(),
            [{"id_producto": 3, "nombre": "Choclo"}],
            [],
            {"id_producto": 3},
            None,
            None,
        ]

        response = self.client.post(
            "/solicitar-lote",
            data=self.valid_submission(),
        )

        self.assertEqual(response.status_code, 302)
        self.assertEqual(response.location, "/dashboard")
        self.assertEqual(execute.call_count, 2)
        self.assertIn("INSERT INTO predios", execute.call_args_list[0].args[0])
        self.assertEqual(execute.call_args_list[0].args[1][1], 7)
        self.assertIn("precio_propuesto_kg", execute.call_args_list[1].args[0])
        self.assertEqual(execute.call_args_list[1].args[1][5], Decimal("4.25"))
        notify_admins.assert_called_once()
        history.assert_called_once()

    @patch("app.execute")
    @patch("app.query")
    def test_invalid_coordinates_are_rejected_before_writing(self, query, execute):
        query.side_effect = [
            self.identity(),
            self.producer(),
            [{"id_producto": 3, "nombre": "Choclo"}],
            [],
            {"id_producto": 3},
        ]

        response = self.client.post(
            "/solicitar-lote",
            data=self.valid_submission(latitud="91"),
        )

        self.assertEqual(response.status_code, 200)
        self.assertIn("Revisa los datos del predio", response.get_data(as_text=True))
        execute.assert_not_called()

    @patch("app.query")
    def test_product_quote_endpoint_returns_latest_market_reference(self, query):
        query.side_effect = [
            self.identity(),
            {
                "precio": Decimal("4.3500"),
                "unidad": "KG",
                "mercado": "GMML",
                "zona": "Lima",
                "fuente": "MIDAGRI",
                "fecha_precio": "2026-08-18",
            },
        ]

        response = self.client.get("/api/productos/3/cotizacion")

        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.get_json()["precio"], "4.3500")
        self.assertEqual(response.get_json()["unidad"], "KG")


if __name__ == "__main__":
    unittest.main()

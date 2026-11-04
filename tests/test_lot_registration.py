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
            "id_predio": "4",
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
    def test_registration_form_only_offers_registered_farms(self, query):
        query.side_effect = [
            self.identity(),
            self.producer(),
            [{"id_producto": 3, "nombre": "Choclo"},
             {"id_producto": 17, "nombre": "Otro"}],
            [{"id_predio": 4, "nombre_predio": "Chacra Jarpa",
              "area_total": 5, "unidad_area": "HECTAREA"}],
        ]

        response = self.client.get("/solicitar-lote")
        page = response.get_data(as_text=True)

        self.assertEqual(response.status_code, 200)
        self.assertIn('name="id_predio"', page)
        self.assertIn("Chacra Jarpa", page)
        self.assertNotIn("Registrar un predio nuevo aquí", page)
        self.assertNotIn("Datos del predio nuevo", page)
        self.assertNotIn("Nombre del predio", page)
        self.assertNotIn("Referencia de ubicación", page)
        self.assertNotIn('id="parcel-map"', page)
        self.assertNotIn('name="latitud"', page)
        self.assertNotIn("Google Maps", page)
        self.assertIn("precio_propuesto_kg", page)
        self.assertIn("/api/productos/0/cotizacion", page)
        self.assertIn('name="nombre_producto_personalizado"', page)
        self.assertIn('data-custom-product="true"', page)

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
    def test_submission_uses_registered_predio_and_saves_proposed_price(
        self, query, execute, notify_admins, history
    ):
        query.side_effect = [
            self.identity(),
            self.producer(),
            [{"id_producto": 3, "nombre": "Choclo"}],
            [{"id_predio": 4, "nombre_predio": "Chacra Jarpa",
              "area_total": 5, "unidad_area": "HECTAREA"}],
            {"id_producto": 3, "nombre": "Choclo"},
            {"id_predio": 4, "area_total": 5, "unidad_area": "HECTAREA"},
            None,
        ]

        response = self.client.post(
            "/solicitar-lote",
            data=self.valid_submission(),
        )

        self.assertEqual(response.status_code, 302)
        self.assertEqual(response.location, "/dashboard")
        execute.assert_called_once()
        self.assertIn("INSERT INTO solicitudes_lote", execute.call_args.args[0])
        self.assertEqual(execute.call_args.args[1][2], 4)
        self.assertEqual(execute.call_args.args[1][5], Decimal("4.25"))
        notify_admins.assert_called_once()
        history.assert_called_once()

    @patch("app.execute")
    @patch("app.query")
    def test_submission_rejects_unregistered_predio(self, query, execute):
        query.side_effect = [
            self.identity(),
            self.producer(),
            [{"id_producto": 3, "nombre": "Choclo"}],
            [{"id_predio": 4, "nombre_predio": "Chacra Jarpa",
              "area_total": 5, "unidad_area": "HECTAREA"}],
            {"id_producto": 3, "nombre": "Choclo"},
            None,
        ]

        response = self.client.post(
            "/solicitar-lote",
            data=self.valid_submission(id_predio="999"),
        )

        self.assertEqual(response.status_code, 200)
        self.assertIn("Selecciona un predio activo", response.get_data(as_text=True))
        execute.assert_not_called()

    @patch("app.registrar_historial_estado")
    @patch("app.notificar_administradores")
    @patch("app.execute", side_effect=[101, 202])
    @patch("app.query")
    def test_other_product_name_is_saved_on_lot_request(
        self, query, execute, notify_admins, history
    ):
        query.side_effect = [
            self.identity(),
            self.producer(),
            [{"id_producto": 17, "nombre": "Otro"}],
            [{"id_predio": 4, "nombre_predio": "Chacra Jarpa",
              "area_total": 5, "unidad_area": "HECTAREA"}],
            {"id_producto": 17, "nombre": "Otro"},
            {"id_predio": 4, "area_total": 5, "unidad_area": "HECTAREA"},
            None,
        ]

        response = self.client.post(
            "/solicitar-lote",
            data=self.valid_submission(
                id_producto="17",
                nombre_producto_personalizado="Camote amarillo",
            ),
        )

        self.assertEqual(response.status_code, 302)
        self.assertIn(
            "nombre_producto_personalizado",
            execute.call_args.args[0],
        )
        self.assertEqual(execute.call_args.args[1][-1], "Camote amarillo")
        notify_admins.assert_called_once()
        history.assert_called_once()

    @patch("app.execute")
    @patch("app.query")
    def test_other_product_requires_a_custom_name(self, query, execute):
        query.side_effect = [
            self.identity(),
            self.producer(),
            [{"id_producto": 17, "nombre": "Otro"}],
            [],
            {"id_producto": 17, "nombre": "Otro"},
        ]

        response = self.client.post(
            "/solicitar-lote",
            data=self.valid_submission(id_producto="17"),
        )

        self.assertEqual(response.status_code, 200)
        self.assertIn("Revisa el producto", response.get_data(as_text=True))
        self.assertRegex(
            response.get_data(as_text=True),
            r'<option value="17"\s+selected',
        )
        execute.assert_not_called()

    @patch("app.execute")
    @patch("app.query")
    def test_submission_requires_registered_predio(self, query, execute):
        query.side_effect = [
            self.identity(),
            self.producer(),
            [{"id_producto": 3, "nombre": "Choclo"}],
            [{"id_predio": 4, "nombre_predio": "Chacra Jarpa",
              "area_total": 5, "unidad_area": "HECTAREA"}],
            {"id_producto": 3, "nombre": "Choclo"},
        ]

        response = self.client.post(
            "/solicitar-lote",
            data=self.valid_submission(id_predio=""),
        )

        self.assertEqual(response.status_code, 200)
        self.assertIn("Selecciona un predio activo", response.get_data(as_text=True))
        execute.assert_not_called()

    @patch("app.query", return_value=[
        {"departamento": "Junín"},
        {"departamento": "Lima"},
    ])
    def test_department_api_lists_active_departments(self, query):
        response = self.client.get("/api/ubigeos/departamentos")

        self.assertEqual(response.status_code, 200)
        self.assertEqual(
            response.get_json(),
            [{"departamento": "Junín"}, {"departamento": "Lima"}],
        )
        self.assertIn("SELECT DISTINCT departamento", query.call_args.args[0])

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

import unittest
from unittest.mock import patch

from app import app as flask_app


class MarketplaceCatalogTests(unittest.TestCase):
    def setUp(self):
        flask_app.config["TESTING"] = True
        self.client = flask_app.test_client()

    @patch("app.query")
    def test_product_catalog_filters_by_name_category_and_location(self, query):
        query.side_effect = [
            [{"id_producto": 4, "nombre": "Ajo", "categoria": "Hortalizas",
              "lotes_disponibles": 2, "precio_minimo": 3.5}],
            [{"id_categoria": 2, "nombre": "Hortalizas"}],
        ]

        response = self.client.get(
            "/productos?buscar=ajo&categoria=2&ubicacion=Junin"
        )

        self.assertEqual(response.status_code, 200)
        self.assertIn("Ajo", response.get_data(as_text=True))
        params = query.call_args_list[0].args[1]
        self.assertEqual(
            params,
            ("Junin", "%Junin%", "%ajo%", 2, 2, "Junin")
        )

    @patch("app.query")
    def test_lot_search_can_filter_category_and_location(self, query):
        query.side_effect = [
            [],
            [{"id_categoria": 2, "nombre": "Hortalizas"}],
        ]

        response = self.client.get(
            "/lotes?buscar=ajo&categoria=2&ubicacion=Junin"
        )

        self.assertEqual(response.status_code, 200)
        self.assertIn('name="ubicacion"', response.get_data(as_text=True))
        params = query.call_args_list[0].args[1]
        self.assertEqual(
            params,
            ("ajo", "%ajo%", "%ajo%", "%ajo%", 2, 2,
             "Junin", "%Junin%", None, None)
        )

    @patch("app.query", return_value={
        "id_lote": 8, "id_producto": 4, "codigo_lote": "LOT-8",
        "producto": "Ajo", "categoria": "Hortalizas",
        "precio_propuesto_kg": 3.25, "produccion_min": 30,
        "produccion_max": 50, "estado": "DISPONIBLE",
        "estado_cultivo_comercial": "LISTO_COSECHA",
        "calidad_verificada": "BUENO", "distrito": "Huancayo",
        "provincia": "Huancayo", "departamento": "Junín",
        "nombre_predio": "Parcela Norte", "referencia": "Zona rural",
        "id_productor": 7, "productor": "Ana Productora",
        "verificacion_productor": "VERIFICADO", "reputacion": 4.5,
    })
    def test_lot_detail_displays_offer_quality_location_and_producer(self, query):
        response = self.client.get("/lotes/8")
        page = response.get_data(as_text=True)

        self.assertEqual(response.status_code, 200)
        self.assertIn("S/ 3.25 / kg", page)
        self.assertIn("30–50 kg", page)
        self.assertIn("Huancayo, Huancayo, Junín", page)
        self.assertIn("/productores/7", page)
        self.assertIn("BUENO", page)

    @patch("app.query")
    def test_producer_profile_lists_available_products(self, query):
        query.side_effect = [
            {"id_productor": 7, "nombre": "Ana Productora",
             "codigo_productor": "PRO-7", "estado_verificacion": "VERIFICADO",
             "reputacion": 4.5},
            [{"id_lote": 8, "codigo_lote": "LOT-8", "producto": "Ajo",
              "categoria": "Hortalizas", "precio_propuesto_kg": 3.25,
              "produccion_min": 30, "produccion_max": 50,
              "distrito": "Huancayo", "provincia": "Huancayo",
              "departamento": "Junín"}],
        ]

        response = self.client.get("/productores/7")
        page = response.get_data(as_text=True)

        self.assertEqual(response.status_code, 200)
        self.assertIn("Ana Productora", page)
        self.assertIn("Ajo", page)
        self.assertIn("/lotes/8", page)

    @patch("app.query")
    def test_admin_product_catalog_requires_administrator(self, query):
        query.side_effect = [
            [{"nombre_rol": "COMPRADOR", "codigo_permiso": None}],
            None,
        ]
        with self.client.session_transaction() as user_session:
            user_session["user_id"] = 5

        response = self.client.get("/admin/productos")

        self.assertEqual(response.status_code, 302)
        self.assertEqual(response.location, "/dashboard")
        self.assertEqual(query.call_count, 2)

    @patch("app.execute", return_value=25)
    @patch("app.query")
    def test_admin_can_create_catalog_product(self, query, execute):
        query.side_effect = [
            [{"nombre_rol": "ADMINISTRADOR", "codigo_permiso": None}],
            {"id": 1},
            {"id_categoria": 2},
            None,
        ]
        with self.client.session_transaction() as user_session:
            user_session["user_id"] = 1
            user_session["_csrf_token"] = "test-csrf-token"

        response = self.client.post(
            "/admin/productos",
            data={
                "csrf_token": "test-csrf-token",
                "nombre": "Camote",
                "id_categoria": "2",
                "descripcion": "Camote fresco",
                "estado": "ACTIVO",
            },
        )

        self.assertEqual(response.status_code, 302)
        self.assertIn("INSERT INTO productos", execute.call_args.args[0])
        self.assertEqual(
            execute.call_args.args[1],
            (2, "Camote", "Camote fresco", "ACTIVO")
        )


if __name__ == "__main__":
    unittest.main()

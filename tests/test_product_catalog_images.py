import unittest
from unittest.mock import patch

from app import app as flask_app


class ProductCatalogImageTests(unittest.TestCase):
    @patch(
        "app.query",
        side_effect=[
            [
                {"id_producto": 1, "nombre": "Ajo", "categoria": "Hortalizas", "descripcion": "Producto agrícola del piloto"},
                {"id_producto": 2, "nombre": "Olluco", "categoria": "Tubérculos", "descripcion": "Producto agrícola del piloto"},
            ],
            [],
        ],
    )
    def test_homepage_hides_products_without_images(self, query):
        flask_app.config["TESTING"] = True
        response = flask_app.test_client().get("/")
        page = response.get_data(as_text=True)

        self.assertEqual(response.status_code, 200)
        self.assertIn("img/ajo.png", page)
        self.assertIn('href="/productos#producto-1"', page)
        self.assertIn("Ver productos", page)
        self.assertNotIn(">Olluco<", page)
        self.assertNotIn("Producto agrícola del piloto", page)

    @patch(
        "app.query",
        side_effect=[
            [
                {"id_producto": 1, "nombre": "Ajo", "categoria": "Hortalizas", "descripcion": "Producto agrícola del piloto"},
                {"id_producto": 2, "nombre": "Apio", "categoria": "Hortalizas", "descripcion": "Producto agrícola del piloto"},
                {"id_producto": 3, "nombre": "Col/Repollo", "categoria": "Hortalizas", "descripcion": "Producto agrícola del piloto"},
                {"id_producto": 4, "nombre": "Lechuga", "categoria": "Hortalizas", "descripcion": "Producto agrícola del piloto"},
                {"id_producto": 5, "nombre": "Quinua", "categoria": "Granos", "descripcion": "Producto agrícola del piloto"},
                {"id_producto": 6, "nombre": "Olluco", "categoria": "Tubérculos", "descripcion": "Producto agrícola del piloto"},
            ],
            [{"nombre": "Hortalizas"}, {"nombre": "Granos"}],
        ],
    )
    def test_catalog_shows_products_with_and_without_images(self, query):
        flask_app.config["TESTING"] = True
        response = flask_app.test_client().get("/productos")
        page = response.get_data(as_text=True)

        self.assertEqual(response.status_code, 200)
        for image in ("ajo.png", "apio.png", "col.png", "lechuga.png", "quinua.png"):
            self.assertIn(f"img/{image}", page)
        self.assertIn(">Olluco<", page)
        self.assertIn('class="producto-sin-imagen"', page)
        self.assertNotIn("Producto agrícola del piloto", page)
        self.assertEqual(page.count('class="producto-card"'), 6)
        self.assertIn('id="producto-1"', page)


if __name__ == "__main__":
    unittest.main()

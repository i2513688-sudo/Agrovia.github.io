import unittest
from unittest.mock import patch

from app import app as flask_app


class InternationalizationTests(unittest.TestCase):
    def setUp(self):
        flask_app.config["TESTING"] = True
        self.client = flask_app.test_client()

    @patch("app.query", side_effect=[[], []])
    def test_homepage_uses_spanish_by_default(self, query):
        response = self.client.get("/")
        page = response.get_data(as_text=True)

        self.assertEqual(response.status_code, 200)
        self.assertIn('<html lang="es">', page)
        self.assertIn("Conectamos el campo", page)
        self.assertIn("Inicio", page)

    @patch("app.query", side_effect=[[], []])
    def test_homepage_can_be_rendered_in_english(self, query):
        with self.client.session_transaction() as user_session:
            user_session["idioma"] = "en"

        response = self.client.get("/")
        page = response.get_data(as_text=True)

        self.assertEqual(response.status_code, 200)
        self.assertIn('<html lang="en">', page)
        self.assertIn("Connecting the countryside", page)
        self.assertIn("Home", page)

    def test_language_change_requires_csrf_and_rejects_unsupported_language(self):
        self.client.get("/login")
        with self.client.session_transaction() as user_session:
            csrf_token = user_session["_csrf_token"]

        response = self.client.post(
            "/idioma",
            data={"idioma": "fr", "csrf_token": csrf_token},
        )

        self.assertEqual(response.status_code, 400)

    def test_language_change_persists_choice_and_returns_to_local_path(self):
        self.client.get("/login")
        with self.client.session_transaction() as user_session:
            csrf_token = user_session["_csrf_token"]

        response = self.client.post(
            "/idioma",
            data={
                "idioma": "en",
                "next": "/login",
                "csrf_token": csrf_token,
            },
        )

        self.assertEqual(response.status_code, 302)
        self.assertEqual(response.headers["Location"], "/login")
        page = self.client.get("/login").get_data(as_text=True)
        self.assertIn('<html lang="en">', page)
        self.assertIn("Sign in with your email or ID number.", page)

    def test_complaints_book_is_translated(self):
        with self.client.session_transaction() as user_session:
            user_session["idioma"] = "en"

        response = self.client.get("/libro-reclamaciones")
        page = response.get_data(as_text=True)

        self.assertEqual(response.status_code, 200)
        self.assertIn("Complaints Book", page)
        self.assertIn("Full name", page)
        self.assertIn("Submit complaint or grievance", page)

    @patch("app.query", side_effect=[[], []])
    def test_product_catalog_is_translated(self, query):
        with self.client.session_transaction() as user_session:
            user_session["idioma"] = "en"

        response = self.client.get("/productos")
        page = response.get_data(as_text=True)

        self.assertEqual(response.status_code, 200)
        self.assertIn("Product catalog", page)
        self.assertIn("Browse agricultural products by category.", page)


if __name__ == "__main__":
    unittest.main()

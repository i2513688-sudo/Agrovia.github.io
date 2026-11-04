import unittest
from unittest.mock import patch

from app import app as flask_app


class AdminQuotePanelTests(unittest.TestCase):
    def setUp(self):
        flask_app.config["TESTING"] = True
        self.client = flask_app.test_client()
        with self.client.session_transaction() as user_session:
            user_session["user_id"] = 1

    @patch(
        "app.query",
        return_value=[
            {
                "nombre_rol": "ADMINISTRADOR",
                "codigo_permiso": "TRANSPORTE_ASIGNAR",
            }
        ],
    )
    def test_admin_quote_page_redirects_to_dashboard(self, query):
        response = self.client.get("/admin/cotizaciones")

        self.assertEqual(response.status_code, 302)
        self.assertEqual(response.headers["Location"], "/dashboard")
        query.assert_called_once()


if __name__ == "__main__":
    unittest.main()

import unittest
from unittest.mock import patch

from app import app as flask_app


class AccountCleanupTests(unittest.TestCase):
    def setUp(self):
        flask_app.config["TESTING"] = True
        self.client = flask_app.test_client()

    @patch("app.query")
    def test_account_page_contains_only_its_title_for_producers_and_buyers(self, query):
        producer_identity = [{"nombre_rol": "PRODUCTOR", "codigo_permiso": None}]
        buyer_identity = [{"nombre_rol": "COMPRADOR", "codigo_permiso": None}]

        for role, identity in (
            ("PRODUCTOR", producer_identity),
            ("COMPRADOR", buyer_identity),
        ):
            with self.subTest(role=role):
                query.reset_mock()
                query.side_effect = [identity]

                with self.client.session_transaction() as user_session:
                    user_session["user_id"] = 1

                response = self.client.get("/mi-cuenta")
                page = response.get_data(as_text=True).lower()

                self.assertEqual(response.status_code, 200)
                self.assertIn("<h1>mi cuenta</h1>", page)
                self.assertNotIn("direcciones de entrega", page)
                self.assertNotIn("datos de facturación", page)
                self.assertNotIn("nombre:", page)
                self.assertNotIn("documento:", page)
                self.assertNotIn("guardar dirección", page)
                self.assertNotIn("guardar datos fiscales", page)
                self.assertEqual(query.call_count, 1)

    @patch("app.get_connection")
    @patch("app.query", return_value=[
        {"nombre_rol": "PRODUCTOR", "codigo_permiso": None}
    ])
    def test_legacy_payment_actions_do_not_open_a_database_connection(
        self, query, get_connection
    ):
        self.client.get("/login")
        with self.client.session_transaction() as user_session:
            user_session["user_id"] = 1
            csrf_token = user_session["_csrf_token"]

        for action in ("guardar_medio_pago", "predeterminar_medio_pago"):
            response = self.client.post(
                "/mi-cuenta",
                data={"action": action, "csrf_token": csrf_token},
            )
            self.assertEqual(response.status_code, 405)

        get_connection.assert_not_called()

    def test_complaints_book_route_is_removed(self):
        response = self.client.get("/libro-reclamaciones")
        self.assertEqual(response.status_code, 404)


if __name__ == "__main__":
    unittest.main()

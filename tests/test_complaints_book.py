import unittest
from unittest.mock import patch

from mysql.connector import Error as MySQLDatabaseError

from app import app as flask_app


class ComplaintsBookTests(unittest.TestCase):
    def setUp(self):
        flask_app.config["TESTING"] = True
        self.client = flask_app.test_client()
        self.client.get("/libro-reclamaciones")
        with self.client.session_transaction() as user_session:
            self.csrf_token = user_session["_csrf_token"]

    def valid_submission(self, **overrides):
        data = {
            "tipo_solicitud": "RECLAMO",
            "nombres": "Ana Pérez",
            "tipo_documento": "DNI",
            "numero_documento": "12345678",
            "domicilio": "Av. Principal 123",
            "telefono": "+51999111222",
            "correo": "ana@example.test",
            "tipo_bien": "PRODUCTO",
            "monto": "12.50",
            "descripcion": "El producto llegó dañado.",
            "pedido": "Solicito el cambio del producto.",
            "csrf_token": self.csrf_token,
        }
        data.update(overrides)
        return data

    @patch("app.execute")
    def test_valid_submission_is_saved_and_returns_tracking_code(self, execute):
        response = self.client.post(
            "/libro-reclamaciones",
            data=self.valid_submission(),
        )

        page = response.get_data(as_text=True)
        self.assertEqual(response.status_code, 200)
        self.assertIn("Solicitud registrada", page)
        self.assertIn("Código de seguimiento:", page)
        execute.assert_called_once()
        self.assertIn("INSERT INTO libro_reclamaciones", execute.call_args.args[0])
        self.assertEqual(execute.call_args.args[1][1:3], ("RECLAMO", "Ana Pérez"))

    @patch("app.execute")
    def test_invalid_submission_is_rejected_without_database_write(self, execute):
        response = self.client.post(
            "/libro-reclamaciones",
            data=self.valid_submission(correo="not-an-email"),
        )

        self.assertEqual(response.status_code, 200)
        self.assertIn("Revisa los datos obligatorios del formulario.", response.get_data(as_text=True))
        execute.assert_not_called()

    @patch("app.execute")
    def test_negative_amount_is_rejected_without_database_write(self, execute):
        response = self.client.post(
            "/libro-reclamaciones",
            data=self.valid_submission(monto="-1"),
        )

        self.assertEqual(response.status_code, 200)
        self.assertIn("El monto debe ser un número válido no negativo.", response.get_data(as_text=True))
        execute.assert_not_called()

    @patch("app.execute", side_effect=MySQLDatabaseError("database unavailable"))
    def test_database_failure_shows_error_instead_of_success(self, execute):
        response = self.client.post(
            "/libro-reclamaciones",
            data=self.valid_submission(),
        )

        self.assertEqual(response.status_code, 200)
        self.assertNotIn("Solicitud registrada", response.get_data(as_text=True))
        self.assertIn("No pudimos registrar tu solicitud.", response.get_data(as_text=True))
        execute.assert_called_once()

    @patch("app.execute")
    def test_honeypot_submission_is_rejected(self, execute):
        response = self.client.post(
            "/libro-reclamaciones",
            data=self.valid_submission(website="spam"),
        )

        self.assertEqual(response.status_code, 400)
        execute.assert_not_called()


if __name__ == "__main__":
    unittest.main()

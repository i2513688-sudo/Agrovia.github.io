import unittest
from unittest.mock import patch

from werkzeug.security import generate_password_hash

from app import app as flask_app


class AccessControlTests(unittest.TestCase):
    def setUp(self):
        flask_app.config["TESTING"] = True
        self.client = flask_app.test_client()
        self.turnstile_patcher = patch("app.verificar_turnstile", return_value=True)
        self.register_config_patcher = patch(
            "app.configuracion_registro_valida", return_value=True
        )
        self.turnstile_patcher.start()
        self.register_config_patcher.start()
        self.addCleanup(self.turnstile_patcher.stop)
        self.addCleanup(self.register_config_patcher.stop)

    def csrf_token(self):
        self.client.get("/registro")
        with self.client.session_transaction() as session:
            return session["_csrf_token"]

    def registration_data(self, **overrides):
        data = {
            "nombres": "Ana",
            "apellido_paterno": "Pérez",
            "apellido_materno": "",
            "numero_documento": "12345678",
            "telefono": "+51999111222",
            "correo": "ana@example.test",
            "password": "secure-pass-123",
            "tipo_persona": "COMPRADOR",
            "csrf_token": self.csrf_token(),
        }
        data.update(overrides)
        return data

    @patch("app.execute")
    @patch("app.query")
    def test_registration_rejects_unknown_role_before_database_access(
        self, query, execute
    ):
        response = self.client.post(
            "/registro",
            data=self.registration_data(tipo_persona="ADMINISTRADOR"),
        )

        self.assertEqual(response.status_code, 200)
        self.assertIn(b"tipo de cuenta v\xc3\xa1lido", response.data)
        query.assert_not_called()
        execute.assert_not_called()

    @patch("app.execute")
    @patch("app.query")
    def test_registration_requires_minimum_password_length(self, query, execute):
        response = self.client.post(
            "/registro",
            data=self.registration_data(password="short"),
        )

        self.assertEqual(response.status_code, 200)
        self.assertIn(b"al menos 8 caracteres", response.data)
        query.assert_not_called()
        execute.assert_not_called()

    @patch("app.execute")
    @patch("app.query", return_value=None)
    def test_registration_fails_when_requested_role_is_unavailable(
        self, query, execute
    ):
        response = self.client.post(
            "/registro",
            data=self.registration_data(),
        )

        self.assertEqual(response.status_code, 200)
        self.assertIn(b"tipo de cuenta seleccionado no est\xc3\xa1 disponible", response.data)
        query.assert_called_once()
        execute.assert_not_called()

    @patch("app.execute")
    @patch("app.query", return_value={
        "id_usuario": 7,
        "password_hash": generate_password_hash("secure-pass-123"),
        "estado": "INACTIVO",
        "nombres": "Ana",
        "apellido_paterno": "Pérez",
        "roles_text": "ADMINISTRADOR",
    })
    def test_inactive_account_cannot_log_in_or_receive_a_session(
        self, query, execute
    ):
        self.client.get("/login")
        with self.client.session_transaction() as session:
            csrf_token = session["_csrf_token"]
        response = self.client.post(
            "/login",
            data={
                "login": "ana@example.test",
                "password": "secure-pass-123",
                "csrf_token": csrf_token,
            },
        )

        self.assertEqual(response.status_code, 200)
        self.assertIn(b"usuario no est\xc3\xa1 activo", response.data)
        execute.assert_not_called()
        with self.client.session_transaction() as session:
            self.assertNotIn("user_id", session)

    @patch("app.execute")
    @patch("app.query", return_value={
        "id_usuario": 7,
        "password_hash": generate_password_hash("secure-pass-123"),
        "estado": "ACTIVO",
        "nombres": "Ana",
        "apellido_paterno": "Pérez",
        "roles_text": "COMPRADOR",
    })
    def test_bad_password_does_not_leave_an_existing_session_authenticated(
        self, query, execute
    ):
        self.client.get("/login")
        with self.client.session_transaction() as session:
            csrf_token = session["_csrf_token"]
            session["user_id"] = 99
            session["roles"] = ["ADMINISTRADOR"]

        response = self.client.post(
            "/login",
            data={
                "login": "ana@example.test",
                "password": "incorrect",
                "csrf_token": csrf_token,
            },
        )

        self.assertEqual(response.status_code, 200)
        self.assertIn(b"Correo/documento o contrase\xc3\xb1a incorrectos", response.data)
        execute.assert_not_called()
        with self.client.session_transaction() as session:
            self.assertNotIn("user_id", session)

    @patch("app.execute")
    @patch("app.query", side_effect=[
        {
            "id_usuario": 7,
            "password_hash": generate_password_hash("secure-pass-123"),
            "estado": "ACTIVO",
            "nombres": "Ana",
            "apellido_paterno": "Pérez",
            "roles_text": "COMPRADOR",
        },
        [{"codigo": "REPORTES_VER"}],
        None,
    ])
    def test_successful_login_stores_active_roles_and_permissions(
        self, query, execute
    ):
        self.client.get("/login")
        with self.client.session_transaction() as session:
            csrf_token = session["_csrf_token"]
        response = self.client.post(
            "/login",
            data={
                "login": "ana@example.test",
                "password": "secure-pass-123",
                "csrf_token": csrf_token,
            },
        )

        self.assertEqual(response.status_code, 302)
        with self.client.session_transaction() as session:
            self.assertEqual(session["user_id"], 7)
            self.assertEqual(session["roles"], ["COMPRADOR"])
            self.assertEqual(session["permissions"], ["REPORTES_VER"])
        execute.assert_called_once()

    @patch("app.query", side_effect=[[
        {"nombre_rol": "COMPRADOR", "codigo_permiso": None}
    ], None])
    def test_permission_route_denies_user_without_active_permission(self, query):
        with self.client.session_transaction() as session:
            session["user_id"] = 7

        response = self.client.get("/admin/permisos")

        self.assertEqual(response.status_code, 302)
        self.assertEqual(response.location, "/dashboard")
        self.assertEqual(query.call_count, 2)

    @patch("app.query", return_value=[
        {"nombre_rol": "COMPRADOR", "codigo_permiso": None}
    ])
    def test_producer_route_requires_active_producer_profile(self, query):
        with self.client.session_transaction() as session:
            session["user_id"] = 7

        response = self.client.get("/predios")

        self.assertEqual(response.status_code, 302)
        self.assertEqual(response.location, "/dashboard")
        query.assert_called_once()

    @patch("app.query", return_value=[])
    def test_inactive_session_account_is_logged_out(self, query):
        with self.client.session_transaction() as session:
            session["user_id"] = 7
            session["roles"] = ["ADMINISTRADOR"]
            session["permissions"] = ["ROLES_GESTIONAR"]

        response = self.client.get("/mis-operaciones")

        self.assertEqual(response.status_code, 302)
        self.assertEqual(response.location, "/login")
        with self.client.session_transaction() as session:
            self.assertNotIn("user_id", session)
            self.assertNotIn("roles", session)
            self.assertNotIn("permissions", session)

    @patch("app.query", side_effect=[
        [
            {"nombre_rol": "COMPRADOR", "codigo_permiso": None},
            {"nombre_rol": "PRODUCTOR", "codigo_permiso": "REPORTES_VER"},
        ],
        [],
    ])
    def test_authenticated_session_roles_are_refreshed_from_active_assignments(
        self, query
    ):
        with self.client.session_transaction() as session:
            session["user_id"] = 7
            session["roles"] = ["ADMINISTRADOR"]
            session["permissions"] = ["ROLES_GESTIONAR"]

        self.client.get("/mis-transportes")

        with self.client.session_transaction() as session:
            self.assertEqual(session["roles"], ["COMPRADOR", "PRODUCTOR"])
            self.assertEqual(session["permissions"], ["REPORTES_VER"])


if __name__ == "__main__":
    unittest.main()

import hashlib
import os
import unittest
from unittest.mock import MagicMock, patch

from werkzeug.security import generate_password_hash

from app import app as flask_app
from app import (
    crear_y_enviar_codigo_telefono,
    enviar_codigo_verificacion_sms,
    validar_codigo_verificacion_sms,
    verificar_turnstile,
)


VERIFICATION_SETTINGS = {
    "APP_BASE_URL": "https://agrovia.example",
    "SMTP_HOST": "smtp.example.test",
    "SMTP_FROM": "mailer@example.test",
}


class EmailVerificationTests(unittest.TestCase):
    def setUp(self):
        flask_app.config["TESTING"] = True
        self.client = flask_app.test_client()

    def csrf_token(self):
        self.client.get("/registro")
        with self.client.session_transaction() as user_session:
            return user_session["_csrf_token"]

    def registration_data(self, **overrides):
        data = {
            "nombres": "Ana",
            "apellido_paterno": "Pérez",
            "apellido_materno": "",
            "tipo_documento": "CE",
            "numero_documento": "ABC12345",
            "telefono": "+51999111222",
            "correo": "ana@example.test",
            "password": "secure-pass-123",
            "tipo_persona": "COMPRADOR",
            "csrf_token": self.csrf_token(),
        }
        data.update(overrides)
        return data

    @patch.dict(os.environ, VERIFICATION_SETTINGS, clear=True)
    @patch("app.verificar_turnstile", return_value=True)
    @patch("app.configuracion_registro_valida", return_value=True)
    @patch("app.enviar_correo_verificacion", return_value=True)
    @patch("app.execute", side_effect=[7, 8, 9, 10])
    @patch("app.query", side_effect=[
        {"id_rol": 2},
        None,
        None,
        None,
    ])
    def test_registration_saves_document_type_and_starts_pending(
        self, query, execute, send_email, config_valid, captcha_valid
    ):
        response = self.client.post(
            "/registro",
            data=self.registration_data(),
        )

        self.assertEqual(response.status_code, 302)
        self.assertEqual(response.location, "/login")
        registration_sql = execute.call_args_list[0].args[0]
        registration_params = execute.call_args_list[0].args[1]
        self.assertIn("tipo_documento", registration_sql)
        self.assertIn("'PENDIENTE'", registration_sql)
        self.assertEqual(registration_params[1], "CE")
        self.assertIn("VERIFICAR_CORREO", execute.call_args_list[-1].args[0])
        self.assertTrue(send_email.call_args.args[1].startswith(
            "https://agrovia.example/verificar-correo/"
        ))

    @patch("app.execute")
    @patch("app.query", return_value={
        "id_usuario": 7,
        "password_hash": generate_password_hash("secure-pass-123"),
        "estado": "PENDIENTE",
        "correo_verificado": 0,
        "nombres": "Ana",
        "apellido_paterno": "Pérez",
        "roles_text": "COMPRADOR",
    })
    def test_pending_user_cannot_log_in_before_verifying_email(self, query, execute):
        self.client.get("/login")
        with self.client.session_transaction() as user_session:
            csrf_token = user_session["_csrf_token"]

        response = self.client.post(
            "/login",
            data={
                "login": "ana@example.test",
                "password": "secure-pass-123",
                "csrf_token": csrf_token,
            },
        )

        self.assertEqual(response.status_code, 200)
        self.assertIn("Tu cuenta aún no está activa", response.get_data(as_text=True))
        execute.assert_not_called()

    @patch("app.crear_y_enviar_codigo_telefono", return_value=True)
    @patch("app.verificar_turnstile", return_value=True)
    @patch("app.get_connection")
    def test_email_verification_sends_sms_but_waits_for_phone(
        self, get_connection, captcha_valid, send_sms
    ):
        connection = MagicMock()
        cursor = connection.cursor.return_value
        cursor.fetchone.return_value = {
            "id_token": 12,
            "id_usuario": 7,
            "telefono": "+51999111222",
        }
        cursor.rowcount = 1
        get_connection.return_value = connection
        token = "verification-token"

        self.client.get(f"/verificar-correo/{token}")
        with self.client.session_transaction() as user_session:
            csrf_token = user_session["_csrf_token"]
        response = self.client.post(
            f"/verificar-correo/{token}",
            data={"csrf_token": csrf_token, "cf-turnstile-response": "captcha"},
        )

        self.assertEqual(response.status_code, 302)
        self.assertEqual(response.location, "/verificar-telefono")
        calls = cursor.execute.call_args_list
        self.assertEqual(
            calls[0].args[1],
            (hashlib.sha256(token.encode("utf-8")).hexdigest(),),
        )
        self.assertIn("correo_verificado = 1", calls[1].args[0])
        self.assertNotIn("estado = 'ACTIVO'", calls[1].args[0])
        self.assertIn("tipo = 'VERIFICAR_CORREO'", calls[2].args[0])
        connection.commit.assert_called_once()
        send_sms.assert_called_once_with(7, "+51999111222")

    @patch("app.verificar_turnstile", return_value=True)
    @patch("app.get_connection")
    def test_invalid_verification_token_does_not_change_account(
        self, get_connection, captcha_valid
    ):
        connection = MagicMock()
        connection.cursor.return_value.fetchone.return_value = None
        get_connection.return_value = connection

        self.client.get("/verificar-correo/invalid-token")
        with self.client.session_transaction() as user_session:
            csrf_token = user_session["_csrf_token"]
        response = self.client.post(
            "/verificar-correo/invalid-token",
            data={"csrf_token": csrf_token, "cf-turnstile-response": "captcha"},
        )

        self.assertEqual(response.status_code, 302)
        self.assertEqual(response.location, "/login")
        connection.rollback.assert_called_once()
        connection.commit.assert_not_called()
        connection.cursor.return_value.execute.assert_called_once()

    @patch.dict(os.environ, VERIFICATION_SETTINGS, clear=True)
    @patch("app.verificar_turnstile", return_value=True)
    @patch("app.crear_y_enviar_token_verificacion", return_value=True)
    @patch("app.query", side_effect=[
        {
            "id_usuario": 7,
            "correo": "ana@example.test",
            "telefono": "+51999111222",
            "correo_verificado": 0,
            "telefono_verificado": 0,
        },
        {"total": 0},
    ])
    def test_pending_user_can_request_another_verification_email(
        self, query, send_verification, captcha_valid
    ):
        self.client.get("/reenviar-verificacion")
        with self.client.session_transaction() as user_session:
            csrf_token = user_session["_csrf_token"]

        response = self.client.post(
            "/reenviar-verificacion",
            data={"correo": "ana@example.test", "csrf_token": csrf_token},
            follow_redirects=True,
        )

        self.assertEqual(response.status_code, 200)
        self.assertIn("Si existe una cuenta pendiente", response.get_data(as_text=True))
        self.assertEqual(query.call_count, 2)
        send_verification.assert_called_once_with(7, "ana@example.test")

    @patch("app.execute")
    @patch("app.query")
    @patch("app.verificar_turnstile", return_value=True)
    def test_registration_rejects_invalid_email_before_database_access(
        self, captcha_valid, query, execute
    ):
        response = self.client.post(
            "/registro",
            data=self.registration_data(correo="not-an-email"),
        )

        self.assertEqual(response.status_code, 200)
        self.assertIn("Ingresa un correo electrónico válido", response.get_data(as_text=True))
        query.assert_not_called()
        execute.assert_not_called()

    @patch.dict(os.environ, {"TURNSTILE_SECRET_KEY": "test-secret"}, clear=True)
    @patch("app.urlopen")
    def test_turnstile_verification_posts_secret_and_token(self, urlopen):
        response = MagicMock()
        response.read.return_value = b'{"success": true}'
        urlopen.return_value.__enter__.return_value = response

        self.assertTrue(verificar_turnstile("challenge-response", "192.0.2.1"))

        request = urlopen.call_args.args[0]
        self.assertIn(b"secret=test-secret", request.data)
        self.assertIn(b"response=challenge-response", request.data)
        self.assertIn(b"remoteip=192.0.2.1", request.data)

    @patch.dict(os.environ, {
        "TWILIO_ACCOUNT_SID": "AC123",
        "TWILIO_AUTH_TOKEN": "test-token",
        "TWILIO_VERIFY_SERVICE_SID": "VA123",
    }, clear=True)
    @patch("app.TwilioClient")
    def test_twilio_verify_sends_sms_and_checks_otp(self, twilio_client):
        client = twilio_client.return_value
        client.verify.v2.services.return_value.verifications.create.return_value.status = "pending"
        client.verify.v2.services.return_value.verification_checks.create.return_value.status = "approved"

        self.assertTrue(enviar_codigo_verificacion_sms("+51999111222"))
        self.assertTrue(validar_codigo_verificacion_sms("+51999111222", "123456"))

        self.assertEqual(twilio_client.call_args.args, ("AC123", "test-token"))
        self.assertEqual(twilio_client.call_args.kwargs["http_client"].timeout, 10)
        verify_service = client.verify.v2.services.return_value
        verify_service.verifications.create.assert_called_once_with(
            to="+51999111222", channel="sms"
        )
        verify_service.verification_checks.create.assert_called_once_with(
            to="+51999111222", code="123456"
        )

    @patch("app.get_connection")
    @patch("app.validar_codigo_verificacion_sms", return_value=True)
    @patch("app.verificar_turnstile", return_value=True)
    @patch("app.query", return_value={"id_usuario": 7, "telefono": "+51999111222"})
    def test_valid_sms_code_activates_account(
        self, query, captcha_valid, check_code, get_connection
    ):
        connection = MagicMock()
        cursor = connection.cursor.return_value
        cursor.fetchone.return_value = {"id_usuario": 7}
        cursor.rowcount = 1
        get_connection.return_value = connection
        self.client.get("/login")
        with self.client.session_transaction() as user_session:
            user_session["verificacion_telefono_usuario_id"] = 7
            csrf_token = user_session["_csrf_token"]

        response = self.client.post(
            "/verificar-telefono",
            data={
                "codigo": "123456",
                "cf-turnstile-response": "captcha",
                "csrf_token": csrf_token,
            },
        )

        self.assertEqual(response.status_code, 302)
        self.assertEqual(response.location, "/login")
        check_code.assert_called_once_with("+51999111222", "123456")
        self.assertIn("telefono_verificado = 1, estado = 'ACTIVO'", cursor.execute.call_args_list[1].args[0])
        connection.commit.assert_called_once()
        with self.client.session_transaction() as user_session:
            self.assertNotIn("verificacion_telefono_usuario_id", user_session)

    @patch.dict(os.environ, {
        "TWILIO_ACCOUNT_SID": "AC123",
        "TWILIO_AUTH_TOKEN": "test-token",
        "TWILIO_VERIFY_SERVICE_SID": "VA123",
    }, clear=True)
    @patch("app.enviar_codigo_verificacion_sms")
    @patch("app.get_connection")
    def test_sms_resend_limit_is_checked_under_account_lock(
        self, get_connection, send_sms
    ):
        connection = MagicMock()
        cursor = connection.cursor.return_value
        cursor.fetchone.side_effect = [{"id_usuario": 7}, {"total": 3}]
        get_connection.return_value = connection

        self.assertFalse(crear_y_enviar_codigo_telefono(7, "+51999111222"))

        connection.rollback.assert_called_once()
        connection.commit.assert_not_called()
        send_sms.assert_not_called()
        self.assertEqual(cursor.execute.call_count, 2)

    @patch("app.execute")
    @patch("app.query", return_value={"id_rol": 2})
    @patch("app.verificar_turnstile", return_value=False)
    def test_registration_rejects_failed_captcha_before_database_access(
        self, captcha_valid, query, execute
    ):
        response = self.client.post(
            "/registro",
            data=self.registration_data(),
        )

        self.assertEqual(response.status_code, 200)
        self.assertIn("Completa la verificación anti-robots", response.get_data(as_text=True))
        query.assert_not_called()
        execute.assert_not_called()


if __name__ == "__main__":
    unittest.main()

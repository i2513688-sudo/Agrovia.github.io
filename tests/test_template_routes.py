import unittest
from unittest.mock import patch

from app import app as flask_app


class MissingTemplateRouteTests(unittest.TestCase):
    def setUp(self):
        flask_app.config["TESTING"] = True
        self.client = flask_app.test_client()
        with self.client.session_transaction() as user_session:
            user_session["user_id"] = 1
            user_session["roles"] = ["ADMINISTRADOR", "COMPRADOR"]

    def test_routes_with_restored_templates_render_successfully(self):
        routes = (
            "/admin/valorizaciones",
            "/admin/variedades",
            "/admin/parametros-agricolas",
            "/admin/configuracion-logistica",
            "/admin/beneficios",
            "/admin/campanas-agricolas",
            "/admin/referidos",
            "/beneficios",
            "/mis-referidos",
            "/admin/pagos",
            "/admin/cosechas",
            "/admin/liquidaciones",
            "/admin/auditoria",
            "/admin/capacitaciones",
        )

        def return_query_data(sql, params=(), one=False):
            if "SELECT r.nombre AS nombre_rol" in sql:
                return [
                    {
                        "nombre_rol": "ADMINISTRADOR",
                        "codigo_permiso": "PAGOS_VER",
                    },
                    {"nombre_rol": "COMPRADOR", "codigo_permiso": None},
                ]
            if "SELECT codigo_usuario FROM usuarios" in sql:
                return {"codigo_usuario": "USR-1"}
            if "AS saldo" in sql or "AS puntos" in sql:
                return {"saldo": 0, "puntos": 0}
            return None if one else []

        with (
            patch("app.query", side_effect=return_query_data),
            patch("app.tiene_permiso", return_value=True),
            patch("app.es_admin", return_value=True),
        ):
            for route in routes:
                with self.subTest(route=route):
                    response = self.client.get(route)
                    self.assertEqual(response.status_code, 200)


if __name__ == "__main__":
    unittest.main()

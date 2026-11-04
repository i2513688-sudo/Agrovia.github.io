import unittest

from flask import g, render_template, session

from app import app as flask_app


class DashboardNavigationTests(unittest.TestCase):
    def render_navigation(self, roles, permissions=None):
        with flask_app.test_request_context("/"):
            session["user_id"] = 1
            session["user_name"] = "Usuario de prueba"
            g.authorization = {
                "roles": roles,
                "permissions": permissions or [],
            }
            return render_template("base.html")

    def test_benefits_and_referrals_are_not_shown_to_producers_or_buyers(self):
        for role in ("PRODUCTOR", "COMPRADOR"):
            with self.subTest(role=role):
                page = self.render_navigation([role])
                self.assertNotIn("/beneficios", page)
                self.assertNotIn("/referidos", page)
                self.assertIn("/mi-cuenta", page)

    def test_market_admin_links_are_removed_but_other_agricultural_tools_remain(self):
        page = self.render_navigation(
            ["ADMINISTRADOR"],
            ["PRECIOS_VER", "PARAMETROS_COMERCIALES_MODIFICAR"],
        )

        self.assertNotIn("/admin/valorizaciones", page)
        self.assertNotIn("/admin/precios-mercado", page)
        self.assertNotIn("/admin/variedades", page)
        self.assertIn("/admin/parametros-agricolas", page)


if __name__ == "__main__":
    unittest.main()

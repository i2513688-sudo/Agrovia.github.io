import unittest
from unittest.mock import patch

from app import app as flask_app


class VidaAgroviaTests(unittest.TestCase):
    @patch("app.query", return_value=[])
    def test_hero_uses_potato_planting_image_with_smooth_displacement(self, query):
        flask_app.config["TESTING"] = True
        response = flask_app.test_client().get("/vida-agrovia")
        page = response.get_data(as_text=True)

        self.assertEqual(response.status_code, 200)
        self.assertIn('url("/static/img/sembrado%20papa.png")', page)
        self.assertIn("vida-hero-desplazamiento 24s ease-in-out", page)
        self.assertIn("@keyframes vida-hero-desplazamiento", page)
        self.assertIn("prefers-reduced-motion: reduce", page)

    @patch("app.query", return_value=[])
    def test_default_sample_content_is_not_displayed(self, query):
        flask_app.config["TESTING"] = True
        response = flask_app.test_client().get("/vida-agrovia")

        self.assertEqual(response.status_code, 200)
        content = response.get_data(as_text=True)
        self.assertNotIn("Manejo Integrado de Plagas en Cítricos", content)
        self.assertNotIn("Buenas prácticas agrícolas", content)
        self.assertNotIn("Optimización de Riego con Sensores IoT", content)
        self.assertNotIn('class="btn-contenido"', content)
        self.assertNotIn("Ver contenido", content)
        self.assertIn("Aún no hay contenidos disponibles.", content)

    @patch("app.query")
    def test_published_content_still_appears(self, query):
        query.side_effect = lambda sql, *args, **kwargs: (
            [{
                "id_contenido": 1,
                "titulo": "Contenido publicado",
                "descripcion": "Descripción del contenido",
                "categoria": "TECNOLOGÍA",
                "tipo": "Lectura",
                "imagen": "cosecha choclo.png",
                "video": None,
            }]
            if "FROM contenidos_educativos" in sql
            else []
        )
        flask_app.config["TESTING"] = True
        response = flask_app.test_client().get("/vida-agrovia")

        self.assertEqual(response.status_code, 200)
        self.assertIn("Contenido publicado", response.get_data(as_text=True))

    @patch("app.query")
    def test_agrovia_talk_publication_includes_facebook_link_and_image(self, query):
        query.side_effect = lambda sql, *args, **kwargs: (
            [{
                "id_publicacion": 1,
                "tipo": "CAPACITACION",
                "titulo": "Charla informática sobre Agrovia",
                "contenido": "Información para productores.",
                "fecha_publicacion": None,
            }]
            if "FROM publicaciones" in sql
            else []
        )
        flask_app.config["TESTING"] = True
        response = flask_app.test_client().get("/vida-agrovia")

        self.assertEqual(response.status_code, 200)
        content = response.get_data(as_text=True)
        self.assertIn('src="/static/img/charla_agrovia.jpg"', content)
        self.assertIn('alt="Charla informativa de Agrovia"', content)
        self.assertIn('href="https://www.facebook.com/share/p/1FVxmshvxB/"', content)
        self.assertIn("Ver charla de Agrovia en Facebook", content)
        self.assertEqual(content.count("Ver charla de Agrovia en Facebook"), 1)
        self.assertIn("class=\"charla-agrovia-marco\"", content)
        self.assertIn("aspect-ratio: 1613 / 600", content)
        image_position = content.index('src="/static/img/charla_agrovia.jpg"')
        facebook_link_position = content.index("Ver charla de Agrovia en Facebook")
        self.assertLess(image_position, facebook_link_position)

    @patch("app.query", return_value=[])
    def test_agrovia_talk_is_shown_when_no_publications_are_registered(self, query):
        flask_app.config["TESTING"] = True
        response = flask_app.test_client().get("/vida-agrovia")

        self.assertEqual(response.status_code, 200)
        content = response.get_data(as_text=True)
        self.assertIn("Charla informativa de Agrovia", content)
        self.assertIn('src="/static/img/charla_agrovia.jpg"', content)
        self.assertIn("Ver charla de Agrovia en Facebook", content)
        self.assertNotIn("Aún no hay publicaciones disponibles.", content)


if __name__ == "__main__":
    unittest.main()

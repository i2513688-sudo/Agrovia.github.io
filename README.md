# Agrovia - Sistema Web conectado a MariaDB/phpMyAdmin

## 1. Crear la base de datos
En phpMyAdmin:
1. Crear la base de datos `agrovia_v01` con cotejamiento `utf8mb4_unicode_ci`.
2. Importar `sql/agrovia_v01.sql`.

Si la base `agrovia_v01` ya existía y ya ejecutaste `sql/migracion_contenidos_educativos.sql`, selecciona esa base en phpMyAdmin e importa una sola vez `sql/migracion_video_contenidos_educativos.sql`.

Para enlazar el comprobante fiscal seleccionado con cada pago en una base existente, importa una sola vez `sql/migracion_pago_facturacion.sql` después de crear `datos_facturacion`.

Para habilitar el seguimiento logístico en una base existente, importa una sola vez `sql/migracion_seguimiento_logistico.sql` después de crear `transportes`. En una instalación nueva, impórtala también después de `sql/agrovia_v01.sql`.

Para habilitar el precio propuesto por productor en una base existente, importa una sola vez `sql/migracion_cotizacion_productor.sql`. En una instalación nueva la columna ya está incluida en `sql/agrovia_v01.sql`. Los productores pueden registrar un lote con un predio existente o crear uno en el mismo formulario; las ubicaciones nuevas se guardan con coordenadas seleccionadas en Google Maps.

Para permitir que los productores indiquen el nombre de un producto fuera del catálogo al seleccionar “Otro”, importa una sola vez `sql/migracion_producto_personalizado.sql` en una base existente. En una instalación nueva, la columna ya está incluida en `sql/agrovia_v01.sql`.

Para habilitar las solicitudes y negociación de cotizaciones entre productores y compradores en una base existente, importa una sola vez `sql/migracion_cotizaciones_comerciales.sql` después de `sql/agrovia_v01.sql`. En una instalación nueva, las tablas ya están incluidas en `sql/agrovia_v01.sql`. El flujo permite buscar lotes y productores, solicitar cotizaciones, intercambiar mensajes y ofertas y confirmar los términos con aceptación de ambas partes; la reserva, logística y pago continúan en el flujo operativo existente.

## 2. Configurar conexión
Copiar `.env.example` como `.env` y revisar:
- DB_HOST
- DB_PORT
- DB_NAME
- DB_USER
- DB_PASSWORD
- SECRET_KEY
- OSRM_ROUTING_URL (opcional; instancia OSRM confiable para calcular rutas)
- GOOGLE_MAPS_API_KEY (necesaria para el mapa interactivo al registrar predios)

Activa Maps JavaScript API y Geocoding API en Google Cloud, configura restricciones por sitio web para tu dominio y habilita la facturación requerida por Google. Configura la clave en `GOOGLE_MAPS_API_KEY` dentro de `.env`; es una clave pública de navegador, por lo que debe tener restricciones de dominio y de API. Sin clave, el formulario permite ingresar coordenadas manualmente.
Genera una clave aleatoria para `SECRET_KEY` con `python -c "import secrets; print(secrets.token_hex(32))"` y no la compartas ni la guardes en el repositorio. En producción define además `APP_ENV=production`, configura el servicio detrás de HTTPS y usa `SESSION_COOKIE_SECURE=true`; la aplicación rechaza iniciar en producción sin una clave de al menos 32 caracteres. El modo de depuración está desactivado.

Los formularios POST incluyen protección CSRF automáticamente. Las cookies de sesión usan `HttpOnly` y `SameSite=Lax`. Mantén la clave secreta privada y reiníciala si se filtra.

Para Gmail, configurar en `.env` `SMTP_HOST=smtp.gmail.com`, `SMTP_PORT=587`, `SMTP_USE_TLS=true` y `SMTP_USE_SSL=false`. En `SMTP_USER` y `SMTP_FROM` usar la dirección de Gmail; en `SMTP_PASSWORD`, una contraseña de aplicación de Google (requiere tener activada la verificación en dos pasos). Crea la contraseña de aplicación desde la seguridad de tu cuenta de Google y escríbela directamente en `.env`, sin compartirla ni guardarla en el repositorio. Reinicia la aplicación después del cambio. Para otro servidor, usar sus parámetros SMTP; el puerto 587 requiere STARTTLS (`SMTP_USE_TLS=true`, `SMTP_USE_SSL=false`) y el 465 TLS implícito (`SMTP_USE_TLS=false`, `SMTP_USE_SSL=true`). `APP_BASE_URL` debe ser la URL pública de la aplicación, por ejemplo `https://agrovia.midominio.com`; no uses `localhost` si los usuarios abrirán el enlace desde otros equipos, porque el enlace solo funcionará en el servidor local. Los mensajes de recuperación salen con el nombre **Agrovia** y se envían a la dirección guardada en la cuenta. El enlace expira en 30 minutos y cada cuenta puede solicitar hasta 3 enlaces por cada ventana de 15 minutos.

La aplicación invalida los enlaces de recuperación utilizados al cambiar la contraseña y también invalida el token si el envío SMTP falla. El formulario no muestra un aviso de éxito en la pantalla de inicio de sesión y mantiene una respuesta genérica para no revelar si un correo está registrado. Revisa la consola/log de la aplicación para detectar errores SMTP/configuración. Los rechazos de autenticación y de destinatario se registran con el código SMTP, sin imprimir credenciales ni la dirección destinataria. Un mensaje de aceptación significa que el servidor SMTP lo aceptó, no que haya llegado a la bandeja de entrada; revisa también spam. Para Gmail, usa una contraseña de aplicación válida y alinea `SMTP_FROM` con la cuenta autenticada o con un alias verificado. Para dominios propios, configura SPF, DKIM y DMARC con el proveedor de correo; la aplicación no puede garantizar si un mensaje llegará a la bandeja de entrada o a spam. `APP_BASE_URL` debe apuntar a la dirección pública accesible por quien restablece la contraseña. La cuenta de MySQL configurada debe tener acceso a `usuarios` y `tokens_seguridad`; la estructura de esta última se define en `sql/agrovia_v01.sql`. Los errores de base de datos se registran y se informa al usuario para que el fallo no aparezca como una página 500. Configura SMTP con credenciales válidas y prueba el envío con una cuenta controlada.

Para XAMPP/MariaDB local normalmente:
DB_HOST=127.0.0.1
DB_PORT=3306
DB_USER=root
DB_PASSWORD=

Estos valores son solo para desarrollo local con XAMPP. En producción no usar `root` ni una contraseña vacía; crear un usuario MariaDB dedicado con los permisos mínimos requeridos por la aplicación.

## 3. Instalar dependencias
Windows:
```bash
py -m venv venv
venv\Scripts\activate
pip install -r requirements.txt
```

## 4. Crear usuario administrador
```bash
python crear_admin.py
```

## 5. Ejecutar
```bash
python app.py
```
Abrir: http://127.0.0.1:5000

## 6. Recuperación de cuenta
El enlace de recuperación solo se envía cuando SMTP está configurado. Los tokens se almacenan como hash, expiran a los 30 minutos y se invalidan al cambiar la contraseña.

## 7. Verificación de correo
El registro requiere `SMTP_HOST`, `SMTP_FROM` (o `SMTP_USER`), una `APP_BASE_URL` pública válida, claves de Cloudflare Turnstile y credenciales de Twilio Verify. Cada cuenta web se crea como pendiente; el enlace de correo expira en 24 horas y el código SMS se confirma con Twilio antes de activar la cuenta. Las verificaciones de correo y SMS tienen un máximo de tres envíos cada 15 minutos. El código SMS no se guarda en Agrovia. La contraseña y los datos se guardan al solicitar el registro, pero la cuenta no puede iniciar sesión hasta completar ambas verificaciones.

Configura estas variables en `.env`:

```env
TURNSTILE_SITE_KEY=
TURNSTILE_SECRET_KEY=
TWILIO_ACCOUNT_SID=
TWILIO_AUTH_TOKEN=
TWILIO_VERIFY_SERVICE_SID=
```

Obtén las claves de Turnstile desde Cloudflare y registra el dominio de la aplicación. En Twilio, crea un servicio **Verify** y coloca su SID `VA...` en `TWILIO_VERIFY_SERVICE_SID`; habilita SMS y revisa las restricciones de números del proyecto. Los teléfonos ingresados deben incluir prefijo internacional E.164, por ejemplo `+51999111222`. Protege los secretos en `.env`; nunca los subas al repositorio. La validación Turnstile falla de forma cerrada si el servicio no está configurado o no responde. Selenium no interviene en la protección de usuarios: es una herramienta para automatizar pruebas del navegador.

## 8. Idiomas
La aplicación permite elegir español o inglés desde el selector de idioma de la barra superior; la preferencia se conserva en la sesión y el español es el idioma predeterminado. La navegación compartida, el inicio, el catálogo, los lotes y las pantallas de acceso/registro/recuperación tienen traducciones en inglés; para extenderlas a otras vistas, marca sus textos con gettext. Las traducciones usan Flask-Babel y los catálogos gettext de `translations/`. Al agregar o modificar traducciones, edita `translations/en/LC_MESSAGES/messages.po` y compílalo con:

```bash
venv\Scripts\pybabel compile -d translations -l en
```

En las plantillas, marca el texto visible con `{{ _('Texto en español') }}` para que aparezca en el catálogo en inglés.

## Módulos incluidos
- Inicio / marketplace
- Inicio de sesión
- Dashboard
- Catálogo de productos
- Catálogo comercial con filtros por nombre, categoría y ubicación; cada oferta incluye detalle del lote y perfil público del productor
- Administración de productos del catálogo, publicaciones editoriales y revisión de solicitudes para publicar lotes
- Predios, direcciones de entrega y direcciones fiscales con selección de ubigeo
- Lotes publicados
- Cotizaciones comerciales y mensajería entre productores y compradores
- Usuarios y roles
- Operaciones con historial de estados visible para productor y comprador participantes; 5 puntos por participante cuando la operación está completada y ambos la calificaron
- Dashboard administrativo con métricas de lotes disponibles, operaciones activas, pagos por revisar, cosechas en proceso, entregas pendientes e incidencias abiertas
- Mi cuenta
- Referencias calculadas de precios, cosecha y logística a través de vistas SQL

El módulo de Cosechas muestra los parámetros y costos referenciales activos de `vw_parametros_cosecha_demo`, incluyendo calidad y fuente del dato. Las rutas con permisos operativos validan las asignaciones activas en `usuarios_roles`, `roles`, `roles_permisos` y `permisos`; los cambios de rol o permiso se aplican sin depender de los datos guardados al iniciar sesión.

Los compradores deben registrar una dirección de entrega con ubigeo antes de cotizar. Al aceptar una cotización, administración confirma la carga en kg, el tipo de vehículo y los peajes. Si el predio y la dirección de entrega tienen coordenadas y se configura `OSRM_ROUTING_URL` con una instancia OSRM de confianza, se calculan distancia y duración por carretera; sin configuración, coordenadas o respuesta de ruta, se conserva la captura manual de distancia. Las coordenadas se envían únicamente al servicio configurado; use un servidor privado o una instancia que esté autorizado a recibirlas. Para servicios remotos se requiere HTTPS; HTTP solo se permite para `localhost`. El proveedor, las coordenadas, la distancia y la duración quedan registrados en `cotizaciones_logisticas`. Al asignar el transporte, el sistema exige un vehículo activo, disponible, perteneciente al transportista elegido y con capacidad suficiente para la carga registrada; la asignación actualiza vehículo, operación y lote en una transacción. El rango de producción verificado se propone como carga inicial cuando existe; administración debe confirmarlo.

El usuario vinculado al transportista puede entrar a **Mis transportes**, avanzar el estado por las etapas de recojo, carga, ruta y llegada, y compartir GPS desde un navegador con permiso de ubicación y conexión HTTPS. El comprador y productor ven el estado, la ruta estimada, la dirección/destino en Google Maps y la última ubicación informada en **Mis operaciones**; la consulta del GPS se actualiza cada 30 segundos. Administración puede revisar en **Entregas** el punto GPS más reciente en Google Maps y verificar la llegada si existe un reporte de los últimos 15 minutos. La verificación de llegada es distinta de la confirmación administrativa de entrega, que continúa siendo el cierre final de la operación.

La aplicación consulta directamente las tablas de la BD `agrovia_v01`; no crea una base de datos paralela.

## Notificaciones y seguimiento
Las solicitudes de lote y los cambios de verificación se registran en el historial y se notifican al productor y al personal con el permiso de revisión. Los cambios de operación notifican al productor y al comprador participantes; los pagos pendientes también notifican al personal autorizado. Las incidencias pueden pasar por atención, resolución y cierre; cada cambio queda registrado y se notifica a ambos participantes. Los usuarios consultan sus avisos en **Notificaciones**, productores pueden revisar estados e historial en **Mis solicitudes**, y comprador/productor ven incidencias e historial en **Mis operaciones**. Al abrir la bandeja, las notificaciones se marcan como leídas.

## Reportes descargables
Usuarios con el permiso `REPORTES_VER` pueden abrir **Reportes** desde el panel y descargar operaciones, pagos, productos, productores o entregas en Excel (`.xlsx`) o PDF. Los filtros de fechas son opcionales y el estado solo admite los valores del reporte elegido. Las fechas se aplican a la operación, pago, publicación de lotes, actividad de productores o entrega/asignación de transporte, según el reporte. Los archivos incluyen hasta 50 000 filas; para consultas mayores, delimita el periodo o el estado.

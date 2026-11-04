-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 27-10-2026 a las 18:45:52
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `agrovia_v01`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `archivos`
--

CREATE TABLE `archivos` (
  `id_archivo` bigint(20) UNSIGNED NOT NULL,
  `codigo_archivo` varchar(24) NOT NULL,
  `tipo_archivo` varchar(50) NOT NULL,
  `entidad_tipo` varchar(50) NOT NULL,
  `entidad_id` bigint(20) UNSIGNED NOT NULL,
  `nombre_original` varchar(255) NOT NULL,
  `nombre_almacenado` varchar(255) NOT NULL,
  `ruta_clave` varchar(500) NOT NULL,
  `proveedor_almacenamiento` enum('LOCAL','CLOUD') NOT NULL DEFAULT 'LOCAL',
  `mime_type` varchar(100) DEFAULT NULL,
  `id_usuario_carga` bigint(20) UNSIGNED NOT NULL,
  `visibilidad` enum('PRIVADO','INTERNO','PUBLICO') NOT NULL DEFAULT 'INTERNO',
  `estado` enum('ACTIVO','INACTIVO') NOT NULL DEFAULT 'ACTIVO',
  `fecha_carga` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `archivos`
--

INSERT INTO `archivos` (`id_archivo`, `codigo_archivo`, `tipo_archivo`, `entidad_tipo`, `entidad_id`, `nombre_original`, `nombre_almacenado`, `ruta_clave`, `proveedor_almacenamiento`, `mime_type`, `id_usuario_carga`, `visibilidad`, `estado`, `fecha_carga`) VALUES
(1, 'ARC-00001', 'IMAGEN', 'SOLICITUD_LOTE', 2, 'Acelga_fresca_con_montanas_al_fondo.png', '51a8c897dd194858a530f13f14882293.png', 'uploads/solicitudes/51a8c897dd194858a530f13f14882293.png', 'LOCAL', 'image/png', 2, 'INTERNO', 'ACTIVO', '2026-10-02 19:39:13'),
(2, 'ARC-00002', 'IMAGEN', 'SOLICITUD_LOTE', 3, 'choclo.png', 'a085b6896a09485a83f447139ecfbf0d.png', 'uploads/solicitudes/a085b6896a09485a83f447139ecfbf0d.png', 'LOCAL', 'image/png', 2, 'INTERNO', 'ACTIVO', '2026-10-02 21:19:54');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `asignaciones_cuadrilla`
--

CREATE TABLE `asignaciones_cuadrilla` (
  `id_asignacion` bigint(20) UNSIGNED NOT NULL,
  `id_cosecha` bigint(20) UNSIGNED NOT NULL,
  `id_cuadrilla` bigint(20) UNSIGNED NOT NULL,
  `numero_trabajadores` smallint(5) UNSIGNED NOT NULL,
  `jornal_acordado` decimal(10,2) NOT NULL,
  `fecha_asignacion` datetime NOT NULL DEFAULT current_timestamp(),
  `estado` enum('ASIGNADA','CONFIRMADA','COMPLETADA','CANCELADA') NOT NULL DEFAULT 'ASIGNADA'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `auditoria`
--

CREATE TABLE `auditoria` (
  `id_auditoria` bigint(20) UNSIGNED NOT NULL,
  `id_usuario` bigint(20) UNSIGNED DEFAULT NULL,
  `rol` varchar(40) DEFAULT NULL,
  `accion` varchar(100) NOT NULL,
  `modulo` varchar(60) NOT NULL,
  `entidad_tipo` varchar(50) NOT NULL,
  `entidad_id` bigint(20) UNSIGNED DEFAULT NULL,
  `valor_anterior` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`valor_anterior`)),
  `valor_nuevo` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`valor_nuevo`)),
  `direccion_ip` varchar(45) DEFAULT NULL,
  `fecha_hora` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `beneficios`
--

CREATE TABLE `beneficios` (
  `id_beneficio` bigint(20) UNSIGNED NOT NULL,
  `codigo_beneficio` varchar(24) NOT NULL,
  `nombre` varchar(150) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `puntos_requeridos` int(10) UNSIGNED NOT NULL,
  `tipo_usuario` enum('PRODUCTOR','COMPRADOR','AMBOS') NOT NULL DEFAULT 'AMBOS',
  `vigencia_inicio` date DEFAULT NULL,
  `vigencia_fin` date DEFAULT NULL,
  `stock` int(10) UNSIGNED DEFAULT NULL,
  `estado` enum('ACTIVO','INACTIVO','AGOTADO') NOT NULL DEFAULT 'ACTIVO'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `calificaciones`
--

CREATE TABLE `calificaciones` (
  `id_calificacion` bigint(20) UNSIGNED NOT NULL,
  `id_operacion` bigint(20) UNSIGNED NOT NULL,
  `id_usuario_califica` bigint(20) UNSIGNED NOT NULL,
  `id_usuario_calificado` bigint(20) UNSIGNED NOT NULL,
  `puntuacion` tinyint(3) UNSIGNED NOT NULL,
  `comentario` varchar(500) DEFAULT NULL,
  `tipo` enum('PRODUCTOR_A_COMPRADOR','COMPRADOR_A_PRODUCTOR','OTRO') NOT NULL,
  `fecha` datetime NOT NULL DEFAULT current_timestamp(),
  `estado` enum('ACTIVO','OCULTO','ANULADO') NOT NULL DEFAULT 'ACTIVO'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `campanas_agricolas`
--

CREATE TABLE `campanas_agricolas` (
  `id_campana` int(10) UNSIGNED NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `fecha_inicio` date NOT NULL,
  `fecha_fin` date NOT NULL,
  `estado` enum('PLANIFICADA','ACTIVA','CERRADA','INACTIVA') NOT NULL DEFAULT 'PLANIFICADA'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `campanas_agricolas`
--

INSERT INTO `campanas_agricolas` (`id_campana`, `nombre`, `fecha_inicio`, `fecha_fin`, `estado`) VALUES
(1, 'Campaña agrícola 2026-2027', '2026-08-01', '2027-07-31', 'ACTIVA');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `canjes_beneficios`
--

CREATE TABLE `canjes_beneficios` (
  `id_canje` bigint(20) UNSIGNED NOT NULL,
  `id_beneficio` bigint(20) UNSIGNED NOT NULL,
  `id_usuario` bigint(20) UNSIGNED NOT NULL,
  `puntos_utilizados` int(10) UNSIGNED NOT NULL,
  `fecha` datetime NOT NULL DEFAULT current_timestamp(),
  `estado` enum('SOLICITADO','APROBADO','ENTREGADO','CANCELADO') NOT NULL DEFAULT 'SOLICITADO'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `capacitaciones`
--

CREATE TABLE `capacitaciones` (
  `id_capacitacion` bigint(20) UNSIGNED NOT NULL,
  `codigo_capacitacion` varchar(24) NOT NULL,
  `titulo` varchar(180) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `fecha` date NOT NULL,
  `hora` time DEFAULT NULL,
  `lugar` varchar(255) NOT NULL,
  `latitud` decimal(10,7) DEFAULT NULL,
  `longitud` decimal(10,7) DEFAULT NULL,
  `capacidad` int(10) UNSIGNED DEFAULT NULL,
  `estado` enum('PROGRAMADA','ABIERTA','CERRADA','REALIZADA','CANCELADA') NOT NULL DEFAULT 'PROGRAMADA'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `capacitacion_asistentes`
--

CREATE TABLE `capacitacion_asistentes` (
  `id_asistencia` bigint(20) UNSIGNED NOT NULL,
  `id_capacitacion` bigint(20) UNSIGNED NOT NULL,
  `id_usuario` bigint(20) UNSIGNED NOT NULL,
  `confirmado` tinyint(1) NOT NULL DEFAULT 0,
  `estado_asistencia` enum('REGISTRADO','CONFIRMADO','ASISTIO','NO_ASISTIO','CANCELADO') NOT NULL DEFAULT 'REGISTRADO',
  `fecha_registro` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categorias_producto`
--

CREATE TABLE `categorias_producto` (
  `id_categoria` int(10) UNSIGNED NOT NULL,
  `nombre` varchar(80) NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `estado` enum('ACTIVO','INACTIVO') NOT NULL DEFAULT 'ACTIVO'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `categorias_producto`
--

INSERT INTO `categorias_producto` (`id_categoria`, `nombre`, `descripcion`, `estado`) VALUES
(1, 'Tubérculos', 'Tubérculos y raíces de producción agrícola', 'ACTIVO'),
(2, 'Hortalizas', 'Hortalizas comerciales', 'ACTIVO'),
(3, 'Leguminosas', 'Leguminosas de consumo humano', 'ACTIVO'),
(4, 'Granos andinos', 'Granos andinos', 'ACTIVO'),
(5, 'Cereales', 'Cereales y maíces', 'ACTIVO'),
(6, 'Otros', 'Otros productos agrícolas', 'ACTIVO');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `compradores`
--

CREATE TABLE `compradores` (
  `id_comprador` bigint(20) UNSIGNED NOT NULL,
  `id_usuario` bigint(20) UNSIGNED NOT NULL,
  `codigo_comprador` varchar(20) NOT NULL,
  `tipo_comprador` enum('PERSONA_CON_NEGOCIO','RESTAURANTE','COMERCIANTE','MERCADO','DISTRIBUIDOR','SUPERMERCADO','EMPRESA','OTRO') NOT NULL DEFAULT 'OTRO',
  `nombre_comercial` varchar(150) DEFAULT NULL,
  `estado_verificacion` enum('PENDIENTE','VERIFICADO','OBSERVADO','RECHAZADO') NOT NULL DEFAULT 'PENDIENTE',
  `reputacion` decimal(3,2) NOT NULL DEFAULT 0.00,
  `estado` enum('ACTIVO','INACTIVO') NOT NULL DEFAULT 'ACTIVO'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `compradores`
--

INSERT INTO `compradores` (`id_comprador`, `id_usuario`, `codigo_comprador`, `tipo_comprador`, `nombre_comercial`, `estado_verificacion`, `reputacion`, `estado`) VALUES
(1, 3, 'COM-00001', 'PERSONA_CON_NEGOCIO', NULL, 'PENDIENTE', 0.00, 'ACTIVO');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `contenidos_educativos`
--

CREATE TABLE `contenidos_educativos` (
  `id_contenido` bigint(20) UNSIGNED NOT NULL,
  `titulo` varchar(180) NOT NULL,
  `descripcion` text NOT NULL,
  `categoria` varchar(80) NOT NULL,
  `tipo` varchar(80) NOT NULL,
  `imagen` varchar(180) NOT NULL,
  `video` varchar(255) DEFAULT NULL,
  `id_usuario_creador` bigint(20) UNSIGNED NOT NULL,
  `estado` varchar(16) NOT NULL,
  `fecha_creacion` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cosechas`
--

CREATE TABLE `cosechas` (
  `id_cosecha` bigint(20) UNSIGNED NOT NULL,
  `codigo_cosecha` varchar(24) NOT NULL,
  `id_operacion` bigint(20) UNSIGNED NOT NULL,
  `fecha_programada` date NOT NULL,
  `fecha_inicio` datetime DEFAULT NULL,
  `fecha_fin` datetime DEFAULT NULL,
  `produccion_real` decimal(14,2) DEFAULT NULL,
  `trabajadores_requeridos_estimados` smallint(5) UNSIGNED DEFAULT NULL,
  `costo_base_estimado` decimal(14,2) DEFAULT NULL,
  `costo_real` decimal(14,2) DEFAULT NULL,
  `estado` enum('PROGRAMADA','EN_PROCESO','FINALIZADA_PENDIENTE_VALIDACION','VALIDADA','CANCELADA') NOT NULL DEFAULT 'PROGRAMADA',
  `observaciones` text DEFAULT NULL,
  `id_responsable` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `cosechas`
--

INSERT INTO `cosechas` (`id_cosecha`, `codigo_cosecha`, `id_operacion`, `fecha_programada`, `fecha_inicio`, `fecha_fin`, `produccion_real`, `trabajadores_requeridos_estimados`, `costo_base_estimado`, `costo_real`, `estado`, `observaciones`, `id_responsable`) VALUES
(1, 'CS-00001', 1, '2026-10-05', NULL, NULL, NULL, 10, 0.00, NULL, 'PROGRAMADA', 'Cosecha programada por administración.', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cotizaciones_logisticas`
--

CREATE TABLE `cotizaciones_logisticas` (
  `id_cotizacion` bigint(20) UNSIGNED NOT NULL,
  `codigo_cotizacion` varchar(24) NOT NULL,
  `id_cotizacion_operacion` bigint(20) UNSIGNED NOT NULL,
  `latitud_origen` decimal(10,7) DEFAULT NULL,
  `longitud_origen` decimal(10,7) DEFAULT NULL,
  `latitud_destino` decimal(10,7) DEFAULT NULL,
  `longitud_destino` decimal(10,7) DEFAULT NULL,
  `modo_calculo` enum('AUTOMATICO','MONTO_FIJO') NOT NULL DEFAULT 'AUTOMATICO',
  `distancia_km` decimal(12,2) DEFAULT NULL,
  `duracion_estimada_min` int(10) UNSIGNED DEFAULT NULL,
  `proveedor_ruta` varchar(50) DEFAULT NULL,
  `fecha_consulta_ruta` datetime DEFAULT NULL,
  `peso_kg` decimal(14,2) DEFAULT NULL,
  `tipo_vehiculo` varchar(80) DEFAULT NULL,
  `cantidad_vehiculos` smallint(5) UNSIGNED DEFAULT NULL,
  `precio_combustible` decimal(10,4) DEFAULT NULL,
  `rendimiento` decimal(10,2) DEFAULT NULL,
  `costo_combustible` decimal(14,2) DEFAULT NULL,
  `costo_operativo` decimal(14,2) DEFAULT NULL,
  `carga_descarga` decimal(14,2) DEFAULT NULL,
  `peajes` decimal(14,2) DEFAULT NULL,
  `seguro` decimal(14,2) DEFAULT NULL,
  `otros_costos` decimal(14,2) DEFAULT NULL,
  `costo_base_flete` decimal(14,2) NOT NULL,
  `monto_fijo` decimal(14,2) DEFAULT NULL,
  `motivo_monto_fijo` varchar(500) DEFAULT NULL,
  `margen_agrovia_pct` decimal(6,3) NOT NULL DEFAULT 5.000,
  `margen_agrovia_monto` decimal(14,2) NOT NULL DEFAULT 0.00,
  `precio_flete_cliente` decimal(14,2) NOT NULL,
  `fecha_calculo` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `cotizaciones_logisticas`
--

INSERT INTO `cotizaciones_logisticas` (`id_cotizacion`, `codigo_cotizacion`, `id_cotizacion_operacion`, `latitud_origen`, `longitud_origen`, `latitud_destino`, `longitud_destino`, `modo_calculo`, `distancia_km`, `duracion_estimada_min`, `proveedor_ruta`, `fecha_consulta_ruta`, `peso_kg`, `tipo_vehiculo`, `cantidad_vehiculos`, `precio_combustible`, `rendimiento`, `costo_combustible`, `costo_operativo`, `carga_descarga`, `peajes`, `seguro`, `otros_costos`, `costo_base_flete`, `monto_fijo`, `motivo_monto_fijo`, `margen_agrovia_pct`, `margen_agrovia_monto`, `precio_flete_cliente`, `fecha_calculo`) VALUES
(1, 'FLT-00001', 1, NULL, NULL, NULL, NULL, 'AUTOMATICO', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.00, NULL, NULL, 5.000, 0.00, 0.00, '2026-10-02 19:45:45'),
(2, 'FLT-00002', 2, NULL, NULL, NULL, NULL, 'AUTOMATICO', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.00, NULL, NULL, 5.000, 0.00, 0.00, '2026-10-02 21:23:01');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cotizaciones_operacion`
--

CREATE TABLE `cotizaciones_operacion` (
  `id_cotizacion_operacion` bigint(20) UNSIGNED NOT NULL,
  `codigo_cotizacion` varchar(24) NOT NULL,
  `id_lote` bigint(20) UNSIGNED NOT NULL,
  `id_comprador` bigint(20) UNSIGNED NOT NULL,
  `id_direccion_entrega` bigint(20) UNSIGNED NOT NULL,
  `valor_produccion` decimal(14,2) NOT NULL,
  `costo_base_cosecha` decimal(14,2) NOT NULL DEFAULT 0.00,
  `margen_cosecha_pct` decimal(6,3) NOT NULL DEFAULT 5.000,
  `margen_cosecha_monto` decimal(14,2) NOT NULL DEFAULT 0.00,
  `precio_cosecha_cliente` decimal(14,2) NOT NULL DEFAULT 0.00,
  `costo_base_flete` decimal(14,2) NOT NULL DEFAULT 0.00,
  `margen_transporte_pct` decimal(6,3) NOT NULL DEFAULT 5.000,
  `margen_transporte_monto` decimal(14,2) NOT NULL DEFAULT 0.00,
  `precio_flete_cliente` decimal(14,2) NOT NULL DEFAULT 0.00,
  `comision_venta_pct` decimal(6,3) NOT NULL DEFAULT 5.000,
  `comision_venta_monto` decimal(14,2) NOT NULL DEFAULT 0.00,
  `ingreso_total_agrovia` decimal(14,2) NOT NULL DEFAULT 0.00,
  `total_operacion` decimal(14,2) NOT NULL,
  `fecha_calculo` datetime NOT NULL DEFAULT current_timestamp(),
  `fecha_vencimiento` datetime NOT NULL,
  `estado` enum('VIGENTE','ACEPTADA','VENCIDA','CANCELADA') NOT NULL DEFAULT 'VIGENTE'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `cotizaciones_operacion`
--

INSERT INTO `cotizaciones_operacion` (`id_cotizacion_operacion`, `codigo_cotizacion`, `id_lote`, `id_comprador`, `id_direccion_entrega`, `valor_produccion`, `costo_base_cosecha`, `margen_cosecha_pct`, `margen_cosecha_monto`, `precio_cosecha_cliente`, `costo_base_flete`, `margen_transporte_pct`, `margen_transporte_monto`, `precio_flete_cliente`, `comision_venta_pct`, `comision_venta_monto`, `ingreso_total_agrovia`, `total_operacion`, `fecha_calculo`, `fecha_vencimiento`, `estado`) VALUES
(1, 'COT-00001', 2, 1, 1, 0.00, 0.00, 5.000, 0.00, 0.00, 0.00, 5.000, 0.00, 0.00, 5.000, 0.00, 0.00, 0.00, '2026-10-02 19:45:45', '2026-10-09 19:45:45', 'ACEPTADA'),
(2, 'COT-00002', 3, 1, 1, 823600.00, 65888.00, 5.000, 3294.40, 892782.40, 0.00, 5.000, 0.00, 0.00, 5.000, 41180.00, 44474.40, 933962.40, '2026-10-02 21:23:01', '2026-10-09 21:23:01', 'ACEPTADA');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cuadrillas`
--

CREATE TABLE `cuadrillas` (
  `id_cuadrilla` bigint(20) UNSIGNED NOT NULL,
  `codigo_cuadrilla` varchar(24) NOT NULL,
  `nombre` varchar(120) NOT NULL,
  `responsable` varchar(180) NOT NULL,
  `telefono` varchar(20) NOT NULL,
  `zona` varchar(120) DEFAULT NULL,
  `numero_integrantes_disponibles` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `capacidad_max_integrantes` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `disponibilidad` enum('DISPONIBLE','PARCIAL','OCUPADA','NO_DISPONIBLE') NOT NULL DEFAULT 'DISPONIBLE',
  `estado` enum('ACTIVO','INACTIVO') NOT NULL DEFAULT 'ACTIVO'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `datos_facturacion`
--

CREATE TABLE `datos_facturacion` (
  `id_facturacion` bigint(20) UNSIGNED NOT NULL,
  `id_comprador` bigint(20) UNSIGNED NOT NULL,
  `tipo_documento` enum('DNI','RUC','CE','PASAPORTE','OTRO') NOT NULL,
  `numero_documento` varchar(20) NOT NULL,
  `nombre_razon_social` varchar(180) NOT NULL,
  `direccion_fiscal` varchar(255) DEFAULT NULL,
  `id_ubigeo` int(10) UNSIGNED DEFAULT NULL,
  `correo_facturacion` varchar(150) DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `predeterminado` tinyint(1) NOT NULL DEFAULT 0,
  `estado` enum('ACTIVO','INACTIVO') NOT NULL DEFAULT 'ACTIVO'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `devoluciones`
--

CREATE TABLE `devoluciones` (
  `id_devolucion` bigint(20) UNSIGNED NOT NULL,
  `codigo_devolucion` varchar(24) NOT NULL,
  `id_operacion` bigint(20) UNSIGNED NOT NULL,
  `id_pago` bigint(20) UNSIGNED NOT NULL,
  `motivo` varchar(500) NOT NULL,
  `monto` decimal(14,2) NOT NULL,
  `metodo` enum('TRANSFERENCIA_BANCARIA','BILLETERA_DIGITAL','EFECTIVO','OTRO') NOT NULL,
  `referencia` varchar(120) DEFAULT NULL,
  `id_usuario_autoriza` bigint(20) UNSIGNED NOT NULL,
  `id_usuario_ejecuta` bigint(20) UNSIGNED DEFAULT NULL,
  `fecha` datetime NOT NULL DEFAULT current_timestamp(),
  `estado` enum('SOLICITADA','AUTORIZADA','EJECUTADA','RECHAZADA','CANCELADA') NOT NULL DEFAULT 'SOLICITADA'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `direcciones_entrega`
--

CREATE TABLE `direcciones_entrega` (
  `id_direccion` bigint(20) UNSIGNED NOT NULL,
  `id_comprador` bigint(20) UNSIGNED NOT NULL,
  `nombre_referencia` varchar(120) NOT NULL,
  `direccion` varchar(255) NOT NULL,
  `referencia` varchar(255) DEFAULT NULL,
  `latitud` decimal(10,7) DEFAULT NULL,
  `longitud` decimal(10,7) DEFAULT NULL,
  `id_ubigeo` int(10) UNSIGNED DEFAULT NULL,
  `predeterminada` tinyint(1) NOT NULL DEFAULT 0,
  `estado` enum('ACTIVO','INACTIVO') NOT NULL DEFAULT 'ACTIVO'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `direcciones_entrega`
--

INSERT INTO `direcciones_entrega` (`id_direccion`, `id_comprador`, `nombre_referencia`, `direccion`, `referencia`, `latitud`, `longitud`, `id_ubigeo`, `predeterminada`, `estado`) VALUES
(1, 1, 'Dirección principal', 'Dirección por definir', 'Entrega para la operación', NULL, NULL, NULL, 1, 'ACTIVO');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `entregas`
--

CREATE TABLE `entregas` (
  `id_entrega` bigint(20) UNSIGNED NOT NULL,
  `codigo_entrega` varchar(24) NOT NULL,
  `id_operacion` bigint(20) UNSIGNED NOT NULL,
  `id_transporte` bigint(20) UNSIGNED NOT NULL,
  `fecha_hora` datetime NOT NULL DEFAULT current_timestamp(),
  `nombre_receptor` varchar(180) NOT NULL,
  `documento_receptor` varchar(20) DEFAULT NULL,
  `cantidad_entregada` decimal(14,2) DEFAULT NULL,
  `conforme` tinyint(1) DEFAULT NULL,
  `id_usuario_confirma` bigint(20) UNSIGNED DEFAULT NULL,
  `observaciones` text DEFAULT NULL,
  `estado` enum('PENDIENTE_CONFIRMACION','CONFORME','OBSERVADA','RECHAZADA') NOT NULL DEFAULT 'PENDIENTE_CONFIRMACION'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `historial_estados`
--

CREATE TABLE `historial_estados` (
  `id_historial` bigint(20) UNSIGNED NOT NULL,
  `entidad_tipo` varchar(50) NOT NULL,
  `entidad_id` bigint(20) UNSIGNED NOT NULL,
  `estado_anterior` varchar(60) DEFAULT NULL,
  `estado_nuevo` varchar(60) NOT NULL,
  `id_usuario` bigint(20) UNSIGNED DEFAULT NULL,
  `fecha` datetime NOT NULL DEFAULT current_timestamp(),
  `observacion` varchar(500) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `historial_estados`
--

INSERT INTO `historial_estados` (`id_historial`, `entidad_tipo`, `entidad_id`, `estado_anterior`, `estado_nuevo`, `id_usuario`, `fecha`, `observacion`) VALUES
(1, 'OPERACION', 2, NULL, 'PENDIENTE_PAGO', 1, '2026-10-02 21:23:32', 'Operación creada y reserva confirmada tras aceptar la cotización.'),
(2, 'OPERACION', 2, 'PENDIENTE_PAGO', 'PAGO_CONFIRMADO', 1, '2026-10-02 21:23:44', 'Pago confirmado por administración.');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `incidencias`
--

CREATE TABLE `incidencias` (
  `id_incidencia` bigint(20) UNSIGNED NOT NULL,
  `codigo_incidencia` varchar(24) NOT NULL,
  `id_usuario_reporta` bigint(20) UNSIGNED NOT NULL,
  `id_operacion` bigint(20) UNSIGNED DEFAULT NULL,
  `categoria` varchar(80) NOT NULL,
  `descripcion` text NOT NULL,
  `prioridad` enum('BAJA','MEDIA','ALTA','CRITICA') NOT NULL DEFAULT 'MEDIA',
  `estado` enum('ABIERTO','EN_ATENCION','RESUELTO','CERRADO') NOT NULL DEFAULT 'ABIERTO',
  `id_responsable` bigint(20) UNSIGNED DEFAULT NULL,
  `fecha_apertura` datetime NOT NULL DEFAULT current_timestamp(),
  `fecha_cierre` datetime DEFAULT NULL,
  `solucion` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `incidencias`
--

INSERT INTO `incidencias` (`id_incidencia`, `codigo_incidencia`, `id_usuario_reporta`, `id_operacion`, `categoria`, `descripcion`, `prioridad`, `estado`, `id_responsable`, `fecha_apertura`, `fecha_cierre`, `solucion`) VALUES
(1, 'INC-00001', 1, 1, 'OPERACIONAL', 'el transporte\r\n', 'BAJA', 'ABIERTO', 1, '2026-10-02 19:48:40', NULL, NULL);

-- --------------------------------------------------------

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `liquidaciones`
--

CREATE TABLE `liquidaciones` (
  `id_liquidacion` bigint(20) UNSIGNED NOT NULL,
  `codigo_liquidacion` varchar(24) NOT NULL,
  `id_operacion` bigint(20) UNSIGNED NOT NULL,
  `id_productor_beneficiario` bigint(20) UNSIGNED DEFAULT NULL,
  `id_cuadrilla_beneficiaria` bigint(20) UNSIGNED DEFAULT NULL,
  `id_transportista_beneficiario` bigint(20) UNSIGNED DEFAULT NULL,
  `beneficiario_agrovia` tinyint(1) NOT NULL DEFAULT 0,
  `concepto` varchar(150) NOT NULL,
  `monto` decimal(14,2) NOT NULL,
  `metodo` enum('TRANSFERENCIA_BANCARIA','BILLETERA_DIGITAL','EFECTIVO_PRESENCIAL','INTERNO') NOT NULL,
  `estado` enum('PENDIENTE','HABILITADA','EN_PROCESO','PAGADA','CANCELADA') NOT NULL DEFAULT 'PENDIENTE',
  `fecha_programada` datetime DEFAULT NULL,
  `fecha_pago` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `lotes`
--

CREATE TABLE `lotes` (
  `id_lote` bigint(20) UNSIGNED NOT NULL,
  `codigo_lote` varchar(24) NOT NULL,
  `id_solicitud` bigint(20) UNSIGNED NOT NULL,
  `id_valorizacion` bigint(20) UNSIGNED NOT NULL,
  `produccion_min` decimal(14,2) DEFAULT NULL,
  `produccion_max` decimal(14,2) DEFAULT NULL,
  `precio_publicado` decimal(14,2) NOT NULL,
  `fecha_cosecha_inicio` date DEFAULT NULL,
  `fecha_cosecha_fin` date DEFAULT NULL,
  `estado_cultivo_comercial` enum('EN_DESARROLLO','PROXIMO_COSECHA','LISTO_COSECHA','COSECHADO') NOT NULL DEFAULT 'EN_DESARROLLO',
  `fecha_publicacion` datetime DEFAULT NULL,
  `estado` enum('DISPONIBLE','RESERVADO','VENDIDO','COSECHA_PROGRAMADA','COSECHADO','EN_TRANSPORTE','ENTREGADO','COMPLETADO','CANCELADO') NOT NULL DEFAULT 'DISPONIBLE'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `lotes`
--

INSERT INTO `lotes` (`id_lote`, `codigo_lote`, `id_solicitud`, `id_valorizacion`, `produccion_min`, `produccion_max`, `precio_publicado`, `fecha_cosecha_inicio`, `fecha_cosecha_fin`, `estado_cultivo_comercial`, `fecha_publicacion`, `estado`) VALUES
(1, 'LOT-00001', 1, 1, 100.00, 100.00, 0.00, '2026-09-28', '2026-10-01', 'PROXIMO_COSECHA', '2026-10-01 21:54:49', 'RESERVADO'),
(2, 'LOT-00002', 2, 2, 100.00, 100.00, 0.00, '2026-09-20', '2026-10-02', 'PROXIMO_COSECHA', '2026-10-02 19:39:39', 'COSECHA_PROGRAMADA'),
(3, 'LOT-00003', 3, 3, 200.00, 200.00, 0.00, '2026-05-30', '2026-06-20', 'PROXIMO_COSECHA', '2026-10-02 21:21:07', 'VENDIDO');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `medios_pago_usuario`
--

CREATE TABLE `medios_pago_usuario` (
  `id_medio_pago` bigint(20) UNSIGNED NOT NULL,
  `id_usuario` bigint(20) UNSIGNED NOT NULL,
  `tipo_medio` enum('TRANSFERENCIA_BANCARIA','BILLETERA_DIGITAL','EFECTIVO_PRESENCIAL') NOT NULL,
  `entidad` varchar(100) DEFAULT NULL,
  `titular` varchar(180) DEFAULT NULL,
  `telefono_asociado` varchar(20) DEFAULT NULL,
  `numero_cuenta_enmascarado` varchar(40) DEFAULT NULL,
  `cci_enmascarado` varchar(40) DEFAULT NULL,
  `predeterminado` tinyint(1) NOT NULL DEFAULT 0,
  `verificado` tinyint(1) NOT NULL DEFAULT 0,
  `estado` enum('ACTIVO','INACTIVO') NOT NULL DEFAULT 'ACTIVO'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `movimientos_puntos`
--

CREATE TABLE `movimientos_puntos` (
  `id_movimiento` bigint(20) UNSIGNED NOT NULL,
  `id_usuario` bigint(20) UNSIGNED NOT NULL,
  `tipo` enum('CREDITO','DEBITO') NOT NULL,
  `puntos` int(11) NOT NULL,
  `motivo` varchar(255) NOT NULL,
  `id_operacion` bigint(20) UNSIGNED DEFAULT NULL,
  `fecha` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `notificaciones`
--

CREATE TABLE `notificaciones` (
  `id_notificacion` bigint(20) UNSIGNED NOT NULL,
  `id_usuario` bigint(20) UNSIGNED NOT NULL,
  `titulo` varchar(180) NOT NULL,
  `mensaje` text NOT NULL,
  `tipo` varchar(60) NOT NULL,
  `entidad_tipo` varchar(50) DEFAULT NULL,
  `entidad_id` bigint(20) UNSIGNED DEFAULT NULL,
  `leida` tinyint(1) NOT NULL DEFAULT 0,
  `fecha` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `operaciones`
--

CREATE TABLE `operaciones` (
  `id_operacion` bigint(20) UNSIGNED NOT NULL,
  `codigo_operacion` varchar(24) NOT NULL,
  `id_lote` bigint(20) UNSIGNED NOT NULL,
  `id_productor` bigint(20) UNSIGNED NOT NULL,
  `id_comprador` bigint(20) UNSIGNED NOT NULL,
  `id_direccion_entrega` bigint(20) UNSIGNED NOT NULL,
  `id_cotizacion_operacion` bigint(20) UNSIGNED NOT NULL,
  `modalidad_operacion` enum('COSECHA_PROXIMA','COMPRA_ANTICIPADA') NOT NULL,
  `valor_produccion` decimal(14,2) NOT NULL,
  `costo_base_cosecha` decimal(14,2) NOT NULL DEFAULT 0.00,
  `margen_cosecha_pct` decimal(6,3) NOT NULL DEFAULT 5.000,
  `margen_cosecha_monto` decimal(14,2) NOT NULL DEFAULT 0.00,
  `precio_cosecha_cliente` decimal(14,2) NOT NULL DEFAULT 0.00,
  `costo_base_flete` decimal(14,2) NOT NULL DEFAULT 0.00,
  `margen_transporte_pct` decimal(6,3) NOT NULL DEFAULT 5.000,
  `margen_transporte_monto` decimal(14,2) NOT NULL DEFAULT 0.00,
  `precio_flete_cliente` decimal(14,2) NOT NULL DEFAULT 0.00,
  `comision_venta_pct` decimal(6,3) NOT NULL DEFAULT 5.000,
  `comision_venta_monto` decimal(14,2) NOT NULL DEFAULT 0.00,
  `ingreso_total_agrovia` decimal(14,2) NOT NULL DEFAULT 0.00,
  `total_operacion` decimal(14,2) NOT NULL,
  `causa_cancelacion` varchar(500) DEFAULT NULL,
  `estado` enum('PENDIENTE_PAGO','PAGO_CONFIRMADO','COSECHA_PROGRAMADA','EN_COSECHA','COSECHA_VALIDADA','EN_TRANSPORTE','ENTREGADA','COMPLETADA','CANCELADA') NOT NULL DEFAULT 'PENDIENTE_PAGO',
  `fecha_operacion` datetime NOT NULL DEFAULT current_timestamp(),
  `fecha_creacion` datetime NOT NULL DEFAULT current_timestamp(),
  `fecha_actualizacion` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `operaciones`
--

INSERT INTO `operaciones` (`id_operacion`, `codigo_operacion`, `id_lote`, `id_productor`, `id_comprador`, `id_direccion_entrega`, `id_cotizacion_operacion`, `modalidad_operacion`, `valor_produccion`, `costo_base_cosecha`, `margen_cosecha_pct`, `margen_cosecha_monto`, `precio_cosecha_cliente`, `costo_base_flete`, `margen_transporte_pct`, `margen_transporte_monto`, `precio_flete_cliente`, `comision_venta_pct`, `comision_venta_monto`, `ingreso_total_agrovia`, `total_operacion`, `causa_cancelacion`, `estado`, `fecha_operacion`, `fecha_creacion`, `fecha_actualizacion`) VALUES
(1, 'OP-00001', 2, 1, 1, 1, 1, 'COSECHA_PROXIMA', 0.00, 0.00, 5.000, 0.00, 0.00, 0.00, 5.000, 0.00, 0.00, 5.000, 0.00, 0.00, 0.00, NULL, 'COSECHA_PROGRAMADA', '2026-10-02 19:46:30', '2026-10-02 19:46:30', '2026-10-02 19:47:51'),
(2, 'OP-00002', 3, 1, 1, 1, 2, 'COSECHA_PROXIMA', 823600.00, 65888.00, 5.000, 3294.40, 892782.40, 0.00, 5.000, 0.00, 0.00, 5.000, 41180.00, 44474.40, 933962.40, NULL, 'PAGO_CONFIRMADO', '2026-10-02 21:23:32', '2026-10-02 21:23:32', '2026-10-02 21:23:44');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ordenes_pago`
--

CREATE TABLE `ordenes_pago` (
  `id_orden_pago` bigint(20) UNSIGNED NOT NULL,
  `codigo_orden_pago` varchar(24) NOT NULL,
  `id_liquidacion` bigint(20) UNSIGNED NOT NULL,
  `metodo_pago` enum('TRANSFERENCIA_BANCARIA','BILLETERA_DIGITAL','EFECTIVO_PRESENCIAL','INTERNO') NOT NULL,
  `monto` decimal(14,2) NOT NULL,
  `id_usuario_solicita` bigint(20) UNSIGNED NOT NULL,
  `id_usuario_autoriza` bigint(20) UNSIGNED DEFAULT NULL,
  `id_usuario_ejecuta` bigint(20) UNSIGNED DEFAULT NULL,
  `fecha_solicitud` datetime NOT NULL DEFAULT current_timestamp(),
  `fecha_autorizacion` datetime DEFAULT NULL,
  `fecha_ejecucion` datetime DEFAULT NULL,
  `estado` enum('GENERADA','PENDIENTE_AUTORIZACION','AUTORIZADA','EN_EJECUCION','PAGADA','RECHAZADA','CANCELADA') NOT NULL DEFAULT 'GENERADA',
  `observaciones` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pagos`
--

CREATE TABLE `pagos` (
  `id_pago` bigint(20) UNSIGNED NOT NULL,
  `codigo_pago` varchar(24) NOT NULL,
  `id_operacion` bigint(20) UNSIGNED NOT NULL,
  `id_facturacion` bigint(20) UNSIGNED DEFAULT NULL,
  `tipo_pago` enum('PAGO_COMPRADOR','OTRO') NOT NULL DEFAULT 'PAGO_COMPRADOR',
  `monto` decimal(14,2) NOT NULL,
  `metodo` enum('TRANSFERENCIA_BANCARIA','BILLETERA_DIGITAL','EFECTIVO','OTRO') NOT NULL,
  `referencia` varchar(120) DEFAULT NULL,
  `fecha` datetime NOT NULL DEFAULT current_timestamp(),
  `estado` enum('PENDIENTE','RECIBIDO','RETENIDO','DEVUELTO','ANULADO') NOT NULL DEFAULT 'PENDIENTE'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `pagos`
--

INSERT INTO `pagos` (`id_pago`, `codigo_pago`, `id_operacion`, `id_facturacion`, `tipo_pago`, `monto`, `metodo`, `referencia`, `fecha`, `estado`) VALUES
(1, 'PG-00001', 1, NULL, 'PAGO_COMPRADOR', 0.00, 'TRANSFERENCIA_BANCARIA', 'CONFIRMADO_MANUAL', '2026-10-02 19:47:09', 'RECIBIDO'),
(2, 'PG-00002', 2, NULL, 'PAGO_COMPRADOR', 933962.40, 'TRANSFERENCIA_BANCARIA', 'CONFIRMADO_MANUAL', '2026-10-02 21:23:44', 'RECIBIDO');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pagos_efectivo`
--

CREATE TABLE `pagos_efectivo` (
  `id_pago_efectivo` bigint(20) UNSIGNED NOT NULL,
  `id_orden_pago` bigint(20) UNSIGNED NOT NULL,
  `monto_entregado` decimal(14,2) NOT NULL,
  `fecha_entrega` date NOT NULL,
  `hora_entrega` time NOT NULL,
  `lugar_entrega` varchar(255) NOT NULL,
  `id_usuario_entrega` bigint(20) UNSIGNED NOT NULL,
  `nombre_receptor` varchar(180) NOT NULL,
  `documento_receptor` varchar(20) NOT NULL,
  `conforme` tinyint(1) NOT NULL DEFAULT 0,
  `observaciones` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `parametros_comerciales`
--

CREATE TABLE `parametros_comerciales` (
  `id_parametro` int(10) UNSIGNED NOT NULL,
  `codigo` varchar(80) NOT NULL,
  `nombre` varchar(120) NOT NULL,
  `valor` decimal(14,4) NOT NULL,
  `tipo_dato` enum('PORCENTAJE','MONTO','FACTOR','NUMERO') NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `fecha_actualizacion` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `id_usuario_actualiza` bigint(20) UNSIGNED DEFAULT NULL,
  `estado` enum('ACTIVO','INACTIVO') NOT NULL DEFAULT 'ACTIVO'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `parametros_comerciales`
--

INSERT INTO `parametros_comerciales` (`id_parametro`, `codigo`, `nombre`, `valor`, `tipo_dato`, `descripcion`, `fecha_actualizacion`, `id_usuario_actualiza`, `estado`) VALUES
(1, 'COMISION_VENTA_AGROVIA', 'Comisión comercial Agrovía', 5.0000, 'PORCENTAJE', 'Porcentaje sobre valor de producción', '2026-08-21 22:27:04', NULL, 'ACTIVO'),
(2, 'MARGEN_COSECHA_AGROVIA', 'Margen Agrovía por cosecha', 5.0000, 'PORCENTAJE', 'Margen interno aplicado al costo base del servicio de cosecha.', '2026-08-21 22:58:43', NULL, 'ACTIVO'),
(3, 'MARGEN_TRANSPORTE_AGROVIA', 'Margen Agrovía por transporte', 5.0000, 'PORCENTAJE', 'Margen interno configurable aplicado al costo base del flete.', '2026-08-21 23:03:50', NULL, 'ACTIVO'),
(4, 'PESO_PRECIO_ACTUAL', 'Peso del precio actual', 60.0000, 'PORCENTAJE', 'Ponderación precio actual', '2026-08-21 22:27:04', NULL, 'ACTIVO'),
(5, 'PESO_PROMEDIO', 'Peso del promedio histórico', 40.0000, 'PORCENTAJE', 'Ponderación promedio histórico', '2026-08-21 22:27:04', NULL, 'ACTIVO'),
(6, 'FACTOR_TEMPORADA_DEFAULT', 'Factor de temporada inicial', 1.0000, 'FACTOR', 'Valor neutro inicial', '2026-08-21 22:13:43', NULL, 'ACTIVO'),
(7, 'FACTOR_ZONA_DEFAULT', 'Factor de zona inicial', 1.0000, 'FACTOR', 'Valor neutro inicial', '2026-08-21 22:13:43', NULL, 'ACTIVO'),
(8, 'FACTOR_CONDICION_DEFAULT', 'Factor de condición inicial', 1.0000, 'FACTOR', 'Valor neutro inicial', '2026-08-21 22:13:43', NULL, 'ACTIVO'),
(14, 'VENTANA_PROMEDIO_PRECIOS_DIAS', 'Ventana histórica de precio promedio', 30.0000, 'NUMERO', 'Cantidad de días usados para calcular promedio histórico', '2026-08-21 22:40:23', NULL, 'ACTIVO'),
(15, 'FACTOR_REFERENCIA_MAYORISTA', 'Factor inicial sobre precio mayorista', 1.0000, 'FACTOR', 'Por defecto 1.0. Comercial puede ajustarlo si usa una referencia de mercado distinta', '2026-08-21 22:40:23', NULL, 'ACTIVO'),
(16, 'PORCENTAJE_TOLERANCIA_PRODUCCION', 'Tolerancia inicial sobre producción estimada', 10.0000, 'PORCENTAJE', 'Rango de incertidumbre inicial antes de validación de campo', '2026-08-21 22:40:23', NULL, 'ACTIVO'),
(17, 'JORNAL_COSECHA_DEFAULT', 'Jornal base inicial de cosecha', 80.0000, 'MONTO', 'Valor inicial configurable para mano de obra. El valor utilizado en cada cotización debe guardarse históricamente.', '2026-08-21 22:58:43', NULL, 'ACTIVO'),
(18, 'DURACION_COSECHA_DIAS', 'Duración objetivo cosecha', 1.0000, 'NUMERO', 'Agrovía v0.1 dimensiona la cuadrilla para terminar la cosecha en un día.', '2026-08-21 22:58:43', NULL, 'ACTIVO'),
(20, 'RESERVA_CAPACIDAD_VEHICULO', 'Reserva operativa de capacidad', 5.0000, 'PORCENTAJE', 'Reserva MVP para evitar planificar el vehículo al 100% de su capacidad nominal. Editable.', '2026-08-21 23:03:50', NULL, 'ACTIVO'),
(21, 'FACTOR_RUTA_RETORNO', 'Factor de recorrido facturable', 1.0000, 'FACTOR', '1.0 cobra recorrido origen-destino. Operaciones puede modificarlo si un servicio exige retorno o reposicionamiento.', '2026-08-21 23:03:50', NULL, 'ACTIVO');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `parametros_cosecha`
--

CREATE TABLE `parametros_cosecha` (
  `id_parametro_cosecha` bigint(20) UNSIGNED NOT NULL,
  `id_producto` int(10) UNSIGNED NOT NULL,
  `id_variedad` int(10) UNSIGNED DEFAULT NULL,
  `kg_trabajador_dia` decimal(12,2) DEFAULT NULL,
  `jornales_referenciales_ha` decimal(10,2) DEFAULT NULL,
  `jornal_diario` decimal(10,2) NOT NULL DEFAULT 80.00,
  `costo_carga_tonelada` decimal(12,2) NOT NULL DEFAULT 0.00,
  `costo_acondicionamiento_tonelada` decimal(12,2) NOT NULL DEFAULT 0.00,
  `otros_costos_base` decimal(12,2) NOT NULL DEFAULT 0.00,
  `duracion_objetivo_dias` tinyint(3) UNSIGNED NOT NULL DEFAULT 1,
  `fuente` varchar(180) DEFAULT NULL,
  `url_fuente` varchar(500) DEFAULT NULL,
  `fecha_fuente` date DEFAULT NULL,
  `id_usuario_actualiza` bigint(20) UNSIGNED DEFAULT NULL,
  `fecha_actualizacion` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `estado` enum('ACTIVO','INACTIVO') NOT NULL DEFAULT 'ACTIVO'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `parametros_cosecha`
--

INSERT INTO `parametros_cosecha` (`id_parametro_cosecha`, `id_producto`, `id_variedad`, `kg_trabajador_dia`, `jornales_referenciales_ha`, `jornal_diario`, `costo_carga_tonelada`, `costo_acondicionamiento_tonelada`, `otros_costos_base`, `duracion_objetivo_dias`, `fuente`, `url_fuente`, `fecha_fuente`, `id_usuario_actualiza`, `fecha_actualizacion`, `estado`) VALUES
(1, 11, NULL, NULL, 28.00, 80.00, 50.00, 85.00, 140.00, 1, '[ESTIMADO_MVP] Acelga: 28 jornales/ha considerando corte manual, selección y acondicionamiento. Parámetro inicial editable.', NULL, '2026-08-22', NULL, '2026-08-21 22:58:43', 'ACTIVO'),
(2, 4, NULL, NULL, 30.00, 80.00, 40.00, 80.00, 150.00, 1, '[ESTIMADO_MVP] Ajo: 30 jornales/ha para cosecha, limpieza, selección y preparación de carga. Basado en manejo manual intensivo; debe validarse con cuadrillas de Chupaca.', 'https://repositorio.inia.gob.pe/', '2026-08-22', NULL, '2026-08-21 22:58:42', 'ACTIVO'),
(3, 5, NULL, NULL, 35.00, 80.00, 45.00, 75.00, 150.00, 1, '[ESTIMADO_MVP] Apio: parámetro operativo inicial de 35 jornales/ha por cosecha manual, limpieza, selección y acondicionamiento. Validar localmente.', NULL, '2026-08-22', NULL, '2026-08-21 22:58:42', 'ACTIVO'),
(4, 14, NULL, NULL, 40.00, 80.00, 40.00, 60.00, 120.00, 1, '[OFICIAL/REFERENCIAL] Guía INIA de producción comercial de arveja: 40 días-persona/ha de mano de obra de cosecha en el método propuesto (18.5 en convencional). Agrovía usa 40 como ', 'https://repositorio.inia.gob.pe/server/api/core/bitstreams/8d090be5-ed72-40f5-ba06-af79ac47672e/content', '2016-07-01', NULL, '2026-08-21 22:58:42', 'ACTIVO'),
(5, 10, NULL, NULL, 20.00, 80.00, 35.00, 60.00, 110.00, 1, '[ESTIMADO_MVP] Beterraga: 20 jornales/ha para extracción, selección y acondicionamiento. Parámetro inicial editable.', NULL, '2026-08-22', NULL, '2026-08-21 22:58:43', 'ACTIVO'),
(6, 7, NULL, NULL, 25.00, 80.00, 35.00, 65.00, 120.00, 1, '[ESTIMADO_MVP] Cebolla: 25 jornales/ha para arrancado/recolección, selección y acondicionamiento. Parámetro inicial editable y sujeto a validación local.', NULL, '2026-08-22', NULL, '2026-08-21 22:58:42', 'ACTIVO'),
(7, 3, NULL, NULL, 14.00, 80.00, 35.00, 45.00, 120.00, 1, '[REFERENCIAL] INIA: estructura de maíz con 14 jornales/ha de cosecha manual; usado como aproximación inicial para choclo. Requiere validación local.', 'https://repositorio.inia.gob.pe/server/api/core/bitstreams/1d6fcac0-4ea7-4190-a7ec-7418c4c9025d/content', '2022-01-01', NULL, '2026-08-21 22:58:42', 'ACTIVO'),
(8, 9, NULL, NULL, 22.00, 80.00, 45.00, 70.00, 130.00, 1, '[ESTIMADO_MVP] Col/Repollo: 22 jornales/ha para corte, selección y carga. Parámetro inicial editable.', NULL, '2026-08-22', NULL, '2026-08-21 22:58:43', 'ACTIVO'),
(9, 15, NULL, NULL, 55.00, 80.00, 40.00, 60.00, 120.00, 1, '[REFERENCIAL] INIA cultivo de haba: estructura de labores de corte, traslado, venteo, selección/ensacado; se usa 55 jornales/ha como referencia de cosecha y preparación de producto', 'https://repositorio.inia.gob.pe/items/fbd2255d-3ff6-457a-aaa4-164288aaf3ac', '2013-01-01', NULL, '2026-08-21 22:58:42', 'ACTIVO'),
(10, 8, NULL, NULL, 25.00, 80.00, 50.00, 90.00, 150.00, 1, '[ESTIMADO_MVP] Lechuga: 25 jornales/ha; cosecha delicada, selección y acondicionamiento. Parámetro inicial para demo, validable por Operaciones.', NULL, '2026-08-22', NULL, '2026-08-21 22:58:43', 'ACTIVO'),
(11, 2, NULL, NULL, 15.00, 80.00, 30.00, 35.00, 100.00, 1, '[OFICIAL+MVP] Referencia técnica INIA: 15 jornales/ha para cosecha de olluco. Costos complementarios son parámetros iniciales Agrovía.', 'https://repositorio.inia.gob.pe/', '2026-08-22', NULL, '2026-08-21 22:58:42', 'ACTIVO'),
(12, 1, NULL, NULL, 15.00, 80.00, 30.00, 35.00, 100.00, 1, '[OFICIAL+MVP] INIA: 15 jornales/ha para cosecha de papa. Carga, acondicionamiento y otros costos son parámetros iniciales Agrovía editables.', 'https://repositorio.inia.gob.pe/server/api/core/bitstreams/8950ddb2-9463-438c-8ab5-8b36fceec66b/content', '2024-12-31', NULL, '2026-08-21 22:58:42', 'ACTIVO'),
(13, 12, NULL, NULL, 30.00, 80.00, 45.00, 80.00, 140.00, 1, '[ESTIMADO_MVP] Poro: 30 jornales/ha para extracción, limpieza, selección y acondicionamiento. Parámetro inicial editable.', NULL, '2026-08-22', NULL, '2026-08-21 22:58:43', 'ACTIVO'),
(14, 16, NULL, NULL, 20.00, 80.00, 45.00, 70.00, 120.00, 1, '[OFICIAL+ADAPTADO] INIA costos de quinua: 15 jornales de cosecha + 2 selección + 3 postcosecha = 20 jornales/ha usados por Agrovía para preparación previa al transporte.', 'https://repositorio.inia.gob.pe/server/api/core/bitstreams/57cd2519-66bd-449a-8617-b6bb9fdf8dc2/content', '2011-12-30', NULL, '2026-08-21 22:58:42', 'ACTIVO'),
(15, 13, NULL, NULL, 20.00, 80.00, 40.00, 65.00, 110.00, 1, '[ESTIMADO_MVP] Rábano: 20 jornales/ha para extracción, selección y acondicionamiento. Parámetro inicial editable.', NULL, '2026-08-22', NULL, '2026-08-21 22:58:43', 'ACTIVO'),
(16, 6, NULL, NULL, 20.00, 80.00, 35.00, 60.00, 120.00, 1, '[ESTIMADO_MVP] Zanahoria: 20 jornales/ha como parámetro inicial para cosecha, selección y acondicionamiento. El ciclo/rendimiento INIA 101 se encuentra documentado; productividad l', 'https://repositorio.inia.gob.pe/server/api/core/bitstreams/bdc06c10-dd3e-4f5e-857e-4ab168df6419/content', '2026-08-22', NULL, '2026-08-21 22:58:42', 'ACTIVO');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `parametros_cultivo`
--

CREATE TABLE `parametros_cultivo` (
  `id_parametro_cultivo` bigint(20) UNSIGNED NOT NULL,
  `id_producto` int(10) UNSIGNED NOT NULL,
  `id_variedad` int(10) UNSIGNED DEFAULT NULL,
  `tipo_inicio_ciclo` enum('SIEMBRA','TRASPLANTE') NOT NULL DEFAULT 'SIEMBRA',
  `dias_cosecha_min` smallint(5) UNSIGNED NOT NULL,
  `dias_cosecha_max` smallint(5) UNSIGNED NOT NULL,
  `rendimiento_min_kg_ha` decimal(12,2) DEFAULT NULL,
  `rendimiento_max_kg_ha` decimal(12,2) DEFAULT NULL,
  `epoca_siembra_inicio` tinyint(3) UNSIGNED DEFAULT NULL,
  `epoca_siembra_fin` tinyint(3) UNSIGNED DEFAULT NULL,
  `altitud_min` smallint(5) UNSIGNED DEFAULT NULL,
  `altitud_max` smallint(5) UNSIGNED DEFAULT NULL,
  `fuente` varchar(180) DEFAULT NULL,
  `url_fuente` varchar(500) DEFAULT NULL,
  `fecha_fuente` date DEFAULT NULL,
  `id_usuario_actualiza` bigint(20) UNSIGNED DEFAULT NULL,
  `fecha_actualizacion` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `estado` enum('ACTIVO','INACTIVO') NOT NULL DEFAULT 'ACTIVO'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `parametros_cultivo`
--

INSERT INTO `parametros_cultivo` (`id_parametro_cultivo`, `id_producto`, `id_variedad`, `tipo_inicio_ciclo`, `dias_cosecha_min`, `dias_cosecha_max`, `rendimiento_min_kg_ha`, `rendimiento_max_kg_ha`, `epoca_siembra_inicio`, `epoca_siembra_fin`, `altitud_min`, `altitud_max`, `fuente`, `url_fuente`, `fecha_fuente`, `id_usuario_actualiza`, `fecha_actualizacion`, `estado`) VALUES
(1, 1, 3, 'SIEMBRA', 120, 120, 30000.00, 40000.00, 10, 12, 2000, 3500, 'INIA - Papa INIA 303 Canchán', 'https://repositorio.inia.gob.pe/server/api/core/bitstreams/3d207256-660c-42d9-b5fa-f3d0bcf3dcf2/content', '2012-01-01', NULL, '2026-08-21 22:27:04', 'ACTIVO'),
(2, 1, 1, 'SIEMBRA', 170, 180, 30000.00, 40000.00, 9, 11, NULL, NULL, 'INIA - Cultivo de papa / variedad Yungay', 'https://repositorio.inia.gob.pe/server/api/core/bitstreams/b6a1104b-8119-422b-aec5-6d52d3e9ad75/content', '2018-01-01', NULL, '2026-08-21 22:27:04', 'ACTIVO'),
(3, 3, 19, 'SIEMBRA', 120, 120, NULL, NULL, NULL, NULL, NULL, NULL, 'INIA - Choclo INIA 606 Choclero Prolífico', 'https://repositorio.inia.gob.pe/items/67777519-7756-4323-98ce-5e679c002399', '2004-04-06', NULL, '2026-08-21 22:27:04', 'ACTIVO'),
(4, 3, 20, 'SIEMBRA', 170, 170, NULL, NULL, NULL, NULL, 2600, 3000, 'INIA - Maíz INIA 603 Choclero', 'https://repositorio.inia.gob.pe/bitstreams/e0509df1-5586-481f-a12a-c49d4bfb883a/download', '2013-01-01', NULL, '2026-08-21 22:27:04', 'ACTIVO'),
(5, 4, 24, 'SIEMBRA', 165, 180, 8000.00, 10000.00, NULL, NULL, NULL, NULL, 'INIA - Manual de fertilización de ajo y cebolla / validación cultivar Cincomesino', 'https://repositorio.inia.gob.pe/server/api/core/bitstreams/569195e3-180d-42a6-97a1-c504a5059c24/content', '2025-01-01', NULL, '2026-08-21 22:27:04', 'ACTIVO'),
(6, 4, 26, 'SIEMBRA', 150, 165, 12000.00, 16000.00, NULL, NULL, NULL, NULL, 'INIA - Manual de fertilización de ajo y cebolla / validación cultivar Cincomesino', 'https://repositorio.inia.gob.pe/server/api/core/bitstreams/569195e3-180d-42a6-97a1-c504a5059c24/content', '2025-01-01', NULL, '2026-08-21 22:27:04', 'ACTIVO'),
(7, 4, 27, 'SIEMBRA', 150, 155, 9000.00, 12000.00, NULL, NULL, NULL, NULL, 'INIA - Manual de fertilización de ajo y cebolla / validación cultivar Cincomesino', 'https://repositorio.inia.gob.pe/server/api/core/bitstreams/569195e3-180d-42a6-97a1-c504a5059c24/content', '2025-01-01', NULL, '2026-08-21 22:27:04', 'ACTIVO'),
(8, 4, 23, 'SIEMBRA', 175, 185, 10000.00, 12000.00, NULL, NULL, NULL, NULL, 'INIA - Manual de fertilización de ajo y cebolla / validación cultivar Cincomesino', 'https://repositorio.inia.gob.pe/server/api/core/bitstreams/569195e3-180d-42a6-97a1-c504a5059c24/content', '2025-01-01', NULL, '2026-08-21 22:27:04', 'ACTIVO'),
(9, 4, 25, 'SIEMBRA', 205, 215, 10000.00, 13000.00, NULL, NULL, NULL, NULL, 'INIA - Manual de fertilización de ajo y cebolla / validación cultivar Cincomesino', 'https://repositorio.inia.gob.pe/server/api/core/bitstreams/569195e3-180d-42a6-97a1-c504a5059c24/content', '2025-01-01', NULL, '2026-08-21 22:27:04', 'ACTIVO'),
(10, 4, 22, 'SIEMBRA', 205, 215, 7000.00, 10000.00, NULL, NULL, NULL, NULL, 'INIA - Manual de fertilización de ajo y cebolla / validación cultivar Cincomesino', 'https://repositorio.inia.gob.pe/server/api/core/bitstreams/569195e3-180d-42a6-97a1-c504a5059c24/content', '2025-01-01', NULL, '2026-08-21 22:27:04', 'ACTIVO'),
(12, 6, 29, 'SIEMBRA', 110, 120, 30000.00, 50000.00, NULL, NULL, NULL, NULL, 'INIA - Zanahoria INIA 101, Sierra Central', 'https://repositorio.inia.gob.pe/server/api/core/bitstreams/bdc06c10-dd3e-4f5e-857e-4ab168df6419/content', '2009-12-01', NULL, '2026-08-21 22:27:04', 'ACTIVO'),
(13, 14, 38, 'SIEMBRA', 105, 115, 3285.00, NULL, NULL, NULL, NULL, NULL, 'INIA - Arveja INIA 103 Remate, Sierra Central / Valle del Mantaro', 'https://repositorio.inia.gob.pe/items/f91dcdee-6fa4-473b-a19e-404df3306558', '2003-03-06', NULL, '2026-08-21 22:27:04', 'ACTIVO'),
(14, 15, 41, 'SIEMBRA', 160, 180, 5000.00, NULL, NULL, NULL, 2200, 3850, 'INIA - Haba INIA 401 Cusco', 'https://repositorio.inia.gob.pe/bitstreams/b7cae603-cf90-42c8-8494-a3cae909a5d2/download', '2025-01-01', NULL, '2026-08-21 22:27:04', 'ACTIVO'),
(15, 16, 31, 'SIEMBRA', 141, 155, NULL, NULL, 10, 12, NULL, NULL, 'INIA - Catálogo de variedades comerciales de quinua / estudios de madurez', 'https://repositorio.inia.gob.pe/items/155e2317-d3cc-4133-a407-895aa0c0cd24', '2013-10-01', NULL, '2026-08-21 22:27:04', 'ACTIVO'),
(16, 16, 32, 'SIEMBRA', 140, 155, NULL, NULL, 10, 12, NULL, NULL, 'INIA - Catálogo de variedades comerciales de quinua / estudios de madurez', 'https://repositorio.inia.gob.pe/items/155e2317-d3cc-4133-a407-895aa0c0cd24', '2013-10-01', NULL, '2026-08-21 22:27:04', 'ACTIVO'),
(17, 16, 33, 'SIEMBRA', 123, 155, NULL, NULL, 10, 12, NULL, NULL, 'INIA - Catálogo de variedades comerciales de quinua / estudios de madurez', 'https://repositorio.inia.gob.pe/items/155e2317-d3cc-4133-a407-895aa0c0cd24', '2013-10-01', NULL, '2026-08-21 22:27:04', 'ACTIVO'),
(18, 16, 34, 'SIEMBRA', 150, 160, NULL, NULL, 10, 12, NULL, NULL, 'INIA - Catálogo de variedades comerciales de quinua / estudios de madurez', 'https://repositorio.inia.gob.pe/items/155e2317-d3cc-4133-a407-895aa0c0cd24', '2013-10-01', NULL, '2026-08-21 22:27:04', 'ACTIVO'),
(22, 11, 44, 'SIEMBRA', 60, 100, NULL, NULL, NULL, NULL, NULL, NULL, 'FAO - referencia general de duración de cultivos; validar localmente en Chupaca', 'https://www.fao.org/4/s2022e/s2022e07.htm', '2026-08-22', NULL, '2026-08-21 22:27:04', 'ACTIVO'),
(23, 5, 45, 'TRASPLANTE', 100, 140, NULL, NULL, NULL, NULL, NULL, NULL, 'FAO - referencia general de duración de cultivos; validar localmente en Chupaca', 'https://www.fao.org/4/s2022e/s2022e07.htm', '2026-08-22', NULL, '2026-08-21 22:27:04', 'ACTIVO'),
(24, 10, 46, 'SIEMBRA', 90, 150, NULL, NULL, NULL, NULL, NULL, NULL, 'FAO - referencia general de duración de cultivos; validar localmente en Chupaca', 'https://www.fao.org/4/s2022e/s2022e07.htm', '2026-08-22', NULL, '2026-08-21 22:27:04', 'ACTIVO'),
(25, 7, 47, 'SIEMBRA', 150, 210, NULL, NULL, NULL, NULL, NULL, NULL, 'FAO - referencia general de duración de cultivos; validar localmente en Chupaca', 'https://www.fao.org/4/s2022e/s2022e07.htm', '2026-08-22', NULL, '2026-08-21 22:27:04', 'ACTIVO'),
(26, 9, 48, 'TRASPLANTE', 120, 140, NULL, NULL, NULL, NULL, NULL, NULL, 'FAO - referencia general de duración de cultivos; validar localmente en Chupaca', 'https://www.fao.org/4/s2022e/s2022e07.htm', '2026-08-22', NULL, '2026-08-21 22:27:04', 'ACTIVO'),
(27, 8, 49, 'TRASPLANTE', 75, 140, NULL, NULL, NULL, NULL, NULL, NULL, 'FAO - referencia general de duración de cultivos; validar localmente en Chupaca', 'https://www.fao.org/4/s2022e/s2022e07.htm', '2026-08-22', NULL, '2026-08-21 22:27:04', 'ACTIVO'),
(28, 2, 50, 'SIEMBRA', 150, 210, NULL, NULL, NULL, NULL, NULL, NULL, 'FAO - referencia general de duración de cultivos; validar localmente en Chupaca', 'https://www.fao.org/4/s2022e/s2022e07.htm', '2026-08-22', NULL, '2026-08-21 22:27:04', 'ACTIVO'),
(29, 12, 51, 'TRASPLANTE', 120, 180, NULL, NULL, NULL, NULL, NULL, NULL, 'FAO - referencia general de duración de cultivos; validar localmente en Chupaca', 'https://www.fao.org/4/s2022e/s2022e07.htm', '2026-08-22', NULL, '2026-08-21 22:27:04', 'ACTIVO'),
(30, 13, 52, 'SIEMBRA', 35, 45, NULL, NULL, NULL, NULL, NULL, NULL, 'FAO - referencia general de duración de cultivos; validar localmente en Chupaca', 'https://www.fao.org/4/s2022e/s2022e07.htm', '2026-08-22', NULL, '2026-08-21 22:27:04', 'ACTIVO');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `parametros_logisticos`
--

CREATE TABLE `parametros_logisticos` (
  `id_parametro` int(10) UNSIGNED NOT NULL,
  `codigo` varchar(80) NOT NULL,
  `nombre` varchar(120) NOT NULL,
  `valor` decimal(14,4) NOT NULL,
  `unidad` varchar(40) DEFAULT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `fecha_actualizacion` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `id_usuario_actualiza` bigint(20) UNSIGNED DEFAULT NULL,
  `estado` enum('ACTIVO','INACTIVO') NOT NULL DEFAULT 'ACTIVO'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `parametros_logisticos`
--

INSERT INTO `parametros_logisticos` (`id_parametro`, `codigo`, `nombre`, `valor`, `unidad`, `descripcion`, `fecha_actualizacion`, `id_usuario_actualiza`, `estado`) VALUES
(1, 'PRECIO_COMBUSTIBLE', 'Precio referencial combustible', 0.0000, 'S/ por galón', 'Actualizar desde fuente vigente antes de cotizar', '2026-08-21 22:27:04', NULL, 'ACTIVO'),
(2, 'COSTO_OPERATIVO_KM', 'Costo operativo por kilómetro', 0.0000, 'S/ por km', 'Configurable por Operaciones', '2026-08-21 22:27:04', NULL, 'ACTIVO'),
(3, 'CARGA_DESCARGA', 'Costo base carga/descarga', 0.0000, 'S/', 'Configurable por Operaciones', '2026-08-21 22:27:04', NULL, 'ACTIVO'),
(4, 'SEGURO_CARGA', 'Costo base seguro de carga', 0.0000, 'S/', 'Configurable por Operaciones', '2026-08-21 22:27:04', NULL, 'ACTIVO');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `permisos`
--

CREATE TABLE `permisos` (
  `id_permiso` int(10) UNSIGNED NOT NULL,
  `codigo` varchar(80) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `modulo` varchar(60) NOT NULL,
  `estado` enum('ACTIVO','INACTIVO') NOT NULL DEFAULT 'ACTIVO'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `permisos`
--

INSERT INTO `permisos` (`id_permiso`, `codigo`, `nombre`, `descripcion`, `modulo`, `estado`) VALUES
(1, 'USUARIOS_VER', 'Ver usuarios', NULL, 'usuarios', 'ACTIVO'),
(2, 'USUARIOS_EDITAR', 'Editar usuarios', NULL, 'usuarios', 'ACTIVO'),
(3, 'ROLES_GESTIONAR', 'Gestionar roles y permisos', NULL, 'seguridad', 'ACTIVO'),
(4, 'PRECIOS_VER', 'Ver precios de mercado', NULL, 'comercial', 'ACTIVO'),
(5, 'PRECIOS_MODIFICAR', 'Modificar precios de mercado', NULL, 'comercial', 'ACTIVO'),
(6, 'PARAMETROS_COMERCIALES_MODIFICAR', 'Modificar parámetros comerciales', NULL, 'comercial', 'ACTIVO'),
(7, 'SOLICITUDES_REVISAR', 'Revisar solicitudes', NULL, 'operaciones', 'ACTIVO'),
(8, 'VERIFICACIONES_ASIGNAR', 'Asignar verificadores', NULL, 'operaciones', 'ACTIVO'),
(9, 'VERIFICACIONES_EJECUTAR', 'Ejecutar verificaciones', NULL, 'verificacion', 'ACTIVO'),
(10, 'COSECHA_PROGRAMAR', 'Programar cosecha', NULL, 'operaciones', 'ACTIVO'),
(11, 'COSECHA_VALIDAR', 'Validar cosecha', NULL, 'operaciones', 'ACTIVO'),
(12, 'TRANSPORTE_ASIGNAR', 'Asignar transporte', NULL, 'logistica', 'ACTIVO'),
(13, 'TRANSPORTE_ACTUALIZAR', 'Actualizar estado de transporte', NULL, 'logistica', 'ACTIVO'),
(14, 'PAGOS_VER', 'Ver pagos', NULL, 'finanzas', 'ACTIVO'),
(15, 'PAGOS_AUTORIZAR', 'Autorizar pagos', NULL, 'finanzas', 'ACTIVO'),
(16, 'PAGOS_EJECUTAR', 'Ejecutar pagos', NULL, 'finanzas', 'ACTIVO'),
(17, 'AUDITORIA_VER', 'Ver auditoría', NULL, 'auditoria', 'ACTIVO'),
(18, 'REPORTES_VER', 'Ver reportes e indicadores', NULL, 'reportes', 'ACTIVO'),
(19, 'PUBLICACIONES_GESTIONAR', 'Gestionar Vida Agrovía', NULL, 'comunidad', 'ACTIVO'),
(20, 'CAPACITACIONES_GESTIONAR', 'Gestionar capacitaciones', NULL, 'comunidad', 'ACTIVO');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `precios_combustible_logistica`
--

CREATE TABLE `precios_combustible_logistica` (
  `id_precio_combustible` bigint(20) UNSIGNED NOT NULL,
  `combustible` varchar(80) NOT NULL,
  `departamento` varchar(100) DEFAULT NULL,
  `provincia` varchar(100) DEFAULT NULL,
  `distrito` varchar(100) DEFAULT NULL,
  `precio_galon` decimal(10,2) NOT NULL,
  `fuente` varchar(255) NOT NULL,
  `fecha_precio` date NOT NULL,
  `calidad_dato` enum('OFICIAL','REFERENCIAL','ESTIMADO_MVP') NOT NULL DEFAULT 'OFICIAL',
  `estado` enum('ACTIVO','INACTIVO') NOT NULL DEFAULT 'ACTIVO',
  `creado_en` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `precios_combustible_logistica`
--

INSERT INTO `precios_combustible_logistica` (`id_precio_combustible`, `combustible`, `departamento`, `provincia`, `distrito`, `precio_galon`, `fuente`, `fecha_precio`, `calidad_dato`, `estado`, `creado_en`) VALUES
(1, 'Diesel B5 S-50', 'Junín', 'Chupaca', 'Chupaca', 15.50, 'ESTIMADO_MVP - reemplazar por precio vigente de establecimiento formal consultado en Osinergmin Facilito', '2026-08-22', 'ESTIMADO_MVP', 'ACTIVO', '2026-08-21 23:03:50');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `precios_mercado`
--

CREATE TABLE `precios_mercado` (
  `id_precio` bigint(20) UNSIGNED NOT NULL,
  `id_producto` int(10) UNSIGNED NOT NULL,
  `id_variedad` int(10) UNSIGNED DEFAULT NULL,
  `precio` decimal(12,4) NOT NULL,
  `unidad` enum('KG','TONELADA','SACO','UNIDAD') NOT NULL DEFAULT 'KG',
  `mercado` varchar(120) DEFAULT NULL,
  `zona` varchar(120) DEFAULT NULL,
  `fuente` varchar(180) DEFAULT NULL,
  `fecha_precio` date NOT NULL,
  `id_usuario_registro` bigint(20) UNSIGNED DEFAULT NULL,
  `estado` enum('ACTIVO','INACTIVO') NOT NULL DEFAULT 'ACTIVO'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `precios_mercado`
--

INSERT INTO `precios_mercado` (`id_precio`, `id_producto`, `id_variedad`, `precio`, `unidad`, `mercado`, `zona`, `fuente`, `fecha_precio`, `id_usuario_registro`, `estado`) VALUES
(1, 1, 3, 1.1300, 'KG', 'GMML', 'Lima', 'MIDAGRI - reporte mercados mayoristas 28/05/2026', '2026-05-28', NULL, 'ACTIVO'),
(2, 1, 3, 1.0800, 'KG', 'GMML', 'Lima', 'MIDAGRI - reporte mercados mayoristas 08/06/2026', '2026-06-08', NULL, 'ACTIVO'),
(3, 1, 3, 1.7300, 'KG', 'GMML', 'Lima', 'MIDAGRI/SISAP - valor contrastado 18/08/2026', '2026-08-18', NULL, 'ACTIVO'),
(4, 1, 1, 1.0300, 'KG', 'GMML', 'Lima', 'MIDAGRI - reporte mercados mayoristas 28/05/2026', '2026-05-28', NULL, 'ACTIVO'),
(5, 1, 1, 1.3800, 'KG', 'GMML', 'Lima', 'MIDAGRI - reporte mercados mayoristas 08/06/2026', '2026-06-08', NULL, 'ACTIVO'),
(6, 1, 1, 1.0300, 'KG', 'GMML', 'Lima', 'MIDAGRI/SISAP - valor contrastado 18/08/2026', '2026-08-18', NULL, 'ACTIVO'),
(7, 1, 2, 2.1300, 'KG', 'GMML', 'Lima', 'MIDAGRI - reporte mercados mayoristas 28/05/2026', '2026-05-28', NULL, 'ACTIVO'),
(8, 1, 2, 1.6300, 'KG', 'GMML', 'Lima', 'MIDAGRI/SISAP - valor contrastado 18/08/2026', '2026-08-18', NULL, 'ACTIVO'),
(9, 1, 5, 1.4300, 'KG', 'GMML', 'Lima', 'MIDAGRI - reporte mercados mayoristas 28/05/2026', '2026-05-28', NULL, 'ACTIVO'),
(10, 1, 5, 1.6000, 'KG', 'GMML', 'Lima', 'MIDAGRI - reporte mercados mayoristas 08/06/2026', '2026-06-08', NULL, 'ACTIVO'),
(11, 1, 4, 1.7000, 'KG', 'GMML', 'Lima', 'MIDAGRI - reporte mercados mayoristas 28/05/2026', '2026-05-28', NULL, 'ACTIVO'),
(12, 1, 4, 1.9000, 'KG', 'GMML', 'Lima', 'MIDAGRI - reporte mercados mayoristas 08/06/2026', '2026-06-08', NULL, 'ACTIVO'),
(13, 6, 29, 0.7100, 'KG', 'GMML', 'Lima', 'MIDAGRI - reporte mercados mayoristas 28/05/2026', '2026-05-28', NULL, 'ACTIVO'),
(14, 6, 29, 0.7900, 'KG', 'GMML', 'Lima', 'MIDAGRI - reporte mercados mayoristas 08/06/2026', '2026-06-08', NULL, 'ACTIVO'),
(15, 6, 29, 1.0400, 'KG', 'GMML', 'Lima', 'MIDAGRI/SISAP - valor contrastado 18/08/2026', '2026-08-18', NULL, 'ACTIVO'),
(16, 3, NULL, 3.2100, 'KG', 'GMML', 'Lima', 'MIDAGRI - Choclo tipo Cusco 28/05/2026', '2026-05-28', NULL, 'ACTIVO'),
(17, 3, NULL, 3.7500, 'KG', 'GMML', 'Lima', 'MIDAGRI - Choclo tipo Cusco 08/06/2026', '2026-06-08', NULL, 'ACTIVO'),
(18, 3, NULL, 4.3500, 'KG', 'GMML', 'Lima', 'MIDAGRI/SISAP - Choclo tipo Cusco, valor contrastado 18/08/2026', '2026-08-18', NULL, 'ACTIVO'),
(19, 15, NULL, 1.7300, 'KG', 'GMML', 'Lima', 'MIDAGRI - Haba verde serrana 28/05/2026', '2026-05-28', NULL, 'ACTIVO'),
(20, 15, NULL, 2.1300, 'KG', 'GMML', 'Lima', 'MIDAGRI - Haba verde serrana 08/06/2026', '2026-06-08', NULL, 'ACTIVO'),
(21, 14, NULL, 2.3500, 'KG', 'GMML', 'Lima', 'MIDAGRI - Arveja verde serrana 28/05/2026', '2026-05-28', NULL, 'ACTIVO'),
(22, 14, NULL, 1.8500, 'KG', 'GMML', 'Lima', 'MIDAGRI - Arveja verde serrana 08/06/2026', '2026-06-08', NULL, 'ACTIVO'),
(23, 7, NULL, 2.8300, 'KG', 'GMML', 'Lima', 'MIDAGRI - Cebolla cabeza roja 28/05/2026', '2026-05-28', NULL, 'ACTIVO'),
(24, 7, NULL, 1.8000, 'KG', 'GMML', 'Lima', 'MIDAGRI - Cebolla cabeza roja 08/06/2026', '2026-06-08', NULL, 'ACTIVO'),
(25, 7, NULL, 1.5500, 'KG', 'GMML', 'Lima', 'MIDAGRI/SISAP - Cebolla cabeza roja, valor contrastado 18/08/2026', '2026-08-18', NULL, 'ACTIVO'),
(26, 4, 23, 5.5000, 'KG', 'GMML', 'Lima', 'MIDAGRI - Ajo criollo/Napurí 28/05/2026', '2026-05-28', NULL, 'ACTIVO'),
(27, 4, 23, 5.7500, 'KG', 'GMML', 'Lima', 'MIDAGRI/SISAP - Ajo criollo/Napurí, valor contrastado 18/08/2026', '2026-08-18', NULL, 'ACTIVO'),
(28, 4, 22, 7.6300, 'KG', 'GMML', 'Lima', 'MIDAGRI - Ajo morado 28/05/2026', '2026-05-28', NULL, 'ACTIVO'),
(29, 2, NULL, 2.3800, 'KG', 'GMML', 'Lima', 'MIDAGRI - Olluco largo 28/05/2026', '2026-05-28', NULL, 'ACTIVO'),
(30, 2, NULL, 2.2500, 'KG', 'GMML', 'Lima', 'MIDAGRI - Olluco largo 08/06/2026', '2026-06-08', NULL, 'ACTIVO');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `predios`
--

CREATE TABLE `predios` (
  `id_predio` bigint(20) UNSIGNED NOT NULL,
  `codigo_predio` varchar(20) NOT NULL,
  `id_productor` bigint(20) UNSIGNED NOT NULL,
  `nombre_predio` varchar(120) NOT NULL,
  `referencia` varchar(255) DEFAULT NULL,
  `area_total` decimal(10,2) NOT NULL,
  `unidad_area` enum('HECTAREA','METRO_CUADRADO') NOT NULL DEFAULT 'HECTAREA',
  `id_ubigeo` int(10) UNSIGNED DEFAULT NULL,
  `latitud` decimal(10,7) DEFAULT NULL,
  `longitud` decimal(10,7) DEFAULT NULL,
  `estado_verificacion` enum('PENDIENTE','VERIFICADO','OBSERVADO','RECHAZADO') NOT NULL DEFAULT 'PENDIENTE',
  `estado` enum('ACTIVO','INACTIVO') NOT NULL DEFAULT 'ACTIVO',
  `fecha_registro` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `predios`
--

INSERT INTO `predios` (`id_predio`, `codigo_predio`, `id_productor`, `nombre_predio`, `referencia`, `area_total`, `unidad_area`, `id_ubigeo`, `latitud`, `longitud`, `estado_verificacion`, `estado`, `fecha_registro`) VALUES
(1, 'PRE-00001', 1, 'chacra jarpa', 'dos horas de chupaca', 99.97, 'HECTAREA', NULL, NULL, NULL, 'OBSERVADO', 'ACTIVO', '2026-10-01 21:43:34');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `productores`
--

CREATE TABLE `productores` (
  `id_productor` bigint(20) UNSIGNED NOT NULL,
  `id_usuario` bigint(20) UNSIGNED NOT NULL,
  `codigo_productor` varchar(20) NOT NULL,
  `estado_verificacion` enum('PENDIENTE','VERIFICADO','OBSERVADO','RECHAZADO') NOT NULL DEFAULT 'PENDIENTE',
  `reputacion` decimal(3,2) NOT NULL DEFAULT 0.00,
  `estado` enum('ACTIVO','INACTIVO') NOT NULL DEFAULT 'ACTIVO'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `productores`
--

INSERT INTO `productores` (`id_productor`, `id_usuario`, `codigo_productor`, `estado_verificacion`, `reputacion`, `estado`) VALUES
(1, 2, 'PRO-00001', 'PENDIENTE', 0.00, 'ACTIVO');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `productos`
--

CREATE TABLE `productos` (
  `id_producto` int(10) UNSIGNED NOT NULL,
  `id_categoria` int(10) UNSIGNED NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `estado` enum('ACTIVO','INACTIVO') NOT NULL DEFAULT 'ACTIVO'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `productos`
--

INSERT INTO `productos` (`id_producto`, `id_categoria`, `nombre`, `descripcion`, `estado`) VALUES
(1, 1, 'Papa', 'Producto agrícola del piloto', 'ACTIVO'),
(2, 1, 'Olluco', 'Producto agrícola del piloto', 'ACTIVO'),
(3, 5, 'Choclo', 'Producto agrícola del piloto', 'ACTIVO'),
(4, 2, 'Ajo', 'Producto agrícola del piloto', 'ACTIVO'),
(5, 2, 'Apio', 'Producto agrícola del piloto', 'ACTIVO'),
(6, 2, 'Zanahoria', 'Producto agrícola del piloto', 'ACTIVO'),
(7, 2, 'Cebolla', 'Producto agrícola del piloto', 'ACTIVO'),
(8, 2, 'Lechuga', 'Producto agrícola del piloto', 'ACTIVO'),
(9, 2, 'Col/Repollo', 'Producto agrícola del piloto', 'ACTIVO'),
(10, 2, 'Beterraga', 'Producto agrícola del piloto', 'ACTIVO'),
(11, 2, 'Acelga', 'Producto agrícola del piloto', 'ACTIVO'),
(12, 2, 'Poro', 'Producto agrícola del piloto', 'ACTIVO'),
(13, 2, 'Rábano', 'Producto agrícola del piloto', 'ACTIVO'),
(14, 3, 'Arveja', 'Producto agrícola del piloto', 'ACTIVO'),
(15, 3, 'Haba', 'Producto agrícola del piloto', 'ACTIVO'),
(16, 4, 'Quinua', 'Producto agrícola del piloto', 'ACTIVO'),
(17, 6, 'Otro', 'Producto no incluido en el catálogo principal', 'ACTIVO');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `publicaciones`
--

CREATE TABLE `publicaciones` (
  `id_publicacion` bigint(20) UNSIGNED NOT NULL,
  `codigo_publicacion` varchar(24) NOT NULL,
  `tipo` enum('NOTICIA','CAPACITACION','EVENTO','INFORMACION_AGRICOLA','ACTIVIDAD_AGROVIA') NOT NULL,
  `titulo` varchar(180) NOT NULL,
  `contenido` text NOT NULL,
  `id_autor` bigint(20) UNSIGNED NOT NULL,
  `fecha_publicacion` datetime DEFAULT NULL,
  `estado` enum('BORRADOR','PUBLICADA','ARCHIVADA') NOT NULL DEFAULT 'BORRADOR'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `referidos`
--

CREATE TABLE `referidos` (
  `id_referido` bigint(20) UNSIGNED NOT NULL,
  `id_usuario_referidor` bigint(20) UNSIGNED NOT NULL,
  `id_usuario_referido` bigint(20) UNSIGNED NOT NULL,
  `codigo_utilizado` varchar(40) NOT NULL,
  `estado` enum('REGISTRADO','VALIDADO','BONIFICADO','ANULADO') NOT NULL DEFAULT 'REGISTRADO',
  `fecha` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `reservas_lote`
--

CREATE TABLE `reservas_lote` (
  `id_reserva` bigint(20) UNSIGNED NOT NULL,
  `id_lote` bigint(20) UNSIGNED NOT NULL,
  `id_comprador` bigint(20) UNSIGNED NOT NULL,
  `id_cotizacion_operacion` bigint(20) UNSIGNED NOT NULL,
  `fecha_inicio` datetime NOT NULL DEFAULT current_timestamp(),
  `fecha_vencimiento` datetime NOT NULL,
  `estado` enum('ACTIVA','CONFIRMADA','VENCIDA','CANCELADA') NOT NULL DEFAULT 'ACTIVA'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `roles`
--

CREATE TABLE `roles` (
  `id_rol` smallint(5) UNSIGNED NOT NULL,
  `nombre` varchar(40) NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `estado` enum('ACTIVO','INACTIVO') NOT NULL DEFAULT 'ACTIVO'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `roles`
--

INSERT INTO `roles` (`id_rol`, `nombre`, `descripcion`, `estado`) VALUES
(1, 'GERENTE', 'Supervisión general, indicadores, finanzas, reportes y auditoría', 'ACTIVO'),
(2, 'ADMINISTRADOR', 'Configuración, usuarios, roles, permisos y parámetros', 'ACTIVO'),
(3, 'COMERCIAL', 'Precios, valorizaciones, productores, compradores y comunidad', 'ACTIVO'),
(4, 'OPERACIONES', 'Verificaciones, cosecha, cuadrillas, transporte y entregas', 'ACTIVO'),
(5, 'VERIFICADOR', 'Visitas y verificaciones de campo asignadas', 'ACTIVO'),
(6, 'TRANSPORTISTA', 'Servicios de transporte asignados', 'ACTIVO'),
(7, 'PRODUCTOR', 'Gestión de predios, solicitudes, lotes, ventas y pagos', 'ACTIVO'),
(8, 'COMPRADOR', 'Marketplace, cotizaciones, compras, seguimiento y entregas', 'ACTIVO');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `roles_permisos`
--

CREATE TABLE `roles_permisos` (
  `id_rol_permiso` bigint(20) UNSIGNED NOT NULL,
  `id_rol` smallint(5) UNSIGNED NOT NULL,
  `id_permiso` int(10) UNSIGNED NOT NULL,
  `estado` enum('ACTIVO','INACTIVO') NOT NULL DEFAULT 'ACTIVO'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `roles_permisos`
--

INSERT INTO `roles_permisos` (`id_rol_permiso`, `id_rol`, `id_permiso`, `estado`) VALUES
(1, 1, 17, 'ACTIVO'),
(2, 1, 20, 'ACTIVO'),
(3, 1, 10, 'ACTIVO'),
(4, 1, 11, 'ACTIVO'),
(5, 1, 15, 'ACTIVO'),
(6, 1, 16, 'ACTIVO'),
(7, 1, 14, 'ACTIVO'),
(8, 1, 6, 'ACTIVO'),
(9, 1, 5, 'ACTIVO'),
(10, 1, 4, 'ACTIVO'),
(11, 1, 19, 'ACTIVO'),
(12, 1, 18, 'ACTIVO'),
(13, 1, 3, 'ACTIVO'),
(14, 1, 7, 'ACTIVO'),
(15, 1, 13, 'ACTIVO'),
(16, 1, 12, 'ACTIVO'),
(17, 1, 2, 'ACTIVO'),
(18, 1, 1, 'ACTIVO'),
(19, 1, 8, 'ACTIVO'),
(20, 1, 9, 'ACTIVO'),
(32, 2, 17, 'ACTIVO'),
(33, 2, 20, 'ACTIVO'),
(34, 2, 10, 'ACTIVO'),
(35, 2, 11, 'ACTIVO'),
(36, 2, 15, 'ACTIVO'),
(37, 2, 16, 'ACTIVO'),
(38, 2, 14, 'ACTIVO'),
(39, 2, 6, 'ACTIVO'),
(40, 2, 5, 'ACTIVO'),
(41, 2, 4, 'ACTIVO'),
(42, 2, 19, 'ACTIVO'),
(43, 2, 18, 'ACTIVO'),
(44, 2, 3, 'ACTIVO'),
(45, 2, 7, 'ACTIVO'),
(46, 2, 13, 'ACTIVO'),
(47, 2, 12, 'ACTIVO'),
(48, 2, 2, 'ACTIVO'),
(49, 2, 1, 'ACTIVO'),
(50, 2, 8, 'ACTIVO'),
(51, 2, 9, 'ACTIVO'),
(63, 3, 20, 'ACTIVO'),
(64, 3, 6, 'ACTIVO'),
(65, 3, 5, 'ACTIVO'),
(66, 3, 4, 'ACTIVO'),
(67, 3, 19, 'ACTIVO'),
(68, 3, 7, 'ACTIVO'),
(70, 4, 10, 'ACTIVO'),
(71, 4, 11, 'ACTIVO'),
(72, 4, 14, 'ACTIVO'),
(73, 4, 7, 'ACTIVO'),
(74, 4, 12, 'ACTIVO'),
(75, 4, 8, 'ACTIVO'),
(77, 5, 9, 'ACTIVO'),
(78, 6, 13, 'ACTIVO');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `solicitudes_lote`
--

CREATE TABLE `solicitudes_lote` (
  `id_solicitud` bigint(20) UNSIGNED NOT NULL,
  `codigo_solicitud` varchar(20) NOT NULL,
  `id_productor` bigint(20) UNSIGNED NOT NULL,
  `id_predio` bigint(20) UNSIGNED NOT NULL,
  `id_producto` int(10) UNSIGNED NOT NULL,
  `nombre_producto_personalizado` varchar(100) DEFAULT NULL,
  `id_variedad` int(10) UNSIGNED DEFAULT NULL,
  `id_campana` int(10) UNSIGNED DEFAULT NULL,
  `area_cultivada` decimal(10,2) NOT NULL,
  `precio_propuesto_kg` decimal(12,4) DEFAULT NULL,
  `fecha_siembra` date DEFAULT NULL,
  `fecha_cosecha_estimada_inicio` date DEFAULT NULL,
  `fecha_cosecha_estimada_fin` date DEFAULT NULL,
  `descripcion` text DEFAULT NULL,
  `imagen` varchar(255) DEFAULT NULL,
  `estado` enum('ENVIADA','EN_REVISION','OBSERVADA','VISITA_PROGRAMADA','EN_VERIFICACION','VERIFICADA','EN_VALORIZACION','PENDIENTE_ACEPTACION','APROBADA','RECHAZADA','CANCELADA') NOT NULL DEFAULT 'ENVIADA',
  `fecha_solicitud` datetime NOT NULL DEFAULT current_timestamp(),
  `fecha_actualizacion` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `solicitudes_lote`
--

INSERT INTO `solicitudes_lote` (`id_solicitud`, `codigo_solicitud`, `id_productor`, `id_predio`, `id_producto`, `id_variedad`, `id_campana`, `area_cultivada`, `fecha_siembra`, `fecha_cosecha_estimada_inicio`, `fecha_cosecha_estimada_fin`, `descripcion`, `imagen`, `estado`, `fecha_solicitud`, `fecha_actualizacion`) VALUES
(1, 'SOL-00001', 1, 1, 6, NULL, NULL, 100.00, '2026-08-20', '2026-09-28', '2026-10-01', 'buena calidad ', NULL, 'APROBADA', '2026-10-01 21:45:08', '2026-10-01 21:54:49'),
(2, 'SOL-00002', 1, 1, 11, NULL, NULL, 100.00, '2026-08-10', '2026-09-20', '2026-10-02', 'fresco y de calidad ', NULL, 'OBSERVADA', '2026-10-02 19:39:13', '2026-10-02 21:21:02'),
(3, 'SOL-00003', 1, 1, 3, NULL, NULL, 200.00, '2026-04-10', '2026-05-30', '2026-06-20', 'buena calidad ', NULL, 'APROBADA', '2026-10-02 21:19:54', '2026-10-02 21:21:07');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipos_vehiculo_logistica`
--

CREATE TABLE `tipos_vehiculo_logistica` (
  `id_tipo_vehiculo` int(10) UNSIGNED NOT NULL,
  `codigo` varchar(30) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `configuracion_mtc` varchar(20) DEFAULT NULL,
  `capacidad_util_kg` decimal(12,2) NOT NULL,
  `rendimiento_km_galon` decimal(10,2) NOT NULL,
  `costo_operativo_km` decimal(10,2) NOT NULL DEFAULT 0.00,
  `costo_fijo_viaje` decimal(12,2) NOT NULL DEFAULT 0.00,
  `fuente_capacidad` varchar(255) DEFAULT NULL,
  `fuente_parametros` varchar(255) DEFAULT NULL,
  `calidad_dato` enum('LEGAL_REFERENCIAL','REFERENCIAL','ESTIMADO_MVP') NOT NULL DEFAULT 'ESTIMADO_MVP',
  `estado` enum('ACTIVO','INACTIVO') NOT NULL DEFAULT 'ACTIVO',
  `creado_en` datetime NOT NULL DEFAULT current_timestamp(),
  `actualizado_en` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `tipos_vehiculo_logistica`
--

INSERT INTO `tipos_vehiculo_logistica` (`id_tipo_vehiculo`, `codigo`, `nombre`, `configuracion_mtc`, `capacidad_util_kg`, `rendimiento_km_galon`, `costo_operativo_km`, `costo_fijo_viaje`, `fuente_capacidad`, `fuente_parametros`, `calidad_dato`, `estado`, `creado_en`, `actualizado_en`) VALUES
(1, 'CAMION_LIVIANO_5T', 'Camión liviano hasta 5 t', NULL, 5000.00, 30.00, 0.70, 80.00, 'Capacidad operativa MVP; verificar tarjeta/ficha técnica del vehículo contratado.', 'Rendimiento y costo operativo: parámetros iniciales MVP editables por Operaciones.', 'ESTIMADO_MVP', 'ACTIVO', '2026-08-21 23:03:50', '2026-08-21 23:03:50'),
(2, 'CAMION_C2_10T', 'Camión C2 - planificación 10 t', 'C2', 10000.00, 24.00, 0.90, 100.00, 'MTC Reglamento Nacional de Vehículos: C2 PBV legal máx. 18 t; carga útil depende de tara.', 'Rendimiento y costo operativo: parámetros iniciales MVP editables por Operaciones.', 'LEGAL_REFERENCIAL', 'ACTIVO', '2026-08-21 23:03:50', '2026-08-21 23:03:50'),
(3, 'CAMION_C3_15T', 'Camión C3 - planificación 15 t', 'C3', 15000.00, 20.00, 1.10, 120.00, 'MTC Reglamento Nacional de Vehículos: C3 PBV legal máx. 25 t; carga útil depende de tara.', 'Rendimiento y costo operativo: parámetros iniciales MVP editables por Operaciones.', 'LEGAL_REFERENCIAL', 'ACTIVO', '2026-08-21 23:03:50', '2026-08-21 23:03:50'),
(4, 'CAMION_PESADO_20T', 'Camión pesado - planificación 20 t', NULL, 20000.00, 17.00, 1.30, 150.00, 'Capacidad operativa MVP; validar configuración, tara y carga útil legal del vehículo contratado.', 'Rendimiento y costo operativo: parámetros iniciales MVP editables por Operaciones.', 'ESTIMADO_MVP', 'ACTIVO', '2026-08-21 23:03:50', '2026-08-21 23:03:50');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tokens_seguridad`
--

CREATE TABLE `tokens_seguridad` (
  `id_token` bigint(20) UNSIGNED NOT NULL,
  `id_usuario` bigint(20) UNSIGNED NOT NULL,
  `tipo` enum('VERIFICAR_TELEFONO','VERIFICAR_CORREO','RECUPERAR_PASSWORD') NOT NULL,
  `codigo_hash` varchar(255) NOT NULL,
  `fecha_creacion` datetime NOT NULL DEFAULT current_timestamp(),
  `fecha_expiracion` datetime NOT NULL,
  `utilizado` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `tokens_seguridad`
--

INSERT INTO `tokens_seguridad` (`id_token`, `id_usuario`, `tipo`, `codigo_hash`, `fecha_creacion`, `fecha_expiracion`, `utilizado`) VALUES
(1, 1, 'RECUPERAR_PASSWORD', 'd3a364a84e53c614a2ada67f07402612286b0da8338d1cd8c9408908ef020c59', '2026-10-22 17:31:47', '2026-10-22 18:01:47', 1),
(2, 1, 'RECUPERAR_PASSWORD', 'f9e29ba482571218b1c5aa2cdc25820bde3c0067c67140fdf5e9d3038450c6e6', '2026-10-22 17:59:23', '2026-10-22 18:29:23', 1),
(3, 1, 'RECUPERAR_PASSWORD', '91140897ee2ba47fd963f4c20a25b8fd9bca0e41e0f78ef18c44123283ffaa2c', '2026-10-22 18:07:22', '2026-10-22 18:37:22', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `transportes`
--

CREATE TABLE `transportes` (
  `id_transporte` bigint(20) UNSIGNED NOT NULL,
  `codigo_transporte` varchar(24) NOT NULL,
  `id_operacion` bigint(20) UNSIGNED NOT NULL,
  `id_transportista` bigint(20) UNSIGNED NOT NULL,
  `id_vehiculo` bigint(20) UNSIGNED NOT NULL,
  `fecha_asignacion` datetime NOT NULL DEFAULT current_timestamp(),
  `fecha_recojo` datetime DEFAULT NULL,
  `fecha_salida` datetime DEFAULT NULL,
  `fecha_llegada` datetime DEFAULT NULL,
  `origen` varchar(255) NOT NULL,
  `destino` varchar(255) NOT NULL,
  `estado` enum('ASIGNADO','RECOJO_PROGRAMADO','CARGA_REALIZADA','EN_RUTA','LLEGADA_DESTINO','ENTREGADO','CANCELADO') NOT NULL DEFAULT 'ASIGNADO',
  `observaciones` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `transportistas`
--

CREATE TABLE `transportistas` (
  `id_transportista` bigint(20) UNSIGNED NOT NULL,
  `codigo_transportista` varchar(24) NOT NULL,
  `id_usuario` bigint(20) UNSIGNED DEFAULT NULL,
  `nombre_empresa` varchar(180) DEFAULT NULL,
  `ruc` varchar(11) DEFAULT NULL,
  `telefono` varchar(20) NOT NULL,
  `estado` enum('ACTIVO','INACTIVO') NOT NULL DEFAULT 'ACTIVO'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ubicaciones_transporte`
--

CREATE TABLE `ubicaciones_transporte` (
  `id_ubicacion` bigint(20) UNSIGNED NOT NULL,
  `id_transporte` bigint(20) UNSIGNED NOT NULL,
  `latitud` decimal(10,7) NOT NULL,
  `longitud` decimal(10,7) NOT NULL,
  `precision_m` decimal(10,2) DEFAULT NULL,
  `fecha_reporte` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ubigeos`
--

CREATE TABLE `ubigeos` (
  `id_ubigeo` int(10) UNSIGNED NOT NULL,
  `codigo_ubigeo` char(6) NOT NULL,
  `departamento` varchar(80) NOT NULL,
  `provincia` varchar(80) NOT NULL,
  `distrito` varchar(80) NOT NULL,
  `estado` enum('ACTIVO','INACTIVO') NOT NULL DEFAULT 'ACTIVO'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `ubigeos`
--

INSERT INTO `ubigeos` (`id_ubigeo`, `codigo_ubigeo`, `departamento`, `provincia`, `distrito`, `estado`) VALUES
(1, '010101', 'Amazonas', 'Chachapoyas', 'Chachapoyas', 'ACTIVO'),
(2, '010102', 'Amazonas', 'Chachapoyas', 'Asunción', 'ACTIVO'),
(3, '010103', 'Amazonas', 'Chachapoyas', 'Balsas', 'ACTIVO'),
(4, '010104', 'Amazonas', 'Chachapoyas', 'Cheto', 'ACTIVO'),
(5, '010105', 'Amazonas', 'Chachapoyas', 'Chiliquín', 'ACTIVO'),
(6, '010106', 'Amazonas', 'Chachapoyas', 'Chuquibamba', 'ACTIVO'),
(7, '010107', 'Amazonas', 'Chachapoyas', 'Granada', 'ACTIVO'),
(8, '010108', 'Amazonas', 'Chachapoyas', 'Huancas', 'ACTIVO'),
(9, '010109', 'Amazonas', 'Chachapoyas', 'La Jalca', 'ACTIVO'),
(10, '010110', 'Amazonas', 'Chachapoyas', 'Leimebamba', 'ACTIVO'),
(11, '010111', 'Amazonas', 'Chachapoyas', 'Levanto', 'ACTIVO'),
(12, '010112', 'Amazonas', 'Chachapoyas', 'Magdalena', 'ACTIVO'),
(13, '010113', 'Amazonas', 'Chachapoyas', 'Mariscal Castilla', 'ACTIVO'),
(14, '010114', 'Amazonas', 'Chachapoyas', 'Molinopampa', 'ACTIVO'),
(15, '010115', 'Amazonas', 'Chachapoyas', 'Montevideo', 'ACTIVO'),
(16, '010116', 'Amazonas', 'Chachapoyas', 'Olleros', 'ACTIVO'),
(17, '010117', 'Amazonas', 'Chachapoyas', 'Quinjalca', 'ACTIVO'),
(18, '010118', 'Amazonas', 'Chachapoyas', 'San Francisco de Daguas', 'ACTIVO'),
(19, '010119', 'Amazonas', 'Chachapoyas', 'San Isidro de Maino', 'ACTIVO'),
(20, '010120', 'Amazonas', 'Chachapoyas', 'Soloco', 'ACTIVO'),
(21, '010121', 'Amazonas', 'Chachapoyas', 'Sonche', 'ACTIVO'),
(22, '010201', 'Amazonas', 'Bagua', 'Bagua', 'ACTIVO'),
(23, '010202', 'Amazonas', 'Bagua', 'Aramango', 'ACTIVO'),
(24, '010203', 'Amazonas', 'Bagua', 'Copallín', 'ACTIVO'),
(25, '010204', 'Amazonas', 'Bagua', 'El Parco', 'ACTIVO'),
(26, '010205', 'Amazonas', 'Bagua', 'Imaza', 'ACTIVO'),
(27, '010206', 'Amazonas', 'Bagua', 'La Peca', 'ACTIVO'),
(28, '010301', 'Amazonas', 'Bongará', 'Jumbilla', 'ACTIVO'),
(29, '010302', 'Amazonas', 'Bongará', 'Chisquilla', 'ACTIVO'),
(30, '010303', 'Amazonas', 'Bongará', 'Churuja', 'ACTIVO'),
(31, '010304', 'Amazonas', 'Bongará', 'Corosha', 'ACTIVO'),
(32, '010305', 'Amazonas', 'Bongará', 'Cuispes', 'ACTIVO'),
(33, '010306', 'Amazonas', 'Bongará', 'Florida', 'ACTIVO'),
(34, '010307', 'Amazonas', 'Bongará', 'Jazán', 'ACTIVO'),
(35, '010308', 'Amazonas', 'Bongará', 'Recta', 'ACTIVO'),
(36, '010309', 'Amazonas', 'Bongará', 'San Carlos', 'ACTIVO'),
(37, '010310', 'Amazonas', 'Bongará', 'Shipasbamba', 'ACTIVO'),
(38, '010311', 'Amazonas', 'Bongará', 'Valera', 'ACTIVO'),
(39, '010312', 'Amazonas', 'Bongará', 'Yambrasbamba', 'ACTIVO'),
(40, '010401', 'Amazonas', 'Condorcanqui', 'Nieva', 'ACTIVO'),
(41, '010402', 'Amazonas', 'Condorcanqui', 'El Cenepa', 'ACTIVO'),
(42, '010403', 'Amazonas', 'Condorcanqui', 'Río Santiago', 'ACTIVO'),
(43, '010501', 'Amazonas', 'Luya', 'Lámud', 'ACTIVO'),
(44, '010502', 'Amazonas', 'Luya', 'Camporredondo', 'ACTIVO'),
(45, '010503', 'Amazonas', 'Luya', 'Cocabamba', 'ACTIVO'),
(46, '010504', 'Amazonas', 'Luya', 'Colcamar', 'ACTIVO'),
(47, '010505', 'Amazonas', 'Luya', 'Conila', 'ACTIVO'),
(48, '010506', 'Amazonas', 'Luya', 'Inguilpata', 'ACTIVO'),
(49, '010507', 'Amazonas', 'Luya', 'Longuita', 'ACTIVO'),
(50, '010508', 'Amazonas', 'Luya', 'Lonya Chico', 'ACTIVO'),
(51, '010509', 'Amazonas', 'Luya', 'Luya', 'ACTIVO'),
(52, '010510', 'Amazonas', 'Luya', 'Luya Viejo', 'ACTIVO'),
(53, '010511', 'Amazonas', 'Luya', 'María', 'ACTIVO'),
(54, '010512', 'Amazonas', 'Luya', 'Ocalli', 'ACTIVO'),
(55, '010513', 'Amazonas', 'Luya', 'Ocumal', 'ACTIVO'),
(56, '010514', 'Amazonas', 'Luya', 'Pisuquia', 'ACTIVO'),
(57, '010515', 'Amazonas', 'Luya', 'Providencia', 'ACTIVO'),
(58, '010516', 'Amazonas', 'Luya', 'San Cristóbal', 'ACTIVO'),
(59, '010517', 'Amazonas', 'Luya', 'San Francisco del Yeso', 'ACTIVO'),
(60, '010518', 'Amazonas', 'Luya', 'San Jerónimo', 'ACTIVO'),
(61, '010519', 'Amazonas', 'Luya', 'San Juan de Lopecancha', 'ACTIVO'),
(62, '010520', 'Amazonas', 'Luya', 'Santa Catalina', 'ACTIVO'),
(63, '010521', 'Amazonas', 'Luya', 'Santo Tomás', 'ACTIVO'),
(64, '010522', 'Amazonas', 'Luya', 'Tingo', 'ACTIVO'),
(65, '010523', 'Amazonas', 'Luya', 'Trita', 'ACTIVO'),
(66, '010601', 'Amazonas', 'Rodríguez de Mendoza', 'San Nicolás', 'ACTIVO'),
(67, '010602', 'Amazonas', 'Rodríguez de Mendoza', 'Chirimoto', 'ACTIVO'),
(68, '010603', 'Amazonas', 'Rodríguez de Mendoza', 'Cochamal', 'ACTIVO'),
(69, '010604', 'Amazonas', 'Rodríguez de Mendoza', 'Huambo', 'ACTIVO'),
(70, '010605', 'Amazonas', 'Rodríguez de Mendoza', 'Limabamba', 'ACTIVO'),
(71, '010606', 'Amazonas', 'Rodríguez de Mendoza', 'Longar', 'ACTIVO'),
(72, '010607', 'Amazonas', 'Rodríguez de Mendoza', 'Mariscal Benavides', 'ACTIVO'),
(73, '010608', 'Amazonas', 'Rodríguez de Mendoza', 'Milpuc', 'ACTIVO'),
(74, '010609', 'Amazonas', 'Rodríguez de Mendoza', 'Omia', 'ACTIVO'),
(75, '010610', 'Amazonas', 'Rodríguez de Mendoza', 'Santa Rosa', 'ACTIVO'),
(76, '010611', 'Amazonas', 'Rodríguez de Mendoza', 'Totora', 'ACTIVO'),
(77, '010612', 'Amazonas', 'Rodríguez de Mendoza', 'Vista Alegre', 'ACTIVO'),
(78, '010701', 'Amazonas', 'Utcubamba', 'Bagua Grande', 'ACTIVO'),
(79, '010702', 'Amazonas', 'Utcubamba', 'Cajaruro', 'ACTIVO'),
(80, '010703', 'Amazonas', 'Utcubamba', 'Cumba', 'ACTIVO'),
(81, '010704', 'Amazonas', 'Utcubamba', 'El Milagro', 'ACTIVO'),
(82, '010705', 'Amazonas', 'Utcubamba', 'Jamalca', 'ACTIVO'),
(83, '010706', 'Amazonas', 'Utcubamba', 'Lonya Grande', 'ACTIVO'),
(84, '010707', 'Amazonas', 'Utcubamba', 'Yamón', 'ACTIVO'),
(85, '020101', 'Áncash', 'Huaraz', 'Huaraz', 'ACTIVO'),
(86, '020102', 'Áncash', 'Huaraz', 'Cochabamba', 'ACTIVO'),
(87, '020103', 'Áncash', 'Huaraz', 'Colcabamba', 'ACTIVO'),
(88, '020104', 'Áncash', 'Huaraz', 'Huanchay', 'ACTIVO'),
(89, '020105', 'Áncash', 'Huaraz', 'Independencia', 'ACTIVO'),
(90, '020106', 'Áncash', 'Huaraz', 'Jangas', 'ACTIVO'),
(91, '020107', 'Áncash', 'Huaraz', 'La Libertad', 'ACTIVO'),
(92, '020108', 'Áncash', 'Huaraz', 'Olleros', 'ACTIVO'),
(93, '020109', 'Áncash', 'Huaraz', 'Pampas Grande', 'ACTIVO'),
(94, '020110', 'Áncash', 'Huaraz', 'Pariacoto', 'ACTIVO'),
(95, '020111', 'Áncash', 'Huaraz', 'Pira', 'ACTIVO'),
(96, '020112', 'Áncash', 'Huaraz', 'Tarica', 'ACTIVO'),
(97, '020201', 'Áncash', 'Aija', 'Aija', 'ACTIVO'),
(98, '020202', 'Áncash', 'Aija', 'Coris', 'ACTIVO'),
(99, '020203', 'Áncash', 'Aija', 'Huacllán', 'ACTIVO'),
(100, '020204', 'Áncash', 'Aija', 'La Merced', 'ACTIVO'),
(101, '020205', 'Áncash', 'Aija', 'Succha', 'ACTIVO'),
(102, '020301', 'Áncash', 'Antonio Raymondi', 'Llamellín', 'ACTIVO'),
(103, '020302', 'Áncash', 'Antonio Raymondi', 'Aczo', 'ACTIVO'),
(104, '020303', 'Áncash', 'Antonio Raymondi', 'Chaccho', 'ACTIVO'),
(105, '020304', 'Áncash', 'Antonio Raymondi', 'Chingas', 'ACTIVO'),
(106, '020305', 'Áncash', 'Antonio Raymondi', 'Mirgas', 'ACTIVO'),
(107, '020306', 'Áncash', 'Antonio Raymondi', 'San Juan de Rontoy', 'ACTIVO'),
(108, '020401', 'Áncash', 'Asunción', 'Chacas', 'ACTIVO'),
(109, '020402', 'Áncash', 'Asunción', 'Acochaca', 'ACTIVO'),
(110, '020501', 'Áncash', 'Bolognesi', 'Chiquián', 'ACTIVO'),
(111, '020502', 'Áncash', 'Bolognesi', 'Abelardo Pardo Lezameta', 'ACTIVO'),
(112, '020503', 'Áncash', 'Bolognesi', 'Antonio Raymondi', 'ACTIVO'),
(113, '020504', 'Áncash', 'Bolognesi', 'Aquia', 'ACTIVO'),
(114, '020505', 'Áncash', 'Bolognesi', 'Cajacay', 'ACTIVO'),
(115, '020506', 'Áncash', 'Bolognesi', 'Canis', 'ACTIVO'),
(116, '020507', 'Áncash', 'Bolognesi', 'Colquioc', 'ACTIVO'),
(117, '020508', 'Áncash', 'Bolognesi', 'Huallanca', 'ACTIVO'),
(118, '020509', 'Áncash', 'Bolognesi', 'Huasta', 'ACTIVO'),
(119, '020510', 'Áncash', 'Bolognesi', 'Huayllacayán', 'ACTIVO'),
(120, '020511', 'Áncash', 'Bolognesi', 'La Primavera', 'ACTIVO'),
(121, '020512', 'Áncash', 'Bolognesi', 'Mangas', 'ACTIVO'),
(122, '020513', 'Áncash', 'Bolognesi', 'Pacllón', 'ACTIVO'),
(123, '020514', 'Áncash', 'Bolognesi', 'San Miguel de Corpanqui', 'ACTIVO'),
(124, '020515', 'Áncash', 'Bolognesi', 'Ticllos', 'ACTIVO'),
(125, '020601', 'Áncash', 'Carhuaz', 'Carhuaz', 'ACTIVO'),
(126, '020602', 'Áncash', 'Carhuaz', 'Acopampa', 'ACTIVO'),
(127, '020603', 'Áncash', 'Carhuaz', 'Amashca', 'ACTIVO'),
(128, '020604', 'Áncash', 'Carhuaz', 'Anta', 'ACTIVO'),
(129, '020605', 'Áncash', 'Carhuaz', 'Ataquero', 'ACTIVO'),
(130, '020606', 'Áncash', 'Carhuaz', 'Marcará', 'ACTIVO'),
(131, '020607', 'Áncash', 'Carhuaz', 'Pariahuanca', 'ACTIVO'),
(132, '020608', 'Áncash', 'Carhuaz', 'San Miguel de Aco', 'ACTIVO'),
(133, '020609', 'Áncash', 'Carhuaz', 'Shilla', 'ACTIVO'),
(134, '020610', 'Áncash', 'Carhuaz', 'Tinco', 'ACTIVO'),
(135, '020611', 'Áncash', 'Carhuaz', 'Yungar', 'ACTIVO'),
(136, '020701', 'Áncash', 'Carlos Fermín Fitzcarrald', 'San Luis', 'ACTIVO'),
(137, '020702', 'Áncash', 'Carlos Fermín Fitzcarrald', 'San Nicolás', 'ACTIVO'),
(138, '020703', 'Áncash', 'Carlos Fermín Fitzcarrald', 'Yauya', 'ACTIVO'),
(139, '020801', 'Áncash', 'Casma', 'Casma', 'ACTIVO'),
(140, '020802', 'Áncash', 'Casma', 'Buena Vista Alta', 'ACTIVO'),
(141, '020803', 'Áncash', 'Casma', 'Comandante Noél', 'ACTIVO'),
(142, '020804', 'Áncash', 'Casma', 'Yaután', 'ACTIVO'),
(143, '020901', 'Áncash', 'Corongo', 'Corongo', 'ACTIVO'),
(144, '020902', 'Áncash', 'Corongo', 'Aco', 'ACTIVO'),
(145, '020903', 'Áncash', 'Corongo', 'Bambas', 'ACTIVO'),
(146, '020904', 'Áncash', 'Corongo', 'Cusca', 'ACTIVO'),
(147, '020905', 'Áncash', 'Corongo', 'La Pampa', 'ACTIVO'),
(148, '020906', 'Áncash', 'Corongo', 'Yánac', 'ACTIVO'),
(149, '020907', 'Áncash', 'Corongo', 'Yupán', 'ACTIVO'),
(150, '021001', 'Áncash', 'Huari', 'Huari', 'ACTIVO'),
(151, '021002', 'Áncash', 'Huari', 'Anra', 'ACTIVO'),
(152, '021003', 'Áncash', 'Huari', 'Cajay', 'ACTIVO'),
(153, '021004', 'Áncash', 'Huari', 'Chavín de Huántar', 'ACTIVO'),
(154, '021005', 'Áncash', 'Huari', 'Huacachi', 'ACTIVO'),
(155, '021006', 'Áncash', 'Huari', 'Huacchis', 'ACTIVO'),
(156, '021007', 'Áncash', 'Huari', 'Huachis', 'ACTIVO'),
(157, '021008', 'Áncash', 'Huari', 'Huántar', 'ACTIVO'),
(158, '021009', 'Áncash', 'Huari', 'Masín', 'ACTIVO'),
(159, '021010', 'Áncash', 'Huari', 'Paucas', 'ACTIVO'),
(160, '021011', 'Áncash', 'Huari', 'Ponto', 'ACTIVO'),
(161, '021012', 'Áncash', 'Huari', 'Rahuapampa', 'ACTIVO'),
(162, '021013', 'Áncash', 'Huari', 'Rapayan', 'ACTIVO'),
(163, '021014', 'Áncash', 'Huari', 'San Marcos', 'ACTIVO'),
(164, '021015', 'Áncash', 'Huari', 'San Pedro de Chana', 'ACTIVO'),
(165, '021016', 'Áncash', 'Huari', 'Uco', 'ACTIVO'),
(166, '021101', 'Áncash', 'Huarmey', 'Huarmey', 'ACTIVO'),
(167, '021102', 'Áncash', 'Huarmey', 'Cochapeti', 'ACTIVO'),
(168, '021103', 'Áncash', 'Huarmey', 'Culebras', 'ACTIVO'),
(169, '021104', 'Áncash', 'Huarmey', 'Huayán', 'ACTIVO'),
(170, '021105', 'Áncash', 'Huarmey', 'Malvas', 'ACTIVO'),
(171, '021201', 'Áncash', 'Huaylas', 'Caraz', 'ACTIVO'),
(172, '021202', 'Áncash', 'Huaylas', 'Huallanca', 'ACTIVO'),
(173, '021203', 'Áncash', 'Huaylas', 'Huata', 'ACTIVO'),
(174, '021204', 'Áncash', 'Huaylas', 'Huaylas', 'ACTIVO'),
(175, '021205', 'Áncash', 'Huaylas', 'Mato', 'ACTIVO'),
(176, '021206', 'Áncash', 'Huaylas', 'Pamparomás', 'ACTIVO'),
(177, '021207', 'Áncash', 'Huaylas', 'Pueblo Libre', 'ACTIVO'),
(178, '021208', 'Áncash', 'Huaylas', 'Santa Cruz', 'ACTIVO'),
(179, '021209', 'Áncash', 'Huaylas', 'Santo Toribio', 'ACTIVO'),
(180, '021210', 'Áncash', 'Huaylas', 'Yuracmarca', 'ACTIVO'),
(181, '021301', 'Áncash', 'Mariscal Luzuriaga', 'Piscobamba', 'ACTIVO'),
(182, '021302', 'Áncash', 'Mariscal Luzuriaga', 'Casca', 'ACTIVO'),
(183, '021303', 'Áncash', 'Mariscal Luzuriaga', 'Eleazar Guzmán Barrón', 'ACTIVO'),
(184, '021304', 'Áncash', 'Mariscal Luzuriaga', 'Fidel Olivas Escudero', 'ACTIVO'),
(185, '021305', 'Áncash', 'Mariscal Luzuriaga', 'Llama', 'ACTIVO'),
(186, '021306', 'Áncash', 'Mariscal Luzuriaga', 'Llumpa', 'ACTIVO'),
(187, '021307', 'Áncash', 'Mariscal Luzuriaga', 'Lucma', 'ACTIVO'),
(188, '021308', 'Áncash', 'Mariscal Luzuriaga', 'Musga', 'ACTIVO'),
(189, '021401', 'Áncash', 'Ocros', 'Ocros', 'ACTIVO'),
(190, '021402', 'Áncash', 'Ocros', 'Acas', 'ACTIVO'),
(191, '021403', 'Áncash', 'Ocros', 'Cajamarquilla', 'ACTIVO'),
(192, '021404', 'Áncash', 'Ocros', 'Carhuapampa', 'ACTIVO'),
(193, '021405', 'Áncash', 'Ocros', 'Cochas', 'ACTIVO'),
(194, '021406', 'Áncash', 'Ocros', 'Congas', 'ACTIVO'),
(195, '021407', 'Áncash', 'Ocros', 'Llipa', 'ACTIVO'),
(196, '021408', 'Áncash', 'Ocros', 'San Cristóbal de Raján', 'ACTIVO'),
(197, '021409', 'Áncash', 'Ocros', 'San Pedro', 'ACTIVO'),
(198, '021410', 'Áncash', 'Ocros', 'Santiago de Chilcas', 'ACTIVO'),
(199, '021501', 'Áncash', 'Pallasca', 'Cabana', 'ACTIVO'),
(200, '021502', 'Áncash', 'Pallasca', 'Bolognesi', 'ACTIVO'),
(201, '021503', 'Áncash', 'Pallasca', 'Conchucos', 'ACTIVO'),
(202, '021504', 'Áncash', 'Pallasca', 'Huacaschuque', 'ACTIVO'),
(203, '021505', 'Áncash', 'Pallasca', 'Huandoval', 'ACTIVO'),
(204, '021506', 'Áncash', 'Pallasca', 'Lacabamba', 'ACTIVO'),
(205, '021507', 'Áncash', 'Pallasca', 'Llapo', 'ACTIVO'),
(206, '021508', 'Áncash', 'Pallasca', 'Pallasca', 'ACTIVO'),
(207, '021509', 'Áncash', 'Pallasca', 'Pampas', 'ACTIVO'),
(208, '021510', 'Áncash', 'Pallasca', 'Santa Rosa', 'ACTIVO'),
(209, '021511', 'Áncash', 'Pallasca', 'Tauca', 'ACTIVO'),
(210, '021601', 'Áncash', 'Pomabamba', 'Pomabamba', 'ACTIVO'),
(211, '021602', 'Áncash', 'Pomabamba', 'Huayllán', 'ACTIVO'),
(212, '021603', 'Áncash', 'Pomabamba', 'Parobamba', 'ACTIVO'),
(213, '021604', 'Áncash', 'Pomabamba', 'Quinuabamba', 'ACTIVO'),
(214, '021701', 'Áncash', 'Recuay', 'Recuay', 'ACTIVO'),
(215, '021702', 'Áncash', 'Recuay', 'Cátac', 'ACTIVO'),
(216, '021703', 'Áncash', 'Recuay', 'Cotaparaco', 'ACTIVO'),
(217, '021704', 'Áncash', 'Recuay', 'Huayllapampa', 'ACTIVO'),
(218, '021705', 'Áncash', 'Recuay', 'Llacllin', 'ACTIVO'),
(219, '021706', 'Áncash', 'Recuay', 'Marca', 'ACTIVO'),
(220, '021707', 'Áncash', 'Recuay', 'Pampas Chico', 'ACTIVO'),
(221, '021708', 'Áncash', 'Recuay', 'Pararín', 'ACTIVO'),
(222, '021709', 'Áncash', 'Recuay', 'Tapacocha', 'ACTIVO'),
(223, '021710', 'Áncash', 'Recuay', 'Ticapampa', 'ACTIVO'),
(224, '021801', 'Áncash', 'Santa', 'Chimbote', 'ACTIVO'),
(225, '021802', 'Áncash', 'Santa', 'Cáceres del Perú', 'ACTIVO'),
(226, '021803', 'Áncash', 'Santa', 'Coishco', 'ACTIVO'),
(227, '021804', 'Áncash', 'Santa', 'Macate', 'ACTIVO'),
(228, '021805', 'Áncash', 'Santa', 'Moro', 'ACTIVO'),
(229, '021806', 'Áncash', 'Santa', 'Nepeña', 'ACTIVO'),
(230, '021807', 'Áncash', 'Santa', 'Samanco', 'ACTIVO'),
(231, '021808', 'Áncash', 'Santa', 'Santa', 'ACTIVO'),
(232, '021809', 'Áncash', 'Santa', 'Nuevo Chimbote', 'ACTIVO'),
(233, '021901', 'Áncash', 'Sihuas', 'Sihuas', 'ACTIVO'),
(234, '021902', 'Áncash', 'Sihuas', 'Acobamba', 'ACTIVO'),
(235, '021903', 'Áncash', 'Sihuas', 'Alfonso Ugarte', 'ACTIVO'),
(236, '021904', 'Áncash', 'Sihuas', 'Cashapampa', 'ACTIVO'),
(237, '021905', 'Áncash', 'Sihuas', 'Chingalpo', 'ACTIVO'),
(238, '021906', 'Áncash', 'Sihuas', 'Huayllabamba', 'ACTIVO'),
(239, '021907', 'Áncash', 'Sihuas', 'Quiches', 'ACTIVO'),
(240, '021908', 'Áncash', 'Sihuas', 'Ragash', 'ACTIVO'),
(241, '021909', 'Áncash', 'Sihuas', 'San Juan', 'ACTIVO'),
(242, '021910', 'Áncash', 'Sihuas', 'Sicsibamba', 'ACTIVO'),
(243, '022001', 'Áncash', 'Yungay', 'Yungay', 'ACTIVO'),
(244, '022002', 'Áncash', 'Yungay', 'Cascapara', 'ACTIVO'),
(245, '022003', 'Áncash', 'Yungay', 'Mancos', 'ACTIVO'),
(246, '022004', 'Áncash', 'Yungay', 'Matacoto', 'ACTIVO'),
(247, '022005', 'Áncash', 'Yungay', 'Quillo', 'ACTIVO'),
(248, '022006', 'Áncash', 'Yungay', 'Ranrahirca', 'ACTIVO'),
(249, '022007', 'Áncash', 'Yungay', 'Shupluy', 'ACTIVO'),
(250, '022008', 'Áncash', 'Yungay', 'Yanama', 'ACTIVO'),
(251, '030101', 'Apurímac', 'Abancay', 'Abancay', 'ACTIVO'),
(252, '030102', 'Apurímac', 'Abancay', 'Chacoche', 'ACTIVO'),
(253, '030103', 'Apurímac', 'Abancay', 'Circa', 'ACTIVO'),
(254, '030104', 'Apurímac', 'Abancay', 'Curahuasi', 'ACTIVO'),
(255, '030105', 'Apurímac', 'Abancay', 'Huanipaca', 'ACTIVO'),
(256, '030106', 'Apurímac', 'Abancay', 'Lambrama', 'ACTIVO'),
(257, '030107', 'Apurímac', 'Abancay', 'Pichirhua', 'ACTIVO'),
(258, '030108', 'Apurímac', 'Abancay', 'San Pedro de Cachora', 'ACTIVO'),
(259, '030109', 'Apurímac', 'Abancay', 'Tamburco', 'ACTIVO'),
(260, '030201', 'Apurímac', 'Andahuaylas', 'Andahuaylas', 'ACTIVO'),
(261, '030202', 'Apurímac', 'Andahuaylas', 'Andarapa', 'ACTIVO'),
(262, '030203', 'Apurímac', 'Andahuaylas', 'Chiara', 'ACTIVO'),
(263, '030204', 'Apurímac', 'Andahuaylas', 'Huancarama', 'ACTIVO'),
(264, '030205', 'Apurímac', 'Andahuaylas', 'Huancaray', 'ACTIVO'),
(265, '030206', 'Apurímac', 'Andahuaylas', 'Huayana', 'ACTIVO'),
(266, '030207', 'Apurímac', 'Andahuaylas', 'Kishuara', 'ACTIVO'),
(267, '030208', 'Apurímac', 'Andahuaylas', 'Pacobamba', 'ACTIVO'),
(268, '030209', 'Apurímac', 'Andahuaylas', 'Pacucha', 'ACTIVO'),
(269, '030210', 'Apurímac', 'Andahuaylas', 'Pampachiri', 'ACTIVO'),
(270, '030211', 'Apurímac', 'Andahuaylas', 'Pomacocha', 'ACTIVO'),
(271, '030212', 'Apurímac', 'Andahuaylas', 'San Antonio de Cachi', 'ACTIVO'),
(272, '030213', 'Apurímac', 'Andahuaylas', 'San Jerónimo', 'ACTIVO'),
(273, '030214', 'Apurímac', 'Andahuaylas', 'San Miguel de Chaccrampa', 'ACTIVO'),
(274, '030215', 'Apurímac', 'Andahuaylas', 'Santa María de Chicmo', 'ACTIVO'),
(275, '030216', 'Apurímac', 'Andahuaylas', 'Talavera', 'ACTIVO'),
(276, '030217', 'Apurímac', 'Andahuaylas', 'Tumay Huaraca', 'ACTIVO'),
(277, '030218', 'Apurímac', 'Andahuaylas', 'Turpo', 'ACTIVO'),
(278, '030219', 'Apurímac', 'Andahuaylas', 'Kaquiabamba', 'ACTIVO'),
(279, '030220', 'Apurímac', 'Andahuaylas', 'José María Arguedas', 'ACTIVO'),
(280, '030301', 'Apurímac', 'Antabamba', 'Antabamba', 'ACTIVO'),
(281, '030302', 'Apurímac', 'Antabamba', 'El Oro', 'ACTIVO'),
(282, '030303', 'Apurímac', 'Antabamba', 'Huaquirca', 'ACTIVO'),
(283, '030304', 'Apurímac', 'Antabamba', 'Juan Espinoza Medrano', 'ACTIVO'),
(284, '030305', 'Apurímac', 'Antabamba', 'Oropesa', 'ACTIVO'),
(285, '030306', 'Apurímac', 'Antabamba', 'Pachaconas', 'ACTIVO'),
(286, '030307', 'Apurímac', 'Antabamba', 'Sabaino', 'ACTIVO'),
(287, '030401', 'Apurímac', 'Aymaraes', 'Chalhuanca', 'ACTIVO'),
(288, '030402', 'Apurímac', 'Aymaraes', 'Capaya', 'ACTIVO'),
(289, '030403', 'Apurímac', 'Aymaraes', 'Caraybamba', 'ACTIVO'),
(290, '030404', 'Apurímac', 'Aymaraes', 'Chapimarca', 'ACTIVO'),
(291, '030405', 'Apurímac', 'Aymaraes', 'Colcabamba', 'ACTIVO'),
(292, '030406', 'Apurímac', 'Aymaraes', 'Cotaruse', 'ACTIVO'),
(293, '030407', 'Apurímac', 'Aymaraes', 'Ihuayllo', 'ACTIVO'),
(294, '030408', 'Apurímac', 'Aymaraes', 'Justo Apu Sahuaraura', 'ACTIVO'),
(295, '030409', 'Apurímac', 'Aymaraes', 'Lucre', 'ACTIVO'),
(296, '030410', 'Apurímac', 'Aymaraes', 'Pocohuanca', 'ACTIVO'),
(297, '030411', 'Apurímac', 'Aymaraes', 'San Juan de Chacña', 'ACTIVO'),
(298, '030412', 'Apurímac', 'Aymaraes', 'Sañayca', 'ACTIVO'),
(299, '030413', 'Apurímac', 'Aymaraes', 'Soraya', 'ACTIVO'),
(300, '030414', 'Apurímac', 'Aymaraes', 'Tapairihua', 'ACTIVO'),
(301, '030415', 'Apurímac', 'Aymaraes', 'Tintay', 'ACTIVO'),
(302, '030416', 'Apurímac', 'Aymaraes', 'Toraya', 'ACTIVO'),
(303, '030417', 'Apurímac', 'Aymaraes', 'Yanaca', 'ACTIVO'),
(304, '030501', 'Apurímac', 'Cotabambas', 'Tambobamba', 'ACTIVO'),
(305, '030502', 'Apurímac', 'Cotabambas', 'Cotabambas', 'ACTIVO'),
(306, '030503', 'Apurímac', 'Cotabambas', 'Coyllurqui', 'ACTIVO'),
(307, '030504', 'Apurímac', 'Cotabambas', 'Haquira', 'ACTIVO'),
(308, '030505', 'Apurímac', 'Cotabambas', 'Mara', 'ACTIVO'),
(309, '030506', 'Apurímac', 'Cotabambas', 'Challhuahuacho', 'ACTIVO'),
(310, '030601', 'Apurímac', 'Chincheros', 'Chincheros', 'ACTIVO'),
(311, '030602', 'Apurímac', 'Chincheros', 'Anco-Huallo', 'ACTIVO'),
(312, '030603', 'Apurímac', 'Chincheros', 'Cocharcas', 'ACTIVO'),
(313, '030604', 'Apurímac', 'Chincheros', 'Huaccana', 'ACTIVO'),
(314, '030605', 'Apurímac', 'Chincheros', 'Ocobamba', 'ACTIVO'),
(315, '030606', 'Apurímac', 'Chincheros', 'Ongoy', 'ACTIVO'),
(316, '030607', 'Apurímac', 'Chincheros', 'Uranmarca', 'ACTIVO'),
(317, '030608', 'Apurímac', 'Chincheros', 'Ranracancha', 'ACTIVO'),
(318, '030609', 'Apurímac', 'Chincheros', 'Rocchacc', 'ACTIVO'),
(319, '030610', 'Apurímac', 'Chincheros', 'El Porvenir', 'ACTIVO'),
(320, '030611', 'Apurímac', 'Chincheros', 'Los Chankas', 'ACTIVO'),
(321, '030612', 'Apurímac', 'Chincheros', 'Ahuayro', 'ACTIVO'),
(322, '030701', 'Apurímac', 'Grau', 'Chuquibambilla', 'ACTIVO'),
(323, '030702', 'Apurímac', 'Grau', 'Curpahuasi', 'ACTIVO'),
(324, '030703', 'Apurímac', 'Grau', 'Gamarra', 'ACTIVO'),
(325, '030704', 'Apurímac', 'Grau', 'Huayllati', 'ACTIVO'),
(326, '030705', 'Apurímac', 'Grau', 'Mamara', 'ACTIVO'),
(327, '030706', 'Apurímac', 'Grau', 'Micaela Bastidas', 'ACTIVO'),
(328, '030707', 'Apurímac', 'Grau', 'Pataypampa', 'ACTIVO'),
(329, '030708', 'Apurímac', 'Grau', 'Progreso', 'ACTIVO'),
(330, '030709', 'Apurímac', 'Grau', 'San Antonio', 'ACTIVO'),
(331, '030710', 'Apurímac', 'Grau', 'Santa Rosa', 'ACTIVO'),
(332, '030711', 'Apurímac', 'Grau', 'Turpay', 'ACTIVO'),
(333, '030712', 'Apurímac', 'Grau', 'Vilcabamba', 'ACTIVO'),
(334, '030713', 'Apurímac', 'Grau', 'Virundo', 'ACTIVO'),
(335, '030714', 'Apurímac', 'Grau', 'Curasco', 'ACTIVO'),
(336, '040101', 'Arequipa', 'Arequipa', 'Arequipa', 'ACTIVO'),
(337, '040102', 'Arequipa', 'Arequipa', 'Alto Selva Alegre', 'ACTIVO'),
(338, '040103', 'Arequipa', 'Arequipa', 'Cayma', 'ACTIVO'),
(339, '040104', 'Arequipa', 'Arequipa', 'Cerro Colorado', 'ACTIVO'),
(340, '040105', 'Arequipa', 'Arequipa', 'Characato', 'ACTIVO'),
(341, '040106', 'Arequipa', 'Arequipa', 'Chiguata', 'ACTIVO'),
(342, '040107', 'Arequipa', 'Arequipa', 'Jacobo Hunter', 'ACTIVO'),
(343, '040108', 'Arequipa', 'Arequipa', 'La Joya', 'ACTIVO'),
(344, '040109', 'Arequipa', 'Arequipa', 'Mariano Melgar', 'ACTIVO'),
(345, '040110', 'Arequipa', 'Arequipa', 'Miraflores', 'ACTIVO'),
(346, '040111', 'Arequipa', 'Arequipa', 'Mollebaya', 'ACTIVO'),
(347, '040112', 'Arequipa', 'Arequipa', 'Paucarpata', 'ACTIVO'),
(348, '040113', 'Arequipa', 'Arequipa', 'Pocsi', 'ACTIVO'),
(349, '040114', 'Arequipa', 'Arequipa', 'Polobaya', 'ACTIVO'),
(350, '040115', 'Arequipa', 'Arequipa', 'Quequeña', 'ACTIVO'),
(351, '040116', 'Arequipa', 'Arequipa', 'Sabandia', 'ACTIVO'),
(352, '040117', 'Arequipa', 'Arequipa', 'Sachaca', 'ACTIVO'),
(353, '040118', 'Arequipa', 'Arequipa', 'San Juan de Siguas', 'ACTIVO'),
(354, '040119', 'Arequipa', 'Arequipa', 'San Juan de Tarucani', 'ACTIVO'),
(355, '040120', 'Arequipa', 'Arequipa', 'Santa Isabel de Siguas', 'ACTIVO'),
(356, '040121', 'Arequipa', 'Arequipa', 'Santa Rita de Siguas', 'ACTIVO'),
(357, '040122', 'Arequipa', 'Arequipa', 'Socabaya', 'ACTIVO'),
(358, '040123', 'Arequipa', 'Arequipa', 'Tiabaya', 'ACTIVO'),
(359, '040124', 'Arequipa', 'Arequipa', 'Uchumayo', 'ACTIVO'),
(360, '040125', 'Arequipa', 'Arequipa', 'Vitor', 'ACTIVO'),
(361, '040126', 'Arequipa', 'Arequipa', 'Yanahuara', 'ACTIVO'),
(362, '040127', 'Arequipa', 'Arequipa', 'Yarabamba', 'ACTIVO'),
(363, '040128', 'Arequipa', 'Arequipa', 'Yura', 'ACTIVO'),
(364, '040129', 'Arequipa', 'Arequipa', 'José Luis Bustamante y Rivero', 'ACTIVO'),
(365, '040201', 'Arequipa', 'Camaná', 'Camaná', 'ACTIVO'),
(366, '040202', 'Arequipa', 'Camaná', 'José María Quimper', 'ACTIVO'),
(367, '040203', 'Arequipa', 'Camaná', 'Mariano Nicolás Valcárcel', 'ACTIVO'),
(368, '040204', 'Arequipa', 'Camaná', 'Mariscal Cáceres', 'ACTIVO'),
(369, '040205', 'Arequipa', 'Camaná', 'Nicolás de Piérola', 'ACTIVO'),
(370, '040206', 'Arequipa', 'Camaná', 'Ocoña', 'ACTIVO'),
(371, '040207', 'Arequipa', 'Camaná', 'Quilca', 'ACTIVO'),
(372, '040208', 'Arequipa', 'Camaná', 'Samuel Pastor', 'ACTIVO'),
(373, '040301', 'Arequipa', 'Caravelí', 'Caravelí', 'ACTIVO'),
(374, '040302', 'Arequipa', 'Caravelí', 'Acarí', 'ACTIVO'),
(375, '040303', 'Arequipa', 'Caravelí', 'Atico', 'ACTIVO'),
(376, '040304', 'Arequipa', 'Caravelí', 'Atiquipa', 'ACTIVO'),
(377, '040305', 'Arequipa', 'Caravelí', 'Bella Unión', 'ACTIVO'),
(378, '040306', 'Arequipa', 'Caravelí', 'Cahuacho', 'ACTIVO'),
(379, '040307', 'Arequipa', 'Caravelí', 'Chala', 'ACTIVO'),
(380, '040308', 'Arequipa', 'Caravelí', 'Chaparra', 'ACTIVO'),
(381, '040309', 'Arequipa', 'Caravelí', 'Huanuhuanu', 'ACTIVO'),
(382, '040310', 'Arequipa', 'Caravelí', 'Jaqui', 'ACTIVO'),
(383, '040311', 'Arequipa', 'Caravelí', 'Lomas', 'ACTIVO'),
(384, '040312', 'Arequipa', 'Caravelí', 'Quicacha', 'ACTIVO'),
(385, '040313', 'Arequipa', 'Caravelí', 'Yauca', 'ACTIVO'),
(386, '040401', 'Arequipa', 'Castilla', 'Aplao', 'ACTIVO'),
(387, '040402', 'Arequipa', 'Castilla', 'Andagua', 'ACTIVO'),
(388, '040403', 'Arequipa', 'Castilla', 'Ayo', 'ACTIVO'),
(389, '040404', 'Arequipa', 'Castilla', 'Chachas', 'ACTIVO'),
(390, '040405', 'Arequipa', 'Castilla', 'Chilcaymarca', 'ACTIVO'),
(391, '040406', 'Arequipa', 'Castilla', 'Choco', 'ACTIVO'),
(392, '040407', 'Arequipa', 'Castilla', 'Huancarqui', 'ACTIVO'),
(393, '040408', 'Arequipa', 'Castilla', 'Machaguay', 'ACTIVO'),
(394, '040409', 'Arequipa', 'Castilla', 'Orcopampa', 'ACTIVO'),
(395, '040410', 'Arequipa', 'Castilla', 'Pampacolca', 'ACTIVO'),
(396, '040411', 'Arequipa', 'Castilla', 'Tipán', 'ACTIVO'),
(397, '040412', 'Arequipa', 'Castilla', 'Uñón', 'ACTIVO'),
(398, '040413', 'Arequipa', 'Castilla', 'Uraca', 'ACTIVO'),
(399, '040414', 'Arequipa', 'Castilla', 'Viraco', 'ACTIVO'),
(400, '040501', 'Arequipa', 'Caylloma', 'Chivay', 'ACTIVO'),
(401, '040502', 'Arequipa', 'Caylloma', 'Achoma', 'ACTIVO'),
(402, '040503', 'Arequipa', 'Caylloma', 'Cabanaconde', 'ACTIVO'),
(403, '040504', 'Arequipa', 'Caylloma', 'Callalli', 'ACTIVO'),
(404, '040505', 'Arequipa', 'Caylloma', 'Caylloma', 'ACTIVO'),
(405, '040506', 'Arequipa', 'Caylloma', 'Coporaque', 'ACTIVO'),
(406, '040507', 'Arequipa', 'Caylloma', 'Huambo', 'ACTIVO'),
(407, '040508', 'Arequipa', 'Caylloma', 'Huanca', 'ACTIVO'),
(408, '040509', 'Arequipa', 'Caylloma', 'Ichupampa', 'ACTIVO'),
(409, '040510', 'Arequipa', 'Caylloma', 'Lari', 'ACTIVO'),
(410, '040511', 'Arequipa', 'Caylloma', 'Lluta', 'ACTIVO'),
(411, '040512', 'Arequipa', 'Caylloma', 'Maca', 'ACTIVO'),
(412, '040513', 'Arequipa', 'Caylloma', 'Madrigal', 'ACTIVO'),
(413, '040514', 'Arequipa', 'Caylloma', 'San Antonio de Chuca', 'ACTIVO'),
(414, '040515', 'Arequipa', 'Caylloma', 'Sibayo', 'ACTIVO'),
(415, '040516', 'Arequipa', 'Caylloma', 'Tapay', 'ACTIVO'),
(416, '040517', 'Arequipa', 'Caylloma', 'Tisco', 'ACTIVO'),
(417, '040518', 'Arequipa', 'Caylloma', 'Tuti', 'ACTIVO'),
(418, '040519', 'Arequipa', 'Caylloma', 'Yanque', 'ACTIVO'),
(419, '040520', 'Arequipa', 'Caylloma', 'Majes', 'ACTIVO'),
(420, '040601', 'Arequipa', 'Condesuyos', 'Chuquibamba', 'ACTIVO'),
(421, '040602', 'Arequipa', 'Condesuyos', 'Andaray', 'ACTIVO'),
(422, '040603', 'Arequipa', 'Condesuyos', 'Cayarani', 'ACTIVO'),
(423, '040604', 'Arequipa', 'Condesuyos', 'Chichas', 'ACTIVO'),
(424, '040605', 'Arequipa', 'Condesuyos', 'Iray', 'ACTIVO'),
(425, '040606', 'Arequipa', 'Condesuyos', 'Río Grande', 'ACTIVO'),
(426, '040607', 'Arequipa', 'Condesuyos', 'Salamanca', 'ACTIVO'),
(427, '040608', 'Arequipa', 'Condesuyos', 'Yanaquihua', 'ACTIVO'),
(428, '040701', 'Arequipa', 'Islay', 'Mollendo', 'ACTIVO'),
(429, '040702', 'Arequipa', 'Islay', 'Cocachacra', 'ACTIVO'),
(430, '040703', 'Arequipa', 'Islay', 'Dean Valdivia', 'ACTIVO'),
(431, '040704', 'Arequipa', 'Islay', 'Islay', 'ACTIVO'),
(432, '040705', 'Arequipa', 'Islay', 'Mejía', 'ACTIVO'),
(433, '040706', 'Arequipa', 'Islay', 'Punta de Bombón', 'ACTIVO'),
(434, '040801', 'Arequipa', 'La Unión', 'Cotahuasi', 'ACTIVO'),
(435, '040802', 'Arequipa', 'La Unión', 'Alca', 'ACTIVO'),
(436, '040803', 'Arequipa', 'La Unión', 'Charcana', 'ACTIVO'),
(437, '040804', 'Arequipa', 'La Unión', 'Huaynacotas', 'ACTIVO'),
(438, '040805', 'Arequipa', 'La Unión', 'Pampamarca', 'ACTIVO'),
(439, '040806', 'Arequipa', 'La Unión', 'Puyca', 'ACTIVO'),
(440, '040807', 'Arequipa', 'La Unión', 'Quechualla', 'ACTIVO'),
(441, '040808', 'Arequipa', 'La Unión', 'Sayla', 'ACTIVO'),
(442, '040809', 'Arequipa', 'La Unión', 'Tauria', 'ACTIVO'),
(443, '040810', 'Arequipa', 'La Unión', 'Tomepampa', 'ACTIVO'),
(444, '040811', 'Arequipa', 'La Unión', 'Toro', 'ACTIVO'),
(445, '050101', 'Ayacucho', 'Huamanga', 'Ayacucho', 'ACTIVO'),
(446, '050102', 'Ayacucho', 'Huamanga', 'Acocro', 'ACTIVO'),
(447, '050103', 'Ayacucho', 'Huamanga', 'Acos Vinchos', 'ACTIVO'),
(448, '050104', 'Ayacucho', 'Huamanga', 'Carmen Alto', 'ACTIVO'),
(449, '050105', 'Ayacucho', 'Huamanga', 'Chiara', 'ACTIVO'),
(450, '050106', 'Ayacucho', 'Huamanga', 'Ocros', 'ACTIVO'),
(451, '050107', 'Ayacucho', 'Huamanga', 'Pacaycasa', 'ACTIVO'),
(452, '050108', 'Ayacucho', 'Huamanga', 'Quinua', 'ACTIVO'),
(453, '050109', 'Ayacucho', 'Huamanga', 'San José de Ticllas', 'ACTIVO'),
(454, '050110', 'Ayacucho', 'Huamanga', 'San Juan Bautista', 'ACTIVO'),
(455, '050111', 'Ayacucho', 'Huamanga', 'Santiago de Pischa', 'ACTIVO'),
(456, '050112', 'Ayacucho', 'Huamanga', 'Socos', 'ACTIVO'),
(457, '050113', 'Ayacucho', 'Huamanga', 'Tambillo', 'ACTIVO'),
(458, '050114', 'Ayacucho', 'Huamanga', 'Vinchos', 'ACTIVO'),
(459, '050115', 'Ayacucho', 'Huamanga', 'Jesús Nazareno', 'ACTIVO'),
(460, '050116', 'Ayacucho', 'Huamanga', 'Andrés Avelino Cáceres Dorregaray', 'ACTIVO'),
(461, '050201', 'Ayacucho', 'Cangallo', 'Cangallo', 'ACTIVO'),
(462, '050202', 'Ayacucho', 'Cangallo', 'Chuschi', 'ACTIVO'),
(463, '050203', 'Ayacucho', 'Cangallo', 'Los Morochucos', 'ACTIVO'),
(464, '050204', 'Ayacucho', 'Cangallo', 'María Parado de Bellido', 'ACTIVO'),
(465, '050205', 'Ayacucho', 'Cangallo', 'Paras', 'ACTIVO'),
(466, '050206', 'Ayacucho', 'Cangallo', 'Totos', 'ACTIVO'),
(467, '050301', 'Ayacucho', 'Huanca Sancos', 'Sancos', 'ACTIVO'),
(468, '050302', 'Ayacucho', 'Huanca Sancos', 'Carapo', 'ACTIVO'),
(469, '050303', 'Ayacucho', 'Huanca Sancos', 'Sacsamarca', 'ACTIVO'),
(470, '050304', 'Ayacucho', 'Huanca Sancos', 'Santiago de Lucanamarca', 'ACTIVO'),
(471, '050401', 'Ayacucho', 'Huanta', 'Huanta', 'ACTIVO'),
(472, '050402', 'Ayacucho', 'Huanta', 'Ayahuanco', 'ACTIVO'),
(473, '050403', 'Ayacucho', 'Huanta', 'Huamanguilla', 'ACTIVO'),
(474, '050404', 'Ayacucho', 'Huanta', 'Iguain', 'ACTIVO'),
(475, '050405', 'Ayacucho', 'Huanta', 'Luricocha', 'ACTIVO'),
(476, '050406', 'Ayacucho', 'Huanta', 'Santillana', 'ACTIVO'),
(477, '050407', 'Ayacucho', 'Huanta', 'Sivia', 'ACTIVO'),
(478, '050408', 'Ayacucho', 'Huanta', 'Llochegua', 'ACTIVO'),
(479, '050409', 'Ayacucho', 'Huanta', 'Canayre', 'ACTIVO'),
(480, '050410', 'Ayacucho', 'Huanta', 'Uchuraccay', 'ACTIVO'),
(481, '050411', 'Ayacucho', 'Huanta', 'Pucacolpa', 'ACTIVO'),
(482, '050412', 'Ayacucho', 'Huanta', 'Chaca', 'ACTIVO'),
(483, '050413', 'Ayacucho', 'Huanta', 'Putis', 'ACTIVO'),
(484, '050501', 'Ayacucho', 'La Mar', 'San Miguel', 'ACTIVO'),
(485, '050502', 'Ayacucho', 'La Mar', 'Anco', 'ACTIVO'),
(486, '050503', 'Ayacucho', 'La Mar', 'Ayna', 'ACTIVO'),
(487, '050504', 'Ayacucho', 'La Mar', 'Chilcas', 'ACTIVO'),
(488, '050505', 'Ayacucho', 'La Mar', 'Chungui', 'ACTIVO'),
(489, '050506', 'Ayacucho', 'La Mar', 'Luis Carranza', 'ACTIVO'),
(490, '050507', 'Ayacucho', 'La Mar', 'Santa Rosa', 'ACTIVO'),
(491, '050508', 'Ayacucho', 'La Mar', 'Tambo', 'ACTIVO'),
(492, '050509', 'Ayacucho', 'La Mar', 'Samugari', 'ACTIVO'),
(493, '050510', 'Ayacucho', 'La Mar', 'Anchihuay', 'ACTIVO'),
(494, '050511', 'Ayacucho', 'La Mar', 'Oronccoy', 'ACTIVO'),
(495, '050512', 'Ayacucho', 'La Mar', 'Unión Progreso', 'ACTIVO'),
(496, '050513', 'Ayacucho', 'La Mar', 'Río Magdalena', 'ACTIVO'),
(497, '050514', 'Ayacucho', 'La Mar', 'Ninabamba', 'ACTIVO'),
(498, '050515', 'Ayacucho', 'La Mar', 'Patibamba', 'ACTIVO'),
(499, '050601', 'Ayacucho', 'Lucanas', 'Puquio', 'ACTIVO'),
(500, '050602', 'Ayacucho', 'Lucanas', 'Aucara', 'ACTIVO'),
(501, '050603', 'Ayacucho', 'Lucanas', 'Cabana', 'ACTIVO'),
(502, '050604', 'Ayacucho', 'Lucanas', 'Carmen Salcedo', 'ACTIVO'),
(503, '050605', 'Ayacucho', 'Lucanas', 'Chaviña', 'ACTIVO'),
(504, '050606', 'Ayacucho', 'Lucanas', 'Chipao', 'ACTIVO'),
(505, '050607', 'Ayacucho', 'Lucanas', 'Huac-Huas', 'ACTIVO'),
(506, '050608', 'Ayacucho', 'Lucanas', 'Laramate', 'ACTIVO'),
(507, '050609', 'Ayacucho', 'Lucanas', 'Leoncio Prado', 'ACTIVO'),
(508, '050610', 'Ayacucho', 'Lucanas', 'Llauta', 'ACTIVO'),
(509, '050611', 'Ayacucho', 'Lucanas', 'Lucanas', 'ACTIVO'),
(510, '050612', 'Ayacucho', 'Lucanas', 'Ocaña', 'ACTIVO'),
(511, '050613', 'Ayacucho', 'Lucanas', 'Otoca', 'ACTIVO'),
(512, '050614', 'Ayacucho', 'Lucanas', 'Saisa', 'ACTIVO'),
(513, '050615', 'Ayacucho', 'Lucanas', 'San Cristóbal', 'ACTIVO'),
(514, '050616', 'Ayacucho', 'Lucanas', 'San Juan', 'ACTIVO'),
(515, '050617', 'Ayacucho', 'Lucanas', 'San Pedro', 'ACTIVO'),
(516, '050618', 'Ayacucho', 'Lucanas', 'San Pedro de Palco', 'ACTIVO'),
(517, '050619', 'Ayacucho', 'Lucanas', 'Sancos', 'ACTIVO'),
(518, '050620', 'Ayacucho', 'Lucanas', 'Santa Ana de Huaycahuacho', 'ACTIVO'),
(519, '050621', 'Ayacucho', 'Lucanas', 'Santa Lucia', 'ACTIVO'),
(520, '050701', 'Ayacucho', 'Parinacochas', 'Coracora', 'ACTIVO'),
(521, '050702', 'Ayacucho', 'Parinacochas', 'Chumpi', 'ACTIVO'),
(522, '050703', 'Ayacucho', 'Parinacochas', 'Coronel Castañeda', 'ACTIVO'),
(523, '050704', 'Ayacucho', 'Parinacochas', 'Pacapausa', 'ACTIVO'),
(524, '050705', 'Ayacucho', 'Parinacochas', 'Pullo', 'ACTIVO'),
(525, '050706', 'Ayacucho', 'Parinacochas', 'Puyusca', 'ACTIVO'),
(526, '050707', 'Ayacucho', 'Parinacochas', 'San Francisco de Rivacayco', 'ACTIVO'),
(527, '050708', 'Ayacucho', 'Parinacochas', 'Upahuacho', 'ACTIVO'),
(528, '050801', 'Ayacucho', 'Páucar del Sara Sara', 'Pausa', 'ACTIVO'),
(529, '050802', 'Ayacucho', 'Páucar del Sara Sara', 'Colta', 'ACTIVO'),
(530, '050803', 'Ayacucho', 'Páucar del Sara Sara', 'Corculla', 'ACTIVO'),
(531, '050804', 'Ayacucho', 'Páucar del Sara Sara', 'Lampa', 'ACTIVO'),
(532, '050805', 'Ayacucho', 'Páucar del Sara Sara', 'Marcabamba', 'ACTIVO'),
(533, '050806', 'Ayacucho', 'Páucar del Sara Sara', 'Oyolo', 'ACTIVO'),
(534, '050807', 'Ayacucho', 'Páucar del Sara Sara', 'Pararca', 'ACTIVO'),
(535, '050808', 'Ayacucho', 'Páucar del Sara Sara', 'San Javier de Alpabamba', 'ACTIVO'),
(536, '050809', 'Ayacucho', 'Páucar del Sara Sara', 'San José de Ushua', 'ACTIVO'),
(537, '050810', 'Ayacucho', 'Páucar del Sara Sara', 'Sara Sara', 'ACTIVO'),
(538, '050901', 'Ayacucho', 'Sucre', 'Querobamba', 'ACTIVO'),
(539, '050902', 'Ayacucho', 'Sucre', 'Belén', 'ACTIVO'),
(540, '050903', 'Ayacucho', 'Sucre', 'Chalcos', 'ACTIVO'),
(541, '050904', 'Ayacucho', 'Sucre', 'Chilcayoc', 'ACTIVO'),
(542, '050905', 'Ayacucho', 'Sucre', 'Huacaña', 'ACTIVO'),
(543, '050906', 'Ayacucho', 'Sucre', 'Morcolla', 'ACTIVO'),
(544, '050907', 'Ayacucho', 'Sucre', 'Paico', 'ACTIVO'),
(545, '050908', 'Ayacucho', 'Sucre', 'San Pedro de Larcay', 'ACTIVO'),
(546, '050909', 'Ayacucho', 'Sucre', 'San Salvador de Quije', 'ACTIVO'),
(547, '050910', 'Ayacucho', 'Sucre', 'Santiago de Paucaray', 'ACTIVO'),
(548, '050911', 'Ayacucho', 'Sucre', 'Soras', 'ACTIVO'),
(549, '051001', 'Ayacucho', 'Víctor Fajardo', 'Huancapi', 'ACTIVO'),
(550, '051002', 'Ayacucho', 'Víctor Fajardo', 'Alcamenca', 'ACTIVO'),
(551, '051003', 'Ayacucho', 'Víctor Fajardo', 'Apongo', 'ACTIVO'),
(552, '051004', 'Ayacucho', 'Víctor Fajardo', 'Asquipata', 'ACTIVO'),
(553, '051005', 'Ayacucho', 'Víctor Fajardo', 'Canaria', 'ACTIVO'),
(554, '051006', 'Ayacucho', 'Víctor Fajardo', 'Cayara', 'ACTIVO'),
(555, '051007', 'Ayacucho', 'Víctor Fajardo', 'Colca', 'ACTIVO'),
(556, '051008', 'Ayacucho', 'Víctor Fajardo', 'Huamanquiquia', 'ACTIVO'),
(557, '051009', 'Ayacucho', 'Víctor Fajardo', 'Huancaraylla', 'ACTIVO'),
(558, '051010', 'Ayacucho', 'Víctor Fajardo', 'Hualla', 'ACTIVO'),
(559, '051011', 'Ayacucho', 'Víctor Fajardo', 'Sarhua', 'ACTIVO'),
(560, '051012', 'Ayacucho', 'Víctor Fajardo', 'Vilcanchos', 'ACTIVO'),
(561, '051101', 'Ayacucho', 'Vilcas Huamán', 'Vilcas Huamán', 'ACTIVO'),
(562, '051102', 'Ayacucho', 'Vilcas Huamán', 'Accomarca', 'ACTIVO'),
(563, '051103', 'Ayacucho', 'Vilcas Huamán', 'Carhuanca', 'ACTIVO'),
(564, '051104', 'Ayacucho', 'Vilcas Huamán', 'Concepción', 'ACTIVO'),
(565, '051105', 'Ayacucho', 'Vilcas Huamán', 'Huambalpa', 'ACTIVO'),
(566, '051106', 'Ayacucho', 'Vilcas Huamán', 'Independencia', 'ACTIVO'),
(567, '051107', 'Ayacucho', 'Vilcas Huamán', 'Saurama', 'ACTIVO'),
(568, '051108', 'Ayacucho', 'Vilcas Huamán', 'Vischongo', 'ACTIVO'),
(569, '060101', 'Cajamarca', 'Cajamarca', 'Cajamarca', 'ACTIVO'),
(570, '060102', 'Cajamarca', 'Cajamarca', 'Asunción', 'ACTIVO'),
(571, '060103', 'Cajamarca', 'Cajamarca', 'Chetilla', 'ACTIVO'),
(572, '060104', 'Cajamarca', 'Cajamarca', 'Cospán', 'ACTIVO'),
(573, '060105', 'Cajamarca', 'Cajamarca', 'Encañada', 'ACTIVO'),
(574, '060106', 'Cajamarca', 'Cajamarca', 'Jesús', 'ACTIVO'),
(575, '060107', 'Cajamarca', 'Cajamarca', 'Llacanora', 'ACTIVO'),
(576, '060108', 'Cajamarca', 'Cajamarca', 'Los Baños del Inca', 'ACTIVO'),
(577, '060109', 'Cajamarca', 'Cajamarca', 'Magdalena', 'ACTIVO'),
(578, '060110', 'Cajamarca', 'Cajamarca', 'Matara', 'ACTIVO'),
(579, '060111', 'Cajamarca', 'Cajamarca', 'Namora', 'ACTIVO'),
(580, '060112', 'Cajamarca', 'Cajamarca', 'San Juan', 'ACTIVO'),
(581, '060201', 'Cajamarca', 'Cajabamba', 'Cajabamba', 'ACTIVO'),
(582, '060202', 'Cajamarca', 'Cajabamba', 'Cachachi', 'ACTIVO'),
(583, '060203', 'Cajamarca', 'Cajabamba', 'Condebamba', 'ACTIVO'),
(584, '060204', 'Cajamarca', 'Cajabamba', 'Sitacocha', 'ACTIVO'),
(585, '060301', 'Cajamarca', 'Celendín', 'Celendín', 'ACTIVO'),
(586, '060302', 'Cajamarca', 'Celendín', 'Chumuch', 'ACTIVO'),
(587, '060303', 'Cajamarca', 'Celendín', 'Cortegana', 'ACTIVO'),
(588, '060304', 'Cajamarca', 'Celendín', 'Huasmín', 'ACTIVO'),
(589, '060305', 'Cajamarca', 'Celendín', 'Jorge Chávez', 'ACTIVO'),
(590, '060306', 'Cajamarca', 'Celendín', 'José Gálvez', 'ACTIVO'),
(591, '060307', 'Cajamarca', 'Celendín', 'Miguel Iglesias', 'ACTIVO'),
(592, '060308', 'Cajamarca', 'Celendín', 'Oxamarca', 'ACTIVO'),
(593, '060309', 'Cajamarca', 'Celendín', 'Sorochuco', 'ACTIVO'),
(594, '060310', 'Cajamarca', 'Celendín', 'Sucre', 'ACTIVO'),
(595, '060311', 'Cajamarca', 'Celendín', 'Utco', 'ACTIVO'),
(596, '060312', 'Cajamarca', 'Celendín', 'La Libertad de Pallán', 'ACTIVO'),
(597, '060401', 'Cajamarca', 'Chota', 'Chota', 'ACTIVO'),
(598, '060402', 'Cajamarca', 'Chota', 'Anguia', 'ACTIVO'),
(599, '060403', 'Cajamarca', 'Chota', 'Chadin', 'ACTIVO'),
(600, '060404', 'Cajamarca', 'Chota', 'Chiguirip', 'ACTIVO'),
(601, '060405', 'Cajamarca', 'Chota', 'Chimbán', 'ACTIVO'),
(602, '060406', 'Cajamarca', 'Chota', 'Choropampa', 'ACTIVO'),
(603, '060407', 'Cajamarca', 'Chota', 'Cochabamba', 'ACTIVO'),
(604, '060408', 'Cajamarca', 'Chota', 'Conchán', 'ACTIVO'),
(605, '060409', 'Cajamarca', 'Chota', 'Huambos', 'ACTIVO'),
(606, '060410', 'Cajamarca', 'Chota', 'Lajas', 'ACTIVO'),
(607, '060411', 'Cajamarca', 'Chota', 'Llama', 'ACTIVO'),
(608, '060412', 'Cajamarca', 'Chota', 'Miracosta', 'ACTIVO'),
(609, '060413', 'Cajamarca', 'Chota', 'Paccha', 'ACTIVO'),
(610, '060414', 'Cajamarca', 'Chota', 'Pion', 'ACTIVO'),
(611, '060415', 'Cajamarca', 'Chota', 'Querocoto', 'ACTIVO'),
(612, '060416', 'Cajamarca', 'Chota', 'San Juan de Licupis', 'ACTIVO'),
(613, '060417', 'Cajamarca', 'Chota', 'Tacabamba', 'ACTIVO'),
(614, '060418', 'Cajamarca', 'Chota', 'Tocmoche', 'ACTIVO'),
(615, '060419', 'Cajamarca', 'Chota', 'Chalamarca', 'ACTIVO'),
(616, '060501', 'Cajamarca', 'Contumazá', 'Contumazá', 'ACTIVO'),
(617, '060502', 'Cajamarca', 'Contumazá', 'Chilete', 'ACTIVO'),
(618, '060503', 'Cajamarca', 'Contumazá', 'Cupisnique', 'ACTIVO'),
(619, '060504', 'Cajamarca', 'Contumazá', 'Guzmango', 'ACTIVO'),
(620, '060505', 'Cajamarca', 'Contumazá', 'San Benito', 'ACTIVO'),
(621, '060506', 'Cajamarca', 'Contumazá', 'Santa Cruz de Toled', 'ACTIVO'),
(622, '060507', 'Cajamarca', 'Contumazá', 'Tantarica', 'ACTIVO'),
(623, '060508', 'Cajamarca', 'Contumazá', 'Yonán', 'ACTIVO'),
(624, '060601', 'Cajamarca', 'Cutervo', 'Cutervo', 'ACTIVO'),
(625, '060602', 'Cajamarca', 'Cutervo', 'Callayuc', 'ACTIVO'),
(626, '060603', 'Cajamarca', 'Cutervo', 'Choros', 'ACTIVO'),
(627, '060604', 'Cajamarca', 'Cutervo', 'Cujillo', 'ACTIVO'),
(628, '060605', 'Cajamarca', 'Cutervo', 'La Ramada', 'ACTIVO'),
(629, '060606', 'Cajamarca', 'Cutervo', 'Pimpingos', 'ACTIVO'),
(630, '060607', 'Cajamarca', 'Cutervo', 'Querocotillo', 'ACTIVO'),
(631, '060608', 'Cajamarca', 'Cutervo', 'San Andrés de Cutervo', 'ACTIVO'),
(632, '060609', 'Cajamarca', 'Cutervo', 'San Juan de Cutervo', 'ACTIVO'),
(633, '060610', 'Cajamarca', 'Cutervo', 'San Luis de Lucma', 'ACTIVO'),
(634, '060611', 'Cajamarca', 'Cutervo', 'Santa Cruz', 'ACTIVO'),
(635, '060612', 'Cajamarca', 'Cutervo', 'Santo Domingo de La Capilla', 'ACTIVO'),
(636, '060613', 'Cajamarca', 'Cutervo', 'Santo Tomás', 'ACTIVO'),
(637, '060614', 'Cajamarca', 'Cutervo', 'Socota', 'ACTIVO'),
(638, '060615', 'Cajamarca', 'Cutervo', 'Toribio Casanova', 'ACTIVO'),
(639, '060701', 'Cajamarca', 'Hualgayoc', 'Bambamarca', 'ACTIVO'),
(640, '060702', 'Cajamarca', 'Hualgayoc', 'Chugur', 'ACTIVO'),
(641, '060703', 'Cajamarca', 'Hualgayoc', 'Hualgayoc', 'ACTIVO'),
(642, '060801', 'Cajamarca', 'Jaén', 'Jaén', 'ACTIVO'),
(643, '060802', 'Cajamarca', 'Jaén', 'Bellavista', 'ACTIVO'),
(644, '060803', 'Cajamarca', 'Jaén', 'Chontali', 'ACTIVO'),
(645, '060804', 'Cajamarca', 'Jaén', 'Colasay', 'ACTIVO'),
(646, '060805', 'Cajamarca', 'Jaén', 'Huabal', 'ACTIVO'),
(647, '060806', 'Cajamarca', 'Jaén', 'Las Pirias', 'ACTIVO'),
(648, '060807', 'Cajamarca', 'Jaén', 'Pomahuaca', 'ACTIVO'),
(649, '060808', 'Cajamarca', 'Jaén', 'Pucará', 'ACTIVO'),
(650, '060809', 'Cajamarca', 'Jaén', 'Sallique', 'ACTIVO'),
(651, '060810', 'Cajamarca', 'Jaén', 'San Felipe', 'ACTIVO'),
(652, '060811', 'Cajamarca', 'Jaén', 'San José del Alto', 'ACTIVO'),
(653, '060812', 'Cajamarca', 'Jaén', 'Santa Rosa', 'ACTIVO'),
(654, '060901', 'Cajamarca', 'San Ignacio', 'San Ignacio', 'ACTIVO'),
(655, '060902', 'Cajamarca', 'San Ignacio', 'Chirinos', 'ACTIVO'),
(656, '060903', 'Cajamarca', 'San Ignacio', 'Huarango', 'ACTIVO'),
(657, '060904', 'Cajamarca', 'San Ignacio', 'La Coipa', 'ACTIVO'),
(658, '060905', 'Cajamarca', 'San Ignacio', 'Namballe', 'ACTIVO'),
(659, '060906', 'Cajamarca', 'San Ignacio', 'San José de Lourdes', 'ACTIVO'),
(660, '060907', 'Cajamarca', 'San Ignacio', 'Tabaconas', 'ACTIVO'),
(661, '061001', 'Cajamarca', 'San Marcos', 'Pedro Gálvez', 'ACTIVO'),
(662, '061002', 'Cajamarca', 'San Marcos', 'Chancay', 'ACTIVO'),
(663, '061003', 'Cajamarca', 'San Marcos', 'Eduardo Villanueva', 'ACTIVO'),
(664, '061004', 'Cajamarca', 'San Marcos', 'Gregorio Pita', 'ACTIVO'),
(665, '061005', 'Cajamarca', 'San Marcos', 'Ichocán', 'ACTIVO'),
(666, '061006', 'Cajamarca', 'San Marcos', 'José Manuel Quiroz', 'ACTIVO'),
(667, '061007', 'Cajamarca', 'San Marcos', 'José Sabogal', 'ACTIVO'),
(668, '061101', 'Cajamarca', 'San Miguel', 'San Miguel', 'ACTIVO'),
(669, '061102', 'Cajamarca', 'San Miguel', 'Bolívar', 'ACTIVO'),
(670, '061103', 'Cajamarca', 'San Miguel', 'Calquis', 'ACTIVO'),
(671, '061104', 'Cajamarca', 'San Miguel', 'Catilluc', 'ACTIVO'),
(672, '061105', 'Cajamarca', 'San Miguel', 'El Prado', 'ACTIVO'),
(673, '061106', 'Cajamarca', 'San Miguel', 'La Florida', 'ACTIVO'),
(674, '061107', 'Cajamarca', 'San Miguel', 'Llapa', 'ACTIVO'),
(675, '061108', 'Cajamarca', 'San Miguel', 'Nanchoc', 'ACTIVO'),
(676, '061109', 'Cajamarca', 'San Miguel', 'Niepos', 'ACTIVO'),
(677, '061110', 'Cajamarca', 'San Miguel', 'San Gregorio', 'ACTIVO'),
(678, '061111', 'Cajamarca', 'San Miguel', 'San Silvestre de Cochán', 'ACTIVO'),
(679, '061112', 'Cajamarca', 'San Miguel', 'Tongod', 'ACTIVO'),
(680, '061113', 'Cajamarca', 'San Miguel', 'Unión Agua Blanca', 'ACTIVO'),
(681, '061201', 'Cajamarca', 'San Pablo', 'San Pablo', 'ACTIVO'),
(682, '061202', 'Cajamarca', 'San Pablo', 'San Bernardino', 'ACTIVO'),
(683, '061203', 'Cajamarca', 'San Pablo', 'San Luis', 'ACTIVO'),
(684, '061204', 'Cajamarca', 'San Pablo', 'Tumbadén', 'ACTIVO'),
(685, '061301', 'Cajamarca', 'Santa Cruz', 'Santa Cruz', 'ACTIVO'),
(686, '061302', 'Cajamarca', 'Santa Cruz', 'Andabamba', 'ACTIVO'),
(687, '061303', 'Cajamarca', 'Santa Cruz', 'Catache', 'ACTIVO'),
(688, '061304', 'Cajamarca', 'Santa Cruz', 'Chancaybaños', 'ACTIVO'),
(689, '061305', 'Cajamarca', 'Santa Cruz', 'La Esperanza', 'ACTIVO'),
(690, '061306', 'Cajamarca', 'Ninabamba', 'Ninabamba', 'ACTIVO'),
(691, '061307', 'Cajamarca', 'Santa Cruz', 'Pulán', 'ACTIVO'),
(692, '061308', 'Cajamarca', 'Santa Cruz', 'Saucepampa', 'ACTIVO'),
(693, '061309', 'Cajamarca', 'Santa Cruz', 'Sexi', 'ACTIVO'),
(694, '061310', 'Cajamarca', 'Santa Cruz', 'Uticyacu', 'ACTIVO'),
(695, '061311', 'Cajamarca', 'Santa Cruz', 'Yauyucán', 'ACTIVO'),
(696, '070101', 'Callao', 'Callao', 'Callao', 'ACTIVO'),
(697, '070102', 'Callao', 'Callao', 'Bellavista', 'ACTIVO'),
(698, '070103', 'Callao', 'Callao', 'Carmen de La Legua Reynoso', 'ACTIVO'),
(699, '070104', 'Callao', 'Callao', 'La Perla', 'ACTIVO'),
(700, '070105', 'Callao', 'Callao', 'La Punta', 'ACTIVO'),
(701, '070106', 'Callao', 'Callao', 'Ventanilla', 'ACTIVO'),
(702, '070107', 'Callao', 'Callao', 'Mi Perú', 'ACTIVO'),
(703, '080101', 'Cusco', 'Cusco', 'Cusco', 'ACTIVO'),
(704, '080102', 'Cusco', 'Cusco', 'Ccorca', 'ACTIVO'),
(705, '080103', 'Cusco', 'Cusco', 'Poroy', 'ACTIVO'),
(706, '080104', 'Cusco', 'Cusco', 'San Jerónimo', 'ACTIVO'),
(707, '080105', 'Cusco', 'Cusco', 'San Sebastián', 'ACTIVO'),
(708, '080106', 'Cusco', 'Cusco', 'Santiago', 'ACTIVO'),
(709, '080107', 'Cusco', 'Cusco', 'Saylla', 'ACTIVO'),
(710, '080108', 'Cusco', 'Cusco', 'Wanchaq', 'ACTIVO'),
(711, '080201', 'Cusco', 'Acomayo', 'Acomayo', 'ACTIVO'),
(712, '080202', 'Cusco', 'Acomayo', 'Acopia', 'ACTIVO'),
(713, '080203', 'Cusco', 'Acomayo', 'Acos', 'ACTIVO'),
(714, '080204', 'Cusco', 'Acomayo', 'Mosoc Llacta', 'ACTIVO'),
(715, '080205', 'Cusco', 'Acomayo', 'Pomacanchi', 'ACTIVO'),
(716, '080206', 'Cusco', 'Acomayo', 'Rondocán', 'ACTIVO'),
(717, '080207', 'Cusco', 'Acomayo', 'Sangarara', 'ACTIVO'),
(718, '080301', 'Cusco', 'Anta', 'Anta', 'ACTIVO'),
(719, '080302', 'Cusco', 'Anta', 'Ancahuasi', 'ACTIVO'),
(720, '080303', 'Cusco', 'Anta', 'Cachimayo', 'ACTIVO'),
(721, '080304', 'Cusco', 'Anta', 'Chinchaypujio', 'ACTIVO'),
(722, '080305', 'Cusco', 'Anta', 'Huarocondo', 'ACTIVO'),
(723, '080306', 'Cusco', 'Anta', 'Limatambo', 'ACTIVO'),
(724, '080307', 'Cusco', 'Anta', 'Mollepata', 'ACTIVO'),
(725, '080308', 'Cusco', 'Anta', 'Pucyura', 'ACTIVO'),
(726, '080309', 'Cusco', 'Anta', 'Zurite', 'ACTIVO'),
(727, '080401', 'Cusco', 'Calca', 'Calca', 'ACTIVO'),
(728, '080402', 'Cusco', 'Calca', 'Coya', 'ACTIVO'),
(729, '080403', 'Cusco', 'Calca', 'Lamay', 'ACTIVO'),
(730, '080404', 'Cusco', 'Calca', 'Lares', 'ACTIVO'),
(731, '080405', 'Cusco', 'Calca', 'Pisac', 'ACTIVO'),
(732, '080406', 'Cusco', 'Calca', 'San Salvador', 'ACTIVO'),
(733, '080407', 'Cusco', 'Calca', 'Taray', 'ACTIVO'),
(734, '080408', 'Cusco', 'Calca', 'Yanatile', 'ACTIVO'),
(735, '080501', 'Cusco', 'Canas', 'Yanaoca', 'ACTIVO'),
(736, '080502', 'Cusco', 'Canas', 'Checca', 'ACTIVO'),
(737, '080503', 'Cusco', 'Canas', 'Kunturkanki', 'ACTIVO'),
(738, '080504', 'Cusco', 'Canas', 'Langui', 'ACTIVO'),
(739, '080505', 'Cusco', 'Canas', 'Layo', 'ACTIVO'),
(740, '080506', 'Cusco', 'Canas', 'Pampamarca', 'ACTIVO'),
(741, '080507', 'Cusco', 'Canas', 'Quehue', 'ACTIVO'),
(742, '080508', 'Cusco', 'Canas', 'Túpac Amaru', 'ACTIVO'),
(743, '080601', 'Cusco', 'Canchis', 'Sicuani', 'ACTIVO'),
(744, '080602', 'Cusco', 'Canchis', 'Checacupe', 'ACTIVO'),
(745, '080603', 'Cusco', 'Canchis', 'Combapata', 'ACTIVO'),
(746, '080604', 'Cusco', 'Canchis', 'Marangani', 'ACTIVO'),
(747, '080605', 'Cusco', 'Canchis', 'Pitumarca', 'ACTIVO'),
(748, '080606', 'Cusco', 'Canchis', 'San Pablo', 'ACTIVO'),
(749, '080607', 'Cusco', 'Canchis', 'San Pedro', 'ACTIVO'),
(750, '080608', 'Cusco', 'Canchis', 'Tinta', 'ACTIVO'),
(751, '080701', 'Cusco', 'Chumbivilcas', 'Santo Tomás', 'ACTIVO'),
(752, '080702', 'Cusco', 'Chumbivilcas', 'Capacmarca', 'ACTIVO'),
(753, '080703', 'Cusco', 'Chumbivilcas', 'Chamaca', 'ACTIVO'),
(754, '080704', 'Cusco', 'Chumbivilcas', 'Colquemarca', 'ACTIVO'),
(755, '080705', 'Cusco', 'Chumbivilcas', 'Livitaca', 'ACTIVO'),
(756, '080706', 'Cusco', 'Chumbivilcas', 'Llusco', 'ACTIVO'),
(757, '080707', 'Cusco', 'Chumbivilcas', 'Quiñota', 'ACTIVO'),
(758, '080708', 'Cusco', 'Chumbivilcas', 'Velille', 'ACTIVO'),
(759, '080801', 'Cusco', 'Espinar', 'Espinar', 'ACTIVO'),
(760, '080802', 'Cusco', 'Espinar', 'Condoroma', 'ACTIVO'),
(761, '080803', 'Cusco', 'Espinar', 'Coporaque', 'ACTIVO'),
(762, '080804', 'Cusco', 'Espinar', 'Ocoruro', 'ACTIVO'),
(763, '080805', 'Cusco', 'Espinar', 'Pallpata', 'ACTIVO'),
(764, '080806', 'Cusco', 'Espinar', 'Pichigua', 'ACTIVO'),
(765, '080807', 'Cusco', 'Espinar', 'Suyckutambo', 'ACTIVO'),
(766, '080808', 'Cusco', 'Espinar', 'Alto Pichigua', 'ACTIVO'),
(767, '080901', 'Cusco', 'La Convención', 'Santa Ana', 'ACTIVO'),
(768, '080902', 'Cusco', 'La Convención', 'Echarate', 'ACTIVO'),
(769, '080903', 'Cusco', 'La Convención', 'Huayopata', 'ACTIVO'),
(770, '080904', 'Cusco', 'La Convención', 'Maranura', 'ACTIVO'),
(771, '080905', 'Cusco', 'La Convención', 'Ocobamba', 'ACTIVO'),
(772, '080906', 'Cusco', 'La Convención', 'Quellouno', 'ACTIVO'),
(773, '080907', 'Cusco', 'La Convención', 'Kimbiri', 'ACTIVO'),
(774, '080908', 'Cusco', 'La Convención', 'Santa Teresa', 'ACTIVO'),
(775, '080909', 'Cusco', 'La Convención', 'Vilcabamba', 'ACTIVO'),
(776, '080910', 'Cusco', 'La Convención', 'Pichari', 'ACTIVO'),
(777, '080911', 'Cusco', 'La Convención', 'Inkawasi', 'ACTIVO'),
(778, '080912', 'Cusco', 'La Convención', 'Villa Virgen', 'ACTIVO'),
(779, '080913', 'Cusco', 'La Convención', 'Villa Kintiarina', 'ACTIVO'),
(780, '080914', 'Cusco', 'La Convención', 'Megantoni', 'ACTIVO'),
(781, '080915', 'Cusco', 'La Convención', 'Kumpirushiato', 'ACTIVO'),
(782, '080916', 'Cusco', 'La Convención', 'Cielo Punco', 'ACTIVO'),
(783, '080917', 'Cusco', 'La Convención', 'Manitea', 'ACTIVO'),
(784, '080918', 'Cusco', 'La Convención', 'Unión Ashaninka', 'ACTIVO'),
(785, '081001', 'Cusco', 'Paruro', 'Paruro', 'ACTIVO'),
(786, '081002', 'Cusco', 'Paruro', 'Accha', 'ACTIVO'),
(787, '081003', 'Cusco', 'Paruro', 'Ccapi', 'ACTIVO'),
(788, '081004', 'Cusco', 'Paruro', 'Colcha', 'ACTIVO'),
(789, '081005', 'Cusco', 'Paruro', 'Huanoquite', 'ACTIVO'),
(790, '081006', 'Cusco', 'Paruro', 'Omacha', 'ACTIVO'),
(791, '081007', 'Cusco', 'Paruro', 'Paccaritambo', 'ACTIVO'),
(792, '081008', 'Cusco', 'Paruro', 'Pillpinto', 'ACTIVO'),
(793, '081009', 'Cusco', 'Paruro', 'Yaurisque', 'ACTIVO'),
(794, '081101', 'Cusco', 'Paucartambo', 'Paucartambo', 'ACTIVO'),
(795, '081102', 'Cusco', 'Paucartambo', 'Caicay', 'ACTIVO'),
(796, '081103', 'Cusco', 'Paucartambo', 'Challabamba', 'ACTIVO'),
(797, '081104', 'Cusco', 'Paucartambo', 'Colquepata', 'ACTIVO'),
(798, '081105', 'Cusco', 'Paucartambo', 'Huancarani', 'ACTIVO'),
(799, '081106', 'Cusco', 'Paucartambo', 'Kosñipata', 'ACTIVO'),
(800, '081201', 'Cusco', 'Quispicanchi', 'Urcos', 'ACTIVO'),
(801, '081202', 'Cusco', 'Quispicanchi', 'Andahuaylillas', 'ACTIVO'),
(802, '081203', 'Cusco', 'Quispicanchi', 'Camanti', 'ACTIVO'),
(803, '081204', 'Cusco', 'Quispicanchi', 'Ccarhuayo', 'ACTIVO'),
(804, '081205', 'Cusco', 'Quispicanchi', 'Ccatca', 'ACTIVO'),
(805, '081206', 'Cusco', 'Quispicanchi', 'Cusipata', 'ACTIVO'),
(806, '081207', 'Cusco', 'Quispicanchi', 'Huaro', 'ACTIVO'),
(807, '081208', 'Cusco', 'Quispicanchi', 'Lucre', 'ACTIVO'),
(808, '081209', 'Cusco', 'Quispicanchi', 'Marcapata', 'ACTIVO'),
(809, '081210', 'Cusco', 'Quispicanchi', 'Ocongate', 'ACTIVO'),
(810, '081211', 'Cusco', 'Quispicanchi', 'Oropesa', 'ACTIVO');
INSERT INTO `ubigeos` (`id_ubigeo`, `codigo_ubigeo`, `departamento`, `provincia`, `distrito`, `estado`) VALUES
(811, '081212', 'Cusco', 'Quispicanchi', 'Quiquijana', 'ACTIVO'),
(812, '081301', 'Cusco', 'Urubamba', 'Urubamba', 'ACTIVO'),
(813, '081302', 'Cusco', 'Urubamba', 'Chinchero', 'ACTIVO'),
(814, '081303', 'Cusco', 'Urubamba', 'Huayllabamba', 'ACTIVO'),
(815, '081304', 'Cusco', 'Urubamba', 'Machupicchu', 'ACTIVO'),
(816, '081305', 'Cusco', 'Urubamba', 'Maras', 'ACTIVO'),
(817, '081306', 'Cusco', 'Urubamba', 'Ollantaytambo', 'ACTIVO'),
(818, '081307', 'Cusco', 'Urubamba', 'Yucay', 'ACTIVO'),
(819, '090101', 'Huancavelica', 'Huancavelica', 'Huancavelica', 'ACTIVO'),
(820, '090102', 'Huancavelica', 'Huancavelica', 'Acobambilla', 'ACTIVO'),
(821, '090103', 'Huancavelica', 'Huancavelica', 'Acoria', 'ACTIVO'),
(822, '090104', 'Huancavelica', 'Huancavelica', 'Conayca', 'ACTIVO'),
(823, '090105', 'Huancavelica', 'Huancavelica', 'Cuenca', 'ACTIVO'),
(824, '090106', 'Huancavelica', 'Huancavelica', 'Huachocolpa', 'ACTIVO'),
(825, '090107', 'Huancavelica', 'Huancavelica', 'Huayllahuara', 'ACTIVO'),
(826, '090108', 'Huancavelica', 'Huancavelica', 'Izcuchaca', 'ACTIVO'),
(827, '090109', 'Huancavelica', 'Huancavelica', 'Laria', 'ACTIVO'),
(828, '090110', 'Huancavelica', 'Huancavelica', 'Manta', 'ACTIVO'),
(829, '090111', 'Huancavelica', 'Huancavelica', 'Mariscal Cáceres', 'ACTIVO'),
(830, '090112', 'Huancavelica', 'Huancavelica', 'Moya', 'ACTIVO'),
(831, '090113', 'Huancavelica', 'Huancavelica', 'Nuevo Occoro', 'ACTIVO'),
(832, '090114', 'Huancavelica', 'Huancavelica', 'Palca', 'ACTIVO'),
(833, '090115', 'Huancavelica', 'Huancavelica', 'Pilchaca', 'ACTIVO'),
(834, '090116', 'Huancavelica', 'Huancavelica', 'Vilca', 'ACTIVO'),
(835, '090117', 'Huancavelica', 'Huancavelica', 'Yauli', 'ACTIVO'),
(836, '090118', 'Huancavelica', 'Huancavelica', 'Ascensión', 'ACTIVO'),
(837, '090119', 'Huancavelica', 'Huancavelica', 'Huando', 'ACTIVO'),
(838, '090201', 'Huancavelica', 'Acobamba', 'Acobamba', 'ACTIVO'),
(839, '090202', 'Huancavelica', 'Acobamba', 'Andabamba', 'ACTIVO'),
(840, '090203', 'Huancavelica', 'Acobamba', 'Anta', 'ACTIVO'),
(841, '090204', 'Huancavelica', 'Acobamba', 'Caja', 'ACTIVO'),
(842, '090205', 'Huancavelica', 'Acobamba', 'Marcas', 'ACTIVO'),
(843, '090206', 'Huancavelica', 'Acobamba', 'Paucara', 'ACTIVO'),
(844, '090207', 'Huancavelica', 'Acobamba', 'Pomacocha', 'ACTIVO'),
(845, '090208', 'Huancavelica', 'Acobamba', 'Rosario', 'ACTIVO'),
(846, '090301', 'Huancavelica', 'Angaraes', 'Lircay', 'ACTIVO'),
(847, '090302', 'Huancavelica', 'Angaraes', 'Anchonga', 'ACTIVO'),
(848, '090303', 'Huancavelica', 'Angaraes', 'Callanmarca', 'ACTIVO'),
(849, '090304', 'Huancavelica', 'Angaraes', 'Ccochaccasa', 'ACTIVO'),
(850, '090305', 'Huancavelica', 'Angaraes', 'Chincho', 'ACTIVO'),
(851, '090306', 'Huancavelica', 'Angaraes', 'Congalla', 'ACTIVO'),
(852, '090307', 'Huancavelica', 'Angaraes', 'Huanca-Huanca', 'ACTIVO'),
(853, '090308', 'Huancavelica', 'Angaraes', 'Huayllay Grande', 'ACTIVO'),
(854, '090309', 'Huancavelica', 'Angaraes', 'Julcamarca', 'ACTIVO'),
(855, '090310', 'Huancavelica', 'Angaraes', 'San Antonio de Antaparco', 'ACTIVO'),
(856, '090311', 'Huancavelica', 'Angaraes', 'Santo Tomás de Pata', 'ACTIVO'),
(857, '090312', 'Huancavelica', 'Angaraes', 'Secclla', 'ACTIVO'),
(858, '090401', 'Huancavelica', 'Castrovirreyna', 'Castrovirreyna', 'ACTIVO'),
(859, '090402', 'Huancavelica', 'Castrovirreyna', 'Arma', 'ACTIVO'),
(860, '090403', 'Huancavelica', 'Castrovirreyna', 'Aurahua', 'ACTIVO'),
(861, '090404', 'Huancavelica', 'Castrovirreyna', 'Capillas', 'ACTIVO'),
(862, '090405', 'Huancavelica', 'Castrovirreyna', 'Chupamarca', 'ACTIVO'),
(863, '090406', 'Huancavelica', 'Castrovirreyna', 'Cocas', 'ACTIVO'),
(864, '090407', 'Huancavelica', 'Castrovirreyna', 'Huachos', 'ACTIVO'),
(865, '090408', 'Huancavelica', 'Castrovirreyna', 'Huamatambo', 'ACTIVO'),
(866, '090409', 'Huancavelica', 'Castrovirreyna', 'Mollepampa', 'ACTIVO'),
(867, '090410', 'Huancavelica', 'Castrovirreyna', 'San Juan', 'ACTIVO'),
(868, '090411', 'Huancavelica', 'Castrovirreyna', 'Santa Ana', 'ACTIVO'),
(869, '090412', 'Huancavelica', 'Castrovirreyna', 'Tantara', 'ACTIVO'),
(870, '090413', 'Huancavelica', 'Castrovirreyna', 'Ticrapo', 'ACTIVO'),
(871, '090501', 'Huancavelica', 'Churcampa', 'Churcampa', 'ACTIVO'),
(872, '090502', 'Huancavelica', 'Churcampa', 'Anco', 'ACTIVO'),
(873, '090503', 'Huancavelica', 'Churcampa', 'Chinchihuasi', 'ACTIVO'),
(874, '090504', 'Huancavelica', 'Churcampa', 'El Carmen', 'ACTIVO'),
(875, '090505', 'Huancavelica', 'Churcampa', 'La Merced', 'ACTIVO'),
(876, '090506', 'Huancavelica', 'Churcampa', 'Locroja', 'ACTIVO'),
(877, '090507', 'Huancavelica', 'Churcampa', 'Paucarbamba', 'ACTIVO'),
(878, '090508', 'Huancavelica', 'Churcampa', 'San Miguel de Mayocc', 'ACTIVO'),
(879, '090509', 'Huancavelica', 'Churcampa', 'San Pedro de Coris', 'ACTIVO'),
(880, '090510', 'Huancavelica', 'Churcampa', 'Pachamarca', 'ACTIVO'),
(881, '090511', 'Huancavelica', 'Churcampa', 'Cosme', 'ACTIVO'),
(882, '090601', 'Huancavelica', 'Huaytará', 'Huaytará', 'ACTIVO'),
(883, '090602', 'Huancavelica', 'Huaytará', 'Ayavi', 'ACTIVO'),
(884, '090603', 'Huancavelica', 'Huaytará', 'Córdova', 'ACTIVO'),
(885, '090604', 'Huancavelica', 'Huaytará', 'Huayacundo Arma', 'ACTIVO'),
(886, '090605', 'Huancavelica', 'Huaytará', 'Laramarca', 'ACTIVO'),
(887, '090606', 'Huancavelica', 'Huaytará', 'Ocoyo', 'ACTIVO'),
(888, '090607', 'Huancavelica', 'Huaytará', 'Pilpichaca', 'ACTIVO'),
(889, '090608', 'Huancavelica', 'Huaytará', 'Querco', 'ACTIVO'),
(890, '090609', 'Huancavelica', 'Huaytará', 'Quito-Arma', 'ACTIVO'),
(891, '090610', 'Huancavelica', 'Huaytará', 'San Antonio de Cusicancha', 'ACTIVO'),
(892, '090611', 'Huancavelica', 'Huaytará', 'San Francisco de Sangayaico', 'ACTIVO'),
(893, '090612', 'Huancavelica', 'Huaytará', 'San Isidro', 'ACTIVO'),
(894, '090613', 'Huancavelica', 'Huaytará', 'Santiago de Chocorvos', 'ACTIVO'),
(895, '090614', 'Huancavelica', 'Huaytará', 'Santiago de Quirahuara', 'ACTIVO'),
(896, '090615', 'Huancavelica', 'Huaytará', 'Santo Domingo de Capillas', 'ACTIVO'),
(897, '090616', 'Huancavelica', 'Huaytará', 'Tambo', 'ACTIVO'),
(898, '090701', 'Huancavelica', 'Tayacaja', 'Pampas', 'ACTIVO'),
(899, '090702', 'Huancavelica', 'Tayacaja', 'Acostambo', 'ACTIVO'),
(900, '090703', 'Huancavelica', 'Tayacaja', 'Acraquia', 'ACTIVO'),
(901, '090704', 'Huancavelica', 'Tayacaja', 'Ahuaycha', 'ACTIVO'),
(902, '090705', 'Huancavelica', 'Tayacaja', 'Colcabamba', 'ACTIVO'),
(903, '090706', 'Huancavelica', 'Tayacaja', 'Daniel Hernández', 'ACTIVO'),
(904, '090707', 'Huancavelica', 'Tayacaja', 'Huachocolpa', 'ACTIVO'),
(905, '090709', 'Huancavelica', 'Tayacaja', 'Huaribamba', 'ACTIVO'),
(906, '090710', 'Huancavelica', 'Tayacaja', 'Ñahuimpuquio', 'ACTIVO'),
(907, '090711', 'Huancavelica', 'Tayacaja', 'Pazos', 'ACTIVO'),
(908, '090713', 'Huancavelica', 'Tayacaja', 'Quishuar', 'ACTIVO'),
(909, '090714', 'Huancavelica', 'Tayacaja', 'Salcabamba', 'ACTIVO'),
(910, '090715', 'Huancavelica', 'Tayacaja', 'Salcahuasi', 'ACTIVO'),
(911, '090716', 'Huancavelica', 'Tayacaja', 'San Marcos de Rocchac', 'ACTIVO'),
(912, '090717', 'Huancavelica', 'Tayacaja', 'Surcubamba', 'ACTIVO'),
(913, '090718', 'Huancavelica', 'Tayacaja', 'Tintay Puncu', 'ACTIVO'),
(914, '090719', 'Huancavelica', 'Tayacaja', 'Quichuas', 'ACTIVO'),
(915, '090720', 'Huancavelica', 'Tayacaja', 'Andaymarca', 'ACTIVO'),
(916, '090721', 'Huancavelica', 'Tayacaja', 'Roble', 'ACTIVO'),
(917, '090722', 'Huancavelica', 'Tayacaja', 'Pichos', 'ACTIVO'),
(918, '090723', 'Huancavelica', 'Tayacaja', 'Santiago de Tucuma', 'ACTIVO'),
(919, '090724', 'Huancavelica', 'Tayacaja', 'Lambras', 'ACTIVO'),
(920, '090725', 'Huancavelica', 'Tayacaja', 'Cochabamba', 'ACTIVO'),
(921, '100101', 'Huánuco', 'Huánuco', 'Huánuco', 'ACTIVO'),
(922, '100102', 'Huánuco', 'Huánuco', 'Amarilis', 'ACTIVO'),
(923, '100103', 'Huánuco', 'Huánuco', 'Chinchao', 'ACTIVO'),
(924, '100104', 'Huánuco', 'Huánuco', 'Churubamba', 'ACTIVO'),
(925, '100105', 'Huánuco', 'Huánuco', 'Margos', 'ACTIVO'),
(926, '100106', 'Huánuco', 'Huánuco', 'Quisqui', 'ACTIVO'),
(927, '100107', 'Huánuco', 'Huánuco', 'San Francisco de Cayrán', 'ACTIVO'),
(928, '100108', 'Huánuco', 'Huánuco', 'San Pedro de Chaulan', 'ACTIVO'),
(929, '100109', 'Huánuco', 'Huánuco', 'Santa María del Valle', 'ACTIVO'),
(930, '100110', 'Huánuco', 'Huánuco', 'Yarumayo', 'ACTIVO'),
(931, '100111', 'Huánuco', 'Huánuco', 'Pillco Marca', 'ACTIVO'),
(932, '100112', 'Huánuco', 'Huánuco', 'Yacus', 'ACTIVO'),
(933, '100113', 'Huánuco', 'Huánuco', 'San Pablo de Pillao', 'ACTIVO'),
(934, '100201', 'Huánuco', 'Ambo', 'Ambo', 'ACTIVO'),
(935, '100202', 'Huánuco', 'Ambo', 'Cayna', 'ACTIVO'),
(936, '100203', 'Huánuco', 'Ambo', 'Colpas', 'ACTIVO'),
(937, '100204', 'Huánuco', 'Ambo', 'Conchamarca', 'ACTIVO'),
(938, '100205', 'Huánuco', 'Ambo', 'Huacar', 'ACTIVO'),
(939, '100206', 'Huánuco', 'Ambo', 'San Francisco', 'ACTIVO'),
(940, '100207', 'Huánuco', 'Ambo', 'San Rafael', 'ACTIVO'),
(941, '100208', 'Huánuco', 'Ambo', 'Tomay Kichwa', 'ACTIVO'),
(942, '100301', 'Huánuco', 'Dos de Mayo', 'La Unión', 'ACTIVO'),
(943, '100307', 'Huánuco', 'Dos de Mayo', 'Chuquis', 'ACTIVO'),
(944, '100311', 'Huánuco', 'Dos de Mayo', 'Marías', 'ACTIVO'),
(945, '100313', 'Huánuco', 'Dos de Mayo', 'Pachas', 'ACTIVO'),
(946, '100316', 'Huánuco', 'Dos de Mayo', 'Quivilla', 'ACTIVO'),
(947, '100317', 'Huánuco', 'Dos de Mayo', 'Ripan', 'ACTIVO'),
(948, '100321', 'Huánuco', 'Dos de Mayo', 'Shunqui', 'ACTIVO'),
(949, '100322', 'Huánuco', 'Dos de Mayo', 'Sillapata', 'ACTIVO'),
(950, '100323', 'Huánuco', 'Dos de Mayo', 'Yanas', 'ACTIVO'),
(951, '100401', 'Huánuco', 'Huacaybamba', 'Huacaybamba', 'ACTIVO'),
(952, '100402', 'Huánuco', 'Huacaybamba', 'Canchabamba', 'ACTIVO'),
(953, '100403', 'Huánuco', 'Huacaybamba', 'Cochabamba', 'ACTIVO'),
(954, '100404', 'Huánuco', 'Huacaybamba', 'Pinra', 'ACTIVO'),
(955, '100501', 'Huánuco', 'Huamalíes', 'Llata', 'ACTIVO'),
(956, '100502', 'Huánuco', 'Huamalíes', 'Arancay', 'ACTIVO'),
(957, '100503', 'Huánuco', 'Huamalíes', 'Chavín de Pariarca', 'ACTIVO'),
(958, '100504', 'Huánuco', 'Huamalíes', 'Jacas Grande', 'ACTIVO'),
(959, '100505', 'Huánuco', 'Huamalíes', 'Jircan', 'ACTIVO'),
(960, '100506', 'Huánuco', 'Huamalíes', 'Miraflores', 'ACTIVO'),
(961, '100507', 'Huánuco', 'Huamalíes', 'Monzón', 'ACTIVO'),
(962, '100508', 'Huánuco', 'Huamalíes', 'Punchao', 'ACTIVO'),
(963, '100509', 'Huánuco', 'Huamalíes', 'Puños', 'ACTIVO'),
(964, '100510', 'Huánuco', 'Huamalíes', 'Singa', 'ACTIVO'),
(965, '100511', 'Huánuco', 'Huamalíes', 'Tantamayo', 'ACTIVO'),
(966, '100601', 'Huánuco', 'Leoncio Prado', 'Rupa-Rupa', 'ACTIVO'),
(967, '100602', 'Huánuco', 'Leoncio Prado', 'Daniel Alomia Robles', 'ACTIVO'),
(968, '100603', 'Huánuco', 'Leoncio Prado', 'Hermilio Valdizán', 'ACTIVO'),
(969, '100604', 'Huánuco', 'Leoncio Prado', 'José Crespo y Castillo', 'ACTIVO'),
(970, '100605', 'Huánuco', 'Leoncio Prado', 'Luyando', 'ACTIVO'),
(971, '100606', 'Huánuco', 'Leoncio Prado', 'Mariano Damaso Beraún', 'ACTIVO'),
(972, '100607', 'Huánuco', 'Leoncio Prado', 'Pucayacu', 'ACTIVO'),
(973, '100608', 'Huánuco', 'Leoncio Prado', 'Castillo Grande', 'ACTIVO'),
(974, '100609', 'Huánuco', 'Leoncio Prado', 'Pueblo Nuevo', 'ACTIVO'),
(975, '100610', 'Huánuco', 'Leoncio Prado', 'Santo Domingo de Anda', 'ACTIVO'),
(976, '100701', 'Huánuco', 'Marañón', 'Huacrachuco', 'ACTIVO'),
(977, '100702', 'Huánuco', 'Marañón', 'Cholón', 'ACTIVO'),
(978, '100703', 'Huánuco', 'Marañón', 'San Buenaventura', 'ACTIVO'),
(979, '100704', 'Huánuco', 'Marañón', 'La Morada', 'ACTIVO'),
(980, '100705', 'Huánuco', 'Marañón', 'Santa Rosa de Alto Yanajanca', 'ACTIVO'),
(981, '100801', 'Huánuco', 'Pachitea', 'Panao', 'ACTIVO'),
(982, '100802', 'Huánuco', 'Pachitea', 'Chaglla', 'ACTIVO'),
(983, '100803', 'Huánuco', 'Pachitea', 'Molino', 'ACTIVO'),
(984, '100804', 'Huánuco', 'Pachitea', 'Umari', 'ACTIVO'),
(985, '100901', 'Huánuco', 'Puerto Inca', 'Puerto Inca', 'ACTIVO'),
(986, '100902', 'Huánuco', 'Puerto Inca', 'Codo del Pozuzo', 'ACTIVO'),
(987, '100903', 'Huánuco', 'Puerto Inca', 'Honoria', 'ACTIVO'),
(988, '100904', 'Huánuco', 'Puerto Inca', 'Tournavista', 'ACTIVO'),
(989, '100905', 'Huánuco', 'Puerto Inca', 'Yuyapichis', 'ACTIVO'),
(990, '101001', 'Huánuco', 'Lauricocha', 'Jesús', 'ACTIVO'),
(991, '101002', 'Huánuco', 'Lauricocha', 'Baños', 'ACTIVO'),
(992, '101003', 'Huánuco', 'Lauricocha', 'Jivia', 'ACTIVO'),
(993, '101004', 'Huánuco', 'Lauricocha', 'Queropalca', 'ACTIVO'),
(994, '101005', 'Huánuco', 'Lauricocha', 'Rondos', 'ACTIVO'),
(995, '101006', 'Huánuco', 'Lauricocha', 'San Francisco de Asis', 'ACTIVO'),
(996, '101007', 'Huánuco', 'Lauricocha', 'San Miguel de Cauri', 'ACTIVO'),
(997, '101101', 'Huánuco', 'Yarowilca', 'Chavinillo', 'ACTIVO'),
(998, '101102', 'Huánuco', 'Yarowilca', 'Cahuac', 'ACTIVO'),
(999, '101103', 'Huánuco', 'Yarowilca', 'Chacabamba', 'ACTIVO'),
(1000, '101104', 'Huánuco', 'Yarowilca', 'Aparicio Pomares', 'ACTIVO'),
(1001, '101105', 'Huánuco', 'Yarowilca', 'Jacas Chico', 'ACTIVO'),
(1002, '101106', 'Huánuco', 'Yarowilca', 'Obas', 'ACTIVO'),
(1003, '101107', 'Huánuco', 'Yarowilca', 'Pampamarca', 'ACTIVO'),
(1004, '101108', 'Huánuco', 'Yarowilca', 'Choras', 'ACTIVO'),
(1005, '110101', 'Ica', 'Ica', 'Ica', 'ACTIVO'),
(1006, '110102', 'Ica', 'Ica', 'La Tinguiña', 'ACTIVO'),
(1007, '110103', 'Ica', 'Ica', 'Los Aquijes', 'ACTIVO'),
(1008, '110104', 'Ica', 'Ica', 'Ocucaje', 'ACTIVO'),
(1009, '110105', 'Ica', 'Ica', 'Pachacútec', 'ACTIVO'),
(1010, '110106', 'Ica', 'Ica', 'Parcona', 'ACTIVO'),
(1011, '110107', 'Ica', 'Ica', 'Pueblo Nuevo', 'ACTIVO'),
(1012, '110108', 'Ica', 'Ica', 'Salas', 'ACTIVO'),
(1013, '110109', 'Ica', 'Ica', 'San José de Los Molinos', 'ACTIVO'),
(1014, '110110', 'Ica', 'Ica', 'San Juan Bautista', 'ACTIVO'),
(1015, '110111', 'Ica', 'Ica', 'Santiago', 'ACTIVO'),
(1016, '110112', 'Ica', 'Ica', 'Subtanjalla', 'ACTIVO'),
(1017, '110113', 'Ica', 'Ica', 'Tate', 'ACTIVO'),
(1018, '110114', 'Ica', 'Ica', 'Yauca Del Rosario', 'ACTIVO'),
(1019, '110201', 'Ica', 'Chincha', 'Chincha Alta', 'ACTIVO'),
(1020, '110202', 'Ica', 'Chincha', 'Alto Laran', 'ACTIVO'),
(1021, '110203', 'Ica', 'Chincha', 'Chavín', 'ACTIVO'),
(1022, '110204', 'Ica', 'Chincha', 'Chincha Baja', 'ACTIVO'),
(1023, '110205', 'Ica', 'Chincha', 'El Carmen', 'ACTIVO'),
(1024, '110206', 'Ica', 'Chincha', 'Grocio Prado', 'ACTIVO'),
(1025, '110207', 'Ica', 'Chincha', 'Pueblo Nuevo', 'ACTIVO'),
(1026, '110208', 'Ica', 'Chincha', 'San Juan de Yánac', 'ACTIVO'),
(1027, '110209', 'Ica', 'Chincha', 'San Pedro de Huacarpana', 'ACTIVO'),
(1028, '110210', 'Ica', 'Chincha', 'Sunampe', 'ACTIVO'),
(1029, '110211', 'Ica', 'Chincha', 'Tambo de Mora', 'ACTIVO'),
(1030, '110301', 'Ica', 'Nasca', 'Nasca', 'ACTIVO'),
(1031, '110302', 'Ica', 'Nasca', 'Changuillo', 'ACTIVO'),
(1032, '110303', 'Ica', 'Nasca', 'El Ingenio', 'ACTIVO'),
(1033, '110304', 'Ica', 'Nasca', 'Marcona', 'ACTIVO'),
(1034, '110305', 'Ica', 'Nasca', 'Vista Alegre', 'ACTIVO'),
(1035, '110401', 'Ica', 'Palpa', 'Palpa', 'ACTIVO'),
(1036, '110402', 'Ica', 'Palpa', 'Llipata', 'ACTIVO'),
(1037, '110403', 'Ica', 'Palpa', 'Río Grande', 'ACTIVO'),
(1038, '110404', 'Ica', 'Palpa', 'Santa Cruz', 'ACTIVO'),
(1039, '110405', 'Ica', 'Palpa', 'Tibillo', 'ACTIVO'),
(1040, '110501', 'Ica', 'Pisco', 'Pisco', 'ACTIVO'),
(1041, '110502', 'Ica', 'Pisco', 'Huancano', 'ACTIVO'),
(1042, '110503', 'Ica', 'Pisco', 'Humay', 'ACTIVO'),
(1043, '110504', 'Ica', 'Pisco', 'Independencia', 'ACTIVO'),
(1044, '110505', 'Ica', 'Pisco', 'Paracas', 'ACTIVO'),
(1045, '110506', 'Ica', 'Pisco', 'San Andrés', 'ACTIVO'),
(1046, '110507', 'Ica', 'Pisco', 'San Clemente', 'ACTIVO'),
(1047, '110508', 'Ica', 'Pisco', 'Túpac Amaru Inca', 'ACTIVO'),
(1048, '120101', 'Junín', 'Huancayo', 'Huancayo', 'ACTIVO'),
(1049, '120104', 'Junín', 'Huancayo', 'Carhuacallanga', 'ACTIVO'),
(1050, '120105', 'Junín', 'Huancayo', 'Chacapampa', 'ACTIVO'),
(1051, '120106', 'Junín', 'Huancayo', 'Chicche', 'ACTIVO'),
(1052, '120107', 'Junín', 'Huancayo', 'Chilca', 'ACTIVO'),
(1053, '120108', 'Junín', 'Huancayo', 'Chongos Alto', 'ACTIVO'),
(1054, '120111', 'Junín', 'Huancayo', 'Chupuro', 'ACTIVO'),
(1055, '120112', 'Junín', 'Huancayo', 'Colca', 'ACTIVO'),
(1056, '120113', 'Junín', 'Huancayo', 'Cullhuas', 'ACTIVO'),
(1057, '120114', 'Junín', 'Huancayo', 'El Tambo', 'ACTIVO'),
(1058, '120116', 'Junín', 'Huancayo', 'Huacrapuquio', 'ACTIVO'),
(1059, '120117', 'Junín', 'Huancayo', 'Hualhuas', 'ACTIVO'),
(1060, '120119', 'Junín', 'Huancayo', 'Huancán', 'ACTIVO'),
(1061, '120120', 'Junín', 'Huancayo', 'Huasicancha', 'ACTIVO'),
(1062, '120121', 'Junín', 'Huancayo', 'Huayucachi', 'ACTIVO'),
(1063, '120122', 'Junín', 'Huancayo', 'Ingenio', 'ACTIVO'),
(1064, '120124', 'Junín', 'Huancayo', 'Pariahuanca', 'ACTIVO'),
(1065, '120125', 'Junín', 'Huancayo', 'Pilcomayo', 'ACTIVO'),
(1066, '120126', 'Junín', 'Huancayo', 'Pucará', 'ACTIVO'),
(1067, '120127', 'Junín', 'Huancayo', 'Quichuay', 'ACTIVO'),
(1068, '120128', 'Junín', 'Huancayo', 'Quilcas', 'ACTIVO'),
(1069, '120129', 'Junín', 'Huancayo', 'San Agustín', 'ACTIVO'),
(1070, '120130', 'Junín', 'Huancayo', 'San Jerónimo de Tunán', 'ACTIVO'),
(1071, '120132', 'Junín', 'Huancayo', 'Saño', 'ACTIVO'),
(1072, '120133', 'Junín', 'Huancayo', 'Sapallanga', 'ACTIVO'),
(1073, '120134', 'Junín', 'Huancayo', 'Sicaya', 'ACTIVO'),
(1074, '120135', 'Junín', 'Huancayo', 'Santo Domingo de Acobamba', 'ACTIVO'),
(1075, '120136', 'Junín', 'Huancayo', 'Viques', 'ACTIVO'),
(1076, '120201', 'Junín', 'Concepción', 'Concepción', 'ACTIVO'),
(1077, '120202', 'Junín', 'Concepción', 'Aco', 'ACTIVO'),
(1078, '120203', 'Junín', 'Concepción', 'Andamarca', 'ACTIVO'),
(1079, '120204', 'Junín', 'Concepción', 'Chambará', 'ACTIVO'),
(1080, '120205', 'Junín', 'Concepción', 'Cochas', 'ACTIVO'),
(1081, '120206', 'Junín', 'Concepción', 'Comas', 'ACTIVO'),
(1082, '120207', 'Junín', 'Concepción', 'Heroínas Toledo', 'ACTIVO'),
(1083, '120208', 'Junín', 'Concepción', 'Manzanares', 'ACTIVO'),
(1084, '120209', 'Junín', 'Concepción', 'Mariscal Castilla', 'ACTIVO'),
(1085, '120210', 'Junín', 'Concepción', 'Matahuasi', 'ACTIVO'),
(1086, '120211', 'Junín', 'Concepción', 'Mito', 'ACTIVO'),
(1087, '120212', 'Junín', 'Concepción', 'Nueve de Julio', 'ACTIVO'),
(1088, '120213', 'Junín', 'Concepción', 'Orcotuna', 'ACTIVO'),
(1089, '120214', 'Junín', 'Concepción', 'San José de Quero', 'ACTIVO'),
(1090, '120215', 'Junín', 'Concepción', 'Santa Rosa de Ocopa', 'ACTIVO'),
(1091, '120301', 'Junín', 'Chanchamayo', 'Chanchamayo', 'ACTIVO'),
(1092, '120302', 'Junín', 'Chanchamayo', 'Perené', 'ACTIVO'),
(1093, '120303', 'Junín', 'Chanchamayo', 'Pichanaqui', 'ACTIVO'),
(1094, '120304', 'Junín', 'Chanchamayo', 'San Luis de Shuaro', 'ACTIVO'),
(1095, '120305', 'Junín', 'Chanchamayo', 'San Ramón', 'ACTIVO'),
(1096, '120306', 'Junín', 'Chanchamayo', 'Vitoc', 'ACTIVO'),
(1097, '120401', 'Junín', 'Jauja', 'Jauja', 'ACTIVO'),
(1098, '120402', 'Junín', 'Jauja', 'Acolla', 'ACTIVO'),
(1099, '120403', 'Junín', 'Jauja', 'Apata', 'ACTIVO'),
(1100, '120404', 'Junín', 'Jauja', 'Ataura', 'ACTIVO'),
(1101, '120405', 'Junín', 'Jauja', 'Canchayllo', 'ACTIVO'),
(1102, '120406', 'Junín', 'Jauja', 'Curicaca', 'ACTIVO'),
(1103, '120407', 'Junín', 'Jauja', 'El Mantaro', 'ACTIVO'),
(1104, '120408', 'Junín', 'Jauja', 'Huamalí', 'ACTIVO'),
(1105, '120409', 'Junín', 'Jauja', 'Huaripampa', 'ACTIVO'),
(1106, '120410', 'Junín', 'Jauja', 'Huertas', 'ACTIVO'),
(1107, '120411', 'Junín', 'Jauja', 'Janjaillo', 'ACTIVO'),
(1108, '120412', 'Junín', 'Jauja', 'Julcán', 'ACTIVO'),
(1109, '120413', 'Junín', 'Jauja', 'Leonor Ordóñez', 'ACTIVO'),
(1110, '120414', 'Junín', 'Jauja', 'Llocllapampa', 'ACTIVO'),
(1111, '120415', 'Junín', 'Jauja', 'Marco', 'ACTIVO'),
(1112, '120416', 'Junín', 'Jauja', 'Masma', 'ACTIVO'),
(1113, '120417', 'Junín', 'Jauja', 'Masma Chicche', 'ACTIVO'),
(1114, '120418', 'Junín', 'Jauja', 'Molinos', 'ACTIVO'),
(1115, '120419', 'Junín', 'Jauja', 'Monobamba', 'ACTIVO'),
(1116, '120420', 'Junín', 'Jauja', 'Muqui', 'ACTIVO'),
(1117, '120421', 'Junín', 'Jauja', 'Muquiyauyo', 'ACTIVO'),
(1118, '120422', 'Junín', 'Jauja', 'Paca', 'ACTIVO'),
(1119, '120423', 'Junín', 'Jauja', 'Paccha', 'ACTIVO'),
(1120, '120424', 'Junín', 'Jauja', 'Pancán', 'ACTIVO'),
(1121, '120425', 'Junín', 'Jauja', 'Parco', 'ACTIVO'),
(1122, '120426', 'Junín', 'Jauja', 'Pomacancha', 'ACTIVO'),
(1123, '120427', 'Junín', 'Jauja', 'Ricrán', 'ACTIVO'),
(1124, '120428', 'Junín', 'Jauja', 'San Lorenzo', 'ACTIVO'),
(1125, '120429', 'Junín', 'Jauja', 'San Pedro de Chunán', 'ACTIVO'),
(1126, '120430', 'Junín', 'Jauja', 'Sausa', 'ACTIVO'),
(1127, '120431', 'Junín', 'Jauja', 'Sincos', 'ACTIVO'),
(1128, '120432', 'Junín', 'Jauja', 'Tunan Marca', 'ACTIVO'),
(1129, '120433', 'Junín', 'Jauja', 'Yauli', 'ACTIVO'),
(1130, '120434', 'Junín', 'Jauja', 'Yauyos', 'ACTIVO'),
(1131, '120501', 'Junín', 'Junín', 'Junín', 'ACTIVO'),
(1132, '120502', 'Junín', 'Junín', 'Carhuamayo', 'ACTIVO'),
(1133, '120503', 'Junín', 'Junín', 'Ondores', 'ACTIVO'),
(1134, '120504', 'Junín', 'Junín', 'Ulcumayo', 'ACTIVO'),
(1135, '120601', 'Junín', 'Satipo', 'Satipo', 'ACTIVO'),
(1136, '120602', 'Junín', 'Satipo', 'Coviriali', 'ACTIVO'),
(1137, '120603', 'Junín', 'Satipo', 'Llaylla', 'ACTIVO'),
(1138, '120604', 'Junín', 'Satipo', 'Mazamari', 'ACTIVO'),
(1139, '120605', 'Junín', 'Satipo', 'Pampa Hermosa', 'ACTIVO'),
(1140, '120606', 'Junín', 'Satipo', 'Pangoa', 'ACTIVO'),
(1141, '120607', 'Junín', 'Satipo', 'Río Negro', 'ACTIVO'),
(1142, '120608', 'Junín', 'Satipo', 'Río Tambo', 'ACTIVO'),
(1143, '120609', 'Junín', 'Satipo', 'Vizcatán del Ene', 'ACTIVO'),
(1144, '120701', 'Junín', 'Tarma', 'Tarma', 'ACTIVO'),
(1145, '120702', 'Junín', 'Tarma', 'Acobamba', 'ACTIVO'),
(1146, '120703', 'Junín', 'Tarma', 'Huaricolca', 'ACTIVO'),
(1147, '120704', 'Junín', 'Tarma', 'Huasahuasi', 'ACTIVO'),
(1148, '120705', 'Junín', 'Tarma', 'La Unión', 'ACTIVO'),
(1149, '120706', 'Junín', 'Tarma', 'Palca', 'ACTIVO'),
(1150, '120707', 'Junín', 'Tarma', 'Palcamayo', 'ACTIVO'),
(1151, '120708', 'Junín', 'Tarma', 'San Pedro de Cajas', 'ACTIVO'),
(1152, '120709', 'Junín', 'Tarma', 'Tapo', 'ACTIVO'),
(1153, '120801', 'Junín', 'Yauli', 'La Oroya', 'ACTIVO'),
(1154, '120802', 'Junín', 'Yauli', 'Chacapalpa', 'ACTIVO'),
(1155, '120803', 'Junín', 'Yauli', 'Huay-Huay', 'ACTIVO'),
(1156, '120804', 'Junín', 'Yauli', 'Marcapomacocha', 'ACTIVO'),
(1157, '120805', 'Junín', 'Yauli', 'Morococha', 'ACTIVO'),
(1158, '120806', 'Junín', 'Yauli', 'Paccha', 'ACTIVO'),
(1159, '120807', 'Junín', 'Yauli', 'Santa Bárbara de Carhuacayán', 'ACTIVO'),
(1160, '120808', 'Junín', 'Yauli', 'Santa Rosa de Sacco', 'ACTIVO'),
(1161, '120809', 'Junín', 'Yauli', 'Suitucancha', 'ACTIVO'),
(1162, '120810', 'Junín', 'Yauli', 'Yauli', 'ACTIVO'),
(1163, '120901', 'Junín', 'Chupaca', 'Chupaca', 'ACTIVO'),
(1164, '120902', 'Junín', 'Chupaca', 'Ahuac', 'ACTIVO'),
(1165, '120903', 'Junín', 'Chupaca', 'Chongos Bajo', 'ACTIVO'),
(1166, '120904', 'Junín', 'Chupaca', 'Huáchac', 'ACTIVO'),
(1167, '120905', 'Junín', 'Chupaca', 'Huamancaca Chico', 'ACTIVO'),
(1168, '120906', 'Junín', 'Chupaca', 'San Juan de Iscos', 'ACTIVO'),
(1169, '120907', 'Junín', 'Chupaca', 'San Juan de Jarpa', 'ACTIVO'),
(1170, '120908', 'Junín', 'Chupaca', 'Tres de Diciembre', 'ACTIVO'),
(1171, '120909', 'Junín', 'Chupaca', 'Yanacancha', 'ACTIVO'),
(1172, '130101', 'La Libertad', 'Trujillo', 'Trujillo', 'ACTIVO'),
(1173, '130102', 'La Libertad', 'Trujillo', 'El Porvenir', 'ACTIVO'),
(1174, '130103', 'La Libertad', 'Trujillo', 'Florencia de Mora', 'ACTIVO'),
(1175, '130104', 'La Libertad', 'Trujillo', 'Huanchaco', 'ACTIVO'),
(1176, '130105', 'La Libertad', 'Trujillo', 'La Esperanza', 'ACTIVO'),
(1177, '130106', 'La Libertad', 'Trujillo', 'Laredo', 'ACTIVO'),
(1178, '130107', 'La Libertad', 'Trujillo', 'Moche', 'ACTIVO'),
(1179, '130108', 'La Libertad', 'Trujillo', 'Poroto', 'ACTIVO'),
(1180, '130109', 'La Libertad', 'Trujillo', 'Salaverry', 'ACTIVO'),
(1181, '130110', 'La Libertad', 'Trujillo', 'Simbal', 'ACTIVO'),
(1182, '130111', 'La Libertad', 'Trujillo', 'Victor Larco Herrera', 'ACTIVO'),
(1183, '130112', 'La Libertad', 'Trujillo', 'Alto Trujillo', 'ACTIVO'),
(1184, '130201', 'La Libertad', 'Ascope', 'Ascope', 'ACTIVO'),
(1185, '130202', 'La Libertad', 'Ascope', 'Chicama', 'ACTIVO'),
(1186, '130203', 'La Libertad', 'Ascope', 'Chocope', 'ACTIVO'),
(1187, '130204', 'La Libertad', 'Ascope', 'Magdalena de Cao', 'ACTIVO'),
(1188, '130205', 'La Libertad', 'Ascope', 'Paiján', 'ACTIVO'),
(1189, '130206', 'La Libertad', 'Ascope', 'Rázuri', 'ACTIVO'),
(1190, '130207', 'La Libertad', 'Ascope', 'Santiago de Cao', 'ACTIVO'),
(1191, '130208', 'La Libertad', 'Ascope', 'Casa Grande', 'ACTIVO'),
(1192, '130301', 'La Libertad', 'Bolívar', 'Bolívar', 'ACTIVO'),
(1193, '130302', 'La Libertad', 'Bolívar', 'Bambamarca', 'ACTIVO'),
(1194, '130303', 'La Libertad', 'Bolívar', 'Condormarca', 'ACTIVO'),
(1195, '130304', 'La Libertad', 'Bolívar', 'Longotea', 'ACTIVO'),
(1196, '130305', 'La Libertad', 'Bolívar', 'Uchumarca', 'ACTIVO'),
(1197, '130306', 'La Libertad', 'Bolívar', 'Ucuncha', 'ACTIVO'),
(1198, '130401', 'La Libertad', 'Chepén', 'Chepén', 'ACTIVO'),
(1199, '130402', 'La Libertad', 'Chepén', 'Pacanga', 'ACTIVO'),
(1200, '130403', 'La Libertad', 'Chepén', 'Pueblo Nuevo', 'ACTIVO'),
(1201, '130501', 'La Libertad', 'Julcán', 'Julcán', 'ACTIVO'),
(1202, '130502', 'La Libertad', 'Julcán', 'Calamarca', 'ACTIVO'),
(1203, '130503', 'La Libertad', 'Julcán', 'Carabamba', 'ACTIVO'),
(1204, '130504', 'La Libertad', 'Julcán', 'Huaso', 'ACTIVO'),
(1205, '130601', 'La Libertad', 'Otuzco', 'Otuzco', 'ACTIVO'),
(1206, '130602', 'La Libertad', 'Otuzco', 'Agallpampa', 'ACTIVO'),
(1207, '130604', 'La Libertad', 'Otuzco', 'Charat', 'ACTIVO'),
(1208, '130605', 'La Libertad', 'Otuzco', 'Huaranchal', 'ACTIVO'),
(1209, '130606', 'La Libertad', 'Otuzco', 'La Cuesta', 'ACTIVO'),
(1210, '130608', 'La Libertad', 'Otuzco', 'Mache', 'ACTIVO'),
(1211, '130610', 'La Libertad', 'Otuzco', 'Paranday', 'ACTIVO'),
(1212, '130611', 'La Libertad', 'Otuzco', 'Salpo', 'ACTIVO'),
(1213, '130613', 'La Libertad', 'Otuzco', 'Sinsicap', 'ACTIVO'),
(1214, '130614', 'La Libertad', 'Otuzco', 'Usquil', 'ACTIVO'),
(1215, '130701', 'La Libertad', 'Pacasmayo', 'San Pedro de Lloc', 'ACTIVO'),
(1216, '130702', 'La Libertad', 'Pacasmayo', 'Guadalupe', 'ACTIVO'),
(1217, '130703', 'La Libertad', 'Pacasmayo', 'Jequetepeque', 'ACTIVO'),
(1218, '130704', 'La Libertad', 'Pacasmayo', 'Pacasmayo', 'ACTIVO'),
(1219, '130705', 'La Libertad', 'Pacasmayo', 'San José', 'ACTIVO'),
(1220, '130801', 'La Libertad', 'Pataz', 'Tayabamba', 'ACTIVO'),
(1221, '130802', 'La Libertad', 'Pataz', 'Buldibuyo', 'ACTIVO'),
(1222, '130803', 'La Libertad', 'Pataz', 'Chillia', 'ACTIVO'),
(1223, '130804', 'La Libertad', 'Pataz', 'Huancaspata', 'ACTIVO'),
(1224, '130805', 'La Libertad', 'Pataz', 'Huaylillas', 'ACTIVO'),
(1225, '130806', 'La Libertad', 'Pataz', 'Huayo', 'ACTIVO'),
(1226, '130807', 'La Libertad', 'Pataz', 'Ongon', 'ACTIVO'),
(1227, '130808', 'La Libertad', 'Pataz', 'Parcoy', 'ACTIVO'),
(1228, '130809', 'La Libertad', 'Pataz', 'Pataz', 'ACTIVO'),
(1229, '130810', 'La Libertad', 'Pataz', 'Pias', 'ACTIVO'),
(1230, '130811', 'La Libertad', 'Pataz', 'Santiago de Challas', 'ACTIVO'),
(1231, '130812', 'La Libertad', 'Pataz', 'Taurija', 'ACTIVO'),
(1232, '130813', 'La Libertad', 'Pataz', 'Urpay', 'ACTIVO'),
(1233, '130901', 'La Libertad', 'Sánchez Carrión', 'Huamachuco', 'ACTIVO'),
(1234, '130902', 'La Libertad', 'Sánchez Carrión', 'Chugay', 'ACTIVO'),
(1235, '130903', 'La Libertad', 'Sánchez Carrión', 'Cochorco', 'ACTIVO'),
(1236, '130904', 'La Libertad', 'Sánchez Carrión', 'Curgos', 'ACTIVO'),
(1237, '130905', 'La Libertad', 'Sánchez Carrión', 'Marcabal', 'ACTIVO'),
(1238, '130906', 'La Libertad', 'Sánchez Carrión', 'Sanagoran', 'ACTIVO'),
(1239, '130907', 'La Libertad', 'Sánchez Carrión', 'Sarín', 'ACTIVO'),
(1240, '130908', 'La Libertad', 'Sánchez Carrión', 'Sartimbamba', 'ACTIVO'),
(1241, '131001', 'La Libertad', 'Santiago de Chuco', 'Santiago de Chuco', 'ACTIVO'),
(1242, '131002', 'La Libertad', 'Santiago de Chuco', 'Angasmarca', 'ACTIVO'),
(1243, '131003', 'La Libertad', 'Santiago de Chuco', 'Cachicadan', 'ACTIVO'),
(1244, '131004', 'La Libertad', 'Santiago de Chuco', 'Mollebamba', 'ACTIVO'),
(1245, '131005', 'La Libertad', 'Santiago de Chuco', 'Mollepata', 'ACTIVO'),
(1246, '131006', 'La Libertad', 'Santiago de Chuco', 'Quiruvilca', 'ACTIVO'),
(1247, '131007', 'La Libertad', 'Santiago de Chuco', 'Santa Cruz de Chuca', 'ACTIVO'),
(1248, '131008', 'La Libertad', 'Santiago de Chuco', 'Sitabamba', 'ACTIVO'),
(1249, '131101', 'La Libertad', 'Gran Chimú', 'Cascas', 'ACTIVO'),
(1250, '131102', 'La Libertad', 'Gran Chimú', 'Lucma', 'ACTIVO'),
(1251, '131103', 'La Libertad', 'Gran Chimú', 'Marmot', 'ACTIVO'),
(1252, '131104', 'La Libertad', 'Gran Chimú', 'Sayapullo', 'ACTIVO'),
(1253, '131201', 'La Libertad', 'Virú', 'Virú', 'ACTIVO'),
(1254, '131202', 'La Libertad', 'Virú', 'Chao', 'ACTIVO'),
(1255, '131203', 'La Libertad', 'Virú', 'Guadalupito', 'ACTIVO'),
(1256, '140101', 'Lambayeque', 'Chiclayo', 'Chiclayo', 'ACTIVO'),
(1257, '140102', 'Lambayeque', 'Chiclayo', 'Chongoyape', 'ACTIVO'),
(1258, '140103', 'Lambayeque', 'Chiclayo', 'Etén', 'ACTIVO'),
(1259, '140104', 'Lambayeque', 'Chiclayo', 'Etén Puerto', 'ACTIVO'),
(1260, '140105', 'Lambayeque', 'Chiclayo', 'José Leonardo Ortiz', 'ACTIVO'),
(1261, '140106', 'Lambayeque', 'Chiclayo', 'La Victoria', 'ACTIVO'),
(1262, '140107', 'Lambayeque', 'Chiclayo', 'Lagunas', 'ACTIVO'),
(1263, '140108', 'Lambayeque', 'Chiclayo', 'Monsefú', 'ACTIVO'),
(1264, '140109', 'Lambayeque', 'Chiclayo', 'Nueva Arica', 'ACTIVO'),
(1265, '140110', 'Lambayeque', 'Chiclayo', 'Oyotun', 'ACTIVO'),
(1266, '140111', 'Lambayeque', 'Chiclayo', 'Picsi', 'ACTIVO'),
(1267, '140112', 'Lambayeque', 'Chiclayo', 'Pimentel', 'ACTIVO'),
(1268, '140113', 'Lambayeque', 'Chiclayo', 'Reque', 'ACTIVO'),
(1269, '140114', 'Lambayeque', 'Chiclayo', 'Santa Rosa', 'ACTIVO'),
(1270, '140115', 'Lambayeque', 'Chiclayo', 'Saña', 'ACTIVO'),
(1271, '140116', 'Lambayeque', 'Chiclayo', 'Cayaltí', 'ACTIVO'),
(1272, '140117', 'Lambayeque', 'Chiclayo', 'Patapo', 'ACTIVO'),
(1273, '140118', 'Lambayeque', 'Chiclayo', 'Pomalca', 'ACTIVO'),
(1274, '140119', 'Lambayeque', 'Chiclayo', 'Pucala', 'ACTIVO'),
(1275, '140120', 'Lambayeque', 'Chiclayo', 'Tumán', 'ACTIVO'),
(1276, '140201', 'Lambayeque', 'Ferreñafe', 'Ferreñafe', 'ACTIVO'),
(1277, '140202', 'Lambayeque', 'Ferreñafe', 'Cañaris', 'ACTIVO'),
(1278, '140203', 'Lambayeque', 'Ferreñafe', 'Incahuasi', 'ACTIVO'),
(1279, '140204', 'Lambayeque', 'Ferreñafe', 'Manuel Antonio Mesones Muro', 'ACTIVO'),
(1280, '140205', 'Lambayeque', 'Ferreñafe', 'Pitipo', 'ACTIVO'),
(1281, '140206', 'Lambayeque', 'Ferreñafe', 'Pueblo Nuevo', 'ACTIVO'),
(1282, '140301', 'Lambayeque', 'Lambayeque', 'Lambayeque', 'ACTIVO'),
(1283, '140302', 'Lambayeque', 'Lambayeque', 'Chochope', 'ACTIVO'),
(1284, '140303', 'Lambayeque', 'Lambayeque', 'Illimo', 'ACTIVO'),
(1285, '140304', 'Lambayeque', 'Lambayeque', 'Jayanca', 'ACTIVO'),
(1286, '140305', 'Lambayeque', 'Lambayeque', 'Mochumi', 'ACTIVO'),
(1287, '140306', 'Lambayeque', 'Lambayeque', 'Mórrope', 'ACTIVO'),
(1288, '140307', 'Lambayeque', 'Lambayeque', 'Motupe', 'ACTIVO'),
(1289, '140308', 'Lambayeque', 'Lambayeque', 'Olmos', 'ACTIVO'),
(1290, '140309', 'Lambayeque', 'Lambayeque', 'Pacora', 'ACTIVO'),
(1291, '140310', 'Lambayeque', 'Lambayeque', 'Salas', 'ACTIVO'),
(1292, '140311', 'Lambayeque', 'Lambayeque', 'San José', 'ACTIVO'),
(1293, '140312', 'Lambayeque', 'Lambayeque', 'Tucume', 'ACTIVO'),
(1294, '150101', 'Lima', 'Lima', 'Lima', 'ACTIVO'),
(1295, '150102', 'Lima', 'Lima', 'Ancón', 'ACTIVO'),
(1296, '150103', 'Lima', 'Lima', 'Ate', 'ACTIVO'),
(1297, '150104', 'Lima', 'Lima', 'Barranco', 'ACTIVO'),
(1298, '150105', 'Lima', 'Lima', 'Breña', 'ACTIVO'),
(1299, '150106', 'Lima', 'Lima', 'Carabayllo', 'ACTIVO'),
(1300, '150107', 'Lima', 'Lima', 'Chaclacayo', 'ACTIVO'),
(1301, '150108', 'Lima', 'Lima', 'Chorrillos', 'ACTIVO'),
(1302, '150109', 'Lima', 'Lima', 'Cieneguilla', 'ACTIVO'),
(1303, '150110', 'Lima', 'Lima', 'Comas', 'ACTIVO'),
(1304, '150111', 'Lima', 'Lima', 'El Agustino', 'ACTIVO'),
(1305, '150112', 'Lima', 'Lima', 'Independencia', 'ACTIVO'),
(1306, '150113', 'Lima', 'Lima', 'Jesús María', 'ACTIVO'),
(1307, '150114', 'Lima', 'Lima', 'La Molina', 'ACTIVO'),
(1308, '150115', 'Lima', 'Lima', 'La Victoria', 'ACTIVO'),
(1309, '150116', 'Lima', 'Lima', 'Lince', 'ACTIVO'),
(1310, '150117', 'Lima', 'Lima', 'Los Olivos', 'ACTIVO'),
(1311, '150118', 'Lima', 'Lima', 'Lurigancho', 'ACTIVO'),
(1312, '150119', 'Lima', 'Lima', 'Lurín', 'ACTIVO'),
(1313, '150120', 'Lima', 'Lima', 'Magdalena Del Mar', 'ACTIVO'),
(1314, '150121', 'Lima', 'Lima', 'Pueblo Libre', 'ACTIVO'),
(1315, '150122', 'Lima', 'Lima', 'Miraflores', 'ACTIVO'),
(1316, '150123', 'Lima', 'Lima', 'Pachacámac', 'ACTIVO'),
(1317, '150124', 'Lima', 'Lima', 'Pucusana', 'ACTIVO'),
(1318, '150125', 'Lima', 'Lima', 'Puente Piedra', 'ACTIVO'),
(1319, '150126', 'Lima', 'Lima', 'Punta Hermosa', 'ACTIVO'),
(1320, '150127', 'Lima', 'Lima', 'Punta Negra', 'ACTIVO'),
(1321, '150128', 'Lima', 'Lima', 'Rímac', 'ACTIVO'),
(1322, '150129', 'Lima', 'Lima', 'San Bartolo', 'ACTIVO'),
(1323, '150130', 'Lima', 'Lima', 'San Borja', 'ACTIVO'),
(1324, '150131', 'Lima', 'Lima', 'San Isidro', 'ACTIVO'),
(1325, '150132', 'Lima', 'Lima', 'San Juan de Lurigancho', 'ACTIVO'),
(1326, '150133', 'Lima', 'Lima', 'San Juan de Miraflores', 'ACTIVO'),
(1327, '150134', 'Lima', 'Lima', 'San Luis', 'ACTIVO'),
(1328, '150135', 'Lima', 'Lima', 'San Martin de Porres', 'ACTIVO'),
(1329, '150136', 'Lima', 'Lima', 'San Miguel', 'ACTIVO'),
(1330, '150137', 'Lima', 'Lima', 'Santa Anita', 'ACTIVO'),
(1331, '150138', 'Lima', 'Lima', 'Santa María del Mar', 'ACTIVO'),
(1332, '150139', 'Lima', 'Lima', 'Santa Rosa', 'ACTIVO'),
(1333, '150140', 'Lima', 'Lima', 'Santiago de Surco', 'ACTIVO'),
(1334, '150141', 'Lima', 'Lima', 'Surquillo', 'ACTIVO'),
(1335, '150142', 'Lima', 'Lima', 'Villa El Salvador', 'ACTIVO'),
(1336, '150143', 'Lima', 'Lima', 'Villa María Del Triunfo', 'ACTIVO'),
(1337, '150201', 'Lima', 'Barranca', 'Barranca', 'ACTIVO'),
(1338, '150202', 'Lima', 'Barranca', 'Paramonga', 'ACTIVO'),
(1339, '150203', 'Lima', 'Barranca', 'Pativilca', 'ACTIVO'),
(1340, '150204', 'Lima', 'Barranca', 'Supe', 'ACTIVO'),
(1341, '150205', 'Lima', 'Barranca', 'Supe Puerto', 'ACTIVO'),
(1342, '150301', 'Lima', 'Cajatambo', 'Cajatambo', 'ACTIVO'),
(1343, '150302', 'Lima', 'Cajatambo', 'Copa', 'ACTIVO'),
(1344, '150303', 'Lima', 'Cajatambo', 'Gorgor', 'ACTIVO'),
(1345, '150304', 'Lima', 'Cajatambo', 'Huancapón', 'ACTIVO'),
(1346, '150305', 'Lima', 'Cajatambo', 'Manas', 'ACTIVO'),
(1347, '150401', 'Lima', 'Canta', 'Canta', 'ACTIVO'),
(1348, '150402', 'Lima', 'Canta', 'Arahuay', 'ACTIVO'),
(1349, '150403', 'Lima', 'Canta', 'Huamantanga', 'ACTIVO'),
(1350, '150404', 'Lima', 'Canta', 'Huaros', 'ACTIVO'),
(1351, '150405', 'Lima', 'Canta', 'Lachaqui', 'ACTIVO'),
(1352, '150406', 'Lima', 'Canta', 'San Buenaventura', 'ACTIVO'),
(1353, '150407', 'Lima', 'Canta', 'Santa Rosa de Quives', 'ACTIVO'),
(1354, '150501', 'Lima', 'Cañete', 'San Vicente de Cañete', 'ACTIVO'),
(1355, '150502', 'Lima', 'Cañete', 'Asia', 'ACTIVO'),
(1356, '150503', 'Lima', 'Cañete', 'Calango', 'ACTIVO'),
(1357, '150504', 'Lima', 'Cañete', 'Cerro Azul', 'ACTIVO'),
(1358, '150505', 'Lima', 'Cañete', 'Chilca', 'ACTIVO'),
(1359, '150506', 'Lima', 'Cañete', 'Coayllo', 'ACTIVO'),
(1360, '150507', 'Lima', 'Cañete', 'Imperial', 'ACTIVO'),
(1361, '150508', 'Lima', 'Cañete', 'Lunahuana', 'ACTIVO'),
(1362, '150509', 'Lima', 'Cañete', 'Mala', 'ACTIVO'),
(1363, '150510', 'Lima', 'Cañete', 'Nuevo Imperial', 'ACTIVO'),
(1364, '150511', 'Lima', 'Cañete', 'Pacarán', 'ACTIVO'),
(1365, '150512', 'Lima', 'Cañete', 'Quilmana', 'ACTIVO'),
(1366, '150513', 'Lima', 'Cañete', 'San Antonio', 'ACTIVO'),
(1367, '150514', 'Lima', 'Cañete', 'San Luis', 'ACTIVO'),
(1368, '150515', 'Lima', 'Cañete', 'Santa Cruz de Flores', 'ACTIVO'),
(1369, '150516', 'Lima', 'Cañete', 'Zuñiga', 'ACTIVO'),
(1370, '150601', 'Lima', 'Huaral', 'Huaral', 'ACTIVO'),
(1371, '150602', 'Lima', 'Huaral', 'Atavillos Alto', 'ACTIVO'),
(1372, '150603', 'Lima', 'Huaral', 'Atavillos Bajo', 'ACTIVO'),
(1373, '150604', 'Lima', 'Huaral', 'Aucallama', 'ACTIVO'),
(1374, '150605', 'Lima', 'Huaral', 'Chancay', 'ACTIVO'),
(1375, '150606', 'Lima', 'Huaral', 'Ihuari', 'ACTIVO'),
(1376, '150607', 'Lima', 'Huaral', 'Lampián', 'ACTIVO'),
(1377, '150608', 'Lima', 'Huaral', 'Pacaraos', 'ACTIVO'),
(1378, '150609', 'Lima', 'Huaral', 'San Miguel de Acos', 'ACTIVO'),
(1379, '150610', 'Lima', 'Huaral', 'Santa Cruz de Andamarca', 'ACTIVO'),
(1380, '150611', 'Lima', 'Huaral', 'Sumbilca', 'ACTIVO'),
(1381, '150612', 'Lima', 'Huaral', 'Veintisiete de Noviembre', 'ACTIVO'),
(1382, '150701', 'Lima', 'Huarochirí', 'Matucana', 'ACTIVO'),
(1383, '150702', 'Lima', 'Huarochirí', 'Antioquía', 'ACTIVO'),
(1384, '150703', 'Lima', 'Huarochirí', 'Callahuanca', 'ACTIVO'),
(1385, '150704', 'Lima', 'Huarochirí', 'Carampoma', 'ACTIVO'),
(1386, '150705', 'Lima', 'Huarochirí', 'Chicla', 'ACTIVO'),
(1387, '150706', 'Lima', 'Huarochirí', 'Cuenca', 'ACTIVO'),
(1388, '150707', 'Lima', 'Huarochirí', 'Huachupampa', 'ACTIVO'),
(1389, '150708', 'Lima', 'Huarochirí', 'Huanza', 'ACTIVO'),
(1390, '150709', 'Lima', 'Huarochirí', 'Huarochirí', 'ACTIVO'),
(1391, '150710', 'Lima', 'Huarochirí', 'Lahuaytambo', 'ACTIVO'),
(1392, '150711', 'Lima', 'Huarochirí', 'Langa', 'ACTIVO'),
(1393, '150712', 'Lima', 'Huarochirí', 'San Pedro de Laraos', 'ACTIVO'),
(1394, '150713', 'Lima', 'Huarochirí', 'Mariatana', 'ACTIVO'),
(1395, '150714', 'Lima', 'Huarochirí', 'Ricardo Palma', 'ACTIVO'),
(1396, '150715', 'Lima', 'Huarochirí', 'San Andrés de Tupicocha', 'ACTIVO'),
(1397, '150716', 'Lima', 'Huarochirí', 'San Antonio', 'ACTIVO'),
(1398, '150717', 'Lima', 'Huarochirí', 'San Bartolomé', 'ACTIVO'),
(1399, '150718', 'Lima', 'Huarochirí', 'San Damian', 'ACTIVO'),
(1400, '150719', 'Lima', 'Huarochirí', 'San Juan de Iris', 'ACTIVO'),
(1401, '150720', 'Lima', 'Huarochirí', 'San Juan de Tantaranche', 'ACTIVO'),
(1402, '150721', 'Lima', 'Huarochirí', 'San Lorenzo de Quinti', 'ACTIVO'),
(1403, '150722', 'Lima', 'Huarochirí', 'San Mateo', 'ACTIVO'),
(1404, '150723', 'Lima', 'Huarochirí', 'San Mateo de Otao', 'ACTIVO'),
(1405, '150724', 'Lima', 'Huarochirí', 'San Pedro de Casta', 'ACTIVO'),
(1406, '150725', 'Lima', 'Huarochirí', 'San Pedro de Huancayre', 'ACTIVO'),
(1407, '150726', 'Lima', 'Huarochirí', 'Sangallaya', 'ACTIVO'),
(1408, '150727', 'Lima', 'Huarochirí', 'Santa Cruz de Cocachacra', 'ACTIVO'),
(1409, '150728', 'Lima', 'Huarochirí', 'Santa Eulalia', 'ACTIVO'),
(1410, '150729', 'Lima', 'Huarochirí', 'Santiago de Anchucaya', 'ACTIVO'),
(1411, '150730', 'Lima', 'Huarochirí', 'Santiago de Tuna', 'ACTIVO'),
(1412, '150731', 'Lima', 'Huarochirí', 'Santo Domingo de Los Olleros', 'ACTIVO'),
(1413, '150732', 'Lima', 'Huarochirí', 'Surco', 'ACTIVO'),
(1414, '150801', 'Lima', 'Huaura', 'Huacho', 'ACTIVO'),
(1415, '150802', 'Lima', 'Huaura', 'Ambar', 'ACTIVO'),
(1416, '150803', 'Lima', 'Huaura', 'Caleta de Carquín', 'ACTIVO'),
(1417, '150804', 'Lima', 'Huaura', 'Checras', 'ACTIVO'),
(1418, '150805', 'Lima', 'Huaura', 'Hualmay', 'ACTIVO'),
(1419, '150806', 'Lima', 'Huaura', 'Huaura', 'ACTIVO'),
(1420, '150807', 'Lima', 'Huaura', 'Leoncio Prado', 'ACTIVO'),
(1421, '150808', 'Lima', 'Huaura', 'Paccho', 'ACTIVO'),
(1422, '150809', 'Lima', 'Huaura', 'Santa Leonor', 'ACTIVO'),
(1423, '150810', 'Lima', 'Huaura', 'Santa María', 'ACTIVO'),
(1424, '150811', 'Lima', 'Huaura', 'Sayán', 'ACTIVO'),
(1425, '150812', 'Lima', 'Huaura', 'Vegueta', 'ACTIVO'),
(1426, '150901', 'Lima', 'Oyón', 'Oyón', 'ACTIVO'),
(1427, '150902', 'Lima', 'Oyón', 'Andajes', 'ACTIVO'),
(1428, '150903', 'Lima', 'Oyón', 'Caujul', 'ACTIVO'),
(1429, '150904', 'Lima', 'Oyón', 'Cochamarca', 'ACTIVO'),
(1430, '150905', 'Lima', 'Oyón', 'Naván', 'ACTIVO'),
(1431, '150906', 'Lima', 'Oyón', 'Pachangara', 'ACTIVO'),
(1432, '151001', 'Lima', 'Yauyos', 'Yauyos', 'ACTIVO'),
(1433, '151002', 'Lima', 'Yauyos', 'Alis', 'ACTIVO'),
(1434, '151003', 'Lima', 'Yauyos', 'Allauca', 'ACTIVO'),
(1435, '151004', 'Lima', 'Yauyos', 'Ayaviri', 'ACTIVO'),
(1436, '151005', 'Lima', 'Yauyos', 'Azángaro', 'ACTIVO'),
(1437, '151006', 'Lima', 'Yauyos', 'Cacra', 'ACTIVO'),
(1438, '151007', 'Lima', 'Yauyos', 'Carania', 'ACTIVO'),
(1439, '151008', 'Lima', 'Yauyos', 'Catahuasi', 'ACTIVO'),
(1440, '151009', 'Lima', 'Yauyos', 'Chocos', 'ACTIVO'),
(1441, '151010', 'Lima', 'Yauyos', 'Cochas', 'ACTIVO'),
(1442, '151011', 'Lima', 'Yauyos', 'Colonia', 'ACTIVO'),
(1443, '151012', 'Lima', 'Yauyos', 'Hongos', 'ACTIVO'),
(1444, '151013', 'Lima', 'Yauyos', 'Huampara', 'ACTIVO'),
(1445, '151014', 'Lima', 'Yauyos', 'Huancaya', 'ACTIVO'),
(1446, '151015', 'Lima', 'Yauyos', 'Huangascar', 'ACTIVO'),
(1447, '151016', 'Lima', 'Yauyos', 'Huantan', 'ACTIVO'),
(1448, '151017', 'Lima', 'Yauyos', 'Huañec', 'ACTIVO'),
(1449, '151018', 'Lima', 'Yauyos', 'Laraos', 'ACTIVO'),
(1450, '151019', 'Lima', 'Yauyos', 'Lincha', 'ACTIVO'),
(1451, '151020', 'Lima', 'Yauyos', 'Madean', 'ACTIVO'),
(1452, '151021', 'Lima', 'Yauyos', 'Miraflores', 'ACTIVO'),
(1453, '151022', 'Lima', 'Yauyos', 'Omas', 'ACTIVO'),
(1454, '151023', 'Lima', 'Yauyos', 'Putinza', 'ACTIVO'),
(1455, '151024', 'Lima', 'Yauyos', 'Quinches', 'ACTIVO'),
(1456, '151025', 'Lima', 'Yauyos', 'Quinocay', 'ACTIVO'),
(1457, '151026', 'Lima', 'Yauyos', 'San Joaquín', 'ACTIVO'),
(1458, '151027', 'Lima', 'Yauyos', 'San Pedro de Pilas', 'ACTIVO'),
(1459, '151028', 'Lima', 'Yauyos', 'Tanta', 'ACTIVO'),
(1460, '151029', 'Lima', 'Yauyos', 'Tauripampa', 'ACTIVO'),
(1461, '151030', 'Lima', 'Yauyos', 'Tomás', 'ACTIVO'),
(1462, '151031', 'Lima', 'Yauyos', 'Tupe', 'ACTIVO'),
(1463, '151032', 'Lima', 'Yauyos', 'Viñac', 'ACTIVO'),
(1464, '151033', 'Lima', 'Yauyos', 'Vitis', 'ACTIVO'),
(1465, '160101', 'Loreto', 'Maynas', 'Iquitos', 'ACTIVO'),
(1466, '160102', 'Loreto', 'Maynas', 'Alto Nanay', 'ACTIVO'),
(1467, '160103', 'Loreto', 'Maynas', 'Fernando Lores', 'ACTIVO'),
(1468, '160104', 'Loreto', 'Maynas', 'Indiana', 'ACTIVO'),
(1469, '160105', 'Loreto', 'Maynas', 'Las Amazonas', 'ACTIVO'),
(1470, '160106', 'Loreto', 'Maynas', 'Mazan', 'ACTIVO'),
(1471, '160107', 'Loreto', 'Maynas', 'Napo', 'ACTIVO'),
(1472, '160108', 'Loreto', 'Maynas', 'Punchana', 'ACTIVO'),
(1473, '160110', 'Loreto', 'Maynas', 'Torres Causana', 'ACTIVO'),
(1474, '160112', 'Loreto', 'Maynas', 'Belén', 'ACTIVO'),
(1475, '160113', 'Loreto', 'Maynas', 'San Juan Bautista', 'ACTIVO'),
(1476, '160201', 'Loreto', 'Alto Amazonas', 'Yurimaguas', 'ACTIVO'),
(1477, '160202', 'Loreto', 'Alto Amazonas', 'Balsapuerto', 'ACTIVO'),
(1478, '160205', 'Loreto', 'Alto Amazonas', 'Jeberos', 'ACTIVO'),
(1479, '160206', 'Loreto', 'Alto Amazonas', 'Lagunas', 'ACTIVO'),
(1480, '160210', 'Loreto', 'Alto Amazonas', 'Santa Cruz', 'ACTIVO'),
(1481, '160211', 'Loreto', 'Alto Amazonas', 'Teniente César López Rojas', 'ACTIVO'),
(1482, '160301', 'Loreto', 'Loreto', 'Nauta', 'ACTIVO'),
(1483, '160302', 'Loreto', 'Loreto', 'Parinari', 'ACTIVO'),
(1484, '160303', 'Loreto', 'Loreto', 'Tigre', 'ACTIVO'),
(1485, '160304', 'Loreto', 'Loreto', 'Trompeteros', 'ACTIVO'),
(1486, '160305', 'Loreto', 'Loreto', 'Urarinas', 'ACTIVO'),
(1487, '160401', 'Loreto', 'Mariscal Ramón Castilla', 'Ramón Castilla', 'ACTIVO'),
(1488, '160402', 'Loreto', 'Mariscal Ramón Castilla', 'Pebas', 'ACTIVO'),
(1489, '160403', 'Loreto', 'Mariscal Ramón Castilla', 'Yavari', 'ACTIVO'),
(1490, '160404', 'Loreto', 'Mariscal Ramón Castilla', 'San Pablo', 'ACTIVO'),
(1491, '160501', 'Loreto', 'Requena', 'Requena', 'ACTIVO'),
(1492, '160502', 'Loreto', 'Requena', 'Alto Tapiche', 'ACTIVO'),
(1493, '160503', 'Loreto', 'Requena', 'Capelo', 'ACTIVO'),
(1494, '160504', 'Loreto', 'Requena', 'Emilio San Martín', 'ACTIVO'),
(1495, '160505', 'Loreto', 'Requena', 'Maquia', 'ACTIVO'),
(1496, '160506', 'Loreto', 'Requena', 'Puinahua', 'ACTIVO'),
(1497, '160507', 'Loreto', 'Requena', 'Saquena', 'ACTIVO'),
(1498, '160508', 'Loreto', 'Requena', 'Soplin', 'ACTIVO'),
(1499, '160509', 'Loreto', 'Requena', 'Tapiche', 'ACTIVO'),
(1500, '160510', 'Loreto', 'Requena', 'Jenaro Herrera', 'ACTIVO'),
(1501, '160511', 'Loreto', 'Requena', 'Yaquerana', 'ACTIVO'),
(1502, '160601', 'Loreto', 'Ucayali', 'Contamana', 'ACTIVO'),
(1503, '160602', 'Loreto', 'Ucayali', 'Inahuaya', 'ACTIVO'),
(1504, '160603', 'Loreto', 'Ucayali', 'Padre Márquez', 'ACTIVO'),
(1505, '160604', 'Loreto', 'Ucayali', 'Pampa Hermosa', 'ACTIVO'),
(1506, '160605', 'Loreto', 'Ucayali', 'Sarayacu', 'ACTIVO'),
(1507, '160606', 'Loreto', 'Ucayali', 'Vargas Guerra', 'ACTIVO'),
(1508, '160701', 'Loreto', 'Datem del Marañón', 'Barranca', 'ACTIVO'),
(1509, '160702', 'Loreto', 'Datem del Marañón', 'Cahuapanas', 'ACTIVO'),
(1510, '160703', 'Loreto', 'Datem del Marañón', 'Manseriche', 'ACTIVO'),
(1511, '160704', 'Loreto', 'Datem del Marañón', 'Morona', 'ACTIVO'),
(1512, '160705', 'Loreto', 'Datem del Marañón', 'Pastaza', 'ACTIVO'),
(1513, '160706', 'Loreto', 'Datem del Marañón', 'Andoas', 'ACTIVO'),
(1514, '160801', 'Loreto', 'Putumayo', 'Putumayo', 'ACTIVO'),
(1515, '160802', 'Loreto', 'Putumayo', 'Rosa Panduro', 'ACTIVO'),
(1516, '160803', 'Loreto', 'Putumayo', 'Teniente Manuel Clavero', 'ACTIVO'),
(1517, '160804', 'Loreto', 'Putumayo', 'Yaguas', 'ACTIVO'),
(1518, '170101', 'Madre de Dios', 'Tambopata', 'Tambopata', 'ACTIVO'),
(1519, '170102', 'Madre de Dios', 'Tambopata', 'Inambari', 'ACTIVO'),
(1520, '170103', 'Madre de Dios', 'Tambopata', 'Las Piedras', 'ACTIVO'),
(1521, '170104', 'Madre de Dios', 'Tambopata', 'Laberinto', 'ACTIVO'),
(1522, '170201', 'Madre de Dios', 'Manu', 'Manu', 'ACTIVO'),
(1523, '170202', 'Madre de Dios', 'Manu', 'Fitzcarrald', 'ACTIVO'),
(1524, '170203', 'Madre de Dios', 'Manu', 'Madre de Dios', 'ACTIVO'),
(1525, '170204', 'Madre de Dios', 'Manu', 'Huepetuhe', 'ACTIVO'),
(1526, '170301', 'Madre de Dios', 'Tahuamanu', 'Iñapari', 'ACTIVO'),
(1527, '170302', 'Madre de Dios', 'Tahuamanu', 'Iberia', 'ACTIVO'),
(1528, '170303', 'Madre de Dios', 'Tahuamanu', 'Tahuamanu', 'ACTIVO'),
(1529, '180101', 'Moquegua', 'Mariscal Nieto', 'Moquegua', 'ACTIVO'),
(1530, '180102', 'Moquegua', 'Mariscal Nieto', 'Carumas', 'ACTIVO'),
(1531, '180103', 'Moquegua', 'Mariscal Nieto', 'Cuchumbaya', 'ACTIVO'),
(1532, '180104', 'Moquegua', 'Mariscal Nieto', 'Samegua', 'ACTIVO'),
(1533, '180105', 'Moquegua', 'Mariscal Nieto', 'San Cristóbal', 'ACTIVO'),
(1534, '180106', 'Moquegua', 'Mariscal Nieto', 'Torata', 'ACTIVO'),
(1535, '180107', 'Moquegua', 'Mariscal Nieto', 'San Antonio', 'ACTIVO'),
(1536, '180201', 'Moquegua', 'General Sánchez Cerro', 'Omate', 'ACTIVO'),
(1537, '180202', 'Moquegua', 'General Sánchez Cerro', 'Chojata', 'ACTIVO'),
(1538, '180203', 'Moquegua', 'General Sánchez Cerro', 'Coalaque', 'ACTIVO'),
(1539, '180204', 'Moquegua', 'General Sánchez Cerro', 'Ichuña', 'ACTIVO'),
(1540, '180205', 'Moquegua', 'General Sánchez Cerro', 'La Capilla', 'ACTIVO'),
(1541, '180206', 'Moquegua', 'General Sánchez Cerro', 'Lloque', 'ACTIVO'),
(1542, '180207', 'Moquegua', 'General Sánchez Cerro', 'Matalaque', 'ACTIVO'),
(1543, '180208', 'Moquegua', 'General Sánchez Cerro', 'Puquina', 'ACTIVO'),
(1544, '180209', 'Moquegua', 'General Sánchez Cerro', 'Quinistaquillas', 'ACTIVO'),
(1545, '180210', 'Moquegua', 'General Sánchez Cerro', 'Ubinas', 'ACTIVO'),
(1546, '180211', 'Moquegua', 'General Sánchez Cerro', 'Yunga', 'ACTIVO'),
(1547, '180301', 'Moquegua', 'Ilo', 'Ilo', 'ACTIVO'),
(1548, '180302', 'Moquegua', 'Ilo', 'El Algarrobal', 'ACTIVO'),
(1549, '180303', 'Moquegua', 'Ilo', 'Pacocha', 'ACTIVO'),
(1550, '190101', 'Pasco', 'Pasco', 'Chaupimarca', 'ACTIVO'),
(1551, '190102', 'Pasco', 'Pasco', 'Huachón', 'ACTIVO'),
(1552, '190103', 'Pasco', 'Pasco', 'Huariaca', 'ACTIVO'),
(1553, '190104', 'Pasco', 'Pasco', 'Huayllay', 'ACTIVO'),
(1554, '190105', 'Pasco', 'Pasco', 'Ninacaca', 'ACTIVO'),
(1555, '190106', 'Pasco', 'Pasco', 'Pallanchacra', 'ACTIVO'),
(1556, '190107', 'Pasco', 'Pasco', 'Paucartambo', 'ACTIVO'),
(1557, '190108', 'Pasco', 'Pasco', 'San Francisco de Asís de Yarusyacán', 'ACTIVO'),
(1558, '190109', 'Pasco', 'Pasco', 'Simón Bolívar', 'ACTIVO'),
(1559, '190110', 'Pasco', 'Pasco', 'Ticlacayan', 'ACTIVO'),
(1560, '190111', 'Pasco', 'Pasco', 'Tinyahuarco', 'ACTIVO'),
(1561, '190112', 'Pasco', 'Pasco', 'Vicco', 'ACTIVO'),
(1562, '190113', 'Pasco', 'Pasco', 'Yanacancha', 'ACTIVO'),
(1563, '190201', 'Pasco', 'Daniel Alcides Carrión', 'Yanahuanca', 'ACTIVO'),
(1564, '190202', 'Pasco', 'Daniel Alcides Carrión', 'Chacayan', 'ACTIVO'),
(1565, '190203', 'Pasco', 'Daniel Alcides Carrión', 'Goyllarisquizga', 'ACTIVO'),
(1566, '190204', 'Pasco', 'Daniel Alcides Carrión', 'Paucar', 'ACTIVO'),
(1567, '190205', 'Pasco', 'Daniel Alcides Carrión', 'San Pedro de Pillao', 'ACTIVO'),
(1568, '190206', 'Pasco', 'Daniel Alcides Carrión', 'Santa Ana de Tusi', 'ACTIVO'),
(1569, '190207', 'Pasco', 'Daniel Alcides Carrión', 'Tapuc', 'ACTIVO'),
(1570, '190208', 'Pasco', 'Daniel Alcides Carrión', 'Vilcabamba', 'ACTIVO'),
(1571, '190301', 'Pasco', 'Oxapampa', 'Oxapampa', 'ACTIVO'),
(1572, '190302', 'Pasco', 'Oxapampa', 'Chontabamba', 'ACTIVO'),
(1573, '190303', 'Pasco', 'Oxapampa', 'Huancabamba', 'ACTIVO'),
(1574, '190304', 'Pasco', 'Oxapampa', 'Palcazu', 'ACTIVO'),
(1575, '190305', 'Pasco', 'Oxapampa', 'Pozuzo', 'ACTIVO'),
(1576, '190306', 'Pasco', 'Oxapampa', 'Puerto Bermúdez', 'ACTIVO'),
(1577, '190307', 'Pasco', 'Oxapampa', 'Villa Rica', 'ACTIVO'),
(1578, '190308', 'Pasco', 'Oxapampa', 'Constitución', 'ACTIVO'),
(1579, '200101', 'Piura', 'Piura', 'Piura', 'ACTIVO'),
(1580, '200104', 'Piura', 'Piura', 'Castilla', 'ACTIVO'),
(1581, '200105', 'Piura', 'Piura', 'Catacaos', 'ACTIVO'),
(1582, '200107', 'Piura', 'Piura', 'Cura Mori', 'ACTIVO'),
(1583, '200108', 'Piura', 'Piura', 'El Tallán', 'ACTIVO'),
(1584, '200109', 'Piura', 'Piura', 'La Arena', 'ACTIVO'),
(1585, '200110', 'Piura', 'Piura', 'La Unión', 'ACTIVO'),
(1586, '200111', 'Piura', 'Piura', 'Las Lomas', 'ACTIVO'),
(1587, '200114', 'Piura', 'Piura', 'Tambo Grande', 'ACTIVO'),
(1588, '200115', 'Piura', 'Piura', 'Veintiséis de Octubre', 'ACTIVO'),
(1589, '200201', 'Piura', 'Ayabaca', 'Ayabaca', 'ACTIVO'),
(1590, '200202', 'Piura', 'Ayabaca', 'Frías', 'ACTIVO'),
(1591, '200203', 'Piura', 'Ayabaca', 'Jilili', 'ACTIVO'),
(1592, '200204', 'Piura', 'Ayabaca', 'Lagunas', 'ACTIVO'),
(1593, '200205', 'Piura', 'Ayabaca', 'Montero', 'ACTIVO'),
(1594, '200206', 'Piura', 'Ayabaca', 'Pacaipampa', 'ACTIVO'),
(1595, '200207', 'Piura', 'Ayabaca', 'Paimas', 'ACTIVO'),
(1596, '200208', 'Piura', 'Ayabaca', 'Sapillica', 'ACTIVO'),
(1597, '200209', 'Piura', 'Ayabaca', 'Sicchez', 'ACTIVO'),
(1598, '200210', 'Piura', 'Ayabaca', 'Suyo', 'ACTIVO'),
(1599, '200301', 'Piura', 'Huancabamba', 'Huancabamba', 'ACTIVO'),
(1600, '200302', 'Piura', 'Huancabamba', 'Canchaque', 'ACTIVO'),
(1601, '200303', 'Piura', 'Huancabamba', 'El Carmen de La Frontera', 'ACTIVO'),
(1602, '200304', 'Piura', 'Huancabamba', 'Huarmaca', 'ACTIVO'),
(1603, '200305', 'Piura', 'Huancabamba', 'Lalaquiz', 'ACTIVO'),
(1604, '200306', 'Piura', 'Huancabamba', 'San Miguel de El Faique', 'ACTIVO'),
(1605, '200307', 'Piura', 'Huancabamba', 'Sondor', 'ACTIVO'),
(1606, '200308', 'Piura', 'Huancabamba', 'Sondorillo', 'ACTIVO'),
(1607, '200401', 'Piura', 'Morropón', 'Chulucanas', 'ACTIVO'),
(1608, '200402', 'Piura', 'Morropón', 'Buenos Aires', 'ACTIVO'),
(1609, '200403', 'Piura', 'Morropón', 'Chalaco', 'ACTIVO'),
(1610, '200404', 'Piura', 'Morropón', 'La Matanza', 'ACTIVO');
INSERT INTO `ubigeos` (`id_ubigeo`, `codigo_ubigeo`, `departamento`, `provincia`, `distrito`, `estado`) VALUES
(1611, '200405', 'Piura', 'Morropón', 'Morropón', 'ACTIVO'),
(1612, '200406', 'Piura', 'Morropón', 'Salitral', 'ACTIVO'),
(1613, '200407', 'Piura', 'Morropón', 'San Juan de Bigote', 'ACTIVO'),
(1614, '200408', 'Piura', 'Morropón', 'Santa Catalina de Mossa', 'ACTIVO'),
(1615, '200409', 'Piura', 'Morropón', 'Santo Domingo', 'ACTIVO'),
(1616, '200410', 'Piura', 'Morropón', 'Yamango', 'ACTIVO'),
(1617, '200501', 'Piura', 'Paita', 'Paita', 'ACTIVO'),
(1618, '200502', 'Piura', 'Paita', 'Amotape', 'ACTIVO'),
(1619, '200503', 'Piura', 'Paita', 'Arenal', 'ACTIVO'),
(1620, '200504', 'Piura', 'Paita', 'Colan', 'ACTIVO'),
(1621, '200505', 'Piura', 'Paita', 'La Huaca', 'ACTIVO'),
(1622, '200506', 'Piura', 'Paita', 'Tamarindo', 'ACTIVO'),
(1623, '200507', 'Piura', 'Paita', 'Vichayal', 'ACTIVO'),
(1624, '200601', 'Piura', 'Sullana', 'Sullana', 'ACTIVO'),
(1625, '200602', 'Piura', 'Sullana', 'Bellavista', 'ACTIVO'),
(1626, '200603', 'Piura', 'Sullana', 'Ignacio Escudero', 'ACTIVO'),
(1627, '200604', 'Piura', 'Sullana', 'Lancones', 'ACTIVO'),
(1628, '200605', 'Piura', 'Sullana', 'Marcavelica', 'ACTIVO'),
(1629, '200606', 'Piura', 'Sullana', 'Miguel Checa', 'ACTIVO'),
(1630, '200607', 'Piura', 'Sullana', 'Querecotillo', 'ACTIVO'),
(1631, '200608', 'Piura', 'Sullana', 'Salitral', 'ACTIVO'),
(1632, '200701', 'Piura', 'Talara', 'Pariñas', 'ACTIVO'),
(1633, '200702', 'Piura', 'Talara', 'El Alto', 'ACTIVO'),
(1634, '200703', 'Piura', 'Talara', 'La Brea', 'ACTIVO'),
(1635, '200704', 'Piura', 'Talara', 'Lobitos', 'ACTIVO'),
(1636, '200705', 'Piura', 'Talara', 'Los Órganos', 'ACTIVO'),
(1637, '200706', 'Piura', 'Talara', 'Máncora', 'ACTIVO'),
(1638, '200801', 'Piura', 'Sechura', 'Sechura', 'ACTIVO'),
(1639, '200802', 'Piura', 'Sechura', 'Bellavista de La Unión', 'ACTIVO'),
(1640, '200803', 'Piura', 'Sechura', 'Bernal', 'ACTIVO'),
(1641, '200804', 'Piura', 'Sechura', 'Cristo Nos Valga', 'ACTIVO'),
(1642, '200805', 'Piura', 'Sechura', 'Vice', 'ACTIVO'),
(1643, '200806', 'Piura', 'Sechura', 'Rinconada Llicuar', 'ACTIVO'),
(1644, '210101', 'Puno', 'Puno', 'Puno', 'ACTIVO'),
(1645, '210102', 'Puno', 'Puno', 'Acora', 'ACTIVO'),
(1646, '210103', 'Puno', 'Puno', 'Amantani', 'ACTIVO'),
(1647, '210104', 'Puno', 'Puno', 'Atuncolla', 'ACTIVO'),
(1648, '210105', 'Puno', 'Puno', 'Capachica', 'ACTIVO'),
(1649, '210106', 'Puno', 'Puno', 'Chucuito', 'ACTIVO'),
(1650, '210107', 'Puno', 'Puno', 'Coata', 'ACTIVO'),
(1651, '210108', 'Puno', 'Puno', 'Huata', 'ACTIVO'),
(1652, '210109', 'Puno', 'Puno', 'Mañazo', 'ACTIVO'),
(1653, '210110', 'Puno', 'Puno', 'Paucarcolla', 'ACTIVO'),
(1654, '210111', 'Puno', 'Puno', 'Pichacani', 'ACTIVO'),
(1655, '210112', 'Puno', 'Puno', 'Platería', 'ACTIVO'),
(1656, '210113', 'Puno', 'Puno', 'San Antonio', 'ACTIVO'),
(1657, '210114', 'Puno', 'Puno', 'Tiquillaca', 'ACTIVO'),
(1658, '210115', 'Puno', 'Puno', 'Vilque', 'ACTIVO'),
(1659, '210201', 'Puno', 'Azángaro', 'Azángaro', 'ACTIVO'),
(1660, '210202', 'Puno', 'Azángaro', 'Achaya', 'ACTIVO'),
(1661, '210203', 'Puno', 'Azángaro', 'Arapa', 'ACTIVO'),
(1662, '210204', 'Puno', 'Azángaro', 'Asillo', 'ACTIVO'),
(1663, '210205', 'Puno', 'Azángaro', 'Caminaca', 'ACTIVO'),
(1664, '210206', 'Puno', 'Azángaro', 'Chupa', 'ACTIVO'),
(1665, '210207', 'Puno', 'Azángaro', 'José Domingo Choquehuanca', 'ACTIVO'),
(1666, '210208', 'Puno', 'Azángaro', 'Muñani', 'ACTIVO'),
(1667, '210209', 'Puno', 'Azángaro', 'Potoni', 'ACTIVO'),
(1668, '210210', 'Puno', 'Azángaro', 'Saman', 'ACTIVO'),
(1669, '210211', 'Puno', 'Azángaro', 'San Antón', 'ACTIVO'),
(1670, '210212', 'Puno', 'Azángaro', 'San José', 'ACTIVO'),
(1671, '210213', 'Puno', 'Azángaro', 'San Juan de Salinas', 'ACTIVO'),
(1672, '210214', 'Puno', 'Azángaro', 'Santiago de Pupuja', 'ACTIVO'),
(1673, '210215', 'Puno', 'Azángaro', 'Tirapata', 'ACTIVO'),
(1674, '210301', 'Puno', 'Carabaya', 'Macusani', 'ACTIVO'),
(1675, '210302', 'Puno', 'Carabaya', 'Ajoyani', 'ACTIVO'),
(1676, '210303', 'Puno', 'Carabaya', 'Ayapata', 'ACTIVO'),
(1677, '210304', 'Puno', 'Carabaya', 'Coasa', 'ACTIVO'),
(1678, '210305', 'Puno', 'Carabaya', 'Corani', 'ACTIVO'),
(1679, '210306', 'Puno', 'Carabaya', 'Crucero', 'ACTIVO'),
(1680, '210307', 'Puno', 'Carabaya', 'Ituata', 'ACTIVO'),
(1681, '210308', 'Puno', 'Carabaya', 'Ollachea', 'ACTIVO'),
(1682, '210309', 'Puno', 'Carabaya', 'San Gabán', 'ACTIVO'),
(1683, '210310', 'Puno', 'Carabaya', 'Usicayos', 'ACTIVO'),
(1684, '210401', 'Puno', 'Chucuito', 'Juli', 'ACTIVO'),
(1685, '210402', 'Puno', 'Chucuito', 'Desaguadero', 'ACTIVO'),
(1686, '210403', 'Puno', 'Chucuito', 'Huacullani', 'ACTIVO'),
(1687, '210404', 'Puno', 'Chucuito', 'Kelluyo', 'ACTIVO'),
(1688, '210405', 'Puno', 'Chucuito', 'Pisacoma', 'ACTIVO'),
(1689, '210406', 'Puno', 'Chucuito', 'Pomata', 'ACTIVO'),
(1690, '210407', 'Puno', 'Chucuito', 'Zepita', 'ACTIVO'),
(1691, '210501', 'Puno', 'El Collao', 'Ilave', 'ACTIVO'),
(1692, '210502', 'Puno', 'El Collao', 'Capazo', 'ACTIVO'),
(1693, '210503', 'Puno', 'El Collao', 'Pilcuyo', 'ACTIVO'),
(1694, '210504', 'Puno', 'El Collao', 'Santa Rosa', 'ACTIVO'),
(1695, '210505', 'Puno', 'El Collao', 'Conduriri', 'ACTIVO'),
(1696, '210601', 'Puno', 'Huancané', 'Huancané', 'ACTIVO'),
(1697, '210602', 'Puno', 'Huancané', 'Cojata', 'ACTIVO'),
(1698, '210603', 'Puno', 'Huancané', 'Huatasani', 'ACTIVO'),
(1699, '210604', 'Puno', 'Huancané', 'Inchupalla', 'ACTIVO'),
(1700, '210605', 'Puno', 'Huancané', 'Pusi', 'ACTIVO'),
(1701, '210606', 'Puno', 'Huancané', 'Rosaspata', 'ACTIVO'),
(1702, '210607', 'Puno', 'Huancané', 'Taraco', 'ACTIVO'),
(1703, '210608', 'Puno', 'Huancané', 'Vilque Chico', 'ACTIVO'),
(1704, '210701', 'Puno', 'Lampa', 'Lampa', 'ACTIVO'),
(1705, '210702', 'Puno', 'Lampa', 'Cabanilla', 'ACTIVO'),
(1706, '210703', 'Puno', 'Lampa', 'Calapuja', 'ACTIVO'),
(1707, '210704', 'Puno', 'Lampa', 'Nicasio', 'ACTIVO'),
(1708, '210705', 'Puno', 'Lampa', 'Ocuviri', 'ACTIVO'),
(1709, '210706', 'Puno', 'Lampa', 'Palca', 'ACTIVO'),
(1710, '210707', 'Puno', 'Lampa', 'Paratia', 'ACTIVO'),
(1711, '210708', 'Puno', 'Lampa', 'Pucará', 'ACTIVO'),
(1712, '210709', 'Puno', 'Lampa', 'Santa Lucía', 'ACTIVO'),
(1713, '210710', 'Puno', 'Lampa', 'Vilavila', 'ACTIVO'),
(1714, '210801', 'Puno', 'Melgar', 'Ayaviri', 'ACTIVO'),
(1715, '210802', 'Puno', 'Melgar', 'Antauta', 'ACTIVO'),
(1716, '210803', 'Puno', 'Melgar', 'Cupi', 'ACTIVO'),
(1717, '210804', 'Puno', 'Melgar', 'Llalli', 'ACTIVO'),
(1718, '210805', 'Puno', 'Melgar', 'Macari', 'ACTIVO'),
(1719, '210806', 'Puno', 'Melgar', 'Nuñoa', 'ACTIVO'),
(1720, '210807', 'Puno', 'Melgar', 'Orurillo', 'ACTIVO'),
(1721, '210808', 'Puno', 'Melgar', 'Santa Rosa', 'ACTIVO'),
(1722, '210809', 'Puno', 'Melgar', 'Umachiri', 'ACTIVO'),
(1723, '210901', 'Puno', 'Moho', 'Moho', 'ACTIVO'),
(1724, '210902', 'Puno', 'Moho', 'Conima', 'ACTIVO'),
(1725, '210903', 'Puno', 'Moho', 'Huayrapata', 'ACTIVO'),
(1726, '210904', 'Puno', 'Moho', 'Tilali', 'ACTIVO'),
(1727, '211001', 'Puno', 'San Antonio de Putina', 'Putina', 'ACTIVO'),
(1728, '211002', 'Puno', 'San Antonio de Putina', 'Ananea', 'ACTIVO'),
(1729, '211003', 'Puno', 'San Antonio de Putina', 'Pedro Vilca Apaza', 'ACTIVO'),
(1730, '211004', 'Puno', 'San Antonio de Putina', 'Quilcapuncu', 'ACTIVO'),
(1731, '211005', 'Puno', 'San Antonio de Putina', 'Sina', 'ACTIVO'),
(1732, '211101', 'Puno', 'San Román', 'Juliaca', 'ACTIVO'),
(1733, '211102', 'Puno', 'San Román', 'Cabana', 'ACTIVO'),
(1734, '211103', 'Puno', 'San Román', 'Cabanillas', 'ACTIVO'),
(1735, '211104', 'Puno', 'San Román', 'Caracoto', 'ACTIVO'),
(1736, '211105', 'Puno', 'San Román', 'San Miguel', 'ACTIVO'),
(1737, '211201', 'Puno', 'Sandia', 'Sandia', 'ACTIVO'),
(1738, '211202', 'Puno', 'Sandia', 'Cuyocuyo', 'ACTIVO'),
(1739, '211203', 'Puno', 'Sandia', 'Limbani', 'ACTIVO'),
(1740, '211204', 'Puno', 'Sandia', 'Patambuco', 'ACTIVO'),
(1741, '211205', 'Puno', 'Sandia', 'Phara', 'ACTIVO'),
(1742, '211206', 'Puno', 'Sandia', 'Quiaca', 'ACTIVO'),
(1743, '211207', 'Puno', 'Sandia', 'San Juan del Oro', 'ACTIVO'),
(1744, '211208', 'Puno', 'Sandia', 'Yanahuaya', 'ACTIVO'),
(1745, '211209', 'Puno', 'Sandia', 'Alto Inambari', 'ACTIVO'),
(1746, '211210', 'Puno', 'Sandia', 'San Pedro de Putina Punco', 'ACTIVO'),
(1747, '211301', 'Puno', 'Yunguyo', 'Yunguyo', 'ACTIVO'),
(1748, '211302', 'Puno', 'Yunguyo', 'Anapia', 'ACTIVO'),
(1749, '211303', 'Puno', 'Yunguyo', 'Copani', 'ACTIVO'),
(1750, '211304', 'Puno', 'Yunguyo', 'Cuturapi', 'ACTIVO'),
(1751, '211305', 'Puno', 'Yunguyo', 'Ollaraya', 'ACTIVO'),
(1752, '211306', 'Puno', 'Yunguyo', 'Tinicachi', 'ACTIVO'),
(1753, '211307', 'Puno', 'Yunguyo', 'Unicachi', 'ACTIVO'),
(1754, '220101', 'San Martín', 'Moyobamba', 'Moyobamba', 'ACTIVO'),
(1755, '220102', 'San Martín', 'Moyobamba', 'Calzada', 'ACTIVO'),
(1756, '220103', 'San Martín', 'Moyobamba', 'Habana', 'ACTIVO'),
(1757, '220104', 'San Martín', 'Moyobamba', 'Jepelacio', 'ACTIVO'),
(1758, '220105', 'San Martín', 'Moyobamba', 'Soritor', 'ACTIVO'),
(1759, '220106', 'San Martín', 'Moyobamba', 'Yantalo', 'ACTIVO'),
(1760, '220201', 'San Martín', 'Bellavista', 'Bellavista', 'ACTIVO'),
(1761, '220202', 'San Martín', 'Bellavista', 'Alto Biavo', 'ACTIVO'),
(1762, '220203', 'San Martín', 'Bellavista', 'Bajo Biavo', 'ACTIVO'),
(1763, '220204', 'San Martín', 'Bellavista', 'Huallaga', 'ACTIVO'),
(1764, '220205', 'San Martín', 'Bellavista', 'San Pablo', 'ACTIVO'),
(1765, '220206', 'San Martín', 'Bellavista', 'San Rafael', 'ACTIVO'),
(1766, '220301', 'San Martín', 'El Dorado', 'San José de Sisa', 'ACTIVO'),
(1767, '220302', 'San Martín', 'El Dorado', 'Agua Blanca', 'ACTIVO'),
(1768, '220303', 'San Martín', 'El Dorado', 'San Martín', 'ACTIVO'),
(1769, '220304', 'San Martín', 'El Dorado', 'Santa Rosa', 'ACTIVO'),
(1770, '220305', 'San Martín', 'El Dorado', 'Shatoja', 'ACTIVO'),
(1771, '220401', 'San Martín', 'Huallaga', 'Saposoa', 'ACTIVO'),
(1772, '220402', 'San Martín', 'Huallaga', 'Alto Saposoa', 'ACTIVO'),
(1773, '220403', 'San Martín', 'Huallaga', 'El Eslabón', 'ACTIVO'),
(1774, '220404', 'San Martín', 'Huallaga', 'Piscoyacu', 'ACTIVO'),
(1775, '220405', 'San Martín', 'Huallaga', 'Sacanche', 'ACTIVO'),
(1776, '220406', 'San Martín', 'Huallaga', 'Tingo de Saposoa', 'ACTIVO'),
(1777, '220501', 'San Martín', 'Lamas', 'Lamas', 'ACTIVO'),
(1778, '220502', 'San Martín', 'Lamas', 'Alonso de Alvarado', 'ACTIVO'),
(1779, '220503', 'San Martín', 'Lamas', 'Barranquita', 'ACTIVO'),
(1780, '220504', 'San Martín', 'Lamas', 'Caynarachi', 'ACTIVO'),
(1781, '220505', 'San Martín', 'Lamas', 'Cuñumbuqui', 'ACTIVO'),
(1782, '220506', 'San Martín', 'Lamas', 'Pinto Recodo', 'ACTIVO'),
(1783, '220507', 'San Martín', 'Lamas', 'Rumisapa', 'ACTIVO'),
(1784, '220508', 'San Martín', 'Lamas', 'San Roque de Cumbaza', 'ACTIVO'),
(1785, '220509', 'San Martín', 'Lamas', 'Shanao', 'ACTIVO'),
(1786, '220510', 'San Martín', 'Lamas', 'Tabalosos', 'ACTIVO'),
(1787, '220511', 'San Martín', 'Lamas', 'Zapatero', 'ACTIVO'),
(1788, '220601', 'San Martín', 'Mariscal Cáceres', 'Juanjuí', 'ACTIVO'),
(1789, '220602', 'San Martín', 'Mariscal Cáceres', 'Campanilla', 'ACTIVO'),
(1790, '220603', 'San Martín', 'Mariscal Cáceres', 'Huicungo', 'ACTIVO'),
(1791, '220604', 'San Martín', 'Mariscal Cáceres', 'Pachiza', 'ACTIVO'),
(1792, '220605', 'San Martín', 'Mariscal Cáceres', 'Pajarillo', 'ACTIVO'),
(1793, '220701', 'San Martín', 'Picota', 'Picota', 'ACTIVO'),
(1794, '220702', 'San Martín', 'Picota', 'Buenos Aires', 'ACTIVO'),
(1795, '220703', 'San Martín', 'Picota', 'Caspisapa', 'ACTIVO'),
(1796, '220704', 'San Martín', 'Picota', 'Pilluana', 'ACTIVO'),
(1797, '220705', 'San Martín', 'Picota', 'Pucacaca', 'ACTIVO'),
(1798, '220706', 'San Martín', 'Picota', 'San Cristóbal', 'ACTIVO'),
(1799, '220707', 'San Martín', 'Picota', 'San Hilarión', 'ACTIVO'),
(1800, '220708', 'San Martín', 'Picota', 'Shamboyacu', 'ACTIVO'),
(1801, '220709', 'San Martín', 'Picota', 'Tingo de Ponasa', 'ACTIVO'),
(1802, '220710', 'San Martín', 'Picota', 'Tres Unidos', 'ACTIVO'),
(1803, '220801', 'San Martín', 'Rioja', 'Rioja', 'ACTIVO'),
(1804, '220802', 'San Martín', 'Rioja', 'Awajun', 'ACTIVO'),
(1805, '220803', 'San Martín', 'Rioja', 'Elias Soplín Vargas', 'ACTIVO'),
(1806, '220804', 'San Martín', 'Rioja', 'Nueva Cajamarca', 'ACTIVO'),
(1807, '220805', 'San Martín', 'Rioja', 'Pardo Miguel', 'ACTIVO'),
(1808, '220806', 'San Martín', 'Rioja', 'Posic', 'ACTIVO'),
(1809, '220807', 'San Martín', 'Rioja', 'San Fernando', 'ACTIVO'),
(1810, '220808', 'San Martín', 'Rioja', 'Yorongos', 'ACTIVO'),
(1811, '220809', 'San Martín', 'Rioja', 'Yuracyacu', 'ACTIVO'),
(1812, '220901', 'San Martín', 'San Martín', 'Tarapoto', 'ACTIVO'),
(1813, '220902', 'San Martín', 'San Martín', 'Alberto Leveau', 'ACTIVO'),
(1814, '220903', 'San Martín', 'San Martín', 'Cacatachi', 'ACTIVO'),
(1815, '220904', 'San Martín', 'San Martín', 'Chazuta', 'ACTIVO'),
(1816, '220905', 'San Martín', 'San Martín', 'Chipurana', 'ACTIVO'),
(1817, '220906', 'San Martín', 'San Martín', 'El Porvenir', 'ACTIVO'),
(1818, '220907', 'San Martín', 'San Martín', 'Huimbayoc', 'ACTIVO'),
(1819, '220908', 'San Martín', 'San Martín', 'Juan Guerra', 'ACTIVO'),
(1820, '220909', 'San Martín', 'San Martín', 'La Banda de Shilcayo', 'ACTIVO'),
(1821, '220910', 'San Martín', 'San Martín', 'Morales', 'ACTIVO'),
(1822, '220911', 'San Martín', 'San Martín', 'Papaplaya', 'ACTIVO'),
(1823, '220912', 'San Martín', 'San Martín', 'San Antonio', 'ACTIVO'),
(1824, '220913', 'San Martín', 'San Martín', 'Sauce', 'ACTIVO'),
(1825, '220914', 'San Martín', 'San Martín', 'Shapaja', 'ACTIVO'),
(1826, '221001', 'San Martín', 'Tocache', 'Tocache', 'ACTIVO'),
(1827, '221002', 'San Martín', 'Tocache', 'Nuevo Progreso', 'ACTIVO'),
(1828, '221003', 'San Martín', 'Tocache', 'Pólvora', 'ACTIVO'),
(1829, '221004', 'San Martín', 'Tocache', 'Shunte', 'ACTIVO'),
(1830, '221005', 'San Martín', 'Tocache', 'Uchiza', 'ACTIVO'),
(1831, '221006', 'San Martín', 'Tocache', 'Santa Lucia', 'ACTIVO'),
(1832, '230101', 'Tacna', 'Tacna', 'Tacna', 'ACTIVO'),
(1833, '230102', 'Tacna', 'Tacna', 'Alto de La Alianza', 'ACTIVO'),
(1834, '230103', 'Tacna', 'Tacna', 'Calana', 'ACTIVO'),
(1835, '230104', 'Tacna', 'Tacna', 'Ciudad Nueva', 'ACTIVO'),
(1836, '230105', 'Tacna', 'Tacna', 'Inclán', 'ACTIVO'),
(1837, '230106', 'Tacna', 'Tacna', 'Pachia', 'ACTIVO'),
(1838, '230107', 'Tacna', 'Tacna', 'Palca', 'ACTIVO'),
(1839, '230108', 'Tacna', 'Tacna', 'Pocollay', 'ACTIVO'),
(1840, '230109', 'Tacna', 'Tacna', 'Sama', 'ACTIVO'),
(1841, '230110', 'Tacna', 'Tacna', 'Coronel Gregorio Albarracin Lanchipa', 'ACTIVO'),
(1842, '230111', 'Tacna', 'Tacna', 'La Yarada los Palos', 'ACTIVO'),
(1843, '230201', 'Tacna', 'Candarave', 'Candarave', 'ACTIVO'),
(1844, '230202', 'Tacna', 'Candarave', 'Cairani', 'ACTIVO'),
(1845, '230203', 'Tacna', 'Candarave', 'Camilaca', 'ACTIVO'),
(1846, '230204', 'Tacna', 'Candarave', 'Curibaya', 'ACTIVO'),
(1847, '230205', 'Tacna', 'Candarave', 'Huanuara', 'ACTIVO'),
(1848, '230206', 'Tacna', 'Candarave', 'Quilahuani', 'ACTIVO'),
(1849, '230301', 'Tacna', 'Jorge Basadre', 'Locumba', 'ACTIVO'),
(1850, '230302', 'Tacna', 'Jorge Basadre', 'Ilabaya', 'ACTIVO'),
(1851, '230303', 'Tacna', 'Jorge Basadre', 'Ite', 'ACTIVO'),
(1852, '230401', 'Tacna', 'Tarata', 'Tarata', 'ACTIVO'),
(1853, '230402', 'Tacna', 'Tarata', 'Héroes Albarracín', 'ACTIVO'),
(1854, '230403', 'Tacna', 'Tarata', 'Estique', 'ACTIVO'),
(1855, '230404', 'Tacna', 'Tarata', 'Estique-Pampa', 'ACTIVO'),
(1856, '230405', 'Tacna', 'Tarata', 'Sitajara', 'ACTIVO'),
(1857, '230406', 'Tacna', 'Tarata', 'Susapaya', 'ACTIVO'),
(1858, '230407', 'Tacna', 'Tarata', 'Tarucachi', 'ACTIVO'),
(1859, '230408', 'Tacna', 'Tarata', 'Ticaco', 'ACTIVO'),
(1860, '240101', 'Tumbes', 'Tumbes', 'Tumbes', 'ACTIVO'),
(1861, '240102', 'Tumbes', 'Tumbes', 'Corrales', 'ACTIVO'),
(1862, '240103', 'Tumbes', 'Tumbes', 'La Cruz', 'ACTIVO'),
(1863, '240104', 'Tumbes', 'Tumbes', 'Pampas de Hospital', 'ACTIVO'),
(1864, '240105', 'Tumbes', 'Tumbes', 'San Jacinto', 'ACTIVO'),
(1865, '240106', 'Tumbes', 'Tumbes', 'San Juan de La Virgen', 'ACTIVO'),
(1866, '240201', 'Tumbes', 'Contralmirante Villar', 'Zorritos', 'ACTIVO'),
(1867, '240202', 'Tumbes', 'Contralmirante Villar', 'Casitas', 'ACTIVO'),
(1868, '240203', 'Tumbes', 'Contralmirante Villar', 'Canoas de Punta Sal', 'ACTIVO'),
(1869, '240301', 'Tumbes', 'Zarumilla', 'Zarumilla', 'ACTIVO'),
(1870, '240302', 'Tumbes', 'Zarumilla', 'Aguas Verdes', 'ACTIVO'),
(1871, '240303', 'Tumbes', 'Zarumilla', 'Matapalo', 'ACTIVO'),
(1872, '240304', 'Tumbes', 'Zarumilla', 'Papayal', 'ACTIVO'),
(1873, '250101', 'Ucayali', 'Coronel Portillo', 'Calleria', 'ACTIVO'),
(1874, '250102', 'Ucayali', 'Coronel Portillo', 'Campoverde', 'ACTIVO'),
(1875, '250103', 'Ucayali', 'Coronel Portillo', 'Iparia', 'ACTIVO'),
(1876, '250104', 'Ucayali', 'Coronel Portillo', 'Masisea', 'ACTIVO'),
(1877, '250105', 'Ucayali', 'Coronel Portillo', 'Yarinacocha', 'ACTIVO'),
(1878, '250106', 'Ucayali', 'Coronel Portillo', 'Nueva Requena', 'ACTIVO'),
(1879, '250107', 'Ucayali', 'Coronel Portillo', 'Manantay', 'ACTIVO'),
(1880, '250201', 'Ucayali', 'Atalaya', 'Raimondi', 'ACTIVO'),
(1881, '250202', 'Ucayali', 'Atalaya', 'Sepahua', 'ACTIVO'),
(1882, '250203', 'Ucayali', 'Atalaya', 'Tahuania', 'ACTIVO'),
(1883, '250204', 'Ucayali', 'Atalaya', 'Yurua', 'ACTIVO'),
(1884, '250301', 'Ucayali', 'Padre Abad', 'Padre Abad', 'ACTIVO'),
(1885, '250302', 'Ucayali', 'Padre Abad', 'Irazola', 'ACTIVO'),
(1886, '250303', 'Ucayali', 'Padre Abad', 'Curimaná', 'ACTIVO'),
(1887, '250304', 'Ucayali', 'Padre Abad', 'Neshuya', 'ACTIVO'),
(1888, '250305', 'Ucayali', 'Padre Abad', 'Alexander Von Humboldt', 'ACTIVO'),
(1889, '250306', 'Ucayali', 'Padre Abad', 'Huipoca', 'ACTIVO'),
(1890, '250307', 'Ucayali', 'Padre Abad', 'Boquerón', 'ACTIVO'),
(1891, '250401', 'Ucayali', 'Purús', 'Purús', 'ACTIVO');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id_usuario` bigint(20) UNSIGNED NOT NULL,
  `codigo_usuario` varchar(20) NOT NULL,
  `tipo_documento` enum('DNI','RUC','CE','PASAPORTE','OTRO') NOT NULL DEFAULT 'DNI',
  `numero_documento` varchar(20) NOT NULL,
  `nombres` varchar(100) NOT NULL,
  `apellido_paterno` varchar(80) DEFAULT NULL,
  `apellido_materno` varchar(80) DEFAULT NULL,
  `telefono` varchar(20) NOT NULL,
  `usa_whatsapp` tinyint(1) NOT NULL DEFAULT 1,
  `correo` varchar(150) DEFAULT NULL,
  `password_hash` varchar(255) NOT NULL,
  `telefono_verificado` tinyint(1) NOT NULL DEFAULT 0,
  `correo_verificado` tinyint(1) NOT NULL DEFAULT 0,
  `origen_registro` enum('WEB','CAPACITACION','ASISTIDO','REFERIDO') NOT NULL DEFAULT 'WEB',
  `id_usuario_registro_asistido` bigint(20) UNSIGNED DEFAULT NULL,
  `estado` enum('ACTIVO','INACTIVO','BLOQUEADO','PENDIENTE') NOT NULL DEFAULT 'PENDIENTE',
  `fecha_registro` datetime NOT NULL DEFAULT current_timestamp(),
  `ultimo_acceso` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id_usuario`, `codigo_usuario`, `tipo_documento`, `numero_documento`, `nombres`, `apellido_paterno`, `apellido_materno`, `telefono`, `usa_whatsapp`, `correo`, `password_hash`, `telefono_verificado`, `correo_verificado`, `origen_registro`, `id_usuario_registro_asistido`, `estado`, `fecha_registro`, `ultimo_acceso`) VALUES
(1, 'USR-63308789', 'DNI', '63308789', 'Ana Paola', 'Espinoza', NULL, '000000000', 1, 'anaespinozalopez02@gmail.com', 'scrypt:32768:8:1$6oCf75RMVI2TMUbt$9113946c3e0addfd8e2e2fbf9b1b9f9af00ab8a30516d5823058537abe982d91de3f4beb645332371faa7eec6274932c1c49da7ecb72e24be2f217191499fe3d', 0, 0, 'WEB', NULL, 'ACTIVO', '2026-10-01 20:02:55', '2026-10-27 11:58:54'),
(2, 'USR-63308790', 'DNI', '60257142', 'Alan', 'Balbin', 'Casas', '916711760', 1, 'gbalbincasas@gmail.com', 'scrypt:32768:8:1$loDlswfNSNXcb2JB$671971765fad04dfc131c4c56bbcfc4d55bcf0ff15b96bb627ca74646ef551609e6dfdf26d6b87c7a9965c7e07fea5670756a6e4d823b77211da863b4615cbb9', 0, 0, 'WEB', NULL, 'ACTIVO', '2026-10-01 21:39:09', '2026-10-22 19:12:38'),
(3, 'USR-63308791', 'DNI', '76063183', 'xiomi', 'Espinoza', 'Lopez', '991745518', 1, 'xiomi@gmail.com', 'scrypt:32768:8:1$onXGhGLsynI9dDIM$512bf2800eebfd9d8d660c18a1a743d3c12e54616bfe192621e5be05bcb03d9bbbcfbb81a808c7120d91ef8a655d4e0ab7199c408cb8fee312689391bc217ffc', 0, 0, 'WEB', NULL, 'ACTIVO', '2026-10-01 21:47:22', '2026-10-05 22:02:13');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios_roles`
--

CREATE TABLE `usuarios_roles` (
  `id_usuario_rol` bigint(20) UNSIGNED NOT NULL,
  `id_usuario` bigint(20) UNSIGNED NOT NULL,
  `id_rol` smallint(5) UNSIGNED NOT NULL,
  `fecha_asignacion` datetime NOT NULL DEFAULT current_timestamp(),
  `estado` enum('ACTIVO','INACTIVO') NOT NULL DEFAULT 'ACTIVO'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `usuarios_roles`
--

INSERT INTO `usuarios_roles` (`id_usuario_rol`, `id_usuario`, `id_rol`, `fecha_asignacion`, `estado`) VALUES
(1, 1, 2, '2026-10-01 20:02:55', 'ACTIVO'),
(2, 2, 7, '2026-10-01 21:39:09', 'ACTIVO'),
(3, 3, 8, '2026-10-01 21:47:22', 'ACTIVO');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `valorizaciones`
--

CREATE TABLE `valorizaciones` (
  `id_valorizacion` bigint(20) UNSIGNED NOT NULL,
  `codigo_valorizacion` varchar(24) NOT NULL,
  `id_solicitud` bigint(20) UNSIGNED NOT NULL,
  `modo_calculo` enum('AUTOMATICO','MONTO_FIJO') NOT NULL DEFAULT 'AUTOMATICO',
  `precio_actual` decimal(12,4) DEFAULT NULL,
  `precio_promedio` decimal(12,4) DEFAULT NULL,
  `peso_actual` decimal(6,3) DEFAULT NULL,
  `peso_historico` decimal(6,3) DEFAULT NULL,
  `factor_zona` decimal(8,4) DEFAULT NULL,
  `factor_temporada` decimal(8,4) DEFAULT NULL,
  `factor_condicion` decimal(8,4) DEFAULT NULL,
  `precio_base` decimal(12,4) DEFAULT NULL,
  `precio_ajustado` decimal(12,4) DEFAULT NULL,
  `produccion_estimada` decimal(14,2) DEFAULT NULL,
  `valor_lote` decimal(14,2) NOT NULL,
  `monto_fijo` decimal(14,2) DEFAULT NULL,
  `motivo_monto_fijo` varchar(500) DEFAULT NULL,
  `fecha_calculo` datetime NOT NULL DEFAULT current_timestamp(),
  `fecha_presentacion` datetime DEFAULT NULL,
  `fecha_respuesta` datetime DEFAULT NULL,
  `id_usuario_respuesta` bigint(20) UNSIGNED DEFAULT NULL,
  `respuesta_productor` enum('PENDIENTE','ACEPTADA','SOLICITA_REVISION','RECHAZADA') NOT NULL DEFAULT 'PENDIENTE',
  `estado` enum('BORRADOR','CALCULADA','PRESENTADA','ACEPTADA','RECHAZADA','ANULADA') NOT NULL DEFAULT 'CALCULADA'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `valorizaciones`
--

INSERT INTO `valorizaciones` (`id_valorizacion`, `codigo_valorizacion`, `id_solicitud`, `modo_calculo`, `precio_actual`, `precio_promedio`, `peso_actual`, `peso_historico`, `factor_zona`, `factor_temporada`, `factor_condicion`, `precio_base`, `precio_ajustado`, `produccion_estimada`, `valor_lote`, `monto_fijo`, `motivo_monto_fijo`, `fecha_calculo`, `fecha_presentacion`, `fecha_respuesta`, `id_usuario_respuesta`, `respuesta_productor`, `estado`) VALUES
(1, 'VAL-00001', 1, 'AUTOMATICO', 1.0400, 0.8467, 60.000, 40.000, 1.0000, 1.0000, 1.0000, 0.9627, 0.9627, 4000.00, 3850.67, NULL, NULL, '2026-10-02 21:14:57', '2026-10-01 21:54:49', '2026-10-01 21:54:49', 1, 'ACEPTADA', 'CALCULADA'),
(2, 'VAL-00002', 2, 'AUTOMATICO', 0.0000, 0.0000, 60.000, 40.000, 1.0000, 1.0000, 1.0000, 0.0000, 0.0000, 50000.00, 0.00, NULL, NULL, '2026-10-02 19:42:37', '2026-10-02 19:39:39', '2026-10-02 19:39:39', 1, 'ACEPTADA', 'CALCULADA'),
(3, 'VAL-00003', 3, 'AUTOMATICO', 4.3500, 4.3500, 60.000, 40.000, 1.0000, 1.0000, 1.0000, 4.3500, 4.3500, 200000.00, 870000.00, NULL, NULL, '2026-10-27 12:42:02', '2026-10-02 21:21:07', '2026-10-02 21:21:07', 1, 'ACEPTADA', 'CALCULADA');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `variedades`
--

CREATE TABLE `variedades` (
  `id_variedad` int(10) UNSIGNED NOT NULL,
  `id_producto` int(10) UNSIGNED NOT NULL,
  `nombre` varchar(120) NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `estado` enum('ACTIVO','INACTIVO') NOT NULL DEFAULT 'ACTIVO'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `variedades`
--

INSERT INTO `variedades` (`id_variedad`, `id_producto`, `nombre`, `descripcion`, `estado`) VALUES
(1, 1, 'Yungay', NULL, 'ACTIVO'),
(2, 1, 'Única', NULL, 'ACTIVO'),
(3, 1, 'Canchán', NULL, 'ACTIVO'),
(4, 1, 'Peruanita', NULL, 'ACTIVO'),
(5, 1, 'Huayro', NULL, 'ACTIVO'),
(6, 1, 'Camotillo', NULL, 'ACTIVO'),
(7, 1, 'Tumbay', NULL, 'ACTIVO'),
(8, 1, 'Otra', NULL, 'ACTIVO'),
(9, 1, 'No sé', NULL, 'ACTIVO'),
(19, 3, 'INIA 606 Choclero Prolífico', 'Variedad INIA de choclo', 'ACTIVO'),
(20, 3, 'INIA 603 Choclero', 'Variedad INIA de choclo', 'ACTIVO'),
(21, 3, 'No especificada', 'Variedad pendiente de confirmar', 'ACTIVO'),
(22, 4, 'Morado', 'Cultivar comercial', 'ACTIVO'),
(23, 4, 'Criollo/Napurí', 'Cultivar comercial', 'ACTIVO'),
(24, 4, 'Barranquino', 'Cultivar comercial', 'ACTIVO'),
(25, 4, 'Massone', 'Cultivar comercial', 'ACTIVO'),
(26, 4, 'Chino', 'Cultivar comercial', 'ACTIVO'),
(27, 4, 'Cincomesino', 'Cultivar precoz validado por INIA', 'ACTIVO'),
(28, 4, 'No especificada', 'Variedad pendiente de confirmar', 'ACTIVO'),
(29, 6, 'INIA 101', 'Cultivar INIA adaptado a sierra central', 'ACTIVO'),
(30, 6, 'No especificada', 'Variedad pendiente de confirmar', 'ACTIVO'),
(31, 16, 'Blanca de Junín', 'Variedad comercial de Junín', 'ACTIVO'),
(32, 16, 'Hualhuas', 'Variedad comercial de Junín', 'ACTIVO'),
(33, 16, 'Huancayo', 'Variedad comercial de Junín', 'ACTIVO'),
(34, 16, 'Mantaro', 'Variedad comercial de sierra central', 'ACTIVO'),
(35, 16, 'Rosada Junín', 'Variedad comercial de Junín', 'ACTIVO'),
(36, 16, 'INIA 438 Acollina', 'Variedad desarrollada en Junín', 'ACTIVO'),
(37, 16, 'No especificada', 'Variedad pendiente de confirmar', 'ACTIVO'),
(38, 14, 'INIA 103 Remate', 'Variedad adaptada al Valle del Mantaro', 'ACTIVO'),
(39, 14, 'Usui', 'Variedad comercial', 'ACTIVO'),
(40, 14, 'No especificada', 'Variedad pendiente de confirmar', 'ACTIVO'),
(41, 15, 'INIA 401 Cusco', 'Variedad INIA para sierra', 'ACTIVO'),
(42, 15, 'Patona', 'Cultivar referenciado por INIA', 'ACTIVO'),
(43, 15, 'No especificada', 'Variedad pendiente de confirmar', 'ACTIVO'),
(44, 11, 'No especificada', 'Variedad genérica para registro inicial', 'ACTIVO'),
(45, 5, 'No especificada', 'Variedad genérica para registro inicial', 'ACTIVO'),
(46, 10, 'No especificada', 'Variedad genérica para registro inicial', 'ACTIVO'),
(47, 7, 'No especificada', 'Variedad genérica para registro inicial', 'ACTIVO'),
(48, 9, 'No especificada', 'Variedad genérica para registro inicial', 'ACTIVO'),
(49, 8, 'No especificada', 'Variedad genérica para registro inicial', 'ACTIVO'),
(50, 2, 'No especificada', 'Variedad genérica para registro inicial', 'ACTIVO'),
(51, 12, 'No especificada', 'Variedad genérica para registro inicial', 'ACTIVO'),
(52, 13, 'No especificada', 'Variedad genérica para registro inicial', 'ACTIVO');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vehiculos`
--

CREATE TABLE `vehiculos` (
  `id_vehiculo` bigint(20) UNSIGNED NOT NULL,
  `id_transportista` bigint(20) UNSIGNED NOT NULL,
  `placa` varchar(12) NOT NULL,
  `tipo` varchar(80) NOT NULL,
  `capacidad_kg` decimal(12,2) NOT NULL,
  `rendimiento_km_galon` decimal(10,2) DEFAULT NULL,
  `disponibilidad` enum('DISPONIBLE','ASIGNADO','OCUPADO','NO_DISPONIBLE') NOT NULL DEFAULT 'DISPONIBLE',
  `estado` enum('ACTIVO','INACTIVO') NOT NULL DEFAULT 'ACTIVO'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `verificaciones`
--

CREATE TABLE `verificaciones` (
  `id_verificacion` bigint(20) UNSIGNED NOT NULL,
  `codigo_verificacion` varchar(20) NOT NULL,
  `id_solicitud` bigint(20) UNSIGNED NOT NULL,
  `id_verificador` bigint(20) UNSIGNED NOT NULL,
  `fecha_programada` datetime DEFAULT NULL,
  `fecha_realizada` datetime DEFAULT NULL,
  `latitud` decimal(10,7) DEFAULT NULL,
  `longitud` decimal(10,7) DEFAULT NULL,
  `id_ubigeo` int(10) UNSIGNED DEFAULT NULL,
  `area_observada` decimal(10,2) DEFAULT NULL,
  `estado_cultivo` varchar(120) DEFAULT NULL,
  `etapa_productiva` varchar(120) DEFAULT NULL,
  `produccion_min_estimada` decimal(12,2) DEFAULT NULL,
  `produccion_max_estimada` decimal(12,2) DEFAULT NULL,
  `fecha_cosecha_verificada_inicio` date DEFAULT NULL,
  `fecha_cosecha_verificada_fin` date DEFAULT NULL,
  `observaciones` text DEFAULT NULL,
  `resultado` enum('APROBADO','OBSERVADO','REQUIERE_REEVALUACION','RECHAZADO') DEFAULT NULL,
  `estado` enum('PROGRAMADA','EN_PROCESO','COMPLETADA','CANCELADA') NOT NULL DEFAULT 'PROGRAMADA'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `verificaciones`
--

INSERT INTO `verificaciones` (`id_verificacion`, `codigo_verificacion`, `id_solicitud`, `id_verificador`, `fecha_programada`, `fecha_realizada`, `latitud`, `longitud`, `id_ubigeo`, `area_observada`, `estado_cultivo`, `etapa_productiva`, `produccion_min_estimada`, `produccion_max_estimada`, `fecha_cosecha_verificada_inicio`, `fecha_cosecha_verificada_fin`, `observaciones`, `resultado`, `estado`) VALUES
(1, 'VER-00001', 2, 1, '2026-10-02 19:39:40', '2026-10-02 21:21:02', NULL, NULL, NULL, NULL, 'BUENO', 'CULTIVO_ACTIVO', 100.00, 200.00, NULL, NULL, NULL, 'OBSERVADO', 'COMPLETADA'),
(2, 'VER-00002', 3, 1, '2026-10-02 21:21:07', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'PROGRAMADA');

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vw_combustible_logistica_actual`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vw_combustible_logistica_actual` (
`id_precio_combustible` bigint(20) unsigned
,`combustible` varchar(80)
,`departamento` varchar(100)
,`provincia` varchar(100)
,`distrito` varchar(100)
,`precio_galon` decimal(10,2)
,`fuente` varchar(255)
,`fecha_precio` date
,`calidad_dato` enum('OFICIAL','REFERENCIAL','ESTIMADO_MVP')
,`estado` enum('ACTIVO','INACTIVO')
,`creado_en` datetime
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vw_cosecha_demo_1ha`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vw_cosecha_demo_1ha` (
`producto` varchar(100)
,`calidad_dato` varchar(12)
,`jornales_referenciales_ha` decimal(10,2)
,`trabajadores_para_1_dia` int(10)
,`jornal_diario` decimal(10,2)
,`costo_mano_obra` decimal(19,2)
,`costo_carga_tonelada` decimal(12,2)
,`costo_acondicionamiento_tonelada` decimal(12,2)
,`otros_costos_base` decimal(12,2)
,`costo_base_sin_volumen` decimal(20,2)
,`fuente` varchar(180)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vw_parametros_cosecha_demo`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vw_parametros_cosecha_demo` (
`id_parametro_cosecha` bigint(20) unsigned
,`id_producto` int(10) unsigned
,`producto` varchar(100)
,`jornales_referenciales_ha` decimal(10,2)
,`jornal_diario` decimal(10,2)
,`costo_carga_tonelada` decimal(12,2)
,`costo_acondicionamiento_tonelada` decimal(12,2)
,`otros_costos_base` decimal(12,2)
,`duracion_objetivo_dias` tinyint(3) unsigned
,`calidad_dato` varchar(12)
,`fuente` varchar(180)
,`url_fuente` varchar(500)
,`fecha_fuente` date
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vw_precio_referencia_actual`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vw_precio_referencia_actual` (
`id_producto` int(10) unsigned
,`producto` varchar(100)
,`id_variedad` int(10) unsigned
,`variedad` varchar(120)
,`precio_actual` decimal(12,4)
,`fecha_precio_actual` date
,`promedio_30_dias` decimal(16,8)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vw_vehiculos_logistica`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vw_vehiculos_logistica` (
`id_tipo_vehiculo` int(10) unsigned
,`codigo` varchar(30)
,`nombre` varchar(100)
,`configuracion_mtc` varchar(20)
,`capacidad_util_kg` decimal(12,2)
,`rendimiento_km_galon` decimal(10,2)
,`costo_operativo_km` decimal(10,2)
,`costo_fijo_viaje` decimal(12,2)
,`calidad_dato` enum('LEGAL_REFERENCIAL','REFERENCIAL','ESTIMADO_MVP')
,`fuente_capacidad` varchar(255)
,`fuente_parametros` varchar(255)
);

-- --------------------------------------------------------

--
-- Estructura para la vista `vw_combustible_logistica_actual`
--
DROP TABLE IF EXISTS `vw_combustible_logistica_actual`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_combustible_logistica_actual`  AS SELECT `pc`.`id_precio_combustible` AS `id_precio_combustible`, `pc`.`combustible` AS `combustible`, `pc`.`departamento` AS `departamento`, `pc`.`provincia` AS `provincia`, `pc`.`distrito` AS `distrito`, `pc`.`precio_galon` AS `precio_galon`, `pc`.`fuente` AS `fuente`, `pc`.`fecha_precio` AS `fecha_precio`, `pc`.`calidad_dato` AS `calidad_dato`, `pc`.`estado` AS `estado`, `pc`.`creado_en` AS `creado_en` FROM `precios_combustible_logistica` AS `pc` WHERE `pc`.`estado` = 'ACTIVO' AND `pc`.`id_precio_combustible` = (select `pc2`.`id_precio_combustible` from `precios_combustible_logistica` `pc2` where `pc2`.`combustible` = `pc`.`combustible` AND coalesce(`pc2`.`departamento`,'') = coalesce(`pc`.`departamento`,'') AND coalesce(`pc2`.`provincia`,'') = coalesce(`pc`.`provincia`,'') AND coalesce(`pc2`.`distrito`,'') = coalesce(`pc`.`distrito`,'') AND `pc2`.`estado` = 'ACTIVO' order by `pc2`.`fecha_precio` desc,`pc2`.`id_precio_combustible` desc limit 1) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vw_cosecha_demo_1ha`
--
DROP TABLE IF EXISTS `vw_cosecha_demo_1ha`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_cosecha_demo_1ha`  AS SELECT `vw_parametros_cosecha_demo`.`producto` AS `producto`, `vw_parametros_cosecha_demo`.`calidad_dato` AS `calidad_dato`, `vw_parametros_cosecha_demo`.`jornales_referenciales_ha` AS `jornales_referenciales_ha`, ceiling(`vw_parametros_cosecha_demo`.`jornales_referenciales_ha`) AS `trabajadores_para_1_dia`, `vw_parametros_cosecha_demo`.`jornal_diario` AS `jornal_diario`, ceiling(`vw_parametros_cosecha_demo`.`jornales_referenciales_ha`) * `vw_parametros_cosecha_demo`.`jornal_diario` AS `costo_mano_obra`, `vw_parametros_cosecha_demo`.`costo_carga_tonelada` AS `costo_carga_tonelada`, `vw_parametros_cosecha_demo`.`costo_acondicionamiento_tonelada` AS `costo_acondicionamiento_tonelada`, `vw_parametros_cosecha_demo`.`otros_costos_base` AS `otros_costos_base`, ceiling(`vw_parametros_cosecha_demo`.`jornales_referenciales_ha`) * `vw_parametros_cosecha_demo`.`jornal_diario` + `vw_parametros_cosecha_demo`.`otros_costos_base` AS `costo_base_sin_volumen`, `vw_parametros_cosecha_demo`.`fuente` AS `fuente` FROM `vw_parametros_cosecha_demo` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vw_parametros_cosecha_demo`
--
DROP TABLE IF EXISTS `vw_parametros_cosecha_demo`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_parametros_cosecha_demo`  AS SELECT `pc`.`id_parametro_cosecha` AS `id_parametro_cosecha`, `p`.`id_producto` AS `id_producto`, `p`.`nombre` AS `producto`, `pc`.`jornales_referenciales_ha` AS `jornales_referenciales_ha`, `pc`.`jornal_diario` AS `jornal_diario`, `pc`.`costo_carga_tonelada` AS `costo_carga_tonelada`, `pc`.`costo_acondicionamiento_tonelada` AS `costo_acondicionamiento_tonelada`, `pc`.`otros_costos_base` AS `otros_costos_base`, `pc`.`duracion_objetivo_dias` AS `duracion_objetivo_dias`, CASE WHEN `pc`.`fuente` like '[OFICIAL%' THEN 'OFICIAL' WHEN `pc`.`fuente` like '[REFERENCIAL%' THEN 'REFERENCIAL' WHEN `pc`.`fuente` like '[ESTIMADO_MVP%' THEN 'ESTIMADO_MVP' ELSE 'MIXTO' END AS `calidad_dato`, `pc`.`fuente` AS `fuente`, `pc`.`url_fuente` AS `url_fuente`, `pc`.`fecha_fuente` AS `fecha_fuente` FROM (`parametros_cosecha` `pc` join `productos` `p` on(`p`.`id_producto` = `pc`.`id_producto`)) WHERE `pc`.`id_variedad` is null AND `pc`.`estado` = 'ACTIVO' AND `p`.`nombre` <> 'Otro' ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vw_precio_referencia_actual`
--
DROP TABLE IF EXISTS `vw_precio_referencia_actual`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_precio_referencia_actual`  AS SELECT `p`.`id_producto` AS `id_producto`, `p`.`nombre` AS `producto`, `v`.`id_variedad` AS `id_variedad`, `v`.`nombre` AS `variedad`, (select `pm1`.`precio` from `precios_mercado` `pm1` where `pm1`.`id_producto` = `p`.`id_producto` and (`pm1`.`id_variedad` = `v`.`id_variedad` or `v`.`id_variedad` is null and `pm1`.`id_variedad` is null) and `pm1`.`estado` = 'ACTIVO' order by `pm1`.`fecha_precio` desc,`pm1`.`id_precio` desc limit 1) AS `precio_actual`, (select `pm1`.`fecha_precio` from `precios_mercado` `pm1` where `pm1`.`id_producto` = `p`.`id_producto` and (`pm1`.`id_variedad` = `v`.`id_variedad` or `v`.`id_variedad` is null and `pm1`.`id_variedad` is null) and `pm1`.`estado` = 'ACTIVO' order by `pm1`.`fecha_precio` desc,`pm1`.`id_precio` desc limit 1) AS `fecha_precio_actual`, (select avg(`pm2`.`precio`) from `precios_mercado` `pm2` where `pm2`.`id_producto` = `p`.`id_producto` and (`pm2`.`id_variedad` = `v`.`id_variedad` or `v`.`id_variedad` is null and `pm2`.`id_variedad` is null) and `pm2`.`estado` = 'ACTIVO' and `pm2`.`fecha_precio` >= (select max(`pm3`.`fecha_precio`) from `precios_mercado` `pm3` where `pm3`.`id_producto` = `p`.`id_producto` and (`pm3`.`id_variedad` = `v`.`id_variedad` or `v`.`id_variedad` is null and `pm3`.`id_variedad` is null) and `pm3`.`estado` = 'ACTIVO') - interval 30 day) AS `promedio_30_dias` FROM (`productos` `p` left join `variedades` `v` on(`v`.`id_producto` = `p`.`id_producto`)) WHERE `p`.`estado` = 'ACTIVO' ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vw_vehiculos_logistica`
--
DROP TABLE IF EXISTS `vw_vehiculos_logistica`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_vehiculos_logistica`  AS SELECT `tipos_vehiculo_logistica`.`id_tipo_vehiculo` AS `id_tipo_vehiculo`, `tipos_vehiculo_logistica`.`codigo` AS `codigo`, `tipos_vehiculo_logistica`.`nombre` AS `nombre`, `tipos_vehiculo_logistica`.`configuracion_mtc` AS `configuracion_mtc`, `tipos_vehiculo_logistica`.`capacidad_util_kg` AS `capacidad_util_kg`, `tipos_vehiculo_logistica`.`rendimiento_km_galon` AS `rendimiento_km_galon`, `tipos_vehiculo_logistica`.`costo_operativo_km` AS `costo_operativo_km`, `tipos_vehiculo_logistica`.`costo_fijo_viaje` AS `costo_fijo_viaje`, `tipos_vehiculo_logistica`.`calidad_dato` AS `calidad_dato`, `tipos_vehiculo_logistica`.`fuente_capacidad` AS `fuente_capacidad`, `tipos_vehiculo_logistica`.`fuente_parametros` AS `fuente_parametros` FROM `tipos_vehiculo_logistica` WHERE `tipos_vehiculo_logistica`.`estado` = 'ACTIVO' ;

--
-- Tablas para cotizaciones y negociación entre productor y comprador
--
CREATE TABLE `cotizaciones_comerciales` (
  `id_cotizacion_comercial` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `codigo_cotizacion` varchar(24) NOT NULL,
  `id_lote` bigint(20) UNSIGNED NOT NULL,
  `id_comprador` bigint(20) UNSIGNED NOT NULL,
  `id_cotizacion_operacion` bigint(20) UNSIGNED DEFAULT NULL,
  `cantidad_kg` decimal(14,3) NOT NULL,
  `precio_unitario_kg` decimal(12,4) DEFAULT NULL,
  `version` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `ultimo_ofertante` enum('COMPRADOR','PRODUCTOR') DEFAULT NULL,
  `aceptacion_comprador_version` int(10) UNSIGNED DEFAULT NULL,
  `aceptacion_productor_version` int(10) UNSIGNED DEFAULT NULL,
  `estado` enum('PENDIENTE','NEGOCIACION','ACORDADA','RECHAZADA','CANCELADA') NOT NULL DEFAULT 'PENDIENTE',
  `fecha_creacion` datetime NOT NULL DEFAULT current_timestamp(),
  `fecha_actualizacion` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id_cotizacion_comercial`),
  UNIQUE KEY `codigo_cotizacion` (`codigo_cotizacion`),
  KEY `idx_cotizacion_comercial_lote_comprador_estado` (`id_lote`,`id_comprador`,`estado`),
  KEY `idx_cotizacion_comercial_fecha` (`fecha_actualizacion`,`estado`),
  KEY `idx_cotizacion_comercial_operacion` (`id_cotizacion_operacion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `mensajes_cotizacion_comercial` (
  `id_mensaje` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `id_cotizacion_comercial` bigint(20) UNSIGNED NOT NULL,
  `id_usuario` bigint(20) UNSIGNED NOT NULL,
  `tipo` enum('MENSAJE','OFERTA','SISTEMA') NOT NULL DEFAULT 'MENSAJE',
  `contenido` varchar(2000) NOT NULL,
  `precio_unitario_kg` decimal(12,4) DEFAULT NULL,
  `cantidad_kg` decimal(14,3) DEFAULT NULL,
  `version` int(10) UNSIGNED DEFAULT NULL,
  `fecha` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_mensaje`),
  KEY `idx_mensaje_cotizacion_fecha` (`id_cotizacion_comercial`,`fecha`,`id_mensaje`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `archivos`
--
ALTER TABLE `archivos`
  ADD PRIMARY KEY (`id_archivo`),
  ADD UNIQUE KEY `codigo_archivo` (`codigo_archivo`),
  ADD KEY `idx_archivos_entidad` (`entidad_tipo`,`entidad_id`),
  ADD KEY `idx_archivos_usuario` (`id_usuario_carga`);

--
-- Indices de la tabla `asignaciones_cuadrilla`
--
ALTER TABLE `asignaciones_cuadrilla`
  ADD PRIMARY KEY (`id_asignacion`),
  ADD UNIQUE KEY `uq_asignacion_cosecha_cuadrilla` (`id_cosecha`,`id_cuadrilla`),
  ADD KEY `fk_asignacion_cuadrilla` (`id_cuadrilla`);

--
-- Indices de la tabla `auditoria`
--
ALTER TABLE `auditoria`
  ADD PRIMARY KEY (`id_auditoria`),
  ADD KEY `idx_auditoria_entidad` (`entidad_tipo`,`entidad_id`),
  ADD KEY `idx_auditoria_usuario` (`id_usuario`),
  ADD KEY `idx_auditoria_fecha` (`fecha_hora`);

--
-- Indices de la tabla `beneficios`
--
ALTER TABLE `beneficios`
  ADD PRIMARY KEY (`id_beneficio`),
  ADD UNIQUE KEY `codigo_beneficio` (`codigo_beneficio`);

--
-- Indices de la tabla `calificaciones`
--
ALTER TABLE `calificaciones`
  ADD PRIMARY KEY (`id_calificacion`),
  ADD UNIQUE KEY `uq_calificacion_operacion_tipo` (`id_operacion`,`id_usuario_califica`,`tipo`),
  ADD KEY `fk_calificacion_emisor` (`id_usuario_califica`),
  ADD KEY `fk_calificacion_receptor` (`id_usuario_calificado`);

--
-- Indices de la tabla `campanas_agricolas`
--
ALTER TABLE `campanas_agricolas`
  ADD PRIMARY KEY (`id_campana`),
  ADD UNIQUE KEY `nombre` (`nombre`);

--
-- Indices de la tabla `canjes_beneficios`
--
ALTER TABLE `canjes_beneficios`
  ADD PRIMARY KEY (`id_canje`),
  ADD KEY `fk_canje_beneficio` (`id_beneficio`),
  ADD KEY `fk_canje_usuario` (`id_usuario`);

--
-- Indices de la tabla `capacitaciones`
--
ALTER TABLE `capacitaciones`
  ADD PRIMARY KEY (`id_capacitacion`),
  ADD UNIQUE KEY `codigo_capacitacion` (`codigo_capacitacion`);

--
-- Indices de la tabla `capacitacion_asistentes`
--
ALTER TABLE `capacitacion_asistentes`
  ADD PRIMARY KEY (`id_asistencia`),
  ADD UNIQUE KEY `uq_capacitacion_usuario` (`id_capacitacion`,`id_usuario`),
  ADD KEY `fk_cap_asistente_usuario` (`id_usuario`);

--
-- Indices de la tabla `categorias_producto`
--
ALTER TABLE `categorias_producto`
  ADD PRIMARY KEY (`id_categoria`),
  ADD UNIQUE KEY `nombre` (`nombre`);

--
-- Indices de la tabla `compradores`
--
ALTER TABLE `compradores`
  ADD PRIMARY KEY (`id_comprador`),
  ADD UNIQUE KEY `id_usuario` (`id_usuario`),
  ADD UNIQUE KEY `codigo_comprador` (`codigo_comprador`);

--
-- Indices de la tabla `contenidos_educativos`
--
ALTER TABLE `contenidos_educativos`
  ADD PRIMARY KEY (`id_contenido`),
  ADD KEY `idx_contenido_estado_fecha` (`estado`,`fecha_creacion`);

--
-- Indices de la tabla `cosechas`
--
ALTER TABLE `cosechas`
  ADD PRIMARY KEY (`id_cosecha`),
  ADD UNIQUE KEY `codigo_cosecha` (`codigo_cosecha`),
  ADD KEY `fk_cosecha_responsable` (`id_responsable`),
  ADD KEY `idx_cosecha_operacion` (`id_operacion`),
  ADD KEY `idx_cosecha_estado` (`estado`);

--
-- Indices de la tabla `cotizaciones_logisticas`
--
ALTER TABLE `cotizaciones_logisticas`
  ADD PRIMARY KEY (`id_cotizacion`),
  ADD UNIQUE KEY `codigo_cotizacion` (`codigo_cotizacion`),
  ADD KEY `idx_cot_logistica_operacion` (`id_cotizacion_operacion`);

--
-- Indices de la tabla `cotizaciones_operacion`
--
ALTER TABLE `cotizaciones_operacion`
  ADD PRIMARY KEY (`id_cotizacion_operacion`),
  ADD UNIQUE KEY `codigo_cotizacion` (`codigo_cotizacion`),
  ADD KEY `fk_cotizacion_direccion` (`id_direccion_entrega`),
  ADD KEY `idx_cotizacion_lote` (`id_lote`),
  ADD KEY `idx_cotizacion_comprador` (`id_comprador`),
  ADD KEY `idx_cotizacion_estado` (`estado`);

--
-- Indices de la tabla `cuadrillas`
--
ALTER TABLE `cuadrillas`
  ADD PRIMARY KEY (`id_cuadrilla`),
  ADD UNIQUE KEY `codigo_cuadrilla` (`codigo_cuadrilla`);

--
-- Indices de la tabla `datos_facturacion`
--
ALTER TABLE `datos_facturacion`
  ADD PRIMARY KEY (`id_facturacion`),
  ADD KEY `fk_facturacion_ubigeo` (`id_ubigeo`),
  ADD KEY `idx_facturacion_comprador` (`id_comprador`),
  ADD KEY `idx_facturacion_documento` (`tipo_documento`,`numero_documento`);

--
-- Indices de la tabla `devoluciones`
--
ALTER TABLE `devoluciones`
  ADD PRIMARY KEY (`id_devolucion`),
  ADD UNIQUE KEY `codigo_devolucion` (`codigo_devolucion`),
  ADD KEY `fk_devolucion_operacion` (`id_operacion`),
  ADD KEY `fk_devolucion_pago` (`id_pago`),
  ADD KEY `fk_devolucion_autoriza` (`id_usuario_autoriza`),
  ADD KEY `fk_devolucion_ejecuta` (`id_usuario_ejecuta`);

--
-- Indices de la tabla `direcciones_entrega`
--
ALTER TABLE `direcciones_entrega`
  ADD PRIMARY KEY (`id_direccion`),
  ADD KEY `fk_direccion_ubigeo` (`id_ubigeo`),
  ADD KEY `idx_direcciones_comprador` (`id_comprador`);

--
-- Indices de la tabla `entregas`
--
ALTER TABLE `entregas`
  ADD PRIMARY KEY (`id_entrega`),
  ADD UNIQUE KEY `codigo_entrega` (`codigo_entrega`),
  ADD KEY `fk_entrega_usuario` (`id_usuario_confirma`),
  ADD KEY `idx_entrega_operacion` (`id_operacion`),
  ADD KEY `idx_entrega_transporte` (`id_transporte`);

--
-- Indices de la tabla `historial_estados`
--
ALTER TABLE `historial_estados`
  ADD PRIMARY KEY (`id_historial`),
  ADD KEY `fk_historial_usuario` (`id_usuario`),
  ADD KEY `idx_historial_entidad` (`entidad_tipo`,`entidad_id`),
  ADD KEY `idx_historial_fecha` (`fecha`);

--
-- Indices de la tabla `incidencias`
--
ALTER TABLE `incidencias`
  ADD PRIMARY KEY (`id_incidencia`),
  ADD UNIQUE KEY `codigo_incidencia` (`codigo_incidencia`),
  ADD KEY `fk_incidencia_reporta` (`id_usuario_reporta`),
  ADD KEY `fk_incidencia_responsable` (`id_responsable`),
  ADD KEY `idx_incidencia_operacion` (`id_operacion`),
  ADD KEY `idx_incidencia_estado` (`estado`);

--
-- Indices de la tabla `liquidaciones`
--
ALTER TABLE `liquidaciones`
  ADD PRIMARY KEY (`id_liquidacion`),
  ADD UNIQUE KEY `codigo_liquidacion` (`codigo_liquidacion`),
  ADD KEY `fk_liquidacion_productor` (`id_productor_beneficiario`),
  ADD KEY `fk_liquidacion_cuadrilla` (`id_cuadrilla_beneficiaria`),
  ADD KEY `fk_liquidacion_transportista` (`id_transportista_beneficiario`),
  ADD KEY `idx_liquidacion_operacion` (`id_operacion`),
  ADD KEY `idx_liquidacion_estado` (`estado`);

--
-- Indices de la tabla `lotes`
--
ALTER TABLE `lotes`
  ADD PRIMARY KEY (`id_lote`),
  ADD UNIQUE KEY `codigo_lote` (`codigo_lote`),
  ADD KEY `fk_lote_solicitud` (`id_solicitud`),
  ADD KEY `fk_lote_valorizacion` (`id_valorizacion`),
  ADD KEY `idx_lotes_estado` (`estado`),
  ADD KEY `idx_lotes_cosecha` (`fecha_cosecha_inicio`,`fecha_cosecha_fin`);

--
-- Indices de la tabla `medios_pago_usuario`
--
ALTER TABLE `medios_pago_usuario`
  ADD PRIMARY KEY (`id_medio_pago`),
  ADD KEY `idx_medio_pago_usuario` (`id_usuario`);

--
-- Indices de la tabla `movimientos_puntos`
--
ALTER TABLE `movimientos_puntos`
  ADD PRIMARY KEY (`id_movimiento`),
  ADD KEY `fk_puntos_operacion` (`id_operacion`),
  ADD KEY `idx_puntos_usuario` (`id_usuario`);

--
-- Indices de la tabla `notificaciones`
--
ALTER TABLE `notificaciones`
  ADD PRIMARY KEY (`id_notificacion`),
  ADD KEY `idx_notificacion_usuario_leida` (`id_usuario`,`leida`),
  ADD KEY `idx_notificacion_fecha` (`fecha`);

--
-- Indices de la tabla `operaciones`
--
ALTER TABLE `operaciones`
  ADD PRIMARY KEY (`id_operacion`),
  ADD UNIQUE KEY `codigo_operacion` (`codigo_operacion`),
  ADD UNIQUE KEY `id_cotizacion_operacion` (`id_cotizacion_operacion`),
  ADD KEY `fk_operacion_direccion` (`id_direccion_entrega`),
  ADD KEY `idx_operacion_lote` (`id_lote`),
  ADD KEY `idx_operacion_productor` (`id_productor`),
  ADD KEY `idx_operacion_comprador` (`id_comprador`),
  ADD KEY `idx_operacion_estado` (`estado`),
  ADD KEY `idx_operacion_fecha` (`fecha_operacion`);

--
-- Indices de la tabla `ordenes_pago`
--
ALTER TABLE `ordenes_pago`
  ADD PRIMARY KEY (`id_orden_pago`),
  ADD UNIQUE KEY `codigo_orden_pago` (`codigo_orden_pago`),
  ADD KEY `fk_orden_solicita` (`id_usuario_solicita`),
  ADD KEY `fk_orden_autoriza` (`id_usuario_autoriza`),
  ADD KEY `fk_orden_ejecuta` (`id_usuario_ejecuta`),
  ADD KEY `idx_orden_liquidacion` (`id_liquidacion`),
  ADD KEY `idx_orden_estado` (`estado`);

--
-- Indices de la tabla `pagos`
--
ALTER TABLE `pagos`
  ADD PRIMARY KEY (`id_pago`),
  ADD UNIQUE KEY `codigo_pago` (`codigo_pago`),
  ADD KEY `idx_pago_operacion` (`id_operacion`),
  ADD KEY `idx_pago_estado` (`estado`),
  ADD KEY `idx_pago_facturacion` (`id_facturacion`);

--
-- Indices de la tabla `pagos_efectivo`
--
ALTER TABLE `pagos_efectivo`
  ADD PRIMARY KEY (`id_pago_efectivo`),
  ADD UNIQUE KEY `id_orden_pago` (`id_orden_pago`),
  ADD KEY `fk_pago_efectivo_usuario` (`id_usuario_entrega`);

--
-- Indices de la tabla `parametros_comerciales`
--
ALTER TABLE `parametros_comerciales`
  ADD PRIMARY KEY (`id_parametro`),
  ADD UNIQUE KEY `codigo` (`codigo`),
  ADD KEY `fk_param_comercial_usuario` (`id_usuario_actualiza`);

--
-- Indices de la tabla `parametros_cosecha`
--
ALTER TABLE `parametros_cosecha`
  ADD PRIMARY KEY (`id_parametro_cosecha`),
  ADD KEY `fk_param_cosecha_variedad` (`id_variedad`),
  ADD KEY `fk_param_cosecha_usuario` (`id_usuario_actualiza`),
  ADD KEY `idx_param_cosecha_producto_variedad` (`id_producto`,`id_variedad`);

--
-- Indices de la tabla `parametros_cultivo`
--
ALTER TABLE `parametros_cultivo`
  ADD PRIMARY KEY (`id_parametro_cultivo`),
  ADD KEY `fk_param_cultivo_variedad` (`id_variedad`),
  ADD KEY `fk_param_cultivo_usuario` (`id_usuario_actualiza`),
  ADD KEY `idx_param_cultivo_producto_variedad` (`id_producto`,`id_variedad`);

--
-- Indices de la tabla `parametros_logisticos`
--
ALTER TABLE `parametros_logisticos`
  ADD PRIMARY KEY (`id_parametro`),
  ADD UNIQUE KEY `codigo` (`codigo`),
  ADD KEY `fk_param_logistico_usuario` (`id_usuario_actualiza`);

--
-- Indices de la tabla `permisos`
--
ALTER TABLE `permisos`
  ADD PRIMARY KEY (`id_permiso`),
  ADD UNIQUE KEY `codigo` (`codigo`);

--
-- Indices de la tabla `precios_combustible_logistica`
--
ALTER TABLE `precios_combustible_logistica`
  ADD PRIMARY KEY (`id_precio_combustible`),
  ADD KEY `idx_combustible_fecha` (`combustible`,`fecha_precio`),
  ADD KEY `idx_combustible_zona` (`departamento`,`provincia`,`distrito`);

--
-- Indices de la tabla `precios_mercado`
--
ALTER TABLE `precios_mercado`
  ADD PRIMARY KEY (`id_precio`),
  ADD KEY `fk_precio_variedad` (`id_variedad`),
  ADD KEY `fk_precio_usuario` (`id_usuario_registro`),
  ADD KEY `idx_precio_producto_fecha` (`id_producto`,`id_variedad`,`fecha_precio`);

--
-- Indices de la tabla `predios`
--
ALTER TABLE `predios`
  ADD PRIMARY KEY (`id_predio`),
  ADD UNIQUE KEY `codigo_predio` (`codigo_predio`),
  ADD KEY `idx_predios_productor` (`id_productor`),
  ADD KEY `idx_predios_ubigeo` (`id_ubigeo`);

--
-- Indices de la tabla `productores`
--
ALTER TABLE `productores`
  ADD PRIMARY KEY (`id_productor`),
  ADD UNIQUE KEY `id_usuario` (`id_usuario`),
  ADD UNIQUE KEY `codigo_productor` (`codigo_productor`);

--
-- Indices de la tabla `productos`
--
ALTER TABLE `productos`
  ADD PRIMARY KEY (`id_producto`),
  ADD UNIQUE KEY `nombre` (`nombre`),
  ADD KEY `fk_productos_categoria` (`id_categoria`);

--
-- Indices de la tabla `publicaciones`
--
ALTER TABLE `publicaciones`
  ADD PRIMARY KEY (`id_publicacion`),
  ADD UNIQUE KEY `codigo_publicacion` (`codigo_publicacion`),
  ADD KEY `fk_publicacion_autor` (`id_autor`),
  ADD KEY `idx_publicaciones_estado_fecha` (`estado`,`fecha_publicacion`);

--
-- Indices de la tabla `referidos`
--
ALTER TABLE `referidos`
  ADD PRIMARY KEY (`id_referido`),
  ADD UNIQUE KEY `id_usuario_referido` (`id_usuario_referido`),
  ADD KEY `fk_referido_referidor` (`id_usuario_referidor`);

--
-- Indices de la tabla `reservas_lote`
--
ALTER TABLE `reservas_lote`
  ADD PRIMARY KEY (`id_reserva`),
  ADD KEY `fk_reserva_cotizacion` (`id_cotizacion_operacion`),
  ADD KEY `idx_reserva_lote_estado` (`id_lote`,`estado`),
  ADD KEY `idx_reserva_comprador` (`id_comprador`);

--
-- Indices de la tabla `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id_rol`),
  ADD UNIQUE KEY `nombre` (`nombre`);

--
-- Indices de la tabla `roles_permisos`
--
ALTER TABLE `roles_permisos`
  ADD PRIMARY KEY (`id_rol_permiso`),
  ADD UNIQUE KEY `uq_rol_permiso` (`id_rol`,`id_permiso`),
  ADD KEY `fk_roles_permisos_permiso` (`id_permiso`);

--
-- Indices de la tabla `solicitudes_lote`
--
ALTER TABLE `solicitudes_lote`
  ADD PRIMARY KEY (`id_solicitud`),
  ADD UNIQUE KEY `codigo_solicitud` (`codigo_solicitud`),
  ADD KEY `fk_solicitud_producto` (`id_producto`),
  ADD KEY `fk_solicitud_variedad` (`id_variedad`),
  ADD KEY `fk_solicitud_campana` (`id_campana`),
  ADD KEY `idx_solicitud_productor` (`id_productor`),
  ADD KEY `idx_solicitud_predio` (`id_predio`),
  ADD KEY `idx_solicitud_estado` (`estado`);

--
-- Indices de la tabla `tipos_vehiculo_logistica`
--
ALTER TABLE `tipos_vehiculo_logistica`
  ADD PRIMARY KEY (`id_tipo_vehiculo`),
  ADD UNIQUE KEY `codigo` (`codigo`);

--
-- Indices de la tabla `tokens_seguridad`
--
ALTER TABLE `tokens_seguridad`
  ADD PRIMARY KEY (`id_token`),
  ADD KEY `idx_tokens_usuario_tipo` (`id_usuario`,`tipo`),
  ADD KEY `idx_tokens_expiracion` (`fecha_expiracion`);

--
-- Indices de la tabla `transportes`
--
ALTER TABLE `transportes`
  ADD PRIMARY KEY (`id_transporte`),
  ADD UNIQUE KEY `codigo_transporte` (`codigo_transporte`),
  ADD KEY `fk_transporte_transportista` (`id_transportista`),
  ADD KEY `fk_transporte_vehiculo` (`id_vehiculo`),
  ADD KEY `idx_transporte_operacion` (`id_operacion`),
  ADD KEY `idx_transporte_estado` (`estado`);

--
-- Indices de la tabla `transportistas`
--
ALTER TABLE `transportistas`
  ADD PRIMARY KEY (`id_transportista`),
  ADD UNIQUE KEY `codigo_transportista` (`codigo_transportista`),
  ADD UNIQUE KEY `id_usuario` (`id_usuario`);

--
-- Indices de la tabla `ubicaciones_transporte`
--
ALTER TABLE `ubicaciones_transporte`
  ADD PRIMARY KEY (`id_ubicacion`),
  ADD UNIQUE KEY `uq_ubicaciones_transporte_transporte` (`id_transporte`);

--
-- Indices de la tabla `ubigeos`
--
ALTER TABLE `ubigeos`
  ADD PRIMARY KEY (`id_ubigeo`),
  ADD UNIQUE KEY `codigo_ubigeo` (`codigo_ubigeo`),
  ADD KEY `idx_ubigeos_departamento` (`departamento`),
  ADD KEY `idx_ubigeos_provincia` (`departamento`,`provincia`),
  ADD KEY `idx_ubigeos_distrito` (`departamento`,`provincia`,`distrito`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id_usuario`),
  ADD UNIQUE KEY `codigo_usuario` (`codigo_usuario`),
  ADD UNIQUE KEY `numero_documento` (`numero_documento`),
  ADD UNIQUE KEY `telefono` (`telefono`),
  ADD UNIQUE KEY `correo` (`correo`),
  ADD KEY `fk_usuarios_registro_asistido` (`id_usuario_registro_asistido`);

--
-- Indices de la tabla `usuarios_roles`
--
ALTER TABLE `usuarios_roles`
  ADD PRIMARY KEY (`id_usuario_rol`),
  ADD UNIQUE KEY `uq_usuario_rol` (`id_usuario`,`id_rol`),
  ADD KEY `fk_usuarios_roles_rol` (`id_rol`);

--
-- Indices de la tabla `valorizaciones`
--
ALTER TABLE `valorizaciones`
  ADD PRIMARY KEY (`id_valorizacion`),
  ADD UNIQUE KEY `codigo_valorizacion` (`codigo_valorizacion`),
  ADD KEY `fk_valorizacion_usuario_respuesta` (`id_usuario_respuesta`),
  ADD KEY `idx_valorizacion_solicitud` (`id_solicitud`);

--
-- Indices de la tabla `variedades`
--
ALTER TABLE `variedades`
  ADD PRIMARY KEY (`id_variedad`),
  ADD UNIQUE KEY `uq_variedad_producto` (`id_producto`,`nombre`);

--
-- Indices de la tabla `vehiculos`
--
ALTER TABLE `vehiculos`
  ADD PRIMARY KEY (`id_vehiculo`),
  ADD UNIQUE KEY `placa` (`placa`),
  ADD KEY `fk_vehiculo_transportista` (`id_transportista`);

--
-- Indices de la tabla `verificaciones`
--
ALTER TABLE `verificaciones`
  ADD PRIMARY KEY (`id_verificacion`),
  ADD UNIQUE KEY `codigo_verificacion` (`codigo_verificacion`),
  ADD KEY `fk_verificacion_ubigeo` (`id_ubigeo`),
  ADD KEY `idx_verificacion_solicitud` (`id_solicitud`),
  ADD KEY `idx_verificacion_verificador` (`id_verificador`),
  ADD KEY `idx_verificacion_estado` (`estado`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `archivos`
--
ALTER TABLE `archivos`
  MODIFY `id_archivo` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `asignaciones_cuadrilla`
--
ALTER TABLE `asignaciones_cuadrilla`
  MODIFY `id_asignacion` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `auditoria`
--
ALTER TABLE `auditoria`
  MODIFY `id_auditoria` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `beneficios`
--
ALTER TABLE `beneficios`
  MODIFY `id_beneficio` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `calificaciones`
--
ALTER TABLE `calificaciones`
  MODIFY `id_calificacion` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `campanas_agricolas`
--
ALTER TABLE `campanas_agricolas`
  MODIFY `id_campana` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `canjes_beneficios`
--
ALTER TABLE `canjes_beneficios`
  MODIFY `id_canje` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `capacitaciones`
--
ALTER TABLE `capacitaciones`
  MODIFY `id_capacitacion` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `capacitacion_asistentes`
--
ALTER TABLE `capacitacion_asistentes`
  MODIFY `id_asistencia` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `categorias_producto`
--
ALTER TABLE `categorias_producto`
  MODIFY `id_categoria` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de la tabla `compradores`
--
ALTER TABLE `compradores`
  MODIFY `id_comprador` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `contenidos_educativos`
--
ALTER TABLE `contenidos_educativos`
  MODIFY `id_contenido` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `cosechas`
--
ALTER TABLE `cosechas`
  MODIFY `id_cosecha` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `cotizaciones_logisticas`
--
ALTER TABLE `cotizaciones_logisticas`
  MODIFY `id_cotizacion` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `cotizaciones_operacion`
--
ALTER TABLE `cotizaciones_operacion`
  MODIFY `id_cotizacion_operacion` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `cuadrillas`
--
ALTER TABLE `cuadrillas`
  MODIFY `id_cuadrilla` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `datos_facturacion`
--
ALTER TABLE `datos_facturacion`
  MODIFY `id_facturacion` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `devoluciones`
--
ALTER TABLE `devoluciones`
  MODIFY `id_devolucion` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `direcciones_entrega`
--
ALTER TABLE `direcciones_entrega`
  MODIFY `id_direccion` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `entregas`
--
ALTER TABLE `entregas`
  MODIFY `id_entrega` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `historial_estados`
--
ALTER TABLE `historial_estados`
  MODIFY `id_historial` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `incidencias`
--
ALTER TABLE `incidencias`
  MODIFY `id_incidencia` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `liquidaciones`
--
ALTER TABLE `liquidaciones`
  MODIFY `id_liquidacion` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `lotes`
--
ALTER TABLE `lotes`
  MODIFY `id_lote` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `medios_pago_usuario`
--
ALTER TABLE `medios_pago_usuario`
  MODIFY `id_medio_pago` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `movimientos_puntos`
--
ALTER TABLE `movimientos_puntos`
  MODIFY `id_movimiento` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `notificaciones`
--
ALTER TABLE `notificaciones`
  MODIFY `id_notificacion` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `operaciones`
--
ALTER TABLE `operaciones`
  MODIFY `id_operacion` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `ordenes_pago`
--
ALTER TABLE `ordenes_pago`
  MODIFY `id_orden_pago` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `pagos`
--
ALTER TABLE `pagos`
  MODIFY `id_pago` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `pagos_efectivo`
--
ALTER TABLE `pagos_efectivo`
  MODIFY `id_pago_efectivo` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `parametros_comerciales`
--
ALTER TABLE `parametros_comerciales`
  MODIFY `id_parametro` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT de la tabla `parametros_cosecha`
--
ALTER TABLE `parametros_cosecha`
  MODIFY `id_parametro_cosecha` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT de la tabla `parametros_cultivo`
--
ALTER TABLE `parametros_cultivo`
  MODIFY `id_parametro_cultivo` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT de la tabla `parametros_logisticos`
--
ALTER TABLE `parametros_logisticos`
  MODIFY `id_parametro` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `permisos`
--
ALTER TABLE `permisos`
  MODIFY `id_permiso` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT de la tabla `precios_combustible_logistica`
--
ALTER TABLE `precios_combustible_logistica`
  MODIFY `id_precio_combustible` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `precios_mercado`
--
ALTER TABLE `precios_mercado`
  MODIFY `id_precio` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT de la tabla `predios`
--
ALTER TABLE `predios`
  MODIFY `id_predio` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `productores`
--
ALTER TABLE `productores`
  MODIFY `id_productor` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `productos`
--
ALTER TABLE `productos`
  MODIFY `id_producto` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- AUTO_INCREMENT de la tabla `publicaciones`
--
ALTER TABLE `publicaciones`
  MODIFY `id_publicacion` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `referidos`
--
ALTER TABLE `referidos`
  MODIFY `id_referido` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `reservas_lote`
--
ALTER TABLE `reservas_lote`
  MODIFY `id_reserva` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `roles`
--
ALTER TABLE `roles`
  MODIFY `id_rol` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `roles_permisos`
--
ALTER TABLE `roles_permisos`
  MODIFY `id_rol_permiso` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=79;

--
-- AUTO_INCREMENT de la tabla `solicitudes_lote`
--
ALTER TABLE `solicitudes_lote`
  MODIFY `id_solicitud` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `tipos_vehiculo_logistica`
--
ALTER TABLE `tipos_vehiculo_logistica`
  MODIFY `id_tipo_vehiculo` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `tokens_seguridad`
--
ALTER TABLE `tokens_seguridad`
  MODIFY `id_token` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `transportes`
--
ALTER TABLE `transportes`
  MODIFY `id_transporte` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `transportistas`
--
ALTER TABLE `transportistas`
  MODIFY `id_transportista` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `ubicaciones_transporte`
--
ALTER TABLE `ubicaciones_transporte`
  MODIFY `id_ubicacion` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `ubigeos`
--
ALTER TABLE `ubigeos`
  MODIFY `id_ubigeo` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1892;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id_usuario` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `usuarios_roles`
--
ALTER TABLE `usuarios_roles`
  MODIFY `id_usuario_rol` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `valorizaciones`
--
ALTER TABLE `valorizaciones`
  MODIFY `id_valorizacion` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `variedades`
--
ALTER TABLE `variedades`
  MODIFY `id_variedad` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=59;

--
-- AUTO_INCREMENT de la tabla `vehiculos`
--
ALTER TABLE `vehiculos`
  MODIFY `id_vehiculo` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `verificaciones`
--
ALTER TABLE `verificaciones`
  MODIFY `id_verificacion` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `archivos`
--
ALTER TABLE `archivos`
  ADD CONSTRAINT `fk_archivos_usuario` FOREIGN KEY (`id_usuario_carga`) REFERENCES `usuarios` (`id_usuario`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `asignaciones_cuadrilla`
--
ALTER TABLE `asignaciones_cuadrilla`
  ADD CONSTRAINT `fk_asignacion_cosecha` FOREIGN KEY (`id_cosecha`) REFERENCES `cosechas` (`id_cosecha`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_asignacion_cuadrilla` FOREIGN KEY (`id_cuadrilla`) REFERENCES `cuadrillas` (`id_cuadrilla`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `auditoria`
--
ALTER TABLE `auditoria`
  ADD CONSTRAINT `fk_auditoria_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Filtros para la tabla `calificaciones`
--
ALTER TABLE `calificaciones`
  ADD CONSTRAINT `fk_calificacion_emisor` FOREIGN KEY (`id_usuario_califica`) REFERENCES `usuarios` (`id_usuario`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_calificacion_operacion` FOREIGN KEY (`id_operacion`) REFERENCES `operaciones` (`id_operacion`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_calificacion_receptor` FOREIGN KEY (`id_usuario_calificado`) REFERENCES `usuarios` (`id_usuario`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `canjes_beneficios`
--
ALTER TABLE `canjes_beneficios`
  ADD CONSTRAINT `fk_canje_beneficio` FOREIGN KEY (`id_beneficio`) REFERENCES `beneficios` (`id_beneficio`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_canje_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `capacitacion_asistentes`
--
ALTER TABLE `capacitacion_asistentes`
  ADD CONSTRAINT `fk_cap_asistente_capacitacion` FOREIGN KEY (`id_capacitacion`) REFERENCES `capacitaciones` (`id_capacitacion`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_cap_asistente_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `compradores`
--
ALTER TABLE `compradores`
  ADD CONSTRAINT `fk_compradores_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `cosechas`
--
ALTER TABLE `cosechas`
  ADD CONSTRAINT `fk_cosecha_operacion` FOREIGN KEY (`id_operacion`) REFERENCES `operaciones` (`id_operacion`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_cosecha_responsable` FOREIGN KEY (`id_responsable`) REFERENCES `usuarios` (`id_usuario`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `cotizaciones_logisticas`
--
ALTER TABLE `cotizaciones_logisticas`
  ADD CONSTRAINT `fk_cot_logistica_cot_operacion` FOREIGN KEY (`id_cotizacion_operacion`) REFERENCES `cotizaciones_operacion` (`id_cotizacion_operacion`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `cotizaciones_operacion`
--
ALTER TABLE `cotizaciones_operacion`
  ADD CONSTRAINT `fk_cotizacion_comprador` FOREIGN KEY (`id_comprador`) REFERENCES `compradores` (`id_comprador`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_cotizacion_direccion` FOREIGN KEY (`id_direccion_entrega`) REFERENCES `direcciones_entrega` (`id_direccion`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_cotizacion_lote` FOREIGN KEY (`id_lote`) REFERENCES `lotes` (`id_lote`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `datos_facturacion`
--
ALTER TABLE `datos_facturacion`
  ADD CONSTRAINT `fk_facturacion_comprador` FOREIGN KEY (`id_comprador`) REFERENCES `compradores` (`id_comprador`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_facturacion_ubigeo` FOREIGN KEY (`id_ubigeo`) REFERENCES `ubigeos` (`id_ubigeo`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Filtros para la tabla `devoluciones`
--
ALTER TABLE `devoluciones`
  ADD CONSTRAINT `fk_devolucion_autoriza` FOREIGN KEY (`id_usuario_autoriza`) REFERENCES `usuarios` (`id_usuario`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_devolucion_ejecuta` FOREIGN KEY (`id_usuario_ejecuta`) REFERENCES `usuarios` (`id_usuario`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_devolucion_operacion` FOREIGN KEY (`id_operacion`) REFERENCES `operaciones` (`id_operacion`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_devolucion_pago` FOREIGN KEY (`id_pago`) REFERENCES `pagos` (`id_pago`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `direcciones_entrega`
--
ALTER TABLE `direcciones_entrega`
  ADD CONSTRAINT `fk_direccion_comprador` FOREIGN KEY (`id_comprador`) REFERENCES `compradores` (`id_comprador`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_direccion_ubigeo` FOREIGN KEY (`id_ubigeo`) REFERENCES `ubigeos` (`id_ubigeo`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Filtros para la tabla `entregas`
--
ALTER TABLE `entregas`
  ADD CONSTRAINT `fk_entrega_operacion` FOREIGN KEY (`id_operacion`) REFERENCES `operaciones` (`id_operacion`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_entrega_transporte` FOREIGN KEY (`id_transporte`) REFERENCES `transportes` (`id_transporte`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_entrega_usuario` FOREIGN KEY (`id_usuario_confirma`) REFERENCES `usuarios` (`id_usuario`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Filtros para la tabla `historial_estados`
--
ALTER TABLE `historial_estados`
  ADD CONSTRAINT `fk_historial_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Filtros para la tabla `incidencias`
--
ALTER TABLE `incidencias`
  ADD CONSTRAINT `fk_incidencia_operacion` FOREIGN KEY (`id_operacion`) REFERENCES `operaciones` (`id_operacion`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_incidencia_reporta` FOREIGN KEY (`id_usuario_reporta`) REFERENCES `usuarios` (`id_usuario`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_incidencia_responsable` FOREIGN KEY (`id_responsable`) REFERENCES `usuarios` (`id_usuario`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Filtros para la tabla `liquidaciones`
--
ALTER TABLE `liquidaciones`
  ADD CONSTRAINT `fk_liquidacion_cuadrilla` FOREIGN KEY (`id_cuadrilla_beneficiaria`) REFERENCES `cuadrillas` (`id_cuadrilla`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_liquidacion_operacion` FOREIGN KEY (`id_operacion`) REFERENCES `operaciones` (`id_operacion`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_liquidacion_productor` FOREIGN KEY (`id_productor_beneficiario`) REFERENCES `productores` (`id_productor`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_liquidacion_transportista` FOREIGN KEY (`id_transportista_beneficiario`) REFERENCES `transportistas` (`id_transportista`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `lotes`
--
ALTER TABLE `lotes`
  ADD CONSTRAINT `fk_lote_solicitud` FOREIGN KEY (`id_solicitud`) REFERENCES `solicitudes_lote` (`id_solicitud`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_lote_valorizacion` FOREIGN KEY (`id_valorizacion`) REFERENCES `valorizaciones` (`id_valorizacion`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `medios_pago_usuario`
--
ALTER TABLE `medios_pago_usuario`
  ADD CONSTRAINT `fk_medio_pago_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `movimientos_puntos`
--
ALTER TABLE `movimientos_puntos`
  ADD CONSTRAINT `fk_puntos_operacion` FOREIGN KEY (`id_operacion`) REFERENCES `operaciones` (`id_operacion`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_puntos_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `notificaciones`
--
ALTER TABLE `notificaciones`
  ADD CONSTRAINT `fk_notificacion_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `operaciones`
--
ALTER TABLE `operaciones`
  ADD CONSTRAINT `fk_operacion_comprador` FOREIGN KEY (`id_comprador`) REFERENCES `compradores` (`id_comprador`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_operacion_cotizacion` FOREIGN KEY (`id_cotizacion_operacion`) REFERENCES `cotizaciones_operacion` (`id_cotizacion_operacion`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_operacion_direccion` FOREIGN KEY (`id_direccion_entrega`) REFERENCES `direcciones_entrega` (`id_direccion`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_operacion_lote` FOREIGN KEY (`id_lote`) REFERENCES `lotes` (`id_lote`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_operacion_productor` FOREIGN KEY (`id_productor`) REFERENCES `productores` (`id_productor`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `ordenes_pago`
--
ALTER TABLE `ordenes_pago`
  ADD CONSTRAINT `fk_orden_autoriza` FOREIGN KEY (`id_usuario_autoriza`) REFERENCES `usuarios` (`id_usuario`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_orden_ejecuta` FOREIGN KEY (`id_usuario_ejecuta`) REFERENCES `usuarios` (`id_usuario`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_orden_liquidacion` FOREIGN KEY (`id_liquidacion`) REFERENCES `liquidaciones` (`id_liquidacion`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_orden_solicita` FOREIGN KEY (`id_usuario_solicita`) REFERENCES `usuarios` (`id_usuario`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `pagos`
--
ALTER TABLE `pagos`
  ADD CONSTRAINT `fk_pago_facturacion` FOREIGN KEY (`id_facturacion`) REFERENCES `datos_facturacion` (`id_facturacion`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_pago_operacion` FOREIGN KEY (`id_operacion`) REFERENCES `operaciones` (`id_operacion`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `pagos_efectivo`
--
ALTER TABLE `pagos_efectivo`
  ADD CONSTRAINT `fk_pago_efectivo_orden` FOREIGN KEY (`id_orden_pago`) REFERENCES `ordenes_pago` (`id_orden_pago`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_pago_efectivo_usuario` FOREIGN KEY (`id_usuario_entrega`) REFERENCES `usuarios` (`id_usuario`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `parametros_comerciales`
--
ALTER TABLE `parametros_comerciales`
  ADD CONSTRAINT `fk_param_comercial_usuario` FOREIGN KEY (`id_usuario_actualiza`) REFERENCES `usuarios` (`id_usuario`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Filtros para la tabla `parametros_cosecha`
--
ALTER TABLE `parametros_cosecha`
  ADD CONSTRAINT `fk_param_cosecha_producto` FOREIGN KEY (`id_producto`) REFERENCES `productos` (`id_producto`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_param_cosecha_usuario` FOREIGN KEY (`id_usuario_actualiza`) REFERENCES `usuarios` (`id_usuario`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_param_cosecha_variedad` FOREIGN KEY (`id_variedad`) REFERENCES `variedades` (`id_variedad`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Filtros para la tabla `parametros_cultivo`
--
ALTER TABLE `parametros_cultivo`
  ADD CONSTRAINT `fk_param_cultivo_producto` FOREIGN KEY (`id_producto`) REFERENCES `productos` (`id_producto`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_param_cultivo_usuario` FOREIGN KEY (`id_usuario_actualiza`) REFERENCES `usuarios` (`id_usuario`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_param_cultivo_variedad` FOREIGN KEY (`id_variedad`) REFERENCES `variedades` (`id_variedad`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Filtros para la tabla `parametros_logisticos`
--
ALTER TABLE `parametros_logisticos`
  ADD CONSTRAINT `fk_param_logistico_usuario` FOREIGN KEY (`id_usuario_actualiza`) REFERENCES `usuarios` (`id_usuario`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Filtros para la tabla `precios_mercado`
--
ALTER TABLE `precios_mercado`
  ADD CONSTRAINT `fk_precio_producto` FOREIGN KEY (`id_producto`) REFERENCES `productos` (`id_producto`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_precio_usuario` FOREIGN KEY (`id_usuario_registro`) REFERENCES `usuarios` (`id_usuario`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_precio_variedad` FOREIGN KEY (`id_variedad`) REFERENCES `variedades` (`id_variedad`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Filtros para la tabla `predios`
--
ALTER TABLE `predios`
  ADD CONSTRAINT `fk_predios_productor` FOREIGN KEY (`id_productor`) REFERENCES `productores` (`id_productor`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_predios_ubigeo` FOREIGN KEY (`id_ubigeo`) REFERENCES `ubigeos` (`id_ubigeo`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Filtros para la tabla `productores`
--
ALTER TABLE `productores`
  ADD CONSTRAINT `fk_productores_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `productos`
--
ALTER TABLE `productos`
  ADD CONSTRAINT `fk_productos_categoria` FOREIGN KEY (`id_categoria`) REFERENCES `categorias_producto` (`id_categoria`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `publicaciones`
--
ALTER TABLE `publicaciones`
  ADD CONSTRAINT `fk_publicacion_autor` FOREIGN KEY (`id_autor`) REFERENCES `usuarios` (`id_usuario`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `referidos`
--
ALTER TABLE `referidos`
  ADD CONSTRAINT `fk_referido_referido` FOREIGN KEY (`id_usuario_referido`) REFERENCES `usuarios` (`id_usuario`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_referido_referidor` FOREIGN KEY (`id_usuario_referidor`) REFERENCES `usuarios` (`id_usuario`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `reservas_lote`
--
ALTER TABLE `reservas_lote`
  ADD CONSTRAINT `fk_reserva_comprador` FOREIGN KEY (`id_comprador`) REFERENCES `compradores` (`id_comprador`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_reserva_cotizacion` FOREIGN KEY (`id_cotizacion_operacion`) REFERENCES `cotizaciones_operacion` (`id_cotizacion_operacion`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_reserva_lote` FOREIGN KEY (`id_lote`) REFERENCES `lotes` (`id_lote`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `roles_permisos`
--
ALTER TABLE `roles_permisos`
  ADD CONSTRAINT `fk_roles_permisos_permiso` FOREIGN KEY (`id_permiso`) REFERENCES `permisos` (`id_permiso`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_roles_permisos_rol` FOREIGN KEY (`id_rol`) REFERENCES `roles` (`id_rol`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `solicitudes_lote`
--
ALTER TABLE `solicitudes_lote`
  ADD CONSTRAINT `fk_solicitud_campana` FOREIGN KEY (`id_campana`) REFERENCES `campanas_agricolas` (`id_campana`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_solicitud_predio` FOREIGN KEY (`id_predio`) REFERENCES `predios` (`id_predio`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_solicitud_producto` FOREIGN KEY (`id_producto`) REFERENCES `productos` (`id_producto`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_solicitud_productor` FOREIGN KEY (`id_productor`) REFERENCES `productores` (`id_productor`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_solicitud_variedad` FOREIGN KEY (`id_variedad`) REFERENCES `variedades` (`id_variedad`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Filtros para la tabla `tokens_seguridad`
--
ALTER TABLE `tokens_seguridad`
  ADD CONSTRAINT `fk_tokens_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `transportes`
--
ALTER TABLE `transportes`
  ADD CONSTRAINT `fk_transporte_operacion` FOREIGN KEY (`id_operacion`) REFERENCES `operaciones` (`id_operacion`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_transporte_transportista` FOREIGN KEY (`id_transportista`) REFERENCES `transportistas` (`id_transportista`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_transporte_vehiculo` FOREIGN KEY (`id_vehiculo`) REFERENCES `vehiculos` (`id_vehiculo`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `transportistas`
--
ALTER TABLE `transportistas`
  ADD CONSTRAINT `fk_transportista_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Filtros para la tabla `ubicaciones_transporte`
--
ALTER TABLE `ubicaciones_transporte`
  ADD CONSTRAINT `fk_ubicacion_transporte` FOREIGN KEY (`id_transporte`) REFERENCES `transportes` (`id_transporte`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD CONSTRAINT `fk_usuarios_registro_asistido` FOREIGN KEY (`id_usuario_registro_asistido`) REFERENCES `usuarios` (`id_usuario`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Filtros para la tabla `usuarios_roles`
--
ALTER TABLE `usuarios_roles`
  ADD CONSTRAINT `fk_usuarios_roles_rol` FOREIGN KEY (`id_rol`) REFERENCES `roles` (`id_rol`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_usuarios_roles_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `valorizaciones`
--
ALTER TABLE `valorizaciones`
  ADD CONSTRAINT `fk_valorizacion_solicitud` FOREIGN KEY (`id_solicitud`) REFERENCES `solicitudes_lote` (`id_solicitud`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_valorizacion_usuario_respuesta` FOREIGN KEY (`id_usuario_respuesta`) REFERENCES `usuarios` (`id_usuario`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Filtros para la tabla `variedades`
--
ALTER TABLE `variedades`
  ADD CONSTRAINT `fk_variedades_producto` FOREIGN KEY (`id_producto`) REFERENCES `productos` (`id_producto`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `vehiculos`
--
ALTER TABLE `vehiculos`
  ADD CONSTRAINT `fk_vehiculo_transportista` FOREIGN KEY (`id_transportista`) REFERENCES `transportistas` (`id_transportista`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `verificaciones`
--
ALTER TABLE `verificaciones`
  ADD CONSTRAINT `fk_verificacion_solicitud` FOREIGN KEY (`id_solicitud`) REFERENCES `solicitudes_lote` (`id_solicitud`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_verificacion_ubigeo` FOREIGN KEY (`id_ubigeo`) REFERENCES `ubigeos` (`id_ubigeo`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_verificacion_usuario` FOREIGN KEY (`id_verificador`) REFERENCES `usuarios` (`id_usuario`) ON UPDATE CASCADE;

--
-- Relaciones para negociación de cotizaciones
--
ALTER TABLE `cotizaciones_comerciales`
  ADD CONSTRAINT `fk_cotizacion_comercial_lote` FOREIGN KEY (`id_lote`) REFERENCES `lotes` (`id_lote`),
  ADD CONSTRAINT `fk_cotizacion_comercial_comprador` FOREIGN KEY (`id_comprador`) REFERENCES `compradores` (`id_comprador`),
  ADD CONSTRAINT `fk_cotizacion_comercial_operacion` FOREIGN KEY (`id_cotizacion_operacion`) REFERENCES `cotizaciones_operacion` (`id_cotizacion_operacion`);

ALTER TABLE `mensajes_cotizacion_comercial`
  ADD CONSTRAINT `fk_mensaje_cotizacion_comercial` FOREIGN KEY (`id_cotizacion_comercial`) REFERENCES `cotizaciones_comerciales` (`id_cotizacion_comercial`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_mensaje_cotizacion_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

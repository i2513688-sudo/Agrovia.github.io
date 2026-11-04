ALTER TABLE `solicitudes_lote`
  ADD COLUMN `precio_propuesto_kg` decimal(12,4) DEFAULT NULL
  AFTER `area_cultivada`;

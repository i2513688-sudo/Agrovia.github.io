ALTER TABLE solicitudes_lote
    ADD COLUMN nombre_producto_personalizado varchar(100) DEFAULT NULL
    AFTER id_producto;

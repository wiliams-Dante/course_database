/*insertando tablas independientes*/
/*datos tabla pasajero*/
INSERT INTO pasajero (pasajero_id, dni_pasajero, telefono_pasajero) 
VALUES 
('PSJ00000000001', '60062056', '983104472'),
('PSJ00000000002', '72345678', '912345678'),
('PSJ00000000003', '73456789', '923456789'),
('PSJ00000000004', '74567890', '934567890'),
('PSJ00000000005', '75678901', '945678901');

/*datos tabla tarjeta*/
INSERT INTO tarjeta (tarjeta_id, fecha_emision, fecha_caducidad, saldo_actual, estado_tarjeta, pasajero_id) 
VALUES 
('TRJ00000000001', '2025-01-15 08:30:00', '2026-01-15 08:30:00', 50, 'Activa', 'PSJ00000000001'),
('TRJ00000000002', '2025-02-20 10:15:00', '2026-02-20 10:15:00', 10, 'Activa', 'PSJ00000000002'),
('TRJ00000000003', '2025-03-10 14:45:00', '2026-03-10 14:45:00', 0, 'Inactiva', 'PSJ00000000003'),
('TRJ00000000004', '2025-04-05 09:00:00', '2026-04-05 09:00:00', 100, 'Activa', 'PSJ00000000004'),
('TRJ00000000005', '2025-05-12 16:20:00', '2026-05-12 16:20:00', 25, 'Bloqueada', 'PSJ00000000005');

/*datos tabla tarifa*/
INSERT INTO tarifa (tarifa_id, monto, pasajero_id, tarjeta_id) VALUES 
('TRF00000000001', 2, 'PSJ00000000001', 'TRJ00000000001'),
('TRF00000000002', 1, 'PSJ00000000002', 'TRJ00000000002'),
('TRF00000000003', 2, 'PSJ00000000003', 'TRJ00000000003'),
('TRF00000000004', 3, 'PSJ00000000004', 'TRJ00000000004'),
('TRF00000000005', 1, 'PSJ00000000005', 'TRJ00000000005');



INSERT INTO transaccion (transaccion_id, monto_tr, fecha_hora_tr, estado_tr, pasajero_id, tarjeta_id, tarifa_id) 
VALUES 
('TRN00000000001', 2, '2026-05-24 07:15:00', 'Completada', 'PSJ00000000001', 'TRJ00000000001', 'TRF00000000001'),
('TRN00000000002', 1, '2026-05-24 08:20:00', 'Completada', 'PSJ00000000002', 'TRJ00000000002', 'TRF00000000002'),
('TRN00000000003', 2, '2026-05-24 13:45:00', 'Rechazada', 'PSJ00000000003', 'TRJ00000000003', 'TRF00000000003'),
('TRN00000000004', 3, '2026-05-24 14:10:00', 'Completada', 'PSJ00000000004', 'TRJ00000000004', 'TRF00000000004'),
('TRN00000000005', 1, '2026-05-24 18:30:00', 'Rechazada', 'PSJ00000000005', 'TRJ00000000005', 'TRF00000000005');


INSERT INTO tipo_usuario (tipo_id, nombre, descuento_porcentaje, tarjeta_id) 
VALUES 
('TUS00000000001', 'Universitario', 50, 'TRJ00000000001'),
('TUS00000000002', 'Escolar', 50, 'TRJ00000000002'),
('TUS00000000003', 'General', 0, 'TRJ00000000003'),
('TUS00000000004', 'General', 0, 'TRJ00000000004'),
('TUS00000000005', 'Tercera Edad', 50, 'TRJ00000000005');


INSERT INTO incidencia (incidencia_id, fecha_reporte, descripcion, estado, tarjeta_id) 
VALUES 
('INC00000000001', '2026-05-20 10:00:00', 'Perdida de tarjeta en paradero', 'Pendiente', 'TRJ00000000003'),
('INC00000000002', '2026-05-21 11:30:00', 'Cobro doble en el validador', 'Resuelto', 'TRJ00000000001'),
('INC00000000003', '2026-05-22 15:45:00', 'Robo de billetera', 'Pendiente', 'TRJ00000000005'),
('INC00000000004', '2026-05-23 09:20:00', 'Tarjeta no lee en la maquina', 'En Revision', 'TRJ00000000004'),
('INC00000000005', '2026-05-24 08:10:00', 'Recarga no reflejada en saldo', 'Resuelto', 'TRJ00000000002');


INSERT INTO notificacion_pasajero (notificacion_id, fecha, tipo, mensaje, tarjeta_id) 
VALUES 
('NOT00000000001', '2026-05-20 10:05:00', 'Alerta', 'Su tarjeta ha sido bloqueada temporalmente', 'TRJ00000000003'),
('NOT00000000002', '2026-05-21 11:35:00', 'Reembolso', 'Se ha devuelto el saldo por cobro doble', 'TRJ00000000001'),
('NOT00000000003', '2026-05-22 15:50:00', 'Bloqueo', 'Tarjeta bloqueada por reporte de robo', 'TRJ00000000005'),
('NOT00000000004', '2026-05-23 09:25:00', 'Info', 'Acuda a un centro de atencion para revision de tarjeta', 'TRJ00000000004'),
('NOT00000000005', '2026-05-24 08:15:00', 'Recarga', 'Su recarga ha sido procesada con exito', 'TRJ00000000002');


INSERT INTO historial_cambio_tarjeta (cambio_id, fecha_cambio, motivo_cambio, tarjeta_id) 
VALUES 
('HST00000000001', '2026-01-15 08:35:00', 'Emision de nueva tarjeta', 'TRJ00000000001'),
('HST00000000002', '2026-02-20 10:20:00', 'Emision de nueva tarjeta', 'TRJ00000000002'),
('HST00000000003', '2026-05-20 10:30:00', 'Desactivacion temporal por perdida', 'TRJ00000000003'),
('HST00000000004', '2026-04-05 09:05:00', 'Renovacion de tarjeta', 'TRJ00000000004'),
('HST00000000005', '2026-05-22 16:00:00', 'Bloqueo definitivo por robo', 'TRJ00000000005');


/* UPDATE realizado por: Rodrigo Fredy Sulla Gonzales*/
UPDATE pasajero 
SET telefono_pasajero = '987654321' 
WHERE pasajero_id = 'PSJ00000000001';

/* UPDATE realizado por: Gustavo Alonso Moreno Ojeda*/
UPDATE tarjeta 
SET estado_tarjeta = 'Inactiva' 
WHERE tarjeta_id = 'TRJ00000000004';



/* UPDATE realizado por: Wiliams Yeferson Taipe Huanca */
UPDATE incidencia 
SET estado = 'Resuelto' 
WHERE incidencia_id = 'INC00000000001';


/* UPDATE extra realizado por: Gustavo Alonso Moreno Ojeda */
UPDATE transaccion 
SET estado_tr = 'Anulada' 
WHERE transaccion_id = 'TRN00000000005';

-- Reparando tamaños de RUC para que todos sean CHAR(20)
ALTER TABLE empresa ALTER COLUMN ruc TYPE CHAR(20);
ALTER TABLE ruta ALTER COLUMN empresa_ruc TYPE CHAR(20);
ALTER TABLE unidad ALTER COLUMN empresa_ruc TYPE CHAR(20);
ALTER TABLE reporte_ingresos ALTER COLUMN empresa_ruc TYPE CHAR(20);

/* Reparando el tipo de dato de pasajero_id en la tabla tarjeta*/
ALTER TABLE tarjeta ALTER COLUMN pasajero_id TYPE CHAR(14);

/* Conectar RUTA con EMPRESA*/
ALTER TABLE ruta 
    ADD CONSTRAINT fk_ruta_empresa FOREIGN KEY (empresa_ruc) REFERENCES empresa(ruc);

/*Conectar UNIDAD con EMPRESA, RUTA y CHOFER*/
ALTER TABLE unidad 
    ADD CONSTRAINT fk_unidad_empresa FOREIGN KEY (empresa_ruc) REFERENCES empresa(ruc);

ALTER TABLE unidad 
    ADD CONSTRAINT fk_unidad_ruta FOREIGN KEY (ruta_id) REFERENCES ruta(ruta_id);
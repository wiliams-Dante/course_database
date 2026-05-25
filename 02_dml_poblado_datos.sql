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
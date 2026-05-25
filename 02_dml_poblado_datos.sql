/*insertando tablas independientes*/
/*tabla pasajero*/
INSERT INTO pasajero (pasajero_id, dni_pasajero, telefono_pasajero) 
VALUES 
	('PSJ00000000001', '60062056', '983104472'),
	('PSJ00000000002', '72345678', '912345678'),
	('PSJ00000000003', '73456789', '923456789'),
	('PSJ00000000004', '74567890', '934567890'),
	('PSJ00000000005', '75678901', '945678901');

/*tabla tarjeta*/
INSERT INTO tarjeta (tarjeta_id, fecha_emision, fecha_caducidad, saldo_actual, estado_tarjeta, pasajero_id) 
VALUES 
('TRJ00000000001', '2025-01-15 08:30:00', '2026-01-15 08:30:00', 50, 'Activa', 'PSJ00000000001'),
('TRJ00000000002', '2025-02-20 10:15:00', '2026-02-20 10:15:00', 10, 'Activa', 'PSJ00000000002'),
('TRJ00000000003', '2025-03-10 14:45:00', '2026-03-10 14:45:00', 0, 'Inactiva', 'PSJ00000000003'),
('TRJ00000000004', '2025-04-05 09:00:00', '2026-04-05 09:00:00', 100, 'Activa', 'PSJ00000000004'),
('TRJ00000000005', '2025-05-12 16:20:00', '2026-05-12 16:20:00', 25, 'Bloqueada', 'PSJ00000000005');

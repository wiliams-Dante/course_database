--escenario a: transaccion exitosa
BEGIN;

-- 1. Se se debita el pasaje de la tarjeta
    UPDATE tarjeta 
    SET saldo_actual = saldo_actual - 2.00 
    WHERE tarjeta_id = 'TRJ00000000001';

-- 2. generamos el comprobasnte de la transaccion
    INSERT INTO transaccion (transaccion_id, monto_tr, fecha_hora_tr, estado_tr, pasajero_id, tarjeta_id, tarifa_id) 
    VALUES ('TRN99999999997', 2.00, NOW(), 'Completada', 'PSJ00000000001', 'TRJ00000000001', 'TRF00000000001');
COMMIT;


--escenario b: transaccion fallida 
BEGIN;

-- 1. el validados intenta cobrar el pasaje y descuenta el saldo
    UPDATE tarjeta 
    SET saldo_actual = saldo_actual - 2.00 
    WHERE tarjeta_id = 'TRJ00000000002';

--2. simulacion de que se fue la luz en el validador y se cancela todo
ROLLBACK;


--escenario c: proceso complejo: migracion de saldo por robo o perdida
BEGIN;

--1. bloqueamos la tarjeta reportada como robada
	UPDATE tarjeta 
    SET estado_tarjeta = 'Bloqueada' 
    WHERE tarjeta_id = 'TRJ00000000005';
	
-- 2. registramos el motivo 
	INSERT INTO historial_cambio_tarjeta (cambio_id, fecha_cambio, motivo_cambio, tarjeta_id) 
    VALUES ('HST99999999999', NOW(), 'Bloqueo definitivo por robo y transferencia de saldo a nueva tarjeta', 'TRJ00000000005');
	
--3. emitimos una nueva tarjeta para el pasajero, manteniendo sus saldo previo
	INSERT INTO tarjeta (tarjeta_id, fecha_emision, fecha_caducidad, saldo_actual, estado_tarjeta, pasajero_id) 
    VALUES ('TRJ00000000099', NOW(), NOW() + INTERVAL '1 year', 25.00, 'Activa', 'PSJ00000000005');
COMMIT;
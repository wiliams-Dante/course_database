--escenario a: transaccion exitosa
BEGIN;

UPDATE tarjeta 
SET saldo_actual = saldo_actual - 2 
WHERE tarjeta_id = 'TRJ00000000001';

INSERT INTO transaccion (transaccion_id, monto_tr, fecha_hora_tr, estado_tr, pasajero_id, tarjeta_id, tarifa_id) 
VALUES ('TRN99999999997', 2, NOW(), 'Completada', 'PSJ00000000001', 'TRJ00000000001', 'TRF00000000001');

COMMIT;


--escenario b: transaccion fallida 
BEGIN;

UPDATE tarjeta 
SET saldo_actual = saldo_actual - 2 
WHERE tarjeta_id = 'TRJ00000000002';

--simulacion de que se fue la luz en el validador y se cancela todo
ROLLBACK;
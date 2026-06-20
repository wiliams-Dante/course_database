
--pasajeros
INSERT INTO pasajero (pasajero_id, dni_pasajero, telefono_pasajero)
SELECT 
    'PSJ' || LPAD(i::text, 11, '0'),
    LPAD((10000000 + i)::text, 8, '0'), 
    '9' || LPAD((10000000 + i)::text, 8, '0')
FROM generate_series(100, 15000) AS i;

--tarjetas (una porpasajero)
INSERT INTO tarjeta (tarjeta_id, fecha_emision, fecha_caducidad, saldo_actual, estado_tarjeta, pasajero_id)
SELECT 
    'TRJ' || LPAD(i::text, 11, '0'),
    NOW() - (random() * 365 || ' days')::interval,
    NOW() + (random() * 365 || ' days')::interval,
    floor(random() * 100)::INT,
    CASE WHEN random() > 0.05 THEN 'Activa' ELSE 'Bloqueada' END,
    'PSJ' || LPAD(i::text, 11, '0')
FROM generate_series(100, 15000) AS i;

--tarifas
INSERT INTO tarifa (tarifa_id, monto, pasajero_id, tarjeta_id)
SELECT 
    'TRF' || LPAD(i::text, 11, '0'),
    floor(random() * 5 + 1)::INT,
    'PSJ' || LPAD(i::text, 11, '0'),
    'TRJ' || LPAD(i::text, 11, '0')
FROM generate_series(100, 15000) AS i;

DELETE FROM transaccion WHERE transaccion_id > 'TRN00000000005';

--transacciones
INSERT INTO transaccion (transaccion_id, monto_tr, fecha_hora_tr, estado_tr, pasajero_id, tarjeta_id, tarifa_id)
SELECT 
    'TRN' || LPAD(i::text, 11, '0'),
    floor(random() * 5 + 1)::INT,
    NOW() - (random() * 365 || ' days')::interval,
    CASE WHEN random() > 0.1 THEN 'Completada' ELSE 'Rechazada' END,
    --aqui usamos modulo para asegurar que el id exista en lastaablas anteriores
    'PSJ' || LPAD((100 + (i % 14900))::text, 11, '0'),
    'TRJ' || LPAD((100 + (i % 14900))::text, 11, '0'),
    'TRF' || LPAD((100 + (i % 14900))::text, 11, '0')
FROM generate_series(100, 20000) AS i;


--primer explain analyze
EXPLAIN ANALYZE
SELECT transaccion_id, monto_tr, fecha_hora_tr, estado_tr 
FROM transaccion
WHERE fecha_hora_tr BETWEEN '2026-01-01 00:00:00' AND '2026-01-05 23:59:59';

--creamos el indice
CREATE INDEX idx_transaccion_fecha ON transaccion(fecha_hora_tr);

--realizamos otro explain analyze para ver si en verdad se optimizo 
EXPLAIN ANALYZE
SELECT transaccion_id, monto_tr, fecha_hora_tr, estado_tr 
FROM transaccion
WHERE fecha_hora_tr BETWEEN '2026-01-01 00:00:00' AND '2026-01-05 23:59:59';
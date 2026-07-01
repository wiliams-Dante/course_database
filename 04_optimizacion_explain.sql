
--poblado masivo pasajeros
INSERT INTO pasajero (pasajero_id, dni_pasajero, telefono_pasajero)
SELECT 
    'PSJ' || LPAD(i::text, 11, '0'),
    LPAD((10000000 + i)::text, 8, '0'), 
    '9' || LPAD((10000000 + i)::text, 8, '0')
FROM generate_series(100, 15000) AS i;

--poblado masivo tarjetas
INSERT INTO tarjeta (tarjeta_id, fecha_emision, fecha_caducidad, saldo_actual, estado_tarjeta, pasajero_id)
SELECT 
    'TRJ' || LPAD(i::text, 11, '0'),
    NOW() - (random() * 365 || ' days')::interval,
    NOW() + (random() * 365 || ' days')::interval,
    (random() * 100)::NUMERIC(10,2), -- Ajustado a decimal
    CASE WHEN random() > 0.05 THEN 'Activa' ELSE 'Bloqueada' END,
    'PSJ' || LPAD(i::text, 11, '0')
FROM generate_series(100, 15000) AS i;

--'poblado masivo tipo de usuario'
INSERT INTO tipo_usuario (tipo_id, nombre, descuento_porcentaje, tarjeta_id)
SELECT 
    'TUS' || LPAD(i::text, 11, '0'),
    CASE (i % 4) 
        WHEN 0 THEN 'Universitario' 
        WHEN 1 THEN 'Escolar' 
        WHEN 2 THEN 'General' 
        ELSE 'Tercera Edad' 
    END,
    CASE (i % 4) WHEN 2 THEN 0 ELSE 50 END,
    'TRJ' || LPAD(i::text, 11, '0')
FROM generate_series(100, 15000) AS i;

--poblado masivo para empresa
INSERT INTO empresa (ruc, nombre_empresa, direccion_empresa, telefono_empresa)
SELECT 
    '20' || LPAD(i::text, 9, '0'), -- Ajustado a RUC real de 11 digitos
    'Empresa Trans ' || i,
    'Av. Arequipa ' || i,
    floor(random() * 900000000 + 900000000)::BIGINT
FROM generate_series(100, 500) AS i;

--poblado masivo para ruta
INSERT INTO ruta (ruta_id, nombre_ruta, empresa_ruc)
SELECT 
    'RUT' || LPAD(i::text, 11, '0'),
    'Ruta Troncal ' || i,
    '20' || LPAD((100 + (i % 400))::text, 9, '0')
FROM generate_series(100, 500) AS i;

--poblado masivo para chofer
INSERT INTO chofer (chofer_id, nombre, apellido, dni, licencia_conducir, empresa_ruc)
SELECT 
    'CHF' || LPAD(i::text, 11, '0'),
    'Chofer ' || i,
    'Apellido ' || i,
    LPAD((20000000 + i)::text, 8, '0'),
    'Q' || LPAD((20000000 + i)::text, 8, '0'),
    '20' || LPAD((100 + (i % 400))::text, 9, '0')
FROM generate_series(100, 500) AS i;

--poblado amsivo para los buses
INSERT INTO unidad (placa, modelo_unidad, capacidad_psjros, estado_operativo, empresa_ruc, chofer_id, ruta_id)
SELECT 
    'P' || LPAD(i::text, 5, '0'),
    'Volksbus ' || (i%5),
    floor(random() * 40 + 40)::INT,
    CASE WHEN random() > 0.1 THEN 'Operativo' ELSE 'Mantenimiento' END,
    '20' || LPAD((100 + (i % 400))::text, 9, '0'),
    'CHF' || LPAD((100 + (i % 400))::text, 11, '0'),
    'RUT' || LPAD((100 + (i % 400))::text, 11, '0')
FROM generate_series(100, 500) AS i;
-- Parche para agrandar la columna y que entre la palabra "Mantenimiento"
ALTER TABLE unidad ALTER COLUMN estado_operativo TYPE VARCHAR(15);

-- poblado masivo de tarifas y transacciones
INSERT INTO tarifa (tarifa_id, monto, pasajero_id, tarjeta_id)
SELECT 
    'TRF' || LPAD(i::text, 11, '0'),
    (random() * 5 + 1)::NUMERIC(10,2), -- Ajustado a decimal
    'PSJ' || LPAD(i::text, 11, '0'),
    'TRJ' || LPAD(i::text, 11, '0')
FROM generate_series(100, 15000) AS i;

DELETE FROM transaccion WHERE transaccion_id > 'TRN00000000005';

INSERT INTO transaccion (transaccion_id, monto_tr, fecha_hora_tr, estado_tr, pasajero_id, tarjeta_id, tarifa_id)
SELECT 
    'TRN' || LPAD(i::text, 11, '0'),
    (random() * 5 + 1)::NUMERIC(10,2), -- Ajustado a decimal
    NOW() - (random() * 365 || ' days')::interval,
    CASE WHEN random() > 0.1 THEN 'Completada' ELSE 'Rechazada' END,
    'PSJ' || LPAD((100 + (i % 14900))::text, 11, '0'),
    'TRJ' || LPAD((100 + (i % 14900))::text, 11, '0'),
    'TRF' || LPAD((100 + (i % 14900))::text, 11, '0')
FROM generate_series(100, 20000) AS i;


-- prueba de optimizacion

-- A) Primer EXPLAIN ANALYZE (Sin Índice)
-- Costo alto esperado debido a un Sequential Scan (Seq Scan) en toda la tabla.
EXPLAIN ANALYZE
SELECT transaccion_id, monto_tr, fecha_hora_tr, estado_tr 
FROM transaccion
WHERE fecha_hora_tr BETWEEN (NOW() - INTERVAL '30 days') AND NOW();

-- B) Creamos el índice
CREATE INDEX idx_transaccion_fecha ON transaccion(fecha_hora_tr);

-- C) Segundo EXPLAIN ANALYZE (Con Índice)
-- Costo bajo esperado debido a un Index Scan usando idx_transaccion_fecha.
EXPLAIN ANALYZE
SELECT transaccion_id, monto_tr, fecha_hora_tr, estado_tr 
FROM transaccion
WHERE fecha_hora_tr BETWEEN (NOW() - INTERVAL '30 days') AND NOW();


-- llenando tabla tipo tarjeta
INSERT INTO tipo_tarjeta (recarga_id, prepago, postpago, beneficio, tarjeta_id)
SELECT 
    'REC' || LPAD(i::text, 11, '0'),
    CASE WHEN random() > 0.5 THEN 'Si' ELSE 'No' END,
    CASE WHEN random() > 0.5 THEN 'No' ELSE 'Si' END,
    CASE (i % 3) 
        WHEN 0 THEN 'Ninguno' 
        WHEN 1 THEN 'Bono 10%' 
        ELSE 'Pasaje Libre' 
    END,
    'TRJ' || LPAD(i::text, 11, '0')
FROM generate_series(100, 15000) AS i;


-- llenando tabla reporte ingresos
INSERT INTO reporte_ingresos (reporte_id, fecha_reporte, total_ingresos, total_transacciones, empresa_ruc, tarifa_id)
SELECT 
    'REP' || LPAD(i::text, 11, '0'),
    NOW() - (random() * 30 || ' days')::interval,
    (random() * 5000 + 1000)::NUMERIC(10,2), -- Ingresos random entre 1000 y 6000
    floor(random() * 1000 + 500)::INT,       -- Transacciones random entre 500 y 1500
    '20' || LPAD((100 + (i % 400))::text, 9, '0'),
    'TRF' || LPAD((100 + (i % 400))::text, 11, '0')
FROM generate_series(100, 500) AS i;
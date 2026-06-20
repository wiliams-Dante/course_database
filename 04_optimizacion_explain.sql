INSERT INTO pasajero (pasajero_id, dni_pasajero, telefono_pasajero)
SELECT 
    'PSJ' || LPAD(i::text, 11, '0'),
    LPAD((10000000 + i)::text, 8, '0'), 
    '9' || LPAD((10000000 + i)::text, 8, '0')
FROM generate_series(100, 15000) AS i;
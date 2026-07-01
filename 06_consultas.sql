--seccion 1 (funciones de una fila, fechas y ordenamiento)
-- reporte de tarjetas proximas a vencer
--extraer los dias exactos que faltan para el vencimiento de tarjetas activas
SELECT 
    p.dni_pasajero,
    t.tarjeta_id,
    TO_CHAR(t.fecha_caducidad, 'DD/MM/YYYY') AS fecha_formateada,
    EXTRACT(DAY FROM (t.fecha_caducidad - NOW())) AS dias_para_vencer
FROM pasajero p
JOIN tarjeta t ON p.pasajero_id = t.pasajero_id
WHERE t.estado_tarjeta = 'Activa' 
  AND t.fecha_caducidad BETWEEN NOW() AND (NOW() + INTERVAL '60 days')
ORDER BY dias_para_vencer ASC;


--seccion 2 (funciones de grupo y agregaccion )
--mu3estra quer perfil de usuario genera mas dinero, filtrando a los que 
--superen los 100 soles de recaudacion historica
SELECT 
    tu.nombre AS perfil_pasajero,
    COUNT(tr.transaccion_id) AS total_viajes_realizados,
    SUM(tr.monto_tr) AS recaudacion_total_soles,
    ROUND(AVG(tr.monto_tr), 2) AS ticket_promedio_soles
FROM transaccion tr
JOIN tarjeta t ON tr.tarjeta_id = t.tarjeta_id
JOIN tipo_usuario tu ON t.tarjeta_id = tu.tarjeta_id
WHERE tr.estado_tr = 'Completada'
GROUP BY tu.nombre
HAVING SUM(tr.monto_tr) > 100.00
ORDER BY recaudacion_total_soles DESC;


--seccion 3 (joins multitabla)
--lista de choferes, la empresa a la que pertenecen, la ruta que cubren y el estado de su unidad asignada
SELECT 
    e.nombre_empresa,
    r.nombre_ruta,
    c.nombre || ' ' || c.apellido AS chofer_asignado,
    c.licencia_conducir,
    u.placa AS placa_bus,
    u.estado_operativo
FROM chofer c
INNER JOIN unidad u ON c.chofer_id = u.chofer_id
INNER JOIN empresa e ON c.empresa_ruc = e.ruc
LEFT JOIN ruta r ON u.ruta_id = r.ruta_id
WHERE u.estado_operativo = 'Operativo'
ORDER BY e.nombre_empresa, r.nombre_ruta;


--seccion 4 (subcolumnas)
--identificacion de pasajeros vip( los que gastan mas que el promedio)
--usamos una subconsulta en el HAVING para calcular el promedio global de gastos
--y compararlo contra el gasto individual de cada pasajero
SELECT 
    p.dni_pasajero,
    COUNT(tr.transaccion_id) AS cantidad_viajes,
    SUM(tr.monto_tr) AS gasto_total_soles
FROM pasajero p
JOIN transaccion tr ON p.pasajero_id = tr.pasajero_id
WHERE tr.estado_tr = 'Completada'
GROUP BY p.dni_pasajero
HAVING SUM(tr.monto_tr) > (
    SELECT AVG(monto_tr) 
    FROM transaccion 
    WHERE estado_tr = 'Completada'
)
ORDER BY gasto_total_soles DESC
LIMIT 50; -- limitamos a los 50 mejores clientes


--seccion 5 (dml avanzado mantenimiento masivo)
--en este dml actualizamos a inactiva toda tarjeta que su fecha de caducidad
-- ya paso, pero el sistema aun tiene marcada como activa
UPDATE tarjeta 
SET estado_tarjeta = 'Inactiva'
WHERE fecha_caducidad < NOW() 
  AND estado_tarjeta = 'Activa';

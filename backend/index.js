const express = require('express');
const cors = require('cors');
const { Pool } = require('pg');
const { Parser } = require('json2csv');

const app = express();
app.use(cors());
app.use(express.json());

const pool = new Pool({
    user: 'postgres',
    host: 'localhost',
    database: 'mi_proyecto_db', 
    password: '123456', 
    port: 5432,
});

//Obtener todos los pasajeros
app.get('/api/pasajeros', async (req, res) => {
    try {
        const result = await pool.query('SELECT * FROM pasajero ORDER BY pasajero_id ASC');
        res.json(result.rows);
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Error al consultar pasajeros');
    }
});

//Insertar un nuevo pasajero
app.post('/api/pasajeros', async (req, res) => {
    try {
        const { id, dni, telefono } = req.body;
        await pool.query(
            'INSERT INTO pasajero (pasajero_id, dni_pasajero, telefono_pasajero) VALUES ($1, $2, $3)',
            [id, dni, telefono]
        );
        res.status(201).send('Pasajero agregado con éxito');
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Error al insertar el pasajero');
    }
});

//Descargar CSV de transacciones POR PASAJERO
app.get('/api/transacciones/csv/:pasajero_id', async (req, res) => {
    try {
        const { pasajero_id } = req.params;
        const result = await pool.query('SELECT * FROM transaccion WHERE pasajero_id = $1', [pasajero_id]);
        const transacciones = result.rows;

        if (transacciones.length === 0) return res.status(404).send('No hay transacciones.');

        const json2csvParser = new Parser({ delimiter: ';', withBOM: true });
        res.header('Content-Type', 'text/csv');
        res.attachment(`reporte_transacciones_${pasajero_id}.csv`); //obliga al navegador a descargar 
        return res.send(json2csvParser.parse(transacciones));
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Error al generar el archivo CSV');
    }
});

//Descargar CSV de todas las transacciones 
app.get('/api/transacciones/csv', async (req, res) => {
    try {
        const result = await pool.query('SELECT * FROM transaccion');
        const transacciones = result.rows;

        if (transacciones.length === 0) return res.status(404).send('La base de datos está vacía.');

        const json2csvParser = new Parser({ delimiter: ';', withBOM: true });
        res.header('Content-Type', 'text/csv');
        res.attachment('reporte_general_completo.csv');
        return res.send(json2csvParser.parse(transacciones));
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Error al generar el archivo CSV');
    }
});

//CRUD COMPLEJO -- transaccion
app.post('/api/transacciones/pagar-pasaje', async (req, res) => {
    const { transaccion_id, tarjeta_id, tarifa_id, pasajero_id } = req.body;
    
    try {
        await pool.query('BEGIN');

        const resTarifa = await pool.query('SELECT monto FROM tarifa WHERE tarifa_id = $1', [tarifa_id]);
        if (resTarifa.rows.length === 0) throw new Error('Tarifa no encontrada');
        const monto = resTarifa.rows[0].monto;

        const resTarjeta = await pool.query('SELECT saldo_actual, estado_tarjeta FROM tarjeta WHERE tarjeta_id = $1 FOR UPDATE', [tarjeta_id]);
        if (resTarjeta.rows.length === 0) throw new Error('Tarjeta no encontrada');
        
        const tarjeta = resTarjeta.rows[0];
        if (tarjeta.estado_tarjeta !== 'Activa') throw new Error('La tarjeta no está activa');
        if (tarjeta.saldo_actual < monto) throw new Error('Saldo insuficiente para el viaje');

        const nuevoSaldo = tarjeta.saldo_actual - monto;
        const nuevoEstado = nuevoSaldo === 0 ? 'Inactiva' : 'Activa';
        
        //calcular nuevo saldo
        await pool.query(
            'UPDATE tarjeta SET saldo_actual = $1, estado_tarjeta = $2 WHERE tarjeta_id = $3',
            [nuevoSaldo, nuevoEstado, tarjeta_id]
        );

        await pool.query(
            `INSERT INTO transaccion (transaccion_id, monto_tr, fecha_hora_tr, estado_tr, pasajero_id, tarjeta_id, tarifa_id) 
             VALUES ($1, $2, NOW(), 'Completada', $3, $4, $5)`,
            [transaccion_id, monto, pasajero_id, tarjeta_id, tarifa_id]
        );

        await pool.query('COMMIT');
        res.status(201).json({ mensaje: 'Pasaje pagado con éxito', nuevoSaldo, estadoTarjeta: nuevoEstado });
    } 
    catch (err) 
    { //si no hay saldo en el usuario
        await pool.query('ROLLBACK');
        console.error(err.message);
        res.status(400).send(`Error en la operación: ${err.message}`);
    }
});

//reporte y exportacion con group by y having
app.get('/api/reportes/ingresos-tipo-usuario', async (req, res) => {
    try {
        //ejecucucion de una consulta para mostrar 
        const query = ` 
            SELECT 
                tu.nombre AS tipo_usuario,
                COUNT(t.transaccion_id) AS total_viajes,
                SUM(t.monto_tr) AS ingresos_totales
            FROM transaccion t
            JOIN tarjeta trj ON t.tarjeta_id = trj.tarjeta_id
            JOIN tipo_usuario tu ON trj.tarjeta_id = tu.tarjeta_id
            WHERE t.estado_tr = 'Completada'
            GROUP BY tu.nombre
            HAVING SUM(t.monto_tr) > 0
            ORDER BY ingresos_totales DESC;
        `;
        
        const result = await pool.query(query); //ejecucion y validacion 
        const reporte = result.rows;

        if (reporte.length === 0) return res.status(404).send('No hay datos suficientes para el reporte.'); //seguro por si no hay datos

        const json2csvParser = new Parser({ delimiter: ';', withBOM: true });
        const csv = json2csvParser.parse(reporte);

        //descarga automatica
        res.header('Content-Type', 'text/csv');
        res.attachment('Reporte_Ingresos_Por_Tipo_Usuario.csv');    //descarga el archivo como...
        return res.send(csv);   //guarda el archivo en la pc
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Error al generar el reporte complejo');
    }
});

const PORT = 3000;
app.listen(PORT, () => {
    console.log(`Servidor Backend corriendo en http://localhost:${PORT}`);
});

// Editar un pasajero (Update)
app.put('/api/pasajeros/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const { dni, telefono } = req.body;
        
        const result = await pool.query(
            'UPDATE pasajero SET dni_pasajero = $1, telefono_pasajero = $2 WHERE pasajero_id = $3 RETURNING *',
            [dni, telefono, id]
        );

        if (result.rowCount === 0) {
            return res.status(404).send('Pasajero no encontrado');
        }
        res.json({ mensaje: 'Pasajero actualizado con éxito', pasajero: result.rows[0] });
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Error al actualizar el pasajero');
    }
});

// Eliminar un pasajero (Delete)
app.delete('/api/pasajeros/:id', async (req, res) => {
    try {
        const { id } = req.params;
        
        const result = await pool.query(
            'DELETE FROM pasajero WHERE pasajero_id = $1 RETURNING *',
            [id]
        );

        if (result.rowCount === 0) {
            return res.status(404).send('Pasajero no encontrado');
        }
        res.json({ mensaje: 'Pasajero eliminado con éxito' });
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Error al eliminar el pasajero. Verifica si tiene tarjetas asociadas.');
    }
});
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
        res.attachment(`reporte_transacciones_${pasajero_id}.csv`);
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

const PORT = 3000;
app.listen(PORT, () => {
    console.log(`Servidor Backend corriendo en http://localhost:${PORT}`);
});
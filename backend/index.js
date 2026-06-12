const express = require('express');
const cors = require('cors');
const { Pool } = require('pg');
const { Parser } = require('json2csv');

const app = express();

// Permite que el frontend se conecte sin problemas de seguridad (CORS)
app.use(cors());
app.use(express.json());

// 1. Configuración de conexión a PostgreSQL
// ¡IMPORTANTE!: Cambia 'tu_contraseña' y 'nombre_de_tu_bd' por los datos reales de tu pgAdmin
const pool = new Pool({
    user: 'postgres',
    host: 'localhost',
    database: 'mi_proyecto_db', 
    password: '123456', 
    port: 5432,
});

// Ruta de prueba
app.get('/', (req, res) => {
    res.send('API del Sistema de Transporte funcionando OK');
});

// 2. Ruta para obtener los pasajeros (Para mostrarlos en el frontend básico)
app.get('/api/pasajeros', async (req, res) => {
    try {
        const result = await pool.query('SELECT * FROM pasajero');
        res.json(result.rows);
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Error al consultar la base de datos');
    }
});

// 3. Ruta para descargar el CSV de transacciones (Lo que pidió la profesora)
app.get('/api/transacciones/csv', async (req, res) => {
    try {
        const result = await pool.query('SELECT * FROM transaccion');
        const transacciones = result.rows;

        if (transacciones.length === 0) {
            return res.status(404).send('No hay datos de transacciones para exportar');
        }

        // Convertir el JSON a formato CSV
        const json2csvParser = new Parser();
        const csv = json2csvParser.parse(transacciones);

        // Configurar los encabezados de respuesta para forzar la descarga del archivo
        res.header('Content-Type', 'text/csv');
        res.attachment('reporte_transacciones.csv');
        return res.send(csv);

    } catch (err) {
        console.error(err.message);
        res.status(500).send('Error al generar el archivo CSV');
    }
});

// Iniciar el servidor
const PORT = 3000;
app.listen(PORT, () => {
    console.log(`Servidor Backend corriendo en http://localhost:${PORT}`);
});
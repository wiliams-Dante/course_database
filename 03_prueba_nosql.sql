
CREATE TABLE pasajero_documental (
    id SERIAL PRIMARY KEY,
    datos JSONB NOT NULL
);

-- Inserción del documento adaptado a los nuevos tipos de datos (NUMERIC)
INSERT INTO pasajero_documental (datos) 
VALUES (
'{
  "pasajero_id": "PSJ00000000001",
  "dni_pasajero": "60062056",
  "telefono_pasajero": "987654321",
  "tarjetas": [
    {
      "tarjeta_id": "TRJ00000000001",
      "saldo_actual": 50.00,
      "estado_tarjeta": "Activa",
      "tipo_usuario": {
        "tipo_id": "TUS00000000001",
        "nombre": "Universitario",
        "descuento_porcentaje": 50
      },
      "transacciones": [
        {
          "transaccion_id": "TRN00000000001",
          "monto_tr": 2.00,
          "fecha_hora_tr": "2026-05-24 07:15:00",
          "estado_tr": "Completada"
        }
      ]
    }
  ]
}'::jsonb);

-- Consulta para buscar dentro de la estructura anidada del JSON
SELECT 
    datos->>'pasajero_id' AS id,
    datos->>'dni_pasajero' AS dni,
    datos->>'telefono_pasajero' AS telefono
FROM pasajero_documental
WHERE datos @> '{"tarjetas": [{"tipo_usuario": {"nombre": "Universitario"}}]}';
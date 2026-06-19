# Resolución de la Tarea: Diseño Relacional vs NoSQL

Este documento contiene el desarrollo de los 4 puntos solicitados para la comparación entre el modelo relacional tradicional y el modelo documental (NoSQL) aplicado a nuestro sistema de transporte.

---
Diseño Relacional: Tablas, Llaves Foráneas y JOIN

En el modelo relacional clásico de nuestro proyecto, para gestionar a los usuarios y sus pagos fragmentamos la información en tres tablas principales para evitar redundancia:

*   **`pasajero`**: Contiene los datos del cliente (`pasajero_id` es PK).
*   **`tarjeta`**: Contiene el saldo (`tarjeta_id` es PK y tiene una FK `pasajero_id`).
*   **`transaccion`**: Registra cada viaje pagado (`transaccion_id` es PK y tiene una FK `tarjeta_id` y `pasajero_id`).

### El JOIN convencional
Si quisiéramos consultar los datos de un pasajero, el saldo actual de su tarjeta y el historial de sus transacciones, tendríamos que realizar el siguiente `JOIN`:

```sql
SELECT 
    p.dni_pasajero, 
    p.telefono_pasajero, 
    t.tarjeta_id, 
    t.saldo_actual, 
    tr.transaccion_id,
    tr.monto_tr, 
    tr.fecha_hora_tr,
    tr.estado_tr
FROM pasajero p
JOIN tarjeta t ON p.pasajero_id = t.pasajero_id
JOIN transaccion tr ON t.tarjeta_id = tr.tarjeta_id;


{
  "pasajero_id": "PAS-9823",
  "dni_pasajero": "74839201",
  "telefono_pasajero": "987654321",
  "tarjetas": [
    {
      "tarjeta_id": "TARJ-4412",
      "fecha_emision": "2026-02-15T08:00:00Z",
      "fecha_caducidad": "2031-02-15T08:00:00Z",
      "saldo_actual": 45,
      "estado_tarjeta": "Activa",
      "transacciones": [
        {
          "transaccion_id": "TRX-00192",
          "monto_tr": 5,
          "fecha_hora_tr": "2026-06-19T07:15:00Z",
          "estado_tr": "Completada"
        },
        {
          "transaccion_id": "TRX-00240",
          "monto_tr": 3,
          "fecha_hora_tr": "2026-06-19T13:40:00Z",
          "estado_tr": "Completada"
        }
      ]
    }
  ]
}
# Reto: Mapeo Políglota de tu Proyecto Final

Este documento contiene el diseño relacional, la propuesta de migración a un modelo basado en documentos (NoSQL/JSONB) y las consultas correspondientes para el sistema de gestión de transporte.

---

## 1. Diseño Relacional y Consulta Compleja (JOIN)

En el modelo relacional actual, la información del usuario, sus beneficios y sus movimientos se encuentra fragmentada en cuatro tablas vinculadas por llaves foráneas (`pasajero`, `tarjeta`, `tipo_usuario`, `transaccion`).

Para obtener el perfil completo de un pasajero junto a su tarjeta activa, su tipo de usuario (beneficio) y su historial de transacciones, se requiere la siguiente consulta con múltiples `JOIN`:

```sql
SELECT 
    p.pasajero_id,
    p.dni_pasajero, 
    p.telefono_pasajero, 
    t.tarjeta_id, 
    t.saldo_actual, 
    t.estado_tarjeta,
    tu.nombre AS tipo_beneficio,
    tu.descuento_porcentaje,
    tr.transaccion_id,
    tr.monto_tr,
    tr.fecha_hora_tr,
    tr.estado_tr
FROM pasajero p
JOIN tarjeta t ON p.pasajero_id = t.pasajero_id
LEFT JOIN tipo_usuario tu ON t.tarjeta_id = tu.tarjeta_id
LEFT JOIN transaccion tr ON t.tarjeta_id = tr.tarjeta_id
WHERE p.pasajero_id = 'PSJ00000000001';
```
---

 ## 2. Diseño NoSQL (Estructura de Documento Unificado)
Para optimizar las lecturas y evitar múltiples uniones en tiempo de ejecución, transformamos la relación en un esquema híbrido/documental. Toda la información dependiente se anida dentro del documento raíz del pasajero.

A continuación, se muestra cómo se estructura la misma información unificada dentro de un único documento JSON/JSONB:

```
JSON
{
  "pasajero_id": "PSJ00000000001",
  "dni_pasajero": "60062056",
  "telefono_pasajero": "987654321",
  "tarjetas": [
    {
      "tarjeta_id": "TRJ00000000001",
      "saldo_actual": 50,
      "estado_tarjeta": "Activa",
      "tipo_usuario": {
        "tipo_id": "TUS00000000001",
        "nombre": "Universitario",
        "descuento_porcentaje": 50
      },
      "transacciones": [
        {
          "transaccion_id": "TRN00000000001",
          "monto_tr": 2,
          "fecha_hora_tr": "2026-05-24 07:15:00",
          "estado_tr": "Completada"
        }
      ]
    }
  ]
}

```

---
 ## 3. Consulta de Filtrado sobre Propiedades Internas (PostgreSQL JSONB)
Asumiendo que almacenamos estos documentos en una tabla relacional híbrida llamada pasajero_documental dentro de una columna de tipo JSONB llamada datos, podemos consumir las propiedades internas de la siguiente manera.

Esta consulta filtra y devuelve los datos de los pasajeros que poseen tarjetas asociadas al tipo de usuario "Universitario":

SQL
```
-- Usando el operador de contención (@>) eficiente para índices GIN en PostgreSQL
SELECT 
    datos->>'pasajero_id' AS id,
    datos->>'dni_pasajero' AS dni,
    datos->>'telefono_pasajero' AS telefono
FROM pasajero_documental
WHERE datos @> '{"tarjetas": [{"tipo_usuario": {"nombre": "Universitario"}}]}';
```

--- 

## 4. Sustento Técnico: Flexibilidad Documental vs. JOINs Tradicionales
El uso de un enfoque documental (o columnas JSONB) supera al modelo relacional tradicional en este escenario por las siguientes razones:

Rendimiento Crítico en Tiempo Real: En el transporte masivo, un validador de bus necesita autorizar el acceso en milisegundos. Realizar tres JOINs en una base de datos con millones de registros cada vez que un pasajero pasa su tarjeta genera una carga de procesamiento innecesaria. Leer un único documento unificado es directo y mucho más rápido para el motor de base de datos.

Localidad de los Datos: Las transacciones y los tipos de usuario no tienen sentido de existencia en el sistema si se elimina la tarjeta o al pasajero. Al estar fuertemente cohesionados, su almacenamiento contiguo en disco (dentro del mismo documento JSON) reduce enormemente los tiempos de búsqueda.

Evolución y Flexibilidad del Esquema: Si en el futuro se implementan nuevos tipos de tarjetas con atributos adicionales (por ejemplo, "viajes_gratuitos_restantes" o "banco_emisor"), el modelo documental permite agregarlos al instante sin tener que ejecutar sentencias ALTER TABLE que podrían bloquear la base de datos o requerir la reestructuración de todo el sistema.
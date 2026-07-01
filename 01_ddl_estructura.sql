
--1. tablas principales e indeppendientes

CREATE TABLE empresa (
    ruc CHAR(11) PRIMARY KEY, -- Corregido a 11 dígitos reales
    nombre_empresa VARCHAR(30) NOT NULL UNIQUE,
    direccion_empresa VARCHAR(50) NULL,
    telefono_empresa BIGINT NOT NULL
);

CREATE TABLE ruta (
    ruta_id CHAR(14) PRIMARY KEY,
    nombre_ruta VARCHAR(50) NOT NULL UNIQUE,
    empresa_ruc CHAR(11) NOT NULL,
    CONSTRAINT fk_ruta_empresa FOREIGN KEY (empresa_ruc) REFERENCES empresa(ruc)
);

CREATE TABLE chofer (
    chofer_id CHAR(14) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL, -- Corregido: Ahora es un humano
    apellido VARCHAR(50) NOT NULL,
    dni CHAR(8) NOT NULL UNIQUE,
    licencia_conducir VARCHAR(15) NOT NULL,
    empresa_ruc CHAR(11) NOT NULL,
    CONSTRAINT fk_chofer_empresa FOREIGN KEY (empresa_ruc) REFERENCES empresa(ruc)
);

CREATE TABLE pasajero (
    pasajero_id CHAR(14) PRIMARY KEY,
    dni_pasajero CHAR(8) NOT NULL UNIQUE,
    telefono_pasajero VARCHAR(15) NOT NULL
);

--2. tablas con dependencias

CREATE TABLE unidad (
    placa VARCHAR(6) PRIMARY KEY,
    modelo_unidad VARCHAR(30) NULL,
    capacidad_psjros INT NOT NULL CHECK (capacidad_psjros > 0 AND capacidad_psjros <= 100),
    estado_operativo VARCHAR(10) NOT NULL CHECK (estado_operativo IN ('Operativo', 'Mantenimiento', 'Inactivo')),
    empresa_ruc CHAR(11) NOT NULL,
    chofer_id CHAR(14) NOT NULL,
    ruta_id CHAR(14) NULL, -- Puede ser null si el bus no tiene ruta asignada
    CONSTRAINT fk_unidad_empresa FOREIGN KEY (empresa_ruc) REFERENCES empresa(ruc),
    CONSTRAINT fk_unidad_chofer FOREIGN KEY (chofer_id) REFERENCES chofer(chofer_id),
    CONSTRAINT fk_unidad_ruta FOREIGN KEY (ruta_id) REFERENCES ruta(ruta_id) ON DELETE SET NULL
);

CREATE TABLE tarjeta (
    tarjeta_id CHAR(14) PRIMARY KEY,
    fecha_emision TIMESTAMP NOT NULL,
    fecha_caducidad TIMESTAMP NULL, 
    saldo_actual NUMERIC(10,2) NOT NULL, -- Corregido a DECIMAL
    estado_tarjeta VARCHAR(10) NOT NULL, 
    pasajero_id CHAR(14) NOT NULL, -- Estandarizado a CHAR(14)
    CONSTRAINT fk_tarjeta_pasajero FOREIGN KEY (pasajero_id) REFERENCES pasajero(pasajero_id)
);

CREATE TABLE tarifa (
    tarifa_id CHAR(14) PRIMARY KEY,
    monto NUMERIC(10,2) NOT NULL, -- Corregido a DECIMAL
    pasajero_id CHAR(14) NOT NULL,
    tarjeta_id CHAR(14) NOT NULL,
    CONSTRAINT fk_tarifa_pasajero FOREIGN KEY (pasajero_id) REFERENCES pasajero(pasajero_id),
    CONSTRAINT fk_tarifa_tarjeta FOREIGN KEY (tarjeta_id) REFERENCES tarjeta(tarjeta_id)
);

CREATE TABLE transaccion (
    transaccion_id CHAR(14) PRIMARY KEY,
    monto_tr NUMERIC(10,2) NOT NULL CHECK (monto_tr > 0), -- Corregido a DECIMAL
    fecha_hora_tr TIMESTAMP NOT NULL,
    estado_tr VARCHAR(30) NOT NULL CHECK (estado_tr IN ('Completada', 'Rechazada', 'Anulada')),
    pasajero_id CHAR(14) NOT NULL,
    tarjeta_id CHAR(14) NOT NULL,
    tarifa_id CHAR(14) NOT NULL,
    CONSTRAINT fk_transaccion_pasajero FOREIGN KEY (pasajero_id) REFERENCES pasajero(pasajero_id),
    CONSTRAINT fk_transaccion_tarjeta FOREIGN KEY (tarjeta_id) REFERENCES tarjeta(tarjeta_id),
    CONSTRAINT fk_transaccion_tarifa FOREIGN KEY (tarifa_id) REFERENCES tarifa(tarifa_id)
);

--3. tablas de reportes y sub entidades

CREATE TABLE reporte_ingresos (
    reporte_id CHAR(14) PRIMARY KEY,
    fecha_reporte TIMESTAMP NOT NULL,
    total_ingresos NUMERIC(10,2) NOT NULL CHECK (total_ingresos >= 0), -- Corregido a DECIMAL
    total_transacciones INT NOT NULL CHECK (total_transacciones >= 0),
    empresa_ruc CHAR(11) NOT NULL,
    tarifa_id CHAR(14) NOT NULL,
    CONSTRAINT fk_reporte_empresa FOREIGN KEY (empresa_ruc) REFERENCES empresa(ruc),
    CONSTRAINT fk_reporte_tarifa FOREIGN KEY (tarifa_id) REFERENCES tarifa(tarifa_id)
); 

CREATE TABLE tipo_usuario (
    tipo_id CHAR(14) PRIMARY KEY,
    nombre VARCHAR(30) NULL,
    descuento_porcentaje INT NOT NULL CHECK (descuento_porcentaje >= 0 AND descuento_porcentaje <= 100),
    tarjeta_id CHAR(14) NOT NULL,
    CONSTRAINT fk_tipo_usuario_tarjeta FOREIGN KEY (tarjeta_id) REFERENCES tarjeta(tarjeta_id)
);

CREATE TABLE incidencia (
    incidencia_id CHAR(14) PRIMARY KEY,
    fecha_reporte TIMESTAMP NOT NULL,
    descripcion VARCHAR(500) NULL,
    estado VARCHAR(30) NOT NULL,
    tarjeta_id CHAR(14) NOT NULL,
    CONSTRAINT fk_incidencia_tarjeta FOREIGN KEY (tarjeta_id) REFERENCES tarjeta(tarjeta_id)
);

CREATE TABLE tipo_tarjeta (
    recarga_id CHAR(14) PRIMARY KEY,
    prepago VARCHAR(10) NOT NULL,
    postpago VARCHAR(10) NOT NULL,
    beneficio VARCHAR(30) NOT NULL,
    tarjeta_id CHAR(14) NOT NULL,
    CONSTRAINT fk_tipo_tarjeta_ref FOREIGN KEY (tarjeta_id) REFERENCES tarjeta(tarjeta_id)
);

CREATE TABLE bloqueo_tarjeta (
    bloqueo_id CHAR(14) PRIMARY KEY,
    fecha_bloqueo TIMESTAMP NOT NULL,
    fecha_desbloqueo TIMESTAMP NOT NULL,
    motivo VARCHAR(500) NOT NULL,
    estado VARCHAR(30) NOT NULL,
    tarjeta_id CHAR(14) NOT NULL,
    CONSTRAINT fk_bloqueo_tarjeta_ref FOREIGN KEY (tarjeta_id) REFERENCES tarjeta(tarjeta_id) ON DELETE CASCADE
);

CREATE TABLE notificacion_pasajero (
    notificacion_id CHAR(14) PRIMARY KEY,
    fecha TIMESTAMP NOT NULL,
    tipo VARCHAR(20) NOT NULL,
    mensaje VARCHAR(500) NOT NULL,
    tarjeta_id CHAR(14) NOT NULL,
    CONSTRAINT fk_notificacion_tarjeta FOREIGN KEY (tarjeta_id) REFERENCES tarjeta(tarjeta_id) ON DELETE CASCADE
);

CREATE TABLE historial_cambio_tarjeta (
    cambio_id CHAR(14) PRIMARY KEY,
    fecha_cambio TIMESTAMP NOT NULL,
    motivo_cambio VARCHAR(500) NOT NULL,
    tarjeta_id CHAR(14) NOT NULL,
    CONSTRAINT fk_historial_tarjeta FOREIGN KEY (tarjeta_id) REFERENCES tarjeta(tarjeta_id)
);
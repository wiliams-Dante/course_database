/*tablitas jeje*/

CREATE TABLE empresa (
	ruc CHAR(29) primary key,
	nombre_empresa VARCHAR(30) not null,
	direccion_empresa VARCHAR(50) null,
	telefono_empresa BIGINT not null,
	placa_unidad VARCHAR(6) not null,
	chofer_id CHAR(14) not null
);

CREATE TABLE ruta (
	ruta_id CHAR(14) primary key,
	nombre_ruta VARCHAR(50) not null,
	empresa_ruc CHAR(20) not null
);

CREATE TABLE unidad (
    placa VARCHAR(6) primary key,
    modelo_unidad VARCHAR(30) null,
    capacidad_psjros INT not null,
    estado_operativo VARCHAR(10) not null,
    empresa_ruc CHAR(20) not null,
    chofer_id CHAR(14) not null,
    ruta_id CHAR(14) not null
);

CREATE TABLE chofer(
	chofer_id CHAR(14) primary key,
	modelo_unidad VARCHAR(30) null,
    capacidad_psjros INT not null,
    estado_operativo VARCHAR(10) not null,
    empresa_ruc CHAR(20) not null,
    ruta_id CHAR(14) not null
);

create table pasajero (
	pasajero_id CHAR(14) primary key,
	dni_pasajero CHAR(8) not null unique,
	telefono_pasajero VARCHAR(15) not null
);


CREATE TABLE tarjeta(
	tarjeta_id CHAR(14) PRIMARY KEY,
	fecha_emision TIMESTAMP NOT NULL,
	fecha_caducidad TIMESTAMP NULL, 
	saldo_actual INT NOT NULL,
	estado_tarjeta VARCHAR(10) NOT NULL, 
	pasajero_id VARCHAR(14) NOT NULL    

);

CREATE TABLE tarifa(
	tarifa_id CHAR(14) PRIMARY KEY,
	monto INT NOT NULL,
	pasajero_id CHAR(14) NOT NULL,
	tarjeta_id CHAR(14) NOT NULL	
);

CREATE TABLE transaccion (
	transaccion_id CHAR(14) PRIMARY KEY,
	monto_tr INT NOT NULL,
	fecha_hora_tr TIMESTAMP NOT NULL,
	estado_tr VARCHAR(30) NOT NULL,
	pasajero_id CHAR(14) NOT NULL,
	tarjeta_id CHAR(14) NOT NULL,
	tarifa_id CHAR(14) NOT NULL 
);


CREATE TABLE reporte_ingresos (
	reporte_id CHAR(14) PRIMARY KEY,
	fecha_reporte TIMESTAMP NOT NULL,
	total_ingresos INT NOT NULL,
	total_transacciones INT NOT NULL,
	empresa_ruc CHAR(14) NOT NULL,
	tarifa_id CHAR(14) NOT NULL
); 

CREATE TABLE tipo_usuario(
	tipo_id CHAR(14) PRIMARY KEY,
	nombre VARCHAR(30) NULL,
	descuento_porcentaje INT NOT NULL,
	tarjeta_id CHAR(14) NOT NULL
);


CREATE TABLE incidencia (
    incidencia_id CHAR(14) PRIMARY KEY,
    fecha_reporte TIMESTAMP NOT NULL,
    descripcion VARCHAR(500) NULL,
    estado VARCHAR(30) NOT NULL,
    tarjeta_id CHAR(14) NOT NULL
);


CREATE TABLE tipo_tarjeta (
    recarga_id CHAR(14) PRIMARY KEY,
    prepago VARCHAR(10) NOT NULL,
    postpago VARCHAR(10) NOT NULL,
    beneficio VARCHAR(30) NOT NULL,
    tarjeta_id CHAR(14) NOT NULL
);

CREATE TABLE bloqueo_tarjeta (
    bloqueo_id CHAR(14) PRIMARY KEY,
    fecha_bloqueo TIMESTAMP NOT NULL,
    fecha_desbloqueo TIMESTAMP NOT NULL,
    motivo VARCHAR(500) NOT NULL,
    estado VARCHAR(30) NOT NULL,
    tarjeta_id CHAR(14) NOT NULL
);

CREATE TABLE notificacion_pasajero (
    notificacion_id CHAR(14) PRIMARY KEY,
    fecha TIMESTAMP NOT NULL,
    tipo VARCHAR(20) NOT NULL,
    mensaje VARCHAR(500) NOT NULL,
    tarjeta_id CHAR(14) NOT NULL
);


CREATE TABLE historial_cambio_tarjeta (
    cambio_id CHAR(14) PRIMARY KEY,
    fecha_cambio TIMESTAMP NOT NULL,
    motivo_cambio VARCHAR(500) NOT NULL,
    tarjeta_id CHAR(14) NOT NULL
);


ALTER TABLE empresa
	ADD CONSTRAINT uk_nombre_empresa UNIQUE (nombre_empresa);


ALTER TABLE ruta 
    ADD CONSTRAINT uk_nombre_ruta UNIQUE (nombre_ruta);


ALTER TABLE unidad 
    ADD CONSTRAINT chk_capacidad CHECK (capacidad_psjros > 0 AND capacidad_psjros <= 100),
    ADD CONSTRAINT chk_estado_unidad CHECK (estado_operativo IN ('Operativo', 'Mantenimiento', 'Inactivo'));


ALTER TABLE transaccion 
    ADD CONSTRAINT chk_monto_tr CHECK (monto_tr > 0),
    ADD CONSTRAINT chk_estado_tr CHECK (estado_tr IN ('Completada', 'Rechazada', 'Anulada'));


ALTER TABLE tipo_usuario 
    ADD CONSTRAINT chk_descuento CHECK (descuento_porcentaje >= 0 AND descuento_porcentaje <= 100);


ALTER TABLE reporte_ingresos
    ADD CONSTRAINT chk_totales_reporte CHECK (total_ingresos >= 0 AND total_transacciones >= 0);


-- habilitar delete: si borramos una tarjeta, se borra automaticamente su historial de bloqueos
ALTER TABLE bloqueo_tarjeta 
    ADD CONSTRAINT fk_bloqueo_tarjeta_ref FOREIGN KEY (tarjeta_id) REFERENCES tarjeta(tarjeta_id) ON DELETE CASCADE;

-- ahora el mismo proceso para las notificaciones
ALTER TABLE notificacion_pasajero 
    ADD CONSTRAINT fk_notificacion_tarjeta FOREIGN KEY (tarjeta_id) REFERENCES tarjeta(tarjeta_id) ON DELETE CASCADE;

-- implementar que ruta sea nulo y si se borra, el bus no tiene ruta, pero no se borrara
ALTER TABLE unidad ALTER COLUMN ruta_id DROP NOT NULL;
ALTER TABLE unidad 
    ADD CONSTRAINT fk_unidad_ruta FOREIGN KEY (ruta_id) REFERENCES ruta(ruta_id) ON DELETE SET NULL;

	-- Reparando tamaños de RUC para que todos sean CHAR(20)
ALTER TABLE empresa ALTER COLUMN ruc TYPE CHAR(20);
ALTER TABLE ruta ALTER COLUMN empresa_ruc TYPE CHAR(20);
ALTER TABLE unidad ALTER COLUMN empresa_ruc TYPE CHAR(20);
ALTER TABLE reporte_ingresos ALTER COLUMN empresa_ruc TYPE CHAR(20);

/* Reparando el tipo de dato de pasajero_id en la tabla tarjeta*/
ALTER TABLE tarjeta ALTER COLUMN pasajero_id TYPE CHAR(14);

/* Conectar RUTA con EMPRESA*/
ALTER TABLE ruta 
    ADD CONSTRAINT fk_ruta_empresa FOREIGN KEY (empresa_ruc) REFERENCES empresa(ruc);

/*Conectar UNIDAD con EMPRESA, RUTA y CHOFER*/
ALTER TABLE unidad 
    ADD CONSTRAINT fk_unidad_empresa FOREIGN KEY (empresa_ruc) REFERENCES empresa(ruc);

ALTER TABLE unidad 
    ADD CONSTRAINT fk_unidad_ruta FOREIGN KEY (ruta_id) REFERENCES ruta(ruta_id);

ALTER TABLE unidad 
    ADD CONSTRAINT fk_unidad_chofer FOREIGN KEY (chofer_id) REFERENCES chofer(chofer_id);

/*Conectar TARJETA con PASAJERO*/
ALTER TABLE tarjeta 
    ADD CONSTRAINT fk_tarjeta_pasajero FOREIGN KEY (pasajero_id) REFERENCES pasajero(pasajero_id);

/*Conectar los subtipos y estados a la TARJETA*/
ALTER TABLE tipo_tarjeta 
    ADD CONSTRAINT fk_tipo_tarjeta_ref FOREIGN KEY (tarjeta_id) REFERENCES tarjeta(tarjeta_id);

ALTER TABLE tipo_usuario 
    ADD CONSTRAINT fk_tipo_usuario_ref FOREIGN KEY (tarjeta_id) REFERENCES tarjeta(tarjeta_id);

ALTER TABLE bloqueo_tarjeta 
    ADD CONSTRAINT fk_bloqueo_tarjeta_ref FOREIGN KEY (tarjeta_id) REFERENCES tarjeta(tarjeta_id);

ALTER TABLE notificacion_pasajero 
    ADD CONSTRAINT fk_notificacion_tarjeta FOREIGN KEY (tarjeta_id) REFERENCES tarjeta(tarjeta_id);

ALTER TABLE historial_cambio_tarjeta 
    ADD CONSTRAINT fk_historial_tarjeta FOREIGN KEY (tarjeta_id) REFERENCES tarjeta(tarjeta_id);

ALTER TABLE incidencia 
    ADD CONSTRAINT fk_incidencia_tarjeta FOREIGN KEY (tarjeta_id) REFERENCES tarjeta(tarjeta_id);

/*Conectar TARIFA con PASAJERO y TARJETA*/
ALTER TABLE tarifa 
    ADD CONSTRAINT fk_tarifa_pasajero FOREIGN KEY (pasajero_id) REFERENCES pasajero(pasajero_id);

ALTER TABLE tarifa 
    ADD CONSTRAINT fk_tarifa_tarjeta FOREIGN KEY (tarjeta_id) REFERENCES tarjeta(tarjeta_id);

/*Conectar TRANSACCION con sus tres entidades originarias*/
ALTER TABLE transaccion 
    ADD CONSTRAINT fk_transaccion_pasajero FOREIGN KEY (pasajero_id) REFERENCES pasajero(pasajero_id);

ALTER TABLE transaccion 
    ADD CONSTRAINT fk_transaccion_tarjeta FOREIGN KEY (tarjeta_id) REFERENCES tarjeta(tarjeta_id);

ALTER TABLE transaccion 
    ADD CONSTRAINT fk_transaccion_tarifa FOREIGN KEY (tarifa_id) REFERENCES tarifa(tarifa_id);

/*Conectar REPORTE DE INGRESOS con la EMPRESA y la TARIFA analizada*/
ALTER TABLE reporte_ingresos 
    ADD CONSTRAINT fk_reporte_empresa FOREIGN KEY (empresa_ruc) REFERENCES empresa(ruc);

ALTER TABLE reporte_ingresos 
    ADD CONSTRAINT fk_reporte_tarifa FOREIGN KEY (tarifa_id) REFERENCES tarifa(tarifa_id);
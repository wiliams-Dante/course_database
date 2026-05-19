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
)

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
    chofer_id CHAR(14) not null,
    ruta_id CHAR(14) not null
)

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

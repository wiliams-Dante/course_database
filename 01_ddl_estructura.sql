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
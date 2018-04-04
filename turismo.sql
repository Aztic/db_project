-- Creacion de la base de datos
CREATE DATABASE proyecto_turismo TEMPLATE template1;

-- Conexion a la base de datos
\c proyecto_turismo

-- Dominios
CREATE DOMAIN estado_civil
  as VARCHAR(20)
  CHECK (VALUE IN ('Soltero','Casado','Viudo'));

CREATE DOMAIN tipo_ruta
  as VARCHAR(20)
  CHECK (VALUE IN ('Avión','Barco','Taxi'));

CREATE DOMAIN tipo_posada
  as VARCHAR(10)
  CHECK (VALUE IN ('Apartamento','Casa'));

-- Tablas
CREATE TABLE cliente(
  id_cliente VARCHAR(40),
  usuario VARCHAR(30) UNIQUE NOT NULL,
  ciudad VARCHAR(30),
  clave VARCHAR(255) NOT NULL,
  estado VARCHAR(30),
  nacionalidad VARCHAR(30) NOT NULL,
  nombre_c VARCHAR(40) NOT NULL,
  edo_civil estado_civil NOT NULL,
  PRIMARY KEY (id_cliente)
);

CREATE TABLE proveedor(
  id_proveedor VARCHAR(40),
  usuario VARCHAR(30) UNIQUE NOT NULL,
  ciudad VARCHAR(30),
  clave VARCHAR(255) NOT NULL,
  estado VARCHAR(30),
  nacionalidad VARCHAR(30) NOT NULL,
  nombre_p VARCHAR(40) NOT NULL,
  pais_origen varchar(30),
  edo_civil estado_civil NOT NULL,
  PRIMARY KEY (id_proveedor)
);

CREATE TABLE destino_turistico(
  nombre VARCHAR(40),
  PRIMARY KEY (nombre)
);

CREATE TABLE plan_transporte(
  id_transporte VARCHAR(50),
  descripcion TEXT,
  PRIMARY KEY (id_transporte)
);

CREATE TABLE programa(
  codigo VARCHAR(30),
  precio FLOAT NOT NULL,
  direccion TEXT NOT NULL,
  fecha_inicio DATE NOT NULL,
  fecha_fin DATE NOT NULL,
  PRIMARY KEY (codigo)
);

CREATE TABLE hospedaje(
  precio REAL NOT NULL,
  rif VARCHAR(100) NOT NULL,
  direccion TEXT NOT NULL,
  PRIMARY KEY (rif, direccion)
);

CREATE TABLE hotel(
  rif_hotel VARCHAR(100),
  direccion_h TEXT,
  estrellas INTEGER NOT NULL,
  servicio BOOLEAN NOT NULL,
  precio FLOAT NOT NULL,
  CONSTRAINT precio_valido CHECK(
    precio > 0
  ),
  PRIMARY KEY(rif_hotel, direccion_h),
  FOREIGN KEY (rif_hotel, direccion_h) REFERENCES hospedaje ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE posada(
  rif_posada VARCHAR(100),
  direccion_p TEXT,
  calidad INTEGER NOT NULL,
  servicioP INTEGER NOT NULL,
  habitacion INTEGER NOT NULL,
  tipo tipo_posada NOT NULL,
  precio FLOAT NOT NULL,
  CONSTRAINT puntuacion_valida CHECK (
    calidad > 0
  ),
  CONSTRAINT cantidad_habitaciones_valida CHECK (
    habitacion > 0
  ),
  CONSTRAINT precio_valido CHECK (
    precio > 0
  ),
  PRIMARY KEY (rif_posada, direccion_p),
  FOREIGN KEY (rif_posada, direccion_p) REFERENCES hospedaje ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE residencia(
  rif_resid VARCHAR(100),
  direccion_r TEXT,
  id_prov VARCHAR(40),
  servicio_residencia BOOLEAN NOT NULL,
  precio FLOAT NOT NULL,
  CONSTRAINT precio_valio CHECK(
    precio > 0
  ),
  PRIMARY KEY (rif_resid, direccion_r),
  FOREIGN KEY (id_prov) REFERENCES proveedor ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (rif_resid, direccion_r) REFERENCES hospedaje ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE campamento(
  rif_camp VARCHAR(100),
  direccion_c VARCHAR,
  capacidad INTEGER NOT NULL,
  precio FLOAT NOT NULL,
  servicio_campamento BOOLEAN,
  CONSTRAINT capacidad_valida CHECK(
    capacidad > 0
  ),
  PRIMARY KEY (rif_camp, direccion_c),
  FOREIGN KEY (rif_camp, direccion_c) REFERENCES hospedaje ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE ruta(
  id_r VARCHAR(50),
  origen VARCHAR NOT NULL,
  destino VARCHAR NOT NULL,
  distancia INTEGER NOT NULL,
  rif_proveedor VARCHAR NOT NULL,
  nombre_l VARCHAR NOT NULL,
  tipo_l tipo_ruta NOT NULL,
  cupo INTEGER NOT NULL,
  precio FLOAT NOT NULL,
  fecha DATE NOT NULL,
  PRIMARY KEY (id_r)
);

CREATE TABLE contrata(
  id_cliente VARCHAR(40),
  id_trasporte VARCHAR(50),
  precio FLOAT NOT NULL,
  fecha DATE NOT NULL,
  PRIMARY KEY (id_cliente, id_trasporte),
  FOREIGN KEY (id_cliente) REFERENCES cliente ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (id_trasporte) REFERENCES plan_transporte ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE tiene(
  id_transporte VARCHAR(50),
  id_r VARCHAR(50),
  PRIMARY KEY (id_transporte, id_r),
  FOREIGN KEY (id_transporte) REFERENCES plan_transporte ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (id_r) REFERENCES ruta ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE compra(
  id_cliente VARCHAR(40),
  codigo VARCHAR(30),
  fecha DATE NOT NULL,
  PRIMARY KEY (id_cliente, codigo),
  FOREIGN KEY (id_cliente) REFERENCES cliente ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (codigo) REFERENCES programa ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE reserva(
  id_cliente VARCHAR(40),
  rif VARCHAR(100),
  direccion TEXT,
  fecha DATE NOT NULL,
  PRIMARY KEY (id_cliente, rif, direccion),
  FOREIGN KEY (id_cliente) REFERENCES cliente ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (rif, direccion) REFERENCES hospedaje ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE tipo(
  rif_camp VARCHAR(100),
  direccion_c TEXT,
  PRIMARY KEY (rif_camp),
  FOREIGN KEY (rif_camp, direccion_c) REFERENCES campamento ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE es(
  rif_posada VARCHAR(100),
  direccion_p TEXT,
  PRIMARY KEY(rif_posada),
  FOREIGN KEY (rif_posada, direccion_p) REFERENCES hospedaje ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE es_una(
  rif_resid VARCHAR(100),
  direccion_r TEXT,
  PRIMARY KEY (rif_resid, direccion_r),
  FOREIGN KEY (rif_resid, direccion_r) REFERENCES hospedaje ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE de(
  rif_hotel VARCHAR(100),
  direccion_h TEXT,
  PRIMARY KEY (rif_hotel, direccion_h),
  FOREIGN KEY (rif_hotel, direccion_h) REFERENCES hospedaje ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE galeria(
  nombre VARCHAR(40),
  foto VARCHAR(50),
  PRIMARY KEY (nombre, foto),
  FOREIGN KEY (nombre) REFERENCES destino_turistico ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE comercio(
  nombre VARCHAR(40),
  local VARCHAR(100),
  PRIMARY KEY (nombre, local),
  FOREIGN KEY (nombre) REFERENCES destino_turistico ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE sitios_f(
  nombre VARCHAR(40),
  sitio_f VARCHAR(100),
  PRIMARY KEY (nombre, sitio_f),
  FOREIGN KEY (nombre) REFERENCES destino_turistico ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE informacion(

  nombre VARCHAR(40),
  descripcion VARCHAR(100),
  PRIMARY KEY (nombre, descripcion),
  FOREIGN KEY (nombre) REFERENCES destino_turistico ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE historias(
  nombre VARCHAR(40),
  leyenda_anecdota VARCHAR,
  PRIMARY KEY (nombre, leyenda_anecdota),
  FOREIGN KEY (nombre) REFERENCES destino_turistico ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE edo(
  nombre VARCHAR (40),
  estado VARCHAR (20),
  PRIMARY KEY (nombre, estado),
  FOREIGN KEY (nombre) REFERENCES destino_turistico ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE contacto_ruta(
  rif VARCHAR(40),
  telef VARCHAR(15),
  PRIMARY KEY (rif, telef),
  FOREIGN KEY (rif) REFERENCES ruta ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE contacto_hospedaje(
  rif VARCHAR(100),
  direccion TEXT,
  telef VARCHAR(15),
  PRIMARY KEY (rif, direccion, telef),
  FOREIGN KEY (rif, direccion) REFERENCES hospedaje ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE requerimiento(
  id VARCHAR(40),
  requisito VARCHAR(100),
  PRIMARY KEY (id, requisito),
  FOREIGN KEY (id) REFERENCES proveedor ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE opinion(
  fecha DATE NOT NULL,
  descripcion VARCHAR(100),
  nombre_dt VARCHAR(40),
  id_cliente VARCHAR(40),
  PRIMARY KEY (fecha, descripcion, nombre_dt, id_cliente),
  FOREIGN KEY (nombre_dt) REFERENCES destino_turistico ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (id_cliente) REFERENCES cliente ON DELETE CASCADE ON UPDATE CASCADE

);

CREATE TABLE familia_c(
  id_cliente VARCHAR(40),
  relacion VARCHAR(20),
  nombre VARCHAR(30),
  fecha_nac DATE,
  PRIMARY KEY (id_cliente, relacion, nombre, fecha_nac),
  FOREIGN KEY (id_cliente) REFERENCES cliente ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE familia_prov(
  id_prov VARCHAR(40),
  relacion VARCHAR(20),
  nombre VARCHAR(30),
  fecha_nac DATE,
  PRIMARY KEY (id_prov, relacion, nombre, fecha_nac),
  FOREIGN KEY (id_prov) REFERENCES proveedor ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE visita(
  nombre_destino VARCHAR NOT NULL REFERENCES destino_turistico(nombre),
  id_cliente VARCHAR NOT NULL REFERENCES cliente(id_cliente),
  fecha DATE NOT NULL,
  PRIMARY KEY(nombre_destino,id_cliente,fecha)
);

-- Roles
CREATE USER admin_turismo WITH PASSWORD 'contraseña muy segura';
GRANT ALL PRIVILEGES ON DATABASE proyecto_turismo TO admin_turismo;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA PUBLIC TO admin_turismo;

-- Permisos
CREATE USER cliente_turismo WITH PASSWORD 'contraseña random';
GRANT INSERT ON TABLE cliente TO cliente_turismo;
GRANT UPDATE ON TABLE cliente TO cliente_turismo;
GRANT SELECT ON TABLE cliente TO cliente_turismo;
GRANT SELECT ON TABLE posada TO cliente_turismo;
GRANT SELECT ON TABLE hotel TO cliente_turismo;
GRANT SELECT ON TABLE campamento TO cliente_turismo;
GRANT SELECT ON TABLE residencia TO cliente_turismo;
GRANT SELECT ON TABLE hospedaje TO cliente_turismo;

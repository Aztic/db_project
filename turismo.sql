CREATE DATABASE proyecto_turismo;

\c proyecto_turismo


CREATE DOMAIN estado_civil
  as VARCHAR(20)
  CHECK (VALUE IN ('Soltero','Casado','Viudo'));

CREATE DOMAIN tipo_ruta
  as VARCHAR(20)
  CHECK (VALUE IN ('Avión','Barco','Taxi'));

CREATE DOMAIN tipo_posada
  as VARCHAR(10)
  CHECK (VALUE IN ('Apartamento','Casa'));

CREATE TABLE cliente(
  id_cliente VARCHAR(40),
  usuario VARCHAR(30) UNIQUE NOT NULL,
  ciudad VARCHAR(30),
  clave VARCHAR(255) NOT NULL,
  estado VARCHAR(30),
  nacionalidad VARCHAR(30) NOT NULL,
  nombre_c VARCHAR(40) NOT NULL,
  edo_civil estado_civil NOT NULL,
  es_admin BOOLEAN DEFAULT FALSE,
  PRIMARY KEY (id_cliente)
);

CREATE TABLE destino_turistico(
  nombre VARCHAR(40),
  PRIMARY KEY (nombre)
);

CREATE TABLE plan_transporte(
  id_transporte VARCHAR(50),
  descripcion VARCHAR(100),
  PRIMARY KEY (id_transporte)
);

CREATE TABLE programa(
  codigo VARCHAR(30),
  precio FLOAT NOT NULL,
  direccion VARCHAR(100) NOT NULL,
  fecha_inicio DATE NOT NULL,
  fecha_fin DATE NOT NULL,
  PRIMARY KEY (codigo)
);

CREATE TABLE hospedaje(
  precio FLOAT NOT NULL,
  rif VARCHAR(30) NOT NULL,
  direccion VARCHAR(60) NOT NULL,
  PRIMARY KEY (rif, direccion)
);

CREATE TABLE hotel(
  rif_hotel VARCHAR(30),
  direccion_h VARCHAR,
  estrellas INTEGER NOT NULL,
  servicio BOOLEAN NOT NULL,
  precio INTEGER NOT NULL,
  CONSTRAINT precio_valido CHECK(
    precio > 0
  ),
  PRIMARY KEY(rif_hotel,direccion_h)
);

CREATE TABLE posada(
  rif_posada VARCHAR(100),
  direccion_p VARCHAR,
  calidad INTEGER NOT NULL,
  servicioP INTEGER NOT NULL,
  habitacion INTEGER NOT NULL,
  tipo tipo_posada NOT NULL,
  precio INTEGER NOT NULL,
  CONSTRAINT puntuacion_valida CHECK (
    calidad > 0
  ),
  CONSTRAINT cantidad_habitaciones_valida CHECK (
    habitacion > 0
  ),
  CONSTRAINT precio_valido CHECK (
    precio > 0
  ),
  PRIMARY KEY (rif_posada, direccion_p)
);

CREATE TABLE residencia(
  rif_resid VARCHAR(100),
  direccion_r VARCHAR,
  servicio_residencia BOOLEAN NOT NULL,
  precio INTEGER NOT NULL,
  CONSTRAINT precio_valio CHECK(
    precio > 0
  ),
  PRIMARY KEY (rif_resid, direccion_r)
);

CREATE TABLE campamento(
  rif_camp VARCHAR(100),
  capacidad INTEGER NOT NULL,
  precio INTEGER NOT NULL,
  servicio_campamento BOOLEAN,
  CONSTRAINT capacidad_valida CHECK(
    capacidad > 0
  ),
  PRIMARY KEY (rif_camp)
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
  direccion_R varchar(40),
  edo_civil estado_civil NOT NULL,
  PRIMARY KEY (id_proveedor)
);

CREATE TABLE ruta(
  id_r VARCHAR,
  origen VARCHAR NOT NULL,
  destino VARCHAR NOT NULL,
  distancia INTEGER NOT NULL,
  nombre_l VARCHAR NOT NULL,
  tipo_l tipo_ruta NOT NULL,
  cupo INTEGER NOT NULL,
  precio INTEGER NOT NULL,
  fecha DATE NOT NULL,
  PRIMARY KEY (id_r)
);

CREATE TABLE resid_esta_en(
  id serial PRIMARY KEY,
  rif_resid VARCHAR,
  direccion_r VARCHAR,
  FOREIGN KEY (rif_resid,direccion_r) REFERENCES residencia(rif_resid,direccion_r) ON DELETE CASCADE
);

CREATE TABLE posada_esta_en(
  id SERIAL PRIMARY KEY,
  rif_posada VARCHAR,
  direccion_p VARCHAR,
  FOREIGN KEY (rif_posada,direccion_p) REFERENCES posada(rif_posada,direccion_p)
);

CREATE TABLE contrata(
  id_cliente VARCHAR REFERENCES cliente(id_cliente) ON DELETE CASCADE,
  id_trasporte VARCHAR(50) REFERENCES plan_transporte(id_transporte) ON DELETE CASCADE,
  precio FLOAT NOT NULL,
  fecha DATE NOT NULL,
  PRIMARY KEY (id_cliente,id_trasporte)
);

CREATE TABLE tiene(
  id_transporte VARCHAR(50) REFERENCES plan_transporte(id_transporte) ON DELETE CASCADE,
  id_r VARCHAR(50) REFERENCES ruta(id_r) ON DELETE CASCADE,
  PRIMARY KEY (id_transporte, id_r)
);

CREATE TABLE compra(
  id_cliente VARCHAR REFERENCES cliente(id_cliente) ON DELETE CASCADE,
  codigo VARCHAR(50) REFERENCES programa(codigo) ON DELETE CASCADE,
  fecha DATE NOT NULL,
  PRIMARY KEY (id_cliente, codigo)
);

CREATE TABLE reserva(
  id_cliente VARCHAR REFERENCES cliente(id_cliente) ON DELETE CASCADE,
  rif VARCHAR(100),
  direccion VARCHAR(100),
  fecha DATE NOT NULL,
  FOREIGN KEY (rif, direccion) REFERENCES hospedaje(rif,direccion) ON DELETE CASCADE,
  PRIMARY KEY (id_cliente,rif,direccion)
);

CREATE TABLE tipo(
  rif VARCHAR(100),
  direccion VARCHAR(100),
  rif_camp VARCHAR(100) REFERENCES campamento(rif_camp) ON DELETE CASCADE,
  FOREIGN KEY (rif,direccion) REFERENCES hospedaje(rif,direccion) ON DELETE CASCADE,
  PRIMARY KEY (rif_camp)
);

CREATE TABLE es(
  ubicacion_posada INTEGER REFERENCES posada_esta_en(id) ON DELETE CASCADE,
  rif VARCHAR(100),
  direccion VARCHAR(100),
  FOREIGN KEY (rif,direccion) REFERENCES hospedaje(rif,direccion) ON DELETE CASCADE
);

CREATE TABLE es_una(
  ubicacion_resid INTEGER REFERENCES resid_esta_en(id) ON DELETE CASCADE,
  rif VARCHAR,
  direccion VARCHAR,
  FOREIGN KEY (rif,direccion) REFERENCES hospedaje(rif,direccion) ON DELETE CASCADE,
  PRIMARY KEY (ubicacion_resid,rif,direccion)
);

CREATE TABLE galeria(
  nombre VARCHAR(100) REFERENCES destino_turistico(nombre),
  foto VARCHAR(50),
  PRIMARY KEY (nombre,foto)
);

CREATE TABLE comercio(
  nombre VARCHAR(100) REFERENCES destino_turistico(nombre) ON DELETE CASCADE,
  local VARCHAR(100),
  PRIMARY KEY (nombre,local)
);

CREATE TABLE sitios_f(
  nombre VARCHAR(100) REFERENCES destino_turistico(nombre) ON DELETE CASCADE,
  sitio_f VARCHAR(100),
  PRIMARY KEY (nombre,sitio_f)
);

CREATE TABLE informacion(
  nombre VARCHAR(100) REFERENCES destino_turistico(nombre) ON DELETE CASCADE,
  descripcion VARCHAR(100),
  PRIMARY KEY (nombre, descripcion)
);

CREATE TABLE edo(
  nombre VARCHAR (100) REFERENCES destino_turistico(nombre) ON DELETE CASCADE,
  estado VARCHAR (20),
  PRIMARY KEY (nombre,estado)
);

CREATE TABLE contacto_ruta(
  rif VARCHAR(100) REFERENCES ruta(id_r) ON DELETE CASCADE,
  telef VARCHAR(15),
  PRIMARY KEY (rif,telef)
);

CREATE TABLE contacto_hospedaje(
  rif VARCHAR(100),
  direccion VARCHAR(100),
  telef VARCHAR(15),
  FOREIGN KEY (rif,direccion) REFERENCES hospedaje(rif,direccion) ON DELETE CASCADE,
  PRIMARY KEY (rif,telef)
);

CREATE TABLE requerimiento(
  id VARCHAR REFERENCES proveedor(id_proveedor) ON DELETE CASCADE,
  requisito VARCHAR(100),
  PRIMARY KEY (id,requisito)
);

CREATE TABLE opinion(
  fecha DATE NOT NULL,
  descripcion VARCHAR(100) NOT NULL,
  nombre_dt VARCHAR(100) REFERENCES destino_turistico(nombre) ON DELETE CASCADE,
  id_cliente VARCHAR REFERENCES cliente(id_cliente),
  PRIMARY KEY (nombre_dt,id_cliente)
);

CREATE TABLE familia_c(
  id_cliente VARCHAR REFERENCES cliente(id_cliente),
  relacion VARCHAR(20) NOT NULL,
  nombre VARCHAR(30) NOT NULL,
  fecha_nac DATE NOT NULL,
  PRIMARY KEY (id_cliente)
);

CREATE TABLE familia_prov(
  id_prov VARCHAR REFERENCES proveedor(id_proveedor),
  relacion VARCHAR(20) NOT NULL,
  nombre VARCHAR(30) NOT NULL,
  fecha_nac DATE NOT NULL,
  PRIMARY KEY (id_prov)
);


CREATE USER admin_turismo WITH PASSWORD 'contraseña muy segura';
GRANT ALL PRIVILEGES ON DATABASE proyecto_turismo TO admin_turismo;

CREATE USER cliente_turismo WITH PASSWORD 'contraseña random';
GRANT INSERT ON TABLE cliente TO cliente_turismo;
GRANT UPDATE ON TABLE cliente TO cliente_turismo;
GRANT SELECT ON TABLE cliente TO cliente_turismo;
GRANT SELECT ON TABLE posada TO cliente_turismo;
GRANT SELECT ON TABLE hotel TO cliente_turismo;
GRANT SELECT ON TABLE campamento TO cliente_turismo;
GRANT SELECT ON TABLE residencia TO cliente_turismo;
GRANT SELECT ON TABLE hospedaje TO cliente_turismo;



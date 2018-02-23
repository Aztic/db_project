CREATE DOMAIN estado_civil
  as VARCHAR(20)
  CHECK (VALUE IN ('Soltero','Casado','Viudo'));

CREATE DOMAIN tipo_ruta
  as VARCHAR(20)
  CHECK (VALUE IN ('Avión','Barco','Taxi'));

CREATE TABLE cliente(
  id_cliente INTEGER,
  usuario VARCHAR(30) NOT NULL,
  clave VARCHAR(255) NOT NULL,
  estado VARCHAR(20),
  nacionalidad VARCHAR(20) NOT NULL,
  nombre_c VARCHAR(20) NOT NULL,
  edo_civil estado_civil NOT NULL,
  PRIMARY KEY (id_cliente)
);

CREATE TABLE destino_turistico(
  nombre VARCHAR(100),
  PRIMARY KEY (nombre)
);

CREATE TABLE plan_transporte(
  id_transporte VARCHAR(50),
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
  rif VARCHAR(100) NOT NULL,
  direccion VARCHAR(100) NOT NULL,
  PRIMARY KEY (rif, direccion)
);

CREATE TABLE posada(
  rif_posada VARCHAR(100),
  calidad INTEGER NOT NULL,
  servicioP INTEGER NOT NULL,
  habitaciones INTEGER NOT NULL,
  CONSTRAINT puntuacion_valida CHECK (
    calidad > 0
  ),
  CONSTRAINT cantidad_habitaciones_valida CHECK (
    habitaciones > 0
  ),
  PRIMARY KEY (rif_posada)
);

CREATE TABLE residencia(
  rif_resid VARCHAR(100),
  servicio_residencia BOOLEAN NOT NULL,
  PRIMARY KEY (rif_resid)
);

CREATE TABLE campamento(
  rif_camp VARCHAR(100),
  capacidad INTEGER NOT NULL,
  CONSTRAINT capacidad
  PRIMARY KEY (rif_camp)
);

CREATE TABLE proveedor(
  id_proveedor INTEGER,
  rif_resid VARCHAR(100),
  usuario VARCHAR(30) NOT NULL,
  clave VARCHAR(255) NOT NULL,
  estado VARCHAR(20),
  nacionalidad VARCHAR(20) NOT NULL,
  nombre_c VARCHAR(20) NOT NULL,
  edo_civil estado_civil NOT NULL,
  PRIMARY KEY (id_proveedor)
);

CREATE TABLE ruta(
  id_r VARCHAR(50),
  origen VARCHAR(50),
  destino VARCHAR(50),
  tipo tipo_ruta,
  PRIMARY KEY (id_r)
);

CREATE TABLE contrata(
  id_cliente INTEGER REFERENCES cliente(id_cliente) ON DELETE CASCADE,
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
  id_cliente INTEGER REFERENCES cliente(id_cliente) ON DELETE CASCADE,
  codigo VARCHAR(50) REFERENCES programa(codigo) ON DELETE CASCADE,
  fecha DATE NOT NULL,
  PRIMARY KEY (id_cliente, codigo)
);

CREATE TABLE reserva(
  id_cliente INTEGER REFERENCES cliente(id_cliente) ON DELETE CASCADE,
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
  rif_posada VARCHAR(100) REFERENCES posada(rif_posada) ON DELETE CASCADE ,
  rif VARCHAR(100),
  direccion VARCHAR(100),
  FOREIGN KEY (rif,direccion) REFERENCES hospedaje(rif,direccion) ON DELETE CASCADE
);

CREATE TABLE es_una(
  rif_resid VARCHAR(100) REFERENCES residencia(rif_resid),
  rif VARCHAR(100),
  direccion VARCHAR(100),
  FOREIGN KEY (rif,direccion) REFERENCES hospedaje(rif,direccion) ON DELETE CASCADE,
  PRIMARY KEY (rif_resid,rif,direccion)
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
  id INTEGER REFERENCES proveedor(id_proveedor) ON DELETE CASCADE,
  requisito VARCHAR(100),
  PRIMARY KEY (id,requisito)
);

CREATE TABLE opinion(
  fecha DATE NOT NULL,
  descripcion VARCHAR(100) NOT NULL,
  nombre_dt VARCHAR(100) REFERENCES destino_turistico(nombre) ON DELETE CASCADE,
  id_cliente INTEGER REFERENCES cliente(id_cliente),
  PRIMARY KEY (nombre_dt,id_cliente)
);

CREATE TABLE familia_c(
  id_cliente INTEGER REFERENCES cliente(id_cliente),
  relacion VARCHAR(20) NOT NULL,
  nombre VARCHAR(30) NOT NULL,
  fecha_nac DATE NOT NULL,
  PRIMARY KEY (id_cliente)
);

CREATE TABLE familia_prov(
  id_prov INTEGER REFERENCES proveedor(id_proveedor),
  relacion VARCHAR(20) NOT NULL,
  nombre VARCHAR(30) NOT NULL,
  fecha_nac DATE NOT NULL,
  PRIMARY KEY (id_prov)
);





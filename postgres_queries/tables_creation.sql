
-- PAISES table

CREATE TABLE paises (
    codpais SERIAL PRIMARY KEY,
    pais VARCHAR(50)
);

-- Clientes table

CREATE TABLE clientes (
    codclientes SERIAL PRIMARY KEY,
    identificacion VARCHAR(50),
    codpais INT,
    nombre VARCHAR(50),
    apellido1 VARCHAR(50),
    apellido2 VARCHAR(50),
    direccion VARCHAR(100),
    telefono VARCHAR(50),
    observaciones VARCHAR(255),

    CONSTRAINT fk_clientes_paises
        FOREIGN KEY (codpais)
        REFERENCES paises(codpais)
);

-- TIPO HABITACIONES table

CREATE TABLE tipo_habitacion (
    categoria INT PRIMARY KEY,
    camas INT,
    exterior VARCHAR(2) NOT NULL,
    salon VARCHAR(2),
    terraza VARCHAR(2),

    CONSTRAINT chk_exterior
        CHECK (exterior IN ('Si', 'No')),

    CONSTRAINT chk_salon
        CHECK (salon IN ('Si', 'No')),

    CONSTRAINT chk_terraza
        CHECK (terraza IN ('Si', 'No'))
);

-- HABITACIONES table

CREATE TABLE habitaciones (
    codhabitacion SERIAL PRIMARY KEY,
    numhabitacion INT,
    codcategoria INT,

    CONSTRAINT fk_habitaciones_tipo
        FOREIGN KEY (codcategoria)
        REFERENCES tipo_habitacion(categoria)
);

-- TEMPORADA table

CREATE TABLE temporada (
    codtemporada INT PRIMARY KEY,
    temporada INT,
    fechainicio DATE,
    fechafin DATE,
    tipo CHAR(1),

    CONSTRAINT chk_tipo
        CHECK (tipo IN ('A', 'M', 'B'))
);


-- PRECIO HABITACION table

CREATE TABLE precio_habitacion (
    codprecio SERIAL PRIMARY KEY,
    precio NUMERIC(10,2),
    codtemporada INT,
    tipo_habitacion INT,

    CONSTRAINT fk_precio_temporada
        FOREIGN KEY (codtemporada)
        REFERENCES temporada(codtemporada),

    CONSTRAINT fk_precio_tipo_habitacion
        FOREIGN KEY (tipo_habitacion)
        REFERENCES tipo_habitacion(categoria)
);

-- RESERVA HABITACION table

CREATE TABLE reserva_habitacion (
    codreserva SERIAL PRIMARY KEY,
    fechaentrada DATE,
    fechasalida DATE,
    iva NUMERIC(5,2),
    codhabitacion INT,
    codcliente INT,

    CONSTRAINT fk_reserva_habitacion
        FOREIGN KEY (codhabitacion)
        REFERENCES habitaciones(codhabitacion),

    CONSTRAINT fk_reserva_cliente
        FOREIGN KEY (codcliente)
        REFERENCES clientes(codclientes)
);

-- TIPO SERVICIO table

CREATE TABLE tipo_servicio (
    codtiposervicio SERIAL PRIMARY KEY,
    nombreservicio VARCHAR(50) NOT NULL
);

-- SERVICOIS table

CREATE TABLE servicios (
    codservicios SERIAL PRIMARY KEY,
    codtiposervicio INT,
    descripcion VARCHAR(100),
    precio NUMERIC(10,2),
    iva NUMERIC(5,2),
    fecha DATE,

    CONSTRAINT fk_servicios_tipo
        FOREIGN KEY (codtiposervicio)
        REFERENCES tipo_servicio(codtiposervicio)
);


-- GASTOS table


CREATE TABLE gastos (
    codgastos SERIAL PRIMARY KEY,
    codreserva INT,
    codservicios INT,
    fecha TIMESTAMP,
    cantidad INT,
    precio NUMERIC(10,2),

    CONSTRAINT fk_gastos_reserva
        FOREIGN KEY (codreserva)
        REFERENCES reserva_habitacion(codreserva),

    CONSTRAINT fk_gastos_servicios
        FOREIGN KEY (codservicios)
        REFERENCES servicios(codservicios)
);

--- INSERT

INSERT INTO paises (codpais, pais) VALUES
(1, 'Alemania'),
(2, 'España'),
(3, 'Francia'),
(4, 'Portugal');

INSERT INTO clientes (
    codclientes,
    identificacion,
    codpais,
    nombre,
    apellido1,
    apellido2,
    direccion,
    telefono,
    observaciones
)
VALUES
(1, '12345', 2, 'Felipe', 'Perez', 'Soza',
 'Calle 15 # 48-59', '555555', 'Buen Cliente'),

(2, '44444444', 2, 'Juan', 'Felipe', 'Perez',
 'Calle 20 # 69-95', '301286356', NULL),

(3, '69856456', 3, 'Jorge', 'Pelaez', 'Reyes',
 'Calle 63 # 69-63', '6666665', NULL);

INSERT INTO tipo_habitacion
(categoria, camas, exterior, salon, terraza)
VALUES
(1, 1, 'Si', 'No', 'No'),
(2, 2, 'Si', 'No', 'No'),
(3, 3, 'Si', 'No', 'No'),
(4, 4, 'Si', 'Si', 'No');

INSERT INTO habitaciones
(codhabitacion, numhabitacion, codcategoria)
VALUES
(1, 101, 1),
(2, 102, 1),
(3, 103, 1),
(4, 104, 2),
(5, 105, 2),
(6, 106, 3),
(7, 107, 4);

INSERT INTO temporada
(codtemporada, temporada, fechainicio, fechafin, tipo)
VALUES
(1, 1, '2019-01-01', '2019-03-31', 'B'),
(2, 2, '2019-04-01', '2019-05-31', 'M'),
(3, 3, '2019-06-01', '2019-08-31', 'A'),
(4, 4, '2019-09-01', '2019-10-31', 'M'),
(5, 5, '2019-11-01', '2019-12-31', 'B');



INSERT INTO precio_habitacion
(codprecio, precio, codtemporada, tipo_habitacion)
VALUES
(1, 30.00, 1, 1),
(2, 35.00, 2, 1),
(3, 40.00, 3, 1),
(4, 35.00, 4, 1),
(5, 35.00, 5, 1),
(6, 40.00, 1, 2),
(7, 45.00, 2, 2),
(8, 40.00, 3, 2),
(9, 40.00, 4, 2),
(10, 45.00, 5, 2),
(11, 50.00, 1, 3),
(12, 35.00, 2, 3),
(13, 40.00, 3, 3),
(14, 35.00, 4, 3),
(15, 50.00, 5, 3),
(16, 50.00, 1, 4),
(17, 55.00, 2, 4),
(18, 60.00, 3, 4),
(19, 55.00, 4, 4),
(20, 50.00, 5, 4);

INSERT INTO reserva_habitacion
(codreserva, fechaentrada, fechasalida, iva, codhabitacion, codcliente)
VALUES
(1, '2019-03-15', '2019-03-25', 0.07, 1, 1),
(2, '2019-03-15', '2019-03-25', 0.07, 2, 1),
(8, '2019-02-16', '2019-02-21', 0.07, 3, 1),
(4, '2019-03-16', '2019-03-21', 0.07, 4, 2),
(5, '2019-03-16', '2019-03-21', 0.07, 5, 2),
(6, '2019-03-16', '2019-03-21', 0.07, 6, 2),
(7, '2019-03-16', '2019-03-21', 0.07, 7, 2);

INSERT INTO servicios
(codservicios, codtiposervicio, descripcion, precio, iva, fecha)
VALUES
(1, 1, '1 menu del día', 10.00, 7.00, '2019-01-01'),
(2, 3, 'lavado de camisa', 2.00, 7.00, '2019-01-01'),
(3, 3, 'lavado de pantalon', 1.00, 7.00, '2019-01-01');



INSERT INTO tipo_servicio
(nombreservicio)
VALUES
('Comedor'),
('Lavanderia');
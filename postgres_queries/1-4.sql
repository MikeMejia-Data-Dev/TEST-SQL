
-- 1 Insertar datos en la tabla tipo_servicios "OCIO"

INSERT INTO tipo_servicios (nombreservicio) VALUES ('Ocio');

-- 2 Insertar reserva habitacion 101 para el cliente 12345 del 2 al 4 julio 2020

INSERT INTO reserva_habitacion (codcliente, codhabitacion, fechaentrada, fechasalida) VALUES
(12345, 101, '2020-07-02', '2020-07-04');

-- 3 actualizar el telefono del cliente 12345 a 123456789

UPDATE clientes SET telefono = '123546789' WHERE codcliente = 12345;


-- 4 Actualizar el precio de los servicios en un 2%

UPDATE servicios SET precio = precio * 1.02;
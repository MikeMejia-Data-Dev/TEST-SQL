-- 5 VISTA que devuelva los clientes cuyo apellido incluya la sílaba “Pe” ordenados por su identificador.

CREATE VIEW clientes_pe AS
SELECT codclientes,identificacion,codpais, nombre, apellido1, apellido2, direccion, telefono, observaciones
FROM clientes
WHERE apellido1 ILIKE '%Pe%'
ORDER BY codclientes;


select * from clientes_pe;

-- 6 VISTA que devuelva los clientes, ordenados por su primer apellido, que tengan alguna observación anotada

CREATE VIEW clientes_obv AS
SELECT codclientes,identificacion,codpais, nombre, apellido1, apellido2, direccion, telefono, observaciones
FROM clientes
WHERE observaciones IS NOT NULL
ORDER BY apellido1;

select * from clientes_obv;

-- 7 VISTA que devuelva los servicios cuyo precio supere los 5 USD ordenados por su código deservicio.

CREATE VIEW servicio_altos AS
SELECT codservicios, codtiposervicio, descripcion, precio, iva, fecha
FROM servicios
WHERE precio > 5
ORDER BY codservicios;

select * from servicio_altos;
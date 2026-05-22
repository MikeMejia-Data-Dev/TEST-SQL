-- 8 Cree una consulta que devuelva las habitaciones reservadas para el día 16 de febrero de 2019.

SELECT codhabitacion, numhabitacion FROM habitaciones
WHERE codhabitacion IN (
SELECT codhabitacion FROM reserva_habitacion
WHERE '2019-02-16' BETWEEN fechaentrada AND fechasalida)


--9 Cree una consulta que devuelva el precio del servicio más caro y del más barato.

SELECT ts.nombreservicio, s.precio FROM servicios s
INNER JOIN tipo_servicios ts ON s.codtiposervicio = ts.codtiposervicio
WHERE s.precio = (SELECT MAX(precio) FROM servicios) OR s.precio = (SELECT MIN(precio) FROM servicios);


-- Realice una consulta en donde detalle la siguiente información:
-- • País
-- • Nombre
-- • Apellido1
-- • Apellido2
-- • Teléfono
-- • Código Reserva
-- • Número de la habitación reservada
-- • Fecha de entrada
-- • Fecha de salida
-- • Precio de la habitación + IVA
-- • Nombre de los servicios que consumió
-- • Total de los gastos (servicios que solicito durante el hospedaje)
-- • Total a pagar
-- • Tipo de la habitación
-- • Temporada si es (B,M,A)

SELECT 
    p.pais                                          AS "País",
    c.nombre                                        AS "Nombre",
    c.apellido1                                     AS "Apellido1",
    c.apellido2                                     AS "Apellido2",
    c.telefono                                      AS "Teléfono",
    r.codreserva                                    AS "Código Reserva",
    h.numhabitacion                                 AS "Número Habitación",
    r.fechaentrada                                  AS "Fecha Entrada",
    r.fechasalida                                   AS "Fecha Salida",

    -- Precio habitación × noches + IVA
    ROUND(
        ph.precio 
        * (r.fechasalida - r.fechaentrada) 
        * (1 + r.iva), 2
    )                                               AS "Precio Habitación + IVA",

    -- Servicios consumidos (lista separada por comas)
    COALESCE(
        STRING_AGG(DISTINCT sv.descripcion, ', '), 
        'Sin servicios'
    )                                               AS "Servicios Consumidos",

    -- Total gastos (servicios)
    COALESCE(
        ROUND(
            SUM(g.cantidad * g.precio * (1 + sv.iva / 100)), 
        2), 
        0
    )                                               AS "Total Gastos Servicios",

    -- Total a pagar = habitación con IVA + total gastos
    ROUND(
        ph.precio 
        * (r.fechasalida - r.fechaentrada) 
        * (1 + r.iva)
        +
        COALESCE(SUM(g.cantidad * g.precio * (1 + sv.iva / 100)), 0),
    2)                                              AS "Total a Pagar",

    -- Tipo de habitación (categoría + características)
    CONCAT(
        'Cat.', th.categoria,
        ' | Camas: ', th.camas,
        ' | Exterior: ', th.exterior,
        ' | Salón: ', COALESCE(th.salon, 'No'),
        ' | Terraza: ', COALESCE(th.terraza, 'No')
    )                                               AS "Tipo Habitación",

    -- Temporada
    CASE t.tipo
        WHEN 'A' THEN 'A - Alta'
        WHEN 'M' THEN 'M - Media'
        WHEN 'B' THEN 'B - Baja'
    END                                             AS "Temporada"

FROM reserva_habitacion r

    -- Cliente y País
    JOIN clientes        c   ON c.codclientes    = r.codcliente
    JOIN paises          p   ON p.codpais        = c.codpais

    -- Habitación y tipo
    JOIN habitaciones    h   ON h.codhabitacion  = r.codhabitacion
    JOIN tipo_habitacion th  ON th.categoria     = h.codcategoria

    -- Precio según temporada vigente para la fecha de entrada
    JOIN precio_habitacion ph ON ph.tipo_habitacion = th.categoria
    JOIN temporada         t  ON t.codtemporada    = ph.codtemporada
                             AND r.fechaentrada BETWEEN t.fechainicio AND t.fechafin

    -- Gastos y servicios (LEFT JOIN → puede no tener servicios)
    LEFT JOIN gastos     g   ON g.codreserva     = r.codreserva
    LEFT JOIN servicios  sv  ON sv.codservicios  = g.codservicios

GROUP BY
    p.pais,
    c.nombre, c.apellido1, c.apellido2, c.telefono,
    r.codreserva, h.numhabitacion,
    r.fechaentrada, r.fechasalida, r.iva,
    ph.precio,
    th.categoria, th.camas, th.exterior, th.salon, th.terraza,
    t.tipo

ORDER BY 
    r.codreserva;


-- -- Realice una consulta en donde se liste el último servicio solicitado por los clientes (tabla de referencia es
-- gastos con la columna Fecha y la tabla servicios). Restricción: Se debe realizar la consulta sin hacer uso del
-- filtro fecha y la clausula TOP Ejm: where Fecha:’xxxxx’ o select top 1

SELECT 
    s.descripcion   AS "Servicio",
    g.fecha         AS "Fecha"

FROM gastos g
    INNER JOIN servicios s ON s.codservicios = g.codservicios

WHERE g.fecha = (
    SELECT MAX(fecha) FROM gastos
);
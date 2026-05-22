CREATE VIEW vw_dashboard_hotel AS

SELECT
    r.codreserva,
    r.fechaentrada,
    r.fechasalida,
    r.iva,

    c.codclientes,
    c.nombre,
    c.apellido1,
    c.apellido2,

    p.pais,

    h.numhabitacion,
    th.categoria,

    t.temporada,
    t.tipo AS tipo_temporada,

    ph.precio,

    (ph.precio + (ph.precio * r.iva)) AS valor_reserva

FROM reserva_habitacion r

INNER JOIN clientes c
    ON r.codcliente = c.codclientes

INNER JOIN paises p
    ON c.codpais = p.codpais

INNER JOIN habitaciones h
    ON r.codhabitacion = h.codhabitacion

INNER JOIN tipo_habitacion th
    ON h.codcategoria = th.categoria

INNER JOIN precio_habitacion ph
    ON th.categoria = ph.tipo_habitacion

INNER JOIN temporada t
    ON ph.codtemporada = t.codtemporada

WHERE r.fechaentrada BETWEEN t.fechainicio AND t.fechafin;
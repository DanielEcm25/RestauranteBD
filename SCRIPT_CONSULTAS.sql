-- TOTAL POR ORDEN (factura individual)
SELECT
    O.id AS id_orden,
    C.nit AS nit_cliente,
    C.nombre + ' ' + C.apellido AS cliente,
    E.nit AS nit_empleado,
    E.nombre + ' ' + E.apellido AS empleado,
    COALESCE(MS.suma_menus, 0)      AS total_menus,
    COALESCE(ASUM.suma_adicionales, 0) AS total_adicionales,
    COALESCE(MS.suma_menus, 0) + COALESCE(ASUM.suma_adicionales, 0) AS total_factura
FROM ORDENES O
INNER JOIN CLIENTES C ON O.nit_cliente = C.nit
INNER JOIN EMPLEADOS E ON O.nit_empleado = E.nit
LEFT JOIN (
    -- suma de precios de los menus/platos principales por orden
    SELECT DO.id_orden, SUM(M.precio) AS suma_menus
    FROM DETALLE_ORDEN DO
    INNER JOIN MENUS M ON DO.id_menu = M.id_menu
    GROUP BY DO.id_orden
) MS ON O.id = MS.id_orden
LEFT JOIN (
    -- suma de precios de los adicionales por orden (vía el id_detalle)
    SELECT DO.id_orden, SUM(P.precio) AS suma_adicionales
    FROM DETALLE_ORDEN DO
    INNER JOIN DETALLE_ORDEN_ADICIONAL DOA ON DO.id_detalle = DOA.id_detalle_orden
    INNER JOIN PLATOS P ON DOA.id_plato = P.id
    GROUP BY DO.id_orden
) ASUM ON O.id = ASUM.id_orden
ORDER BY total_factura DESC;

select
    avg(precio) as Promedio_Precio_Menus
from MENUS;
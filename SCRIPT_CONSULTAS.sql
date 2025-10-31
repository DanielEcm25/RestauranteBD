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



/*----------Función AVG (average)---------------*/
/* Calculando el promedio del precio de los menús disponibles:*/
select
    avg(precio) as Promedio_Precio_Menus
from MENUS;

/* Calculando el promedio del salario de los empleados que trabajen como meseros:*/
select 
    avg(salario) as Salario_Mensual_Meseros
from EMPLEADOS where cargo='Mesero'

/*Calculando el promedio del salario de los empleados agrupando por cargo:*/
select 
    cargo,
    avg(salario) as Promedio_Salario
from EMPLEADOS
group by cargo;

/*----------Función MAX y MIN---------------*/
/*---Seleccionando el producto más barato de los menús disponibles---*/
select nombre, precio
from MENUS
WHERE precio = (select MIN(precio) from MENUS);

/*---Seleccionando el producto más barato de los menús disponibles---*/
select nombre, precio
from MENUS
WHERE precio = (select MAX(precio) from MENUS);

/*Mostrando el empleado con el mayor sueldo*/
select nombre, apellido, cargo, salario
from EMPLEADOS
WHERE salario = (select MAX(salario) from EMPLEADOS);

/*Mostrando el empleado con el menor sueldo*/
select nombre, apellido, cargo, salario
from EMPLEADOS
WHERE salario = (select MIN(salario) from EMPLEADOS);

/*Mostrando el cajero que tiene el mayor sueldp*/
select nombre, apellido, salario
from EMPLEADOS
WHERE cargo = 'Mesero' and salario = (select MAX(salario) from EMPLEADOS)
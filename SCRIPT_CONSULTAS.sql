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

----------------------------------------------
--|         SELECT con condiciones         |--
----------------------------------------------
-- 1) Órdenes atendidas por un empleado en un rango de fechas
SELECT
  O.id AS id_orden,
  O.fecha,
  O.hora,
  C.nit AS nit_cliente,
  C.nombre + ' ' + C.apellido AS cliente,
  E.nit AS nit_empleado,
  E.nombre + ' ' + E.apellido AS empleado,
  O.id_mesa
FROM ORDENES O
JOIN CLIENTES C ON O.nit_cliente = C.nit
JOIN EMPLEADOS E ON O.nit_empleado = E.nit
WHERE E.nit = '1765432189'                 
  AND O.fecha BETWEEN '2025-10-25' AND GETDATE()
ORDER BY O.fecha DESC, O.hora DESC;

-- 2) Menus entre 17000 y 50000 y que tienen pollo
SELECT id_menu, nombre, precio, descripcion
FROM MENUS
WHERE precio BETWEEN 18000 AND 30000
  AND nombre LIKE '%Pollo%'  -- en esta parte se usa LIKE para buscar palabras en nombre
ORDER BY precio;

-- 3) Los 3 empleados con mayor salario
SELECT TOP 3 nit, nombre + ' ' + apellido AS empleado, cargo, salario
FROM EMPLEADOS
WHERE salario > 0
ORDER BY salario DESC;

----------------------------------------------
--|     Funcion de agregación Count        |--
----------------------------------------------

-- 1) Número de órdenes por cliente
SELECT C.nit, C.nombre + ' ' + C.apellido AS cliente, COUNT(O.id) AS total_ordenes
FROM CLIENTES C
LEFT JOIN ORDENES O ON O.nit_cliente = C.nit
GROUP BY C.nit, C.nombre, C.apellido
ORDER BY total_ordenes DESC;

--- 2) Platos adicionales más solicitados
SELECT 
    P.id AS id_plato,
    P.nombre AS nombre_plato,
    COUNT(DOA.id) AS veces_pedidas
FROM PLATOS AS P
INNER JOIN DETALLE_ORDEN_ADICIONAL AS DOA 
    ON P.id = DOA.id_plato
GROUP BY P.id, P.nombre
HAVING COUNT(DOA.id) > 1
ORDER BY veces_pedidas DESC;

-- 3)Número de órdenes por empleado
SELECT E.nit,E.nombre + ' ' + E.apellido AS empleado, COUNT(O.id) AS total_ordenes
FROM EMPLEADOS E
LEFT JOIN ORDENES O ON E.nit = O.nit_empleado
GROUP BY E.nit, E.nombre, E.apellido
ORDER BY total_ordenes DESC;

/*----------Función AVG (average)---------------*/
/* Calculando el promedio del precio de los menús disponibles:*/
select
    avg(precio) as Promedio_Precio_Menus
from MENUS;

/*Mostrando los menús con un precio mayor al promedio general*/
select nombre, precio
from MENUS
where precio > (select avg(precio) from MENUS);

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

/* Mostrando el empleado con el mayor sueldo:*/
select nombre, apellido, cargo, salario
from EMPLEADOS
WHERE salario = (select MAX(salario) from EMPLEADOS);

/* Mostrando el empleado con el menor sueldo:*/
select nombre, apellido, cargo, salario
from EMPLEADOS
WHERE salario = (select MIN(salario) from EMPLEADOS);

/* Mostrando el cajero que tiene el mayor sueldo:*/
select nombre, apellido, cargo, salario
from EMPLEADOS
WHERE cargo = 'Mesero' and salario = (select MAX(salario) from EMPLEADOS where cargo = 'Mesero');


/*-------------Función HAVING-----------------*/

/* Mostrando los cargos que en promedio tienen salario superior al promedio general:*/
select cargo, AVG(salario) AS SalarioPromedio
from EMPLEADOS
group by cargo
HAVING AVG(salario) > (select AVG(salario) from EMPLEADOS);

/*Mostrando los cargos que en promedio tienen salario menor al promedio general:*/
select cargo, AVG(salario) AS SalarioPromedio
from EMPLEADOS
group by cargo
HAVING AVG(salario) < (select AVG(salario) from EMPLEADOS);


/* Consultas complejas*/
/*Mostrando los empleados que tienen más de una orden registrada:*/
select E.nombre as Nombre, E.apellido as Apellido,COUNT(O.id) AS total_ordenes
from EMPLEADOS E
JOIN ORDENES O ON E.nit = O.nit_empleado
group by E.nombre, E.apellido
HAVING COUNT(O.id) > 1;

----------------------------------------------
--|              STRING_AGG                |--
----------------------------------------------
-- 1) Menús pedidos por cada orden 
SELECT
  O.id AS id_orden,
  C.nit AS nit_cliente,
  C.nombre + ' ' + C.apellido AS cliente,
  STRING_AGG(M.nombre, ', ') AS menus_pedidos
FROM ORDENES O
JOIN CLIENTES C ON O.nit_cliente = C.nit
JOIN DETALLE_ORDEN D ON O.id = D.id_orden
JOIN MENUS M ON D.id_menu = M.id_menu
GROUP BY O.id, C.nit, C.nombre, C.apellido
ORDER BY O.id;
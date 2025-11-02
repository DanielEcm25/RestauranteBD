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
-- 1) Menús con precio mayor a 25.000
select nombre, precio
from MENUS
WHERE precio > 25000;

-- 2) Menus entre 17000 y 50000 y que tienen pollo
select id_menu, nombre, precio, descripcion
from MENUS
WHERE precio BETWEEN 18000 AND 30000
  AND nombre LIKE '%Pollo%'  -- en esta parte se usa LIKE para buscar palabras en nombre
order by precio;

-- 3) Los 3 empleados con mayor salario
select top 3 nit, nombre + ' ' + apellido AS empleado, cargo, salario
from EMPLEADOS
WHERE salario > 0
order by salario DESC;

----------------------------------------------
--|     Funcion de agregación Count        |--
----------------------------------------------
-- 1) Contar el número total de clientes registrados
select 
COUNT(*) AS total_clientes
from CLIENTES;

-- 2) Contar el número total de empleados registrados
select 
COUNT(*) AS total_empleados
from EMPLEADOS;

-- 3) Número de órdenes por cliente
select C.nit, C.nombre + ' ' + C.apellido AS cliente, 
COUNT(O.id) AS total_ordenes
from CLIENTES C
LEFT JOIN ORDENES O ON O.nit_cliente = C.nit
group by C.nit, C.nombre, C.apellido
order by total_ordenes DESC;

-- 4)Número de órdenes por empleado
select E.nit,E.nombre + ' ' + E.apellido AS empleado,
COUNT(O.id) AS total_ordenes
from EMPLEADOS E
LEFT JOIN ORDENES O ON E.nit = O.nit_empleado
group by E.nit, E.nombre, E.apellido
order by total_ordenes DESC;

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
<<<<<<< HEAD
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

/*---Consulta factura para la orden 1:-------*/

SELECT
    O.id AS id_orden,
    C.nit AS nit_cliente,
    C.nombre + ' ' + C.apellido AS cliente,
    E.nit AS nit_empleado,
    E.nombre + ' ' + E.apellido AS empleado,
    -- Menús principales
    COALESCE(MA.menus, 'Sin menús') AS menus_pedidos,
    COALESCE(MA.total_menus, 0) AS total_menus,
    -- Platos adicionales
    COALESCE(AA.adicionales, 'Sin adicionales') AS adicionales_pedidos,
    COALESCE(AA.total_adicionales, 0) AS total_adicionales,
    -- Total final
    COALESCE(MA.total_menus, 0) + COALESCE(AA.total_adicionales, 0) AS total_factura
FROM ORDENES O
INNER JOIN CLIENTES C ON O.nit_cliente = C.nit
INNER JOIN EMPLEADOS E ON O.nit_empleado = E.nit

-- Subconsulta 1: menús principales
LEFT JOIN (
    SELECT
        DO.id_orden,
        STRING_AGG(M.nombre + ' ($' + CAST(M.precio AS VARCHAR(10)) + ')', ', ') AS menus,
        SUM(M.precio) AS total_menus
    FROM DETALLE_ORDEN DO
    INNER JOIN MENUS M ON DO.id_menu = M.id_menu
    GROUP BY DO.id_orden
) AS MA ON O.id = MA.id_orden

-- Subconsulta 2: platos adicionales
LEFT JOIN (
    SELECT
        DO.id_orden,
        STRING_AGG(P.nombre + ' ($' + CAST(P.precio AS VARCHAR(10)) + ')', ', ') AS adicionales,
        SUM(P.precio) AS total_adicionales
    FROM DETALLE_ORDEN DO
    INNER JOIN DETALLE_ORDEN_ADICIONAL DOA ON DO.id_detalle = DOA.id_detalle_orden
    INNER JOIN PLATOS P ON DOA.id_plato = P.id
    GROUP BY DO.id_orden
) AS AA ON O.id = AA.id_orden

WHERE O.id = 1;
=======
-- 1) Empleados agrupados por cargo
select 
    cargo,
    STRING_AGG(nombre + ' ' + apellido, ', ') AS empleados
from EMPLEADOS
group by cargo
order by cargo;

-- 2) Clientes agrupados por la primera letra del nombre
select 
    LEFT(nombre, 1) AS inicial,
    STRING_AGG(nombre + ' ' + apellido, ', ') AS clientes
from CLIENTES
group by LEFT(nombre, 1)
order by inicial;

-- 3) Lista todos los correos electrónicos de los 
select 
    cargo,
    STRING_AGG(correo, ', ') AS correos_empleados
from EMPLEADOS
group by cargo
order by cargo;




>>>>>>> bd10ce33303beb3cf4dec7b672619f80300b09b0

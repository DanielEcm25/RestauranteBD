
-- 4. INSERCIÓN DE REGISTROS 


-- CLIENTES
INSERT INTO CLIENTES VALUES
('1116537283', 'Carlos', 'Ramírez', '3124567890', 'carlosr@gmail.com'),
('1657892312', 'Ana', 'Gómez', '3151234567', 'anagomez@hotmail.com'),
('1234567890', 'Luis', 'Martínez', '3005554444', 'luism@gmail.com'),
('1223344556', 'María', 'López', '3206667777', 'marialopez@yahoo.com'),
('1112223334', 'Juan', 'Valdez', '3107778888', 'juancastro@gmail.com');

--- Agregando nuevos clientes
INSERT INTO CLIENTES VALUES 
('1109876543', 'Sofía', 'Castro', '3112233445', 'sofiacastro@gmail.com'),
('1198765432', 'Julián', 'Pérez', '3123344556', 'julianperez@hotmail.com'),
('1187654321', 'Carolina', 'Vargas', '3134455667', 'carov@gmail.com'),
('1176543210', 'Mateo', 'Jiménez', '3145566778', 'mateoj@hotmail.com'),
('1165432109', 'Daniela', 'Rojas', '3156677889', 'danielarojas@yahoo.com');

-- MESAS
INSERT INTO MESAS VALUES
( 2, 1),
( 4, 1),
( 4, 0),
( 6, 1),
( 8, 1);

--- Agregando nuevas mesas
INSERT INTO MESAS VALUES
(2, 0),
(4, 1),
(6, 1),
(8, 0),
(10, 1);

-- EMPLEADOS
INSERT INTO EMPLEADOS VALUES
('1765432189', 'Pedro', 'Mora', 'Mesero', '3109876543', 'pedromora@restaurante.com', 1800000),
('1675432199', 'Lucía', 'Jiménez', 'Cajera', '3123456789', 'luciaj@restaurante.com', 1900000),
('177093939', 'Camilo', 'Rojas', 'Cocinero', '3001112222', 'camilor@restaurante.com', 2200000),
('407543215', 'Sofía', 'Díaz', 'Administrador', '3115556666', 'sofiad@restaurante.com', 3000000),
('897654321', 'Andrés', 'Luna', 'Mesero', '3147779999', 'andresl@restaurante.com', 1800000);

-- Agregando nuevos empleados 
INSERT INTO EMPLEADOS VALUES
('1901234567', 'Camila', 'Gómez', 'Mesero', '3101122334', 'camilag@restaurante.com', 1850000),
('1907654321', 'Esteban', 'Rincón', 'Mesero', '3122233445', 'estebanr@restaurante.com', 2200000);

-- MENUS
INSERT INTO MENUS VALUES
( 'Bandeja con pollo', 20000, 'Plato que incluye pechuga de pollo a la plancha, arroz, papas fritas, ensalada fresca y bebida al gusto.'),
( 'Costillas de cerdo BBQ', 25000, 'Jugosas costillas bañadas en salsa BBQ, acompañadas de papas a la francesa y ensalada de la casa.'),
( 'Bandeja Paisa', 23000, 'fríjoles, arroz, carne molida, chicharrón, huevo frito, plátano maduro, arepa y aguacate.'),
( 'Bandeja con mojarra', 22000, 'Mojarra frita acompañada de arroz con coco, patacones, ensalada y una bebida natural.'),
( 'Churrasco familiar', 60000, 'churrasco a la parrilla, papas criollas, ensalada y jugos para cuatro personas.');

-- Agregando nuevos menús 
INSERT INTO MENUS VALUES
('Cazuela de mariscos', 30000, 'Mariscos en salsa, acompañada de arroz con coco y patacones.'),
('Pollo apanado', 21000, 'Pechuga de pollo apanado acompañado con arroz blanco y ensalada fresca.'),
('Hamburguesa doble carne', 18000, 'Dos carnes de res, queso cheddar, lechuga, tomate, tocineta y papas a la francesa.'),
('Carne a la plancha', 20000, 'Carne de res a la plancha, acompañado con papas a la francesa, arroz y ensalada.'),
('Trucha frita', 28000, 'Trucha frita, acompañado de arroz, ensalada, papa a la francesa y bebida al gusto.');

-- PLATOS
INSERT INTO PLATOS VALUES
( 'Papas a la francesa', 5000),
( 'Frutas', 5000),
( 'Arroz', 4000),
( 'Ensalada de frutas', 4500),
( 'Yuca', 3000),
('Costillas', 6000),
('Huevos',5000);

-- Agregando nuevos platos adicionales 
INSERT INTO PLATOS VALUES
('Puré de papa', 4000),      
('Plátano maduro', 3500),    
('Arepa de queso', 2500),    
('Gaseosa', 3500); 


-- ORDENES
INSERT INTO ORDENES VALUES
( CAST(GETDATE()AS DATE), CAST(GETDATE()AS TIME), '1765432189', '1116537283', 1),
( CAST(GETDATE()AS DATE), CAST(GETDATE()AS TIME), '407543215', '1657892312', 2),
( CAST(GETDATE()AS DATE), CAST(GETDATE()AS TIME), '897654321', '1234567890', 4),
( CAST(GETDATE()AS DATE), CAST(GETDATE()AS TIME), '407543215', '1223344556', 3),
( CAST(GETDATE()AS DATE), CAST(GETDATE()AS TIME), '407543215', '1112223334', 5);

-- Agregando nuevas órdenes (5 órdenes nuevas)
INSERT INTO ORDENES VALUES
(CAST(GETDATE()AS DATE), CAST(GETDATE()AS TIME), '1901234567', '1109876543', 6),
(CAST(GETDATE()AS DATE), CAST(GETDATE()AS TIME), '1907654321', '1198765432', 7),
(CAST(GETDATE()AS DATE), CAST(GETDATE()AS TIME), '1765432189', '1187654321', 8),
(CAST(GETDATE()AS DATE), CAST(GETDATE()AS TIME), '1675432199', '1176543210', 9),
(CAST(GETDATE()AS DATE), CAST(GETDATE()AS TIME), '407543215', '1165432109', 10);

-- DETALLE_ORDEN
INSERT INTO DETALLE_ORDEN VALUES
(1, 1),
(1, 2),
(3, 2),
(4, 4),
(5, 5);

-- Agregando nuevos detalles de orden (5 detalles nuevos)
INSERT INTO DETALLE_ORDEN VALUES
(6, 6),
(7, 7),  
(8, 8),  
(9, 9),  
(10, 10); 

select * from MENUS

-- DETALLE_ORDEN_ADICIONAL
INSERT INTO DETALLE_ORDEN_ADICIONAL VALUES
(1, 3),
( 1, 5),
( 3, 1),
( 4, 2),
( 5, 5);

-- Agregando nuevos detalles de orden adicional (platos extra nuevos)
INSERT INTO DETALLE_ORDEN_ADICIONAL VALUES
(6, 8), 
(7, 9),
(8, 10), 
(9, 11),  
(10, 8);  

-- PLATOS_MENU
INSERT INTO PLATOS_MENU VALUES
( 1, 3),
( 1, 1),
( 2, 6),
( 3, 7),
( 4, 5);

-- Agregando nuevas PLATOS_MENU para los nuevos menús
INSERT INTO PLATOS_MENU VALUES
(6, 8),
(7, 9), 
(8, 10), 
(9, 11), 
(10, 8);  




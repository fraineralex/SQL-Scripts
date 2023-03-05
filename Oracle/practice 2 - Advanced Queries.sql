
-- 1. Crear la tabla ITEMS_ORDERED.

CREATE TABLE ITEMS_ORDERED
(
customerid  NUMBER(5),
order_date  DATE,
item        VARCHAR2(25),
quantity    NUMBER(3),
price       NUMBER(6,2)
);

------------------------------------------------------------------------------------------------

-- TRAYENDO TODOS LOS DATOS DE ITEMS_ORDERED

SELECT *
FROM ITEMS_ORDERED;

---------------------------------------------------------------------------------------------------------------

--CREACIÓN DE LA TABLA CUSTOMERS

CREATE TABLE CUSTOMERS
(
customerid  NUMBER(5),
firstname   VARCHAR2(25),
lastname    VARCHAR2(25),
city        VARCHAR2(30),
state       VARCHAR2(30)
);

---------------------------------------------------------------------------------------------------------------------------------

-- TRAYENDO TODOS LOS DATOS DE CUSTOMERS

SELECT *
FROM CUSTOMERS;

----------------------------------------------------------------------------------------------------------------------------

/*	11. De la tabla items_ordered, seleccione todos los items comprados 
por el ID de Cliente 10449. Muestre el ID del Cliente, el item y el precio.*/

SELECT CUSTOMERID "ID DEL CLIENTE", ITEM, PRICE PRECIO
FROM ITEMS_ORDERED
WHERE CUSTOMERID = '10449';

--------------------------------------------------------------------------------------------------------------------------------------

/*12. Seleccione todas las columnas de la tabla items_ordered, 
       en cuyas órdenes se hayan comprado un "Tent".*/

SELECT *
FROM ITEMS_ORDERED
WHERE ITEM IN 'Tent';

------------------------------------------------------------------------------------------------------------------

/* 13. Seleccione el ID del Cliente, Fecha de la Orden y el Item de la tabla items_ordered,
                 buscando aquellos items que inicien con la letra "S".*/
                 
SELECT CUSTOMERID "ID DEL CLIENTE", ORDER_DATE "FECHA DE LA ORDEN", ITEM
FROM ITEMS_ORDERED
WHERE ITEM LIKE 'S%';


/* 14. Seleccione los distintos items que se encuentren 
   en la tabla items_ordered.En otras palabras despliegue
   de manera única los items que se encuentren en la tabla
                       items_ordered.*/
          
SELECT ITEM 
FROM ITEMS_ORDERED;

--------------------------------------------------------------------------------------------------------------------------

/* 15. Seleccione el precio máximo de cualquier 
   item ordenado en la tabla items_ordered.*/

SELECT ITEM, MAX (PRICE) "PRECIO MAXIMO"
FROM ITEMS_ORDERED
GROUP BY ITEM;

--------------------------------------------------------------------------------------------------------------------------

/* 16. Seleccione el promedio de los precios de todos
  los items que fueron comprados en el mes de Diciembre.*/
  
SELECT ITEM, ORDER_DATE FECHA, AVG(PRICE) "PRECIO PROMEDIO"
FROM ITEMS_ORDERED
WHERE to_char(ORDER_DATE, 'MM') = '12'
GROUP BY ITEM, ORDER_DATE;


/* 17. Cuál es la cantidad total de 
 filas en la tabla items_ordered?*/

SELECT COUNT(CUSTOMERID) "CANTIDAD DE FILAS"
FROM ITEMS_ORDERED;

------------------------------------------------------------------------------------------------------------

/* 18. De todos los items "tents" que fueron ordenados en 
 la tabla items_ordered, cuál es el de menor precio?*/
 
 SELECT ITEM, MIN (PRICE) "PRECIO MENOR"
 FROM ITEMS_ORDERED
 WHERE ITEM = 'Tent'
 GROUP BY ITEM;
 
 ------------------------------------------------------------------------------------------------------------
 
 /*19. Cuántas personas hay en cada estado, en la tabla de Clientes? 
  Seleccione el estado y muestre la cantidad de personas de cada estado.*/

SELECT COUNT(DISTINCT CUSTOMERID) "CANTIDAD DE PERSONAS", STATE
FROM CUSTOMERS
GROUP BY STATE;
  
--------------------------------------------------------------------------------------------------------------------------

/* 20. De la tabla items_ordered, seleccione el item, precio máximo 
             y mínimo de cada item existente en la tabla. */
             
SELECT ITEM, MIN (PRICE ) "PRECIO MINIMO", MAX (PRICE)"PRECIO MAXIMO"
FROM ITEMS_ORDERED
GROUP BY ITEM;

----------------------------------------------------------------------------------------------------------------------------------------

/* 21. Cuántas órdenes hay por cliente? Use la tabla items_ordered. 
   Seleccione el Id del Cliente, cantidad de órdenes realizadas 
                      y el precio total.*/
                      
SELECT CUSTOMERID "ID DEL CLIENTE", SUM (PRICE) "PRECIO TOTAL",
COUNT(ITEM) "CANTIDAD DE ORDENES"
 FROM ITEMS_ORDERED
 GROUP BY CUSTOMERID;
                      
--------------------------------------------------------------------------------------------------------------------------------------------

/* 22. Cuántas personas hay en cada estado en la tabla customers 
   que tengan dos o más personas en él? Seleccione el estado y 
   despliegue la cantidad de personas, siempre y cuando hayan más de 1.*/
   

SELECT STATE, COUNT(CUSTOMERID) "CANTIDAD DE PERSONAS"
FROM CUSTOMERS
HAVING COUNT(CUSTOMERID) > 1
GROUP BY STATE;

-------------------------------------------------------------------------------------------------------------------------------------

/* 23. De la tabla items_ordered, seleccione el item, y el precio máximo 
   y mínimo de cada uno. Solamente despliegue los resultados de aquellos 
           items cuyo precio máximo sea mayor que 190. */
           
SELECT ITEM, MIN(PRICE), MAX(PRICE)
FROM ITEMS_ORDERED
HAVING MAX(PRICE) > 190
GROUP BY ITEM;

-----------------------------------------------------------------------------------------------------------------------

/* 24. Cuántas órdenes ha realizado cada cliente? Use la tabla items_ordered. 
    Seleccione el ID del Cliente, cantidad de órdenes realizadas por ellos
           y la sumatoria de precios, si hay más de 1 item comprado. */
           
SELECT CUSTOMERID "ID DEL CLIENTE", COUNT(ITEM) "CANTIDAD DE ORDENES", 
SUM (PRICE) "SUMATORIA DE PRECIOS"
 FROM ITEMS_ORDERED
 WHERE QUANTITY > 1
 GROUP BY CUSTOMERID;
 
-- COMPROBACIÓN

 SELECT CUSTOMERID, ITEM, QUANTITY
 FROM ITEMS_ORDERED
 WHERE CUSTOMERID = '10101' AND QUANTITY > 1;
 
------------------------------------------------------------------------------------------------------------------

/* 25. Seleccione el apellido, nombre y ciudad de todos los clientes. 
        Ordene los datos por apellido en orden ascendente. */
        
SELECT LASTNAME, FIRSTNAME, CITY
FROM CUSTOMERS
ORDER BY 1 ASC;
        
------------------------------------------------------------------------------------------------------------------------------------

/* 26. Seleccione el item y el precio de todos los items 
   de la tabla items_ordered cuyo pecio sea mayor de 10.00.
   Despliegue el resultado ordenado por precio ascendentemente. */
   
SELECT ITEM, PRICE
FROM ITEMS_ORDERED
WHERE PRICE > '10,00'
ORDER BY 2 ASC;

----------------------------------------------------------------------------------------------------------------------------------

/* 27. Seleccione el ID del cliente, fecha de orden y item de 
   la tabla items_ordered, donde el item no sea 'Snow Shoes'
                    o 'Ear Muffs'.  */
                
SELECT CUSTOMERID, ORDER_DATE, ITEM
FROM ITEMS_ORDERED
WHERE ITEM NOT IN ('Snow Shoes', 'Ear Muffs');

--------------------------------------------------------------------------------------------------------------------------------

/*  28. Seleccione el item y precio de todos los items que
        inicien con las letras 'S', 'P', or 'F'.  */
        
SELECT ITEM, PRICE
FROM ITEMS_ORDERED
WHERE ITEM LIKE 'S%' OR ITEM LIKE 'P%' OR ITEM LIKE 'F%';

-------------------------------------------------------------------------------------------------------------------------------

/* 29. Seleccione la fecha, item y precio de la tabla items_ordered 
             cuyo precio esté entre 10.00 y 80.00.  */
             
SELECT ORDER_DATE, ITEM, PRICE
FROM ITEMS_ORDERED
WHERE PRICE BETWEEN '10,00' AND '80,00';

-------------------------------------------------------------------------------------------------------------------------------

/*  30. Seleccione el nombre, ciudad y estado de los clientes que se 
   encuentren en Arizona, Washington, Oklahoma, Colorado o Hawaii. */
   
SELECT FIRSTNAME, CITY, STATE
FROM CUSTOMERS
WHERE STATE IN ('Arizona', 'Washington', 'Oklahoma', 'Colorado', 'Hawaii');

-------------------------------------------------------------------------------------------------------------------------------

/* 31. Seleccione el item y el precio unitario 
   de cada item de la tabla items_ordered.  */
   
SELECT ITEM, ROUND(PRICE / QUANTITY, 2) "PRECIO UNITARIO"
FROM ITEMS_ORDERED
ORDER BY 2 ASC;

------------------------------------------------------------------------------------------------------------------------

/* 32. Escriba una consulta usando relaciones, para determinar cuáles items fueron 
   ordenados por cada cliente. Seleccione el ID del Cliente, nombre, apellido, 
                fecha de orden, item y precio.  */
                
                
SELECT CUSTOMERID, FIRSTNAME, LASTNAME, ORDER_DATE, ITEM, PRICE
FROM ITEMS_ORDERED I
NATURAL JOIN CUSTOMERS C
ORDER BY 4 ASC;
                
---------------------------------------------------------------------------------------------------------------------

-- CONSULTAS PL/SQL

-----------------------------------------------------------------------------------------------------------------------

/* 2.1 Construya un bloque PL/SQL que muestre la fecha de contratación más 
reciente de un empleado. En pantalla debe desplegarse el siguiente mensaje:
         "La fecha más reciente es <fecha reciente>" */  

SET SERVEROUTPUT ON              
DECLARE
  FECHA_RCNT DATE;
  
BEGIN
  
  SELECT MAX(HIRE_DATE) INTO FECHA_RCNT
  FROM EMPLOYEES;
  
  DBMS_OUTPUT.PUT_LINE('La fecha más reciente es: ' ||FECHA_RCNT);
  
END; 
/

----------------------------------------------------------------------------------------------------------------------------------------------------

/*  2.2 Construya un bloque PL/SQL que muestre el apellido
             y el nombre del empleado 100. */
             
DECLARE
   NOMBRE VARCHAR (30);
   APELLIDO VARCHAR (30);
   
BEGIN

   SELECT FIRST_NAME, LAST_NAME INTO NOMBRE, APELLIDO
   FROM EMPLOYEES
   WHERE EMPLOYEE_ID = 100;
   
   DBMS_OUTPUT.PUT_LINE('NOMBRE: ' ||NOMBRE|| CHR(10) || 'APELLIDO: '||APELLIDO);

END;
/

-------------------------------------------------------------------------------------------------------------------------

/* 2.3 Construya un bloque PL/SQL que muestre el apellido y
   el nombre de un empleado que tenga como puesto IT_PROG. */
   
DECLARE
   NOMBRE VARCHAR (30);
   APELLIDO VARCHAR (30);
   
BEGIN

   SELECT FIRST_NAME, LAST_NAME INTO NOMBRE, APELLIDO
   FROM EMPLOYEES
   WHERE JOB_ID = 'IT_PROG'
   AND MANAGER_ID <> '103';
   
   DBMS_OUTPUT.PUT_LINE('NOMBRE: ' ||NOMBRE|| ' | APELLIDO: '||APELLIDO);

END;
/

------------------------------

select * from employees;











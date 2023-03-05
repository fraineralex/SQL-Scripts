
-- CREACIÓN DE LA TABLA DEPT2

CREATE TABLE DEPT2
(
ID NUMBER (7),
NAME VARCHAR2 (25)
);

DESC DEPT2;

-- LLENADO DE LA TABLA DEPT2 CON LOS DATOS DE DEPARTMENTS

INSERT INTO DEPT2 (SELECT DEPARTMENT_ID, DEPARTMENT_NAME
                   FROM DEPARTMENTS);

-- CREACIÓN DE LA TABLA EMP2

CREATE TABLE EMP2
(
ID NUMBER (7),
LAST_NAME VARCHAR2 (25),
FIRST_NAME VARCHAR2 (25),
DEPT_ID NUMBER (7)
);

DESC EMP2;


-- MODIFICACIÓN DE LA COLUMNA FIRST_NAME A 60 CARACTERES EN LA TABLA EMP2.

ALTER TABLE EMP2
MODIFY FIRST_NAME VARCHAR2 (60);

DESC EMP2;

-- CONFIRMACIÓN DE LAS TABLAS DEPT2 Y EMP2 EN EL DICCIONARIO

SELECT * FROM ALL_ALL_TABLES WHERE UPPER(TABLE_NAME) IN ('EMP2', 'DEPT2');

-- CREACIÓN DE LA TABLA EMPLOYEES2

CREATE TABLE EMPLOYEES2
(
EMPLOYEE_ID NUMBER (6) NOT NULL,
FIRST_NAME VARCHAR2 (20),
LAST_NAME VARCHAR2 (25) NOT NULL,
SALARY NUMBER (8,2),
DEPARTMENT_ID NUMBER (4)
);

DESC EMPLOYEES2;

drop table employees2;
-- ASIGNANDO LOS RESPECTIVOS DATOS A EMPLOYEES2 DESDE EMPLOYEES

INSERT INTO EMPLOYEES2 (SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, SALARY, DEPARTMENT_ID
                        FROM EMPLOYEES);
                        
-- BORRADO DE LA TABLA EMP2

DROP TABLE EMP2;

-- CONSULTANDO LA TABLA EMP2 EN LA PAPELERA DE RECICLAJE

SELECT ORIGINAL_NAME, OPERATION, DROPTIME 
  FROM RECYCLEBIN
 WHERE ORIGINAL_NAME IN 'EMP2';
 
 -- ANULANDO EL BORRADO DE LA TABBLA EMP2
 
 FLASHBACK TABLE EMP2 TO BEFORE DROP;
 
 DESC EMP2;
 
 -- BORRADO DE LA COLUMNA FIRST_NAME EN LA TABLA EMPLOYEES2
 
 ALTER TABLE EMPLOYEES2
 DROP COLUMN FIRST_NAME;

-- CONFIRMACIÓN

DESC EMPLOYEES2;

-- MARCADO DE LA COLUMNA DEPT_ID COMO UNUSED

ALTER TABLE EMPLOYEES2
SET UNUSED COLUMN DEPARTMENT_ID;

-- CONFIRMACIÓN

SELECT * FROM USER_UNUSED_COL_TABS;

DESC EMPLOYEES2;

-- BORRADO DE TODAS LAS COLUMNAS INUSED EN LA TABLA EMPLOYEES2

SELECT 'ALTER TABLE '||table_name|| ' DROP UNUSED COLUMNS;'
FROM USER_UNUSED_COL_TABS;

ALTER TABLE EMPLOYEES2 DROP UNUSED COLUMNS;

--CONFIRMACIÓN

SELECT * FROM USER_UNUSED_COL_TABS;

DESC EMPLOYEES2;

-- AGRAGDO DE LA RESTRICCIÓN PRIMARY KEY A LA COLUMNA ID EN LA TABLA EMP2

ALTER TABLE EMP2
ADD CONSTRAINT my_emp_id_pk
PRIMARY KEY (ID);

-- AGREGADO DE LA RESTRICCIÓN PRIMARY KEY A LA COLIMNA ID EN LA TABLA DEPT2.

ALTER TABLE DEPT2
ADD CONSTRAINT my_dept_id_pk
PRIMARY KEY (ID);

-- AGREGADO DE LA REFERENCIA DE CLAVE AJENA EN LA COLUMNA DEPARTMENT_ID EN LA TABLA EMP2.

ALTER TABLE EMP2
ADD CONSTRAINT my_emp_dept_fk
FOREIGN KEY (DEPT_ID)
REFERENCES DEPT2 (ID);

-- CONFIRMACIÓN DEL GUARDADO DE LAS RESTRICCIONES MEDIANTE LA VISTA USER CONSTRAINTS.

SELECT *
FROM USER_CONSTRAINTS
WHERE TABLE_NAME IN ('DEPT2', 'EMP2');

-- MUESTRA DE LOS TIPOS Y LOS NOMBRE DE OBJETO DE LA VISTA DEL DICCIONARIO DE DATOS USER_OBJECT.

SELECT OBJECT_NAME, OBJECT_TYPE
FROM USER_OBJECTS
WHERE OBJECT_NAME IN ('EMP2','DEPT2') OR OBJECT_NAME LIKE ('MY_%');

-- AGREGADO DE LA COLUMNA COMISSION A LA TABLA EMP2

ALTER TABLE EMP2
ADD COMMISSION NUMBER (2,2)
CONSTRAINT check_constraint_commission
CHECK (COMMISSION > 0);

-- CONFIRMACIÓN

SELECT TABLE_NAME, CONSTRAINT_NAME
FROM ALL_CONSTRAINTS
WHERE CONSTRAINT_NAME LIKE 'CHECK%';

-- BORRADO DE LAS TABLAS EMP2 Y DEPT2 DE FORMA QUE NO SE PUEDAN RESTAURAR.

DROP TABLE EMP2 PURGE;
DROP TABLE DEPT2 PURGE;

-- CONFIRMACIÓN

SELECT ORIGINAL_NAME, OPERATION, DROPTIME 
FROM RECYCLEBIN
WHERE ORIGINAL_NAME IN 'EMP2' OR ORIGINAL_NAME IN 'DEPT2';
 
-- CREACIÓN DE LA TABLA DEP_NAMED_INDEX.

CREATE TABLE DEP_NAMED_INDEX
(
Deptno NUMBER (4)
PRIMARY KEY USING INDEX (CREATE INDEX DEPT_PK_IDX ON DEP_NAMED_INDEX(Deptno)),
Dname VARCHAR2 (30)
); 

DROP TABLE DEP_NAMED_INDEX;

-----------------------------------------------------------------------------------------------------------------------------

/*1. Escriba una consulta para mostrar el apellido, el número de departamento y el salario de cualquier empleado cuyo
número de departamento y salario se correspondan con el número de departamento y el salario de cualquier empleado
que gane una comisión. Use sub-consulta en pares*/

SELECT LAST_NAME, DEPARTMENT_ID, SALARY
FROM EMPLOYEES
WHERE (DEPARTMENT_ID, SALARY) IN (SELECT DEPARTMENT_ID, SALARY
                                  FROM EMPLOYEES
                                  WHERE COMMISSION_PCT = '0,25');
                                                                  
----------------------------------------------------------------------------------------------------------------

/* 2. Muestre el apellido, el nombre de departamento y el salario de cualquier empleado cuyo salario y comisión se
correspondan con el salario y la comisión de cualquier empleado con el identificador de ubicación 1700. Use subconsulta en pares.*/


SELECT LAST_NAME, DEPARTMENT_NAME, SALARY, COMMISSION_PCT
FROM EMPLOYEES E
JOIN DEPARTMENTS D ON (E.DEPARTMENT_ID = D.DEPARTMENT_ID)
WHERE (SALARY, COMMISSION_PCT)IN (SELECT  SALARY, COMMISSION_PCT
                                  FROM EMPLOYEES
                                  JOIN DEPARTMENTS D ON (E.DEPARTMENT_ID = D.DEPARTMENT_ID)
                                  WHERE LOCATION_ID = '1700');
                                  
--CONFIRMACIÓN

SELECT LAST_NAME, DEPARTMENT_NAME, SALARY, COMMISSION_PCT, LOCATION_ID
FROM EMPLOYEES E
JOIN DEPARTMENTS D ON (E.DEPARTMENT_ID = D.DEPARTMENT_ID)
WHERE LOCATION_ID = '1700';
                                  
----------------------------------------------------------------------------------------------------------------

/* 3. Muestre los detalles del identificador de empleado, el apellido y el identificador de departamento de los empleados que
vivan en ciudades cuyo nombre empiece por T. Use sub-consultas. */

                  
SELECT EMPLOYEE_ID, LAST_NAME, DEPARTMENT_NAME, E.DEPARTMENT_ID
FROM EMPLOYEES E
JOIN DEPARTMENTS D ON (E.DEPARTMENT_ID = D.DEPARTMENT_ID)
WHERE LOCATION_ID IN (SELECT LOCATION_ID
                        FROM LOCATIONS
                        WHERE CITY LIKE 'T%');
                        
/* 4. Escriba una consulta para buscar todos los empleados que ganen más que el salario medio de su departamento.
Muestre el apellido, el salario, el identificador de departamento y el salario medio del departamento. Ordene por salario
medio. Utilice alias para las columnas recuperadas por la consulta. Use sub-consultas correlacionadas. */


--------------------------------------------------------------------------------------------------------------------------------

 /* 5. Escriba una consulta para mostrar los apellidos de los empleados que tienen uno o más colegas en su departamento
con fechas de contratación posteriores pero salarios más altos. Use EXISTS. */

SELECT LAST_NAME
FROM EMPLOYEES E
WHERE EXISTS (SELECT LAST_NAME
              FROM EMPLOYEES
              WHERE (E.DEPARTMENT_ID = DEPARTMENT_ID)
              AND (SALARY < E.SALARY)
              AND (HIRE_DATE < E.HIRE_DATE));
              
---------------------------------------------------------------------------------------------------------------------------------------              

/* 6. Escriba una consulta para mostrar los nombres de departamento de los departamentos cuyo costo de salario total
supere un octavo (1/8) del costo de salario total de toda la compañía. Utilice la cláusula WITH para escribir esta
consulta. Asigne a la consulta el nombre SUMMARY. */

WITH SUMARY AS (SELECT DEPARTMENT_NAME, SUM(E.SALARY) COSTO_SALARIO_DEPARTAMENTO
                FROM EMPLOYEES E
                JOIN DEPARTMENTS D ON (E.DEPARTMENT_ID = D.DEPARTMENT_ID)
                GROUP BY DEPARTMENT_NAME),
                
 TOTAL_EMPRESA AS (SELECT SUM(COSTO_SALARIO_DEPARTAMENTO) AS COSTO_SALARIO_EMPRESA
                   FROM SUMARY)
                   
SELECT DEPARTMENT_NAME
FROM SUMARY
WHERE COSTO_SALARIO_DEPARTAMENTO > (SELECT (COSTO_SALARIO_EMPRESA * 1/8)
                                    FROM TOTAL_EMPRESA);
                
                





















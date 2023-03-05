/* 7.1 Construya un código PL/SQL que lea el ID del empleado, ID del supervisor y comisión. 
   Si el empleado cobra comisión que guarde en una variable "Cobra comisión". Además, si el 
   empleado se reporta a un supervisor que guarde en la misma variable "Tiene supervisor".
   Al final, mostrar en pantalla el siguiente mensaje:"El empleado <<ID del empleado>> 
   <<Mensaje>>".Guarde la información leída de la tabla de empleados en una variable 
   tipo RECORD. ermitir que el código sea reusable. */

SET SERVEROUTPUT ON                
DECLARE
   TYPE t_record IS RECORD
        (emp_id NUMBER(3),
         man_id NUMBER(3),
         comision NUMBER);
         
 v_record t_record;         
 v_mensaje VARCHAR2(20);

BEGIN

 SELECT employee_id, manager_id, commission_pct
 INTO v_record.emp_id, v_record.man_id, v_record.comision
 FROM employees
 WHERE employee_id = &emp_id;
 
 IF v_record.comision IS NOT NULL THEN
    v_mensaje := 'cobra comisión';
    DBMS_OUTPUT.PUT_LINE('El empleado '|| v_record.emp_id || ' ' || v_mensaje);
    IF v_record.man_id IS NOT NULL THEN
       v_mensaje := 'tiene supervisor';
       DBMS_OUTPUT.PUT_LINE('El empleado '|| v_record.emp_id || ' ' || v_mensaje);
       END IF;
 END IF;
END;
/

---------------------------------------------------------------------------------------------------------------------

/* 7.2 Primero deben crear una tabla [EMP_GRADES] que tenga la siguiente estructura:

EMP_ID NUMBER(6)
NAME VARCHAR2(60) --LASTNAME + '' + FIRSTNAME
SALARY NUMBER(8,2)
DEPT_ID NUMBER(4)
DEPT_NAME VARCHAR2(30)
GRADE VARCHAR2(3)
MSG VARCHAR2(10)

Cree una variable RECORD que contenga el registro completo de empleados, el nombre de
departamento y el nivel salarial (para simplificar la construcción de la variable RECORD cree
una vista). En el cuerpo del código, deberán leer la información correspondiente de las tablas
de empleados, departamentos y niveles salariales y guardar los datos en la variable tipo
RECORD. A continuación deberán construir una estructura CASE para evaluar el nivel salarial.
Deberán almacenar en una variable un texto dependiendo del nivel salarial. Si es "A"
almacenan "Low", si es "B" o "C" almacenan "Medium", si es "D" almacenan "High", de lo
contrario almacenan "Elite". Finalmente deberán insertar en la tabla creada inicialmente los
valores obtenidos. Fuera del código, revise el contenido de la tabla EMP_GRADES.*/

-- Creación de la tabla EMP_GRADES
CREATE TABLE EMP_GRADES
(
EMP_ID NUMBER(6),
NAME VARCHAR2(60),
SALARY NUMBER(8,2),
DEPT_ID NUMBER(4),
DEPT_NAME VARCHAR2(30),
GRADE VARCHAR2(3),
MSG VARCHAR2(10)
);
  
  -- Creación de la vista VW_EMP
  CREATE VIEW VW_EMP AS
    SELECT e.employee_id, e.first_name, e.last_name, e.email, e.phone_number, 
            e.hire_date, e.job_id, e.salary, e.commission_pct, e.manager_id, e.department_id, 
            d.department_name, j.grade
            
    FROM employees e
    
    JOIN departments d ON (e.department_id = d.department_id)
    JOIN job_grades j ON (e.salary BETWEEN j.lowest_sal AND j.highest_sal);

-- Bloque PL/SQL con las especificaciones conernientes
DECLARE
   TYPE t_record IS RECORD
        (emp VW_EMP%ROWTYPE);
        
v_record t_record;
v_mensaje VARCHAR2(10);
BEGIN
  SELECT e.employee_id, e.first_name, e.last_name, e.email, e.phone_number, 
         e.hire_date, e.job_id, e.salary, e.commission_pct, e.manager_id, e.department_id, 
         d.department_name, j.grade
         
  INTO v_record.emp
  
  FROM employees e
  
    JOIN departments d ON (e.department_id = d.department_id) 
    JOIN job_grades j ON (e.salary BETWEEN j.lowest_sal AND j.highest_sal)
  WHERE (e.employee_id = &employee_id);
    
  CASE v_record.emp.grade
      WHEN 'A' THEN
           v_mensaje := 'Low';
      WHEN 'B' THEN
           v_mensaje := 'Midium';
      WHEN 'C' THEN
           v_mensaje := 'Midium';
      WHEN 'D' THEN
           v_mensaje := 'High';
      ELSE
           v_mensaje := 'Elite';
  END CASE;
 
  INSERT INTO EMP_GRADES VALUES (v_record.emp.employee_id, v_record.emp.first_name || ' ' || v_record.emp.last_name,
                                v_record.emp.salary, v_record.emp.department_id, v_record.emp.department_name,
                                v_record.emp.grade, v_mensaje);
END;
/

SELECT *
FROM EMP_GRADES;

----------------------------------------------------------------------------------------------------------------------

/*  7.3 Construir un código PL/SQL usando una estructura de arreglo asociativa (INDEX-BY table).
En la misma deberás guardar los registros de la tabla de empleados para los ID de empleados del
100 al 120. Las siguientes tareas deberán realizarse a partir del arreglo asociativo construido
y usando los métodos de tablas INDEX BY:

  1. Mostrar en pantalla la cantidad de registros.
  2. Mostrar el apellido del primer registro.
  3. Mostrar el apellido del último registro.
  4. Mostrar el apellido del registro 104.
  5. Mostrar el apellido del registro anterior al 104.
  6. Mostrar el apellido del registro posterior al 104.
  7. Mostrar si el registro 8 existe o no.
  8. Mostrar si el registro 108 existen o no.
  9. Eliminar el registro 104.
 10. Eliminar el rango de registros del 115 al 117.
 11. Mostrar la cantidad de registros.
 12. Mostrar el apellido de todos los registros del 100 al 120, en caso
 de que un índice no exista en dicho rango, mostrar "No existe".
 13. Borrar todos los registros.
 14. Mostrar la cantidad de registros.  */
 
 -- Bloque PL/SQL
 SET SERVEROUTPUT ON
 DECLARE 
  TYPE emp_array_type IS TABLE OF
       employees%ROWTYPE INDEX BY PLS_INTEGER;

 emp_array emp_array_type;
 
BEGIN 
 FOR i IN 100..120 LOOP
     SELECT *
     INTO emp_array(i)
     FROM employees
     WHERE (employee_id = i);
 END LOOP;
 
 DBMS_OUTPUT.PUT_LINE(         'RESUMEN DE DATOS'     || CHR(10));
 
 -- 1. Mostrar en pantalla la cantidad de registros.
 DBMS_OUTPUT.PUT_LINE('1. Mostrar en pantalla la cantidad de registros.'
  || CHR(10) || '- Cantidad de registros: ' || emp_array.COUNT || CHR(10));
  
 -- 2. Mostrar el apellido del primer registro.
   DBMS_OUTPUT.PUT_LINE('2. Mostrar el apellido del primer registro.'|| CHR(10) ||
   '- Apellido del primer registro: ' || emp_array(emp_array.FIRST).last_name || CHR(10));
   
 -- 3. Mostrar el apellido del último registro.   
   DBMS_OUTPUT.PUT_LINE('3. Mostrar el apellido del último registro.'|| CHR(10) ||
   '- Apellido del último registro: ' || emp_array(emp_array.LAST).last_name || CHR(10));
   
 -- 4. Mostrar el apellido del registro 104.
      DBMS_OUTPUT.PUT_LINE('4. Mostrar el apellido del registro 104.'|| CHR(10) ||
   '- Apellido del registro 104: ' || emp_array(104).last_name || CHR(10));
   
 -- 5. Mostrar el apellido del registro anterior al 104.
      DBMS_OUTPUT.PUT_LINE('5. Mostrar el apellido del registro anterior al 104.' || CHR(10) ||
   '- Apellido del registro anterior al 104: ' || emp_array(emp_array.PRIOR(104)).last_name || CHR(10));
   
 -- 6. Mostrar el apellido del registro posterior al 104.
      DBMS_OUTPUT.PUT_LINE('6. Mostrar el apellido del registro posterior al 104.'|| CHR(10) ||
   '- Apellido del registro anterior al 104: ' || emp_array(emp_array.NEXT(104)).last_name || CHR(10));
   
 -- 7. Mostrar si el registro 8 existe o no.
      DBMS_OUTPUT.PUT_LINE('7. Mostrar si el registro 8 existe o no.');
      IF emp_array.EXISTS(8) THEN 
         DBMS_OUTPUT.PUT_LINE('- El registro 8 existe' || CHR(10));
      ELSE
         DBMS_OUTPUT.PUT_LINE('- El registro 8 no existe' || CHR(10));
      END IF;
      
 -- 8. Mostrar si el registro 108 existe o no.
      DBMS_OUTPUT.PUT_LINE('8. Mostrar si el registro 108 existe o no.');
      IF emp_array.EXISTS(108) THEN 
         DBMS_OUTPUT.PUT_LINE('- El registro 108 existe'|| CHR(10));
      ELSE
         DBMS_OUTPUT.PUT_LINE('- El registro 108 no existe' || CHR(10));
      END IF;
      
 -- 9. Eliminar el registro 104.
    DBMS_OUTPUT.PUT_LINE('9. Eliminar el registro 104.');
    emp_array.DELETE(104);
    DBMS_OUTPUT.PUT_LINE('- El registro 104 ha sido eliminado'|| CHR(10));
    
 -- 10. Eliminar el rango de registros del 115 al 117.
    DBMS_OUTPUT.PUT_LINE('10. Eliminar el rango de registros del 115 al 117.');
    emp_array.DELETE(115,117);
    DBMS_OUTPUT.PUT_LINE('- Se han eliminado los registros 115, 116 y 117 respectivamente'|| CHR(10));
    
 -- 11. Mostrar la cantidad de registros.
    DBMS_OUTPUT.PUT_LINE('11. Mostrar la cantidad de registros.
    - Cantidad de registros: ' || emp_array.COUNT || CHR(10));
    
 -- 12. Mostrar el apellido de todos los registros del 100 al 120, en caso
 -- de que un índice no exista en dicho rango, mostrar "No existe".
    DBMS_OUTPUT.PUT_LINE('12. Mostrar el apellido de todos los registros del 100 al 120,
    en caso de que un índice no exista en dicho rango, mostrar "No existe' || CHR(10));
    FOR i IN 100..120 LOOP
        IF emp_array.EXISTS(i) THEN
           DBMS_OUTPUT.PUT_LINE('- El apellido del empleado ' || i || ' es ' || emp_array(i).last_name);
           
        ELSE
           DBMS_OUTPUT.PUT_LINE('- El empleado ' || i || ' no existe.');
           
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('');
    
 -- 13. Borrar todos los registros.
    DBMS_OUTPUT.PUT_LINE('13. Borrar todos los registros.');
    emp_array.DELETE;
    DBMS_OUTPUT.PUT_LINE('- Todos los registros han sido borrados.' || CHR(10));
    
 -- 14. Mostrar la cantidad  de registros.
    DBMS_OUTPUT.PUT_LINE('14. Mostrar la cantidad  de registros.' || CHR(10) || 
    '- Cantidad de registros: ' || emp_array.COUNT);
    
END;
/

-------------------------------------------------------------------------------

/*7.4 Construir un código PL/SQL que cree una variable tipo VARRAY de tamaño 21 
para almacenar los apellidos de los ID de empleados 100 al 120. Para llenar el arreglo,
usen BULK COLLECT INTO. Mostrar por pantalla los datos obtenidos con el siguiente formato:
           Elemento <<# de elemento>> del arreglo VARRAY: <<Apellido>>*/
           
SET SERVEROUTPUT ON
DECLARE
  TYPE apellido_type IS VARRAY(21) OF VARCHAR2(30);
  
v_apellidos apellido_type;

BEGIN
  SELECT last_name
  BULK COLLECT INTO v_apellidos
  FROM employees
  WHERE (employee_id BETWEEN 100 AND 120);
  
  DBMS_OUTPUT.PUT_LINE('APELLIDOS:' || CHR(10));
  
  FOR i IN 1..v_apellidos.LAST LOOP
      DBMS_OUTPUT.PUT_LINE('Elemento ' || i || ' del arreglo VARRAY: ' || v_apellidoS(i));
  END LOOP;
  
END;
/

----------------------------------------------------------------------------------------------------

/* 7.5 Crear un tipo de dato VARRAY (dept_type) que sea VARCHAR2(25).
El tamaño del arreglo debe ser de 25. Luego deberán crear una variable 
que use el tipo VARRAY creado anteriormente. En dicha variable almacenen
todos los apellidos de los empleados que trabajan en un departamento dado
por pantalla. Mostrar la información de la siguiente forma:

           Departamento: <<ID del departamento>>
                *** Empleado: <<Apellido>>
Usen el comando para definir una variable de sustitución y para
no visualizar el texto del comando. */

SET VERIFY OFF
SET SERVEROUTPUT ON
DECLARE
  TYPE dept_type IS VARRAY(25) OF VARCHAR(25);
  
v_dept dept_type;
v_id_dept NUMBER(5) := &v_id_dept;

BEGIN 
 SELECT last_name
 BULK COLLECT INTO v_dept
 FROM employees
 WHERE department_id = v_id_dept;
 
  DBMS_OUTPUT.PUT_LINE('Departamento: ' || v_id_dept || CHR(10));
  FOR i IN 1..v_dept.LAST LOOP
      DBMS_OUTPUT.PUT_LINE('*** Empleado: ' || v_dept(i));
  END LOOP;

END;
/

------------------------------------------------------------------------------------------------

/* 8.1 Construya un código PL/SQL que usando un CURSOR explícito busque la fecha máxima
de contratación en la tabla de empleados. Use FETCH para leer cada fila del cursor.
Analice cuántos registros retornará el cursor. Basado en su análisis elija la mejor
forma de construir el código. Muestre el siguiente mensaje:
                      La máxima fecha es <<Fecha>>            */
                      

SET SERVEROUTPUT ON
DECLARE 
  CURSOR c_fecha_cursor IS
         SELECT MAX(hire_date)
         FROM employees;
         
v_fecha employees.hire_date%TYPE;

BEGIN
  OPEN c_fecha_cursor;
  FETCH c_fecha_cursor INTO v_fecha;
  DBMS_OUTPUT.PUT_LINE('La máxima Fecha es: ' || v_fecha);
  CLOSE c_fecha_cursor;
  
END;
/

---------------------------------------------------------------------------------------------------------------

/* 8.2 Construya un código PL/SQL usando un CURSOR explícito que busqueel apellido
y la posición de todos los empleados que se reportan al supervisor 100.
Mostrar el siguiente mensaje sólo para los primeros 10 empleados:

          El empleado <<Apellido>> trabaja como <<Posición>>

Utilice FETCH, %NOTFOUND y %ROWCOUNT. Ante de abrir el CURSOR valide 
       que el mismo no se encuentre abierto usando %ISOPEN. */
       
DECLARE 
   CURSOR c_emp_cursor IS
          SELECT last_name, job_id
          FROM employees
          WHERE manager_id = 100;
v_emp c_emp_cursor%ROWTYPE;

BEGIN
  DBMS_OUTPUT.PUT_LINE('EMPLEADOS QUE SE REPORTAN CON STIVEN KING:' || CHR(10));
  IF NOT c_emp_cursor%ISOPEN THEN
         OPEN c_emp_cursor;
  END IF;
  
  LOOP
      FETCH c_emp_cursor INTO v_emp;
      DBMS_OUTPUT.PUT_LINE('El empleado ' || v_emp.last_name ||
                            ' trabaja como ' || v_emp.job_id);
      EXIT WHEN c_emp_cursor%ROWCOUNT = 10 OR c_emp_cursor%NOTFOUND;
  END LOOP;
  CLOSE c_emp_cursor;
  
END;
/

---------------------------------------------------------------------------------------------------------------------------------------------------

/* 8.3 Construya un código PL/SQL usando cursor FOR LOOP que lea los ID del empleado,apellido, 
salario, nombre de departamento y nivel salarial. Relacione sus datos con la tabla JOB_GRADES
para conocer su nivel salarial. Si el nivel del empleado es 'A'se desea desplegar "Low",
si es 'B' o 'C' que despliegue 'Medium', si es 'D' que despliegue 'High' y si no es
ninguno de estos niveles, que despliegue 'Elite'. Ordene los datos por el nivel
salarial. Mueste la información por pantalla como sigue:

              Id: <<Id del empleado>> * Apellido: <<Apellido>> *
   Departamento: <<Nombre del Departamento>> * Salary: <<Salario>> * Nivel: <<Nivel>>

        El salario debe salir con el siguiente formato: 'fm$99,999' */

-- BLOQUE DE CÓDIGO
ALTER TABLE job_grades
MODIFY grade CHAR(10);

DECLARE
     CURSOR c_emp_cursor IS
            SELECT employee_id, last_name, salary, department_name, grade
            FROM employees e
            JOIN departments d ON (e.department_id = e.department_id)
            JOIN job_grades j ON (e.salary BETWEEN j.lowest_sal AND j.highest_sal)
            ORDER BY 5;
            
BEGIN
     DBMS_OUTPUT.PUT_LINE('INFORMACIÓN DE LOS EMPLEADOS' || CHR(10));
     
     FOR v_emp IN c_emp_cursor LOOP
         CASE v_emp.grade
              WHEN 'A' THEN
                   v_emp.grade := 'Low';
              WHEN 'B' THEN
                   v_emp.grade := 'Midium';
              WHEN 'C' THEN
                   v_emp.grade := 'Midium';
              WHEN 'D' THEN
                   v_emp.grade := 'High';
         ELSE
           v_emp.grade := 'Elite';
  END CASE;
  
  DBMS_OUTPUT.PUT_LINE('Id: ' || v_emp.employee_id || ' * Apellido: ' || v_emp.last_name || ' * ' || CHR(10) ||
                       'Departamento: ' || v_emp.department_name || ' * Salario: ' || to_char(v_emp.salary, 'fm$99,999')|| 
                       ' * Nivel: ' || v_emp.grade || CHR(10));
     END LOOP;
END;
/

-----------------------------------------------------------------------------------------------------------------

/* 8.4 Construya un código PL/SQL usando un cursor FOR LOOP con subquery. Muestre el ID,
apellido y país de todos los empleados que trabajen en Canadá y United Kingdom. Ordene
la data por país y apellido de manera ascendente. El formato de la salida debe ser como sigue
                       ID *** Apellido *** País                   */
SET SERVEROUTPUT ON                   
BEGIN
    DBMS_OUTPUT.PUT_LINE('INFORMACIÓN DE LOS EMPLEADOS' || CHR(10));
    FOR v_emp IN (SELECT employee_id, last_name, country_name
    FROM employees e
    NATURAL JOIN departments
    NATURAL JOIN locations
    NATURAL JOIN countries c
    WHERE c.country_name IN ('United Kingdom', 'Canada')
    ORDER BY 3, 2)
    
    LOOP
       DBMS_OUTPUT.PUT_LINE('ID: ' || v_emp.employee_id || ' *** ' || 'Apellido: ' ||
                            v_emp.last_name || ' *** ' || 'País: ' || v_emp.country_name);
                            
    END LOOP;
    
END;
/

--------------------------------------------------------------------------------------------------------

/* 8.5 Construya un código PL/SQL con un cursor que busque el salario total y el salario
promedio que trabajan en un departamento dado. Al momento de abrir el cursor pase los 
valores 20 y 30 como parámetros. Muestre la información como sigue:

 Departamento(<<ID>>): Salario total <<total>> *** Salario promedio <<promedio>>
   
     Los valores del salario deben salir con el siguiente formato: 'fm$99,999'   */
     
DECLARE
v_dept_20 NUMBER(5) := 20;
v_dept_30 NUMBER(5) := 30;
v_sal_promedio NUMBER(7,2);
v_sal_total NUMBER(7,2);
     CURSOR c_salario_cursor (dept_num NUMBER) IS
            SELECT SUM(salary), AVG(salary)
            FROM employees e
            WHERE (e.department_id = dept_num);
            
BEGIN 
     OPEN c_salario_cursor(v_dept_20);
     FETCH c_salario_cursor INTO v_sal_total,v_sal_promedio;
     
     DBMS_OUTPUT.PUT_LINE('Departamento(' || v_dept_20 || '): Salario total: '
     || TO_CHAR(v_sal_total, 'fm$99,999') || ' *** Salario promedio: ' || 
     TO_CHAR(v_sal_promedio, 'fm$99,999'));
     
     CLOSE c_salario_cursor;
     
         OPEN c_salario_cursor(v_dept_30);
     FETCH c_salario_cursor INTO v_sal_total,v_sal_promedio;
     
     DBMS_OUTPUT.PUT_LINE('Departamento(' || v_dept_30 || '): Salario total: '
     || TO_CHAR(v_sal_total, 'fm$99,999') || ' *** Salario promedio: ' || 
     TO_CHAR(v_sal_promedio, 'fm$99,999'));
     
     CLOSE c_salario_cursor;
END;
/

----------------------------------------------------------------------------------------------------------

/* 8.6 Construya un código PL/SQL que busque el ID y salario de los empleados que ganan una comisión
mayor a un valor dado (Ejemplo: 0.1) y bloquee el salario para que no sea actualizado por otra sesión.
En la sección de ejecución actualice el salario de los empleados que vengan en el cursor en un 10%.
Para realizar esta práctica use un cursor FOR LOOP con parámetros, FOR UDPATE OF, NOWAIT y CURRENT OF.*/


  SELECT employee_id, salary
  FROM employees
  WHERE (commission_pct > &v_comm);
  
DECLARE
      CURSOR c_emp_cursor (comision NUMBER) IS
             SELECT employee_id, salary
             FROM employees
             WHERE (commission_pct > comision)
             FOR UPDATE OF salary NOWAIT;
             
BEGIN
    FOR v_emp IN c_emp_cursor(&v_comm)
    LOOP
        UPDATE employees
        SET salary = (salary * 1.20)
        WHERE CURRENT OF c_emp_cursor;
    END LOOP;
    
END;
/

SELECT employee_id, salary
FROM employees
WHERE (commission_pct > &v_comm);

-------------------------------------------------------------------------------------------

/* 8.7 Realice la práctica 8.6 usando WAIT por 10 segundos. Conectado como SYSTEM cree un usuario
(otorgarles los privilegios correspondientes para que pueda crear una sesión), luego conectado
como HR se le debe otorgar los privilegios de actualización sobre la tabla EMPLOYEES. Cree una
sesión nueva conectado con el usuario recientemente creado y actualice el salario en un 15% al
empleado 146 (no asiente los cambios). En la sesión HR, corra el programa y en un primer 
escenario deje que pase los 10 segundos y comente qué pasa. En la misma sesión de HR, c
orra nuevamente el programa y antes de que venzan los 10 segundos, diríjase a la sesión 
del otro usuario y deshaga el cambio y comente el comportamiento del programa. */


-- Otorgando privilegios a c##prpueba para SELECT AND UPDATE
GRANT SELECT,UPDATE ON employees TO c##prueba;
SHOW USER;

-- Programa del punto 8.6 en HR
DECLARE
      CURSOR c_emp_cursor (comision NUMBER) IS
             SELECT employee_id, salary
             FROM employees
             WHERE (commission_pct > comision)
             FOR UPDATE OF salary WAIT 10;
BEGIN
    FOR v_emp IN c_emp_cursor(&v_comm)
    LOOP
        UPDATE employees
        SET salary = (salary * 1.10)
        WHERE CURRENT OF c_emp_cursor;
    END LOOP;
    
END;
/

-- Programa del punto 8.6 en HR
SET VERIFY ON
DEFINE v_commision = 0.2;

SELECT employee_id, salary
FROM employees
WHERE (commission_pct > &v_commision);

DECLARE
    CURSOR c_emp_info (comision NUMBER) IS
        SELECT employee_id, salary
         FROM employees
         WHERE (commission_pct > comision)
         FOR UPDATE OF salary WAIT 10;
BEGIN
    FOR v_emp_info IN c_emp_info(&v_commision) LOOP 
        UPDATE employees 
        SET salary = (salary * 1.10)
        WHERE CURRENT OF c_emp_info;
    END LOOP;
END;
/


SELECT * FROM EMPLOYEES;
     
        
     


  

         




























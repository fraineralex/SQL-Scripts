
/* 10.1 Construir un c�digo PL/SQL que cree un procedimiento que actualice el salario en un 5%
de un empleado suministrado por pantalla. Muestre el apellido y el salario del empleado,
antes y despu�s de actualizar el registro. Ejecute el procedimiento desde un bloque de programa no nombrado. */

CREATE OR REPLACE PROCEDURE update_salary 
  (v_id NUMBER) IS
  
  v_emp employees%ROWTYPE;
    
BEGIN
  v_emp.employee_id := v_id;
  SELECT *
  INTO v_emp
  FROM employees
  WHERE (employee_id = v_emp.employee_id);
  DBMS_OUTPUT.PUT_LINE('El salario del empleado '|| v_emp.last_name ||' es ' || v_emp.salary);
  
  UPDATE employees
  SET salary = (salary * 1.05)
  WHERE (employee_id = v_emp.employee_id);
  
  SELECT *
  INTO v_emp
  FROM employees
  WHERE (employee_id = v_emp.employee_id);

  DBMS_OUTPUT.PUT_LINE('El nuevo salario del empleado '|| v_emp.last_name ||' es ' || v_emp.salary);
  
END;
/


--Invocando el procedimiento "UPDATE_SALARY" desde un bloque no nombrado
UNDEFINE id
BEGIN
  update_salary (&&id);
  
END;
/

-----------------------------------------------------------------------------------------------------------

/*10.2 Construir un c�digo PL/SQL an�nimo que invoque un procedimiento pas�ndole como par�metro un ID del empleado que fue 
introducido por pantalla y que imprima por pantalla el apellido y el salario de dicho empleado. Desplegar los datos como:    
                                    "Detalle del empleado: <Apellido>, <Salario>"
Construir un c�digo PL/SQL que cree un procedimiento que busque el apellido y el salario de un empleado recibido del c�digo
anterior. Definir dos par�metros de salida para devolver el apellido y el salario de dicho empleado.*/

CREATE OR REPLACE PROCEDURE buscar_salario 
  (v_emp_id IN employees.employee_id%TYPE, v_last_name OUT employees.last_name%TYPE, v_salary OUT employees.salary%TYPE)
  IS 
  
 BEGIN 
 SELECT last_name, salary
 INTO v_last_name, v_salary
 FROM employees
 WHERE employee_id = v_emp_id;
 
 EXCEPTION
    WHEN NO_DATA_FOUND THEN
      v_salary := '-1';
      DBMS_OUTPUT.PUT_LINE('El ID insertado no pertenece a ningun empleado...');
    WHEN OTHERS THEN
      v_salary := '-1';
      DBMS_OUTPUT.PUT_LINE('Error buscando empleado...');
END;
/

-- Invocando el procedimiento desde un bloque anonimo.
UNDEFINE ID
SET SERVEROUTPUT ON
SET VERIFY OFF
DECLARE
 v_last_name employees.last_name%TYPE;
 v_salary employees.salary%TYPE;
BEGIN
 buscar_salario(&&ID, v_last_name, v_salary);
  
  IF v_salary = '-1' THEN 
     DBMS_OUTPUT.PUT_LINE(CHR(10)||'El subprograma report� una excepci�n');
  ELSE
     DBMS_OUTPUT.PUT_LINE('Detalle del empleado: <' || v_last_name ||'>, <' || v_salary || '>');
  END IF;
 
END;
/

----------------------------------------------------------------------------------------------------------------------------------------

/*10.3 A) Construir un c�digo PL/SQL que construya un procedimiento llamado raise_comm,
el cual reciba dos par�metros(ID del empleado y Tasa de aumento). Este procedimiento 
tiene como labor actualizar el salario del empleado dado a la tasa de aumento recibida.*/

CREATE OR REPLACE PROCEDURE raise_comm
(v_emp_id employees.employee_id%TYPE, v_taza NUMBER)
IS

BEGIN
 UPDATE employees
 SET salary = ((salary * v_taza/100) + (salary))
 WHERE employee_id = v_emp_id;
 COMMIT;
 
END;
/


/*B) Construir un c�digo PL/SQL que construya un procedimiento llamado employee_proc,
el cual construya un cursor que busque el ID del empleado, el apellido y el salario
de todos los empleados que trabajan como IT_PROG.

?	Si el empleado gana entre 4000 y 5000, deber� tener una tasa de aumento de 10%.
?	Si el empleado gana entre 5001 y 6000, deber� tener una tasa de aumento de 8%.
?	Si el empleado gana entre 6001 y 7000, deber� tener una tasa de aumento de 6%.
?	Si el empleado gana cualquier otro valor, deber� tener una tasa de aumento de 4%. */

CREATE OR REPLACE PROCEDURE employee_proc
IS
 v_emp_id employees.employee_id%TYPE;
 v_last_name employees.last_name%TYPE;
 v_salary employees.salary%TYPE;
 v_taza NUMBER;
 v_new_salary NUMBER;

 CURSOR c_emp IS
   SELECT employee_id, last_name, salary
   FROM employees
   WHERE (job_id = 'IT_PROG');
BEGIN
 OPEN c_emp;
 
 LOOP
  FETCH c_emp into v_emp_id, v_last_name, v_salary;
   EXIT WHEN c_emp%NOTFOUND;
    IF v_salary BETWEEN 4000 and 5000 THEN
      raise_comm(v_emp_id, 10);
      v_taza:= 10;
      imprimir_datos(v_emp_id, v_last_name, v_taza, v_salary);
      
    ELSIF v_salary BETWEEN 5001 and 6000 THEN
      raise_comm(v_emp_id, 8);
      v_taza:= 8;
      imprimir_datos(v_emp_id, v_last_name, v_taza, v_salary);
      
    ELSIF v_salary BETWEEN 6001 and 7000 THEN
      raise_comm(v_emp_id, 6);
      v_taza:= 6;
      imprimir_datos(v_emp_id, v_last_name, v_taza, v_salary);
      
    ELSE 
      raise_comm(v_emp_id, 4);
      v_taza:= 4;
      imprimir_datos(v_emp_id, v_last_name, v_taza, v_salary);
      
   END IF;
  END LOOP;
 CLOSE c_emp;
END;
/

-- Ejecutando el procedimiento
EXECUTE employee_proc;



--Salarios de los empleados despu�s de la actualizaci�n
SELECT LAST_NAME, SALARY
FROM EMPLOYEES
WHERE JOB_ID = 'IT_PROG';

--Procedimiento para imprimir los datos de los empleados
CREATE OR REPLACE PROCEDURE imprimir_datos
(v_emp_id NUMBER, v_last_name VARCHAR2, v_taza NUMBER, v_salary NUMBER)
IS

 v_new_salary NUMBER;

BEGIN
  SELECT salary
  into v_new_salary
  FROM employees
  WHERE employee_id = v_emp_id;

 DBMS_OUTPUT.PUT_LINE(CHR(10)||'--- Datos del empleado ---' || CHR(10)||
 '*** Apellido: <<'||v_last_name||'>>' || CHR(10) ||
 '*** Aumento [%]: <<'||v_taza||'%>>'||CHR(10)||
 '*** Salario[V]: <<'||to_char(v_salary, '$99,999.00')||'>>'||CHR(10)||
 '*** Salario[N]: <<'||to_char(v_new_salary, '$99,999.00')||'>>'||CHR(10));
 END;
 
 ---------------------------------------------------------------------------------------------------------
 
 /*10.4 Construya un c�digo PL/SQL que cree la funci�n tax, la cual reciba como par�metro el salario 
 de un empleado dado y que retorne el salario aumentado en un 10%.*/
 
 CREATE OR REPLACE FUNCTION tax(v_salary employees.salary%TYPE) 
   RETURN NUMBER IS
   
BEGIN 

  RETURN v_salary + (v_salary * 0.10);

END;
/

 
 /*Realice una consulta usando una instrucci�n SQL. En la misma seleccione el ID del empleado y el
 valor devuelto por la funci�n (llamar funci�n), para todos aquellos empleados cuyo valor devuelto
 por la funci�n (llamar funci�n) sea mayor (query principal) al valor m�ximo devuelto por la 
 funci�n (llamar funci�n) de los empleados que laboren en el departamento 30 (subquery).
 Ordene los valores por el valor devuelto por la funci�n (llamar funci�n).*/
 
SELECT employee_id, tax(salary) AS "Salario actualizado"
FROM employees
WHERE tax(salary) > (SELECT MAX(tax(salary))
                     FROM employees
                     WHERE (department_id = 30))

ORDER BY 2;

-- Confirmaci�n
SELECT max(tax(salary))
FROM EMPLOYEES
where department_id = 30;

------------------------------------------------------------------------------------------------------------------------

/*9.5 Construya un c�digo PL/SQL que busque las localidades que se encuentren en las
ciudades de Toronto, Munich y Mexico City. Esto puede hacerlo usando un cursor. Use el
cursor en el bloque interno. Ordene los datos por ID de localidad. En un bloque interno
aumente en un 25% el salario de los empleados cuyo departamento se encuentre en las
localidades de las ciudades dadas. Para actualizar los datos puede usar un sub-query. Muestre
la cantidad de registros actualizados en cada localidad. Maneje cualquier error que surja al
momento de la actualizaci�n usando excepciones manejadas por el usuario. Defina la
excepci�n en el bloque externo. Muestre el siguiente mensaje de error:

  'Departamento no existe. Favor revise la localidad: <<ID Localidad>>'
  
Maneje tambi�n cualquier error producido durante el manejo del cursor en el bloque interno.
Muestre el siguiente mensaje de error: 'Acceso a cursor inv�lido!'*/

SET SERVEROUTPUT ON
DECLARE
 CURSOR c_emp IS
 SELECT l.location_id
 FROM employees e
 JOIN departments d ON (e.department_id = d.department_id)
 JOIN locations l ON (d.location_id = l.location_id)
 WHERE city IN ('Toronto', 'Munich', 'Mexico city')
 order by 1;
 e_update_excep EXCEPTION;
  
BEGIN

 FOR registro IN c_emp LOOP
  UPDATE employees
  SET salary = (salary * 1.25)
  WHERE department_id IN (SELECT e.department_id
                          FROM employees e
                          JOIN departments d ON (e.department_id = d.department_id)
                          JOIN locations l ON (d.location_id = l.location_id)
                          WHERE l.city IN ('Toronto'));
  DBMS_OUTPUT.PUT_LINE('- La cantidad de registros actualizados en Toronto es: '||SQL%ROWCOUNT);
  
  UPDATE employees
  SET salary = (salary * 1.25)
  WHERE department_id IN (SELECT e.department_id
                          FROM employees e
                          JOIN departments d ON (e.department_id = d.department_id)
                          JOIN locations l ON (d.location_id = l.location_id)
                          WHERE l.city IN ('Munich'));
  DBMS_OUTPUT.PUT_LINE('- La cantidad de registros actualizados en Munich es: '||SQL%ROWCOUNT);
  
  UPDATE employees
  SET salary = (salary * 1.25)
  WHERE department_id IN (SELECT e.department_id
                          FROM employees e
                          JOIN departments d ON (e.department_id = d.department_id)
                          JOIN locations l ON (d.location_id = l.location_id)
                          WHERE l.city IN ('Mexico city'));
  DBMS_OUTPUT.PUT_LINE('- La cantidad de registros actualizados en Mexico city es: '||SQL%ROWCOUNT); 

    IF SQL%NOTFOUND THEN
       RAISE e_update_excep;
    END IF;
 END LOOP;
 
EXCEPTION
  WHEN e_update_excep THEN
     DBMS_OUTPUT.PUT_LINE('Departamento no existe. Favor revise la localidad: '||SQLERRM);
     WHEN INVALID_CURSOR THEN
        DBMS_OUTPUT.PUT_LINE('Acceso a cursor inv�lido!');
        WHEN OTHERS THEN
             DBMS_OUTPUT.PUT_LINE('Error inesperado');

END;
/

SELECT LAST_NAME, SALARY
FROM EMPLOYEES
WHERE DEPARTMENT_ID IN (20, 70);


(SELECT e.department_id
                          FROM employees e
                          
                          SELECT d.department_id
                          JOIN departments d ON (e.department_id = d.department_id)
                          JOIN locations l ON (d.location_id = l.location_id)
                          WHERE l.city IN ('Mexico city'));
                          
                          
CREATE OR REPLACE PROCEDURE buscar_nombre
(v_emp_id employees.employee_id%TYPE) IS
V_NOMBRE VARCHAR(30);

BEGIN

SELECT LAST_NAME
INTO V_NOMBRE
FROM EMPLOYEES
WHERE EMPLOYEE_ID = v_emp_id;

DBMS_OUTPUT.PUT_LINE('NOMBRE: ' || V_NOMBRE || CHR(10)|| 'ID: ' ||V_EMP_ID);

END;

SET SERVEROUTPUT ON
Execute buscar_nombre(v_emp_id => 100);



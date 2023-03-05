
/* 3.1 Construya un bloque PL/SQL donde declare dos variables num�ricas, una caracter, una l�gica y una tipo fecha, y as�gnele
valores durante la declaraci�n. Restrinja la variable caracter para que no permita valores nulos y una de las variables
num�ricas def�nela como constante. Muestre por pantalla los valores asignados*/

SET SERVEROUTPUT ON
DECLARE
c_num1 CONSTANT NUMBER := 25;
v_num2 NUMBER := 40;
v_caracter VARCHAR2(30) NOT NULL := 'BASE DE DATOS';
v_logica BOOLEAN := TRUE;
v_fecha DATE := SYSDATE;
BEGIN

IF v_logica = TRUE THEN
DBMS_OUTPUT.PUT_LINE('VALOR DE LA VARIABLE LOGICA: TRUE' ||CHR(10) ||
                     'VALOR DE LA CONSTANTE NUMERICA: ' || c_num1 || CHR(10) ||
                     'VALOR DE LA VARIABLE NUMERICA: ' || v_num2 || CHR(10)||                                      
                     'VALOR DE LA VARIABLE CARACTER: ' || v_caracter || CHR(10)|| 
                     'VALOR DE La VARIABLE TIPO FECHA: ' || v_fecha || CHR(10));
END IF;
END;
/

------------------------------------------------------------------------------------------------------------------------------------------

/* 3.2 Modifique el c�digo del ejercicio 1 y as�gnele un valor diferente a la 
variable num�rica que fue declarada como constante en el cuerpo del bloque. 
Si da error la ejecuci�n del c�digo, indique el por qu�. */ 

SET SERVEROUTPUT ON
DECLARE
c_num1 CONSTANT NUMBER := 25;
v_num2 NUMBER := 40;
v_caracter VARCHAR2(30) NOT NULL := 'BASE DE DATOS';
v_logica BOOLEAN := TRUE;
v_fecha DATE := SYSDATE;

BEGIN
c_num1 := 30;
IF v_logica = TRUE THEN
DBMS_OUTPUT.PUT_LINE('VALOR DE LA VARIABLE LOGICA: TRUE' ||CHR(10) ||
                     'VALOR DE LA CONSTANTE NUMERICA: ' || c_num1 || CHR(10) ||
                     'VALOR DE LA VARIABLE NUMERICA: ' || v_num2 || CHR(10)||                                      
                     'VALOR DE LA VARIABLE CARACTER: ' || v_caracter || CHR(10)|| 
                     'VALOR DE La VARIABLE TIPO FECHA: ' || v_fecha || CHR(10));
END IF;
END;
/

----------------------------------------------------------------------------------------------------------------------------------------------------------------------

/* 3.3 Construya un bloque PL/SQL donde se busque el nombre y apellido del empleado 100. Declare la variable del apellido
usando %TYPE a partir de la columna de la tabla y la variable del nombre usando %TYPE a partir de la variable del apellido.
Muestre en pantalla el contenido de las variables. */


DECLARE
 v_nombre EMPLOYEES.FIRST_NAME%TYPE;
 v_apellido EMPLOYEES.LAST_NAME%TYPE;

BEGIN

 SELECT FIRST_NAME, LAST_NAME INTO v_nombre, v_apellido
 FROM EMPLOYEES
 WHERE EMPLOYEE_ID = 100;

 DBMS_OUTPUT.PUT_LINE('NOMBRE: ' || v_nombre || CHR(10) || 'APELLIDO: ' || v_apellido );

END;
/

----------------------------------------------------------------------------------------------------------------------------------------------------------------------

/* 3.4 Construya un bloque PL/SQL busque el nombre y apellido 
del empleado 100 y guarde los valores en variables de enlace.
Muestre el contenido de las variables usando el comando PRINT. */

 SET SERVEROUTPUT ON
 VARIABLE b_nombre VARCHAR2(50);
 VARIABLE b_apellido VARCHAR2(50);
 
BEGIN

 SELECT FIRST_NAME, LAST_NAME INTO : b_nombre, : b_apellido
 FROM EMPLOYEES
 WHERE EMPLOYEE_ID = 100;

END;
PRINT b_nombre;
PRINT b_apellido;


----------------------------------------------------------------------------------------------------------------------------------------------------------------------

/* 3.5 Construya un bloque PL/SQL donde se pida el ID del empleado 
204 usando una variable de substituci�n en la secci�n declarativa. 
Guarde los valores del nombre, apellido y salario en variables 
de enlace. Permita que se impriman autom�ticamente sin usar el 
comando PRINT. Fuera del bloque de c�digo construya una instrucci�n
SELECT para listar todos los empleados que tengan el mismo salario 
del empleado 204; use la variable de enlace */

SET SERVEROUTPUT ON
VARIABLE b_nombre VARCHAR(50);
VARIABLE b_apellido VARCHAR(50);
VARIABLE b_salario NUMBER;

SET AUTOPRINT ON 

DECLARE

 v_num NUMBER;

BEGIN

 SELECT FIRST_NAME, LAST_NAME, SALARY 
 INTO :b_nombre, :b_apellido, :b_salario
 FROM EMPLOYEES
 WHERE EMPLOYEE_ID = &v_num;

END;
/

-- Empleados con el mismo salario

SELECT FIRST_NAME, LAST_NAME, SALARY
FROM EMPLOYEES
WHERE SALARY = :b_salario;

----------------------------------------------------------------------------------------------------------------------------------------------------------------------















/* 4.1 Escriba un bloque de c�digo PL/SQL que lea el nombre y apellido del empleado 204. Los valores deben ser guardados en
dos variables declaradas con %TYPE basadas en las columnas de la tabla. Halle la longitud del nombre y del apellido y
tambi�n la diferencia de ambas longitudes. Guarde los valores en variables separadas. Use la funci�n DECODE como una
instrucci�n de PL/SQL para evaluar el resultado de la diferencia de las longitudes del nombre y del apellido. Si el resultado es
0, guardar en una variable el valor "Igual longitud', de lo contrario guarde el valor "Diferente longitud". Muestre en pantalla
la longitud del nombre, apellido, la diferencia de las longitudes y el resultado devuelto por el DECODE. Como se pide usar la
funci�n DECODE como una instrucci�n de PL/SQL y no como una instrucci�n SQL, producir� un error, explique el por qu�. */

SET SERVEROUTPUT ON
DECLARE
 v_log_nombre Number;
 v_log_apellido Number;
 v_ope_diferencia Number;
 v_igualdad VARCHAR2(20) := 'Igual longitud';
 v_diferente VARCHAR2(20) := 'Diferente longitud';
 v_resultado VARCHAR2(20);
 v_nombre EMPLOYEES.FIRST_NAME%TYPE;
 v_apellido EMPLOYEES.LAST_NAME%TYPE;
 f_decode VARCHAR2(20);

BEGIN
 SELECT FIRST_NAME, LAST_NAME 
 INTO v_nombre, v_apellido
 FROM EMPLOYEES
 WHERE EMPLOYEE_ID = 204;
 
 v_log_nombre := LENGTH(v_nombre);
 v_log_apellido := LENGTH(v_apellido);
 v_ope_diferencia := (v_log_nombre - v_log_apellido);
 
 DBMS_OUTPUT.PUT_LINE(
 'LA VARIABLE NOMBRE ES DE LONGITUD: '|| v_log_nombre || CHR(10)|| 
 'LA VARIABLE APELLIDO ES DE LONGITUD: ' || v_log_apellido);
 DBMS_OUTPUT.PUT_LINE('LA DIFERENCIA ENTRE AMBAS ES: ' || v_ope_diferencia);
 
 f_decode := DECODE (v_ope_diferencia, 0, v_igualdad , v_diferente);
 
 DBMS_OUTPUT.PUT_LINE('RESULTADO DEL DECODE: ' || f_decode);

END;


----------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*4.2 Reescriba el c�digo del ejercicio 4.1 para que pueda producir alg�n resultado.*/

SET SERVEROUTPUT ON
DECLARE
 v_log_nombre Number;
 v_log_apellido Number;
 v_ope_diferencia Number;
 v_igualdad VARCHAR2(20) := 'Igual longitud';
 v_diferente VARCHAR2(20) := 'Diferente longitud';
 v_resultado VARCHAR2(20);
 v_nombre EMPLOYEES.FIRST_NAME%TYPE;
 v_apellido EMPLOYEES.LAST_NAME%TYPE;

BEGIN
 SELECT FIRST_NAME, LAST_NAME 
 INTO v_nombre, v_apellido
 FROM EMPLOYEES
 WHERE EMPLOYEE_ID = 204;
 
 v_log_nombre := LENGTH(v_nombre);
 v_log_apellido := LENGTH(v_apellido);
 v_ope_diferencia := (v_log_nombre - v_log_apellido);
 
 DBMS_OUTPUT.PUT_LINE(
 'LA VARIABLE NOMBRE ES DE LONGITUD: '|| v_log_nombre || CHR(10)|| 
 'LA VARIABLE APELLIDO ES DE LONGITUD: ' || v_log_apellido);
 DBMS_OUTPUT.PUT_LINE('LA DIFERENCIA ENTRE AMBAS ES: ' || v_ope_diferencia || CHR(10));
 
 SELECT DECODE (v_ope_diferencia, 0, v_igualdad , v_diferente) INTO v_resultado FROM dual;
DBMS_OUTPUT.PUT_LINE('RESULTADO DEL DECODE: ' || v_resultado);

END;


----------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*  4.3 Construya un c�digo PL/SQL que busque la fecha m�nima y m�xima de los empleados. Busque los meses que hay entre
ambas fechas. Use la  funci�n MONTHS_BETWEEN y almacene su resultado en una variable. El resultado debe expresarse en
valores enteros. Muestre por pantalla el resultado.  */

DECLARE
v_month NUMBER;
v_min DATE;
v_max DATE;


BEGIN

SELECT MIN(hire_date), MAX(hire_date)
INTO v_min,v_max
FROM EMPLOYEES;

v_month := ROUND(MONTHS_BETWEEN(v_max,v_min));
DBMS_OUTPUT.PUT_LINE('ENTRE LAS FECHAS ESTABLECIDAS HAY ' || v_month || ' MESES DE DIFERENCIA');

END;


----------------------------------------------------------------------------------------------------------------------------------------------------------------------

/* 4.4 Construya un c�digo de PL/SQL donde use una secuencia y asigne el valor directamente a una variable, tal como lo
permite Oracle 11g. Muestre el valor de la variable por pantalla. */

DECLARE

 v_numero NUMBER;
 
BEGIN

   v_numero := COD_SEQ.NEXTVAL;
  
   DBMS_OUTPUT.PUT_LINE ('VALOR DE LA VARIABLE v_numero: ' || v_numero);

END;



----------------------------------------------------------------------------------------------------------------------------------------------------------------------

/* 4.5 Construya un bloque PL/SQL que contenga bloques anidados y as� pueda practicar el alcance y visibilidad de las
variables. En el bloque principal busque el apellido y la fecha de ingreso del empleado 204 y en el bloque interno busque el
apellido y la fecha de ingreso de su supervisor. En el bloque interno y externo muestre el apellido y la fecha de ingreso de
ambos empleados. Explique el resultado que produce el c�digo. Si da alg�n error indique c�mo pudiera evitarlo. */


DECLARE
 v_apellido_emp VARCHAR2(30);
 v_fecha_ingreso_emp DATE;
 
BEGIN
 SELECT LAST_NAME, HIRE_DATE
 INTO v_apellido_emp, v_fecha_ingreso_emp
 FROM EMPLOYEES
 WHERE EMPLOYEE_ID = 204;
                                            
  
 DECLARE
  v_apellido_man VARCHAR2(30);
 v_fecha_ingreso_man DATE;
 
 BEGIN
 SELECT LAST_NAME, HIRE_DATE 
 INTO v_apellido_man, v_fecha_ingreso_man
 FROM EMPLOYEES
 WHERE EMPLOYEE_ID IN (SELECT MANAGER_ID
                       FROM EMPLOYEES
                       WHERE EMPLOYEE_ID = 204);
                       
 DBMS_OUTPUT.PUT_LINE('BLOKE INTERNO:' || CHR(10));                      
 DBMS_OUTPUT.PUT_LINE('APELLIDO DEL EMPLEADO: ' || v_apellido_emp ||  ' | ' || 'FECHA DE INGRESO DEL EMPLEADO: ' || v_fecha_ingreso_emp);                              
 DBMS_OUTPUT.PUT_LINE('APELLIDO DEL SUPERVISOR: ' || v_apellido_man || ' | ' || 'FECHA DE INGRESO DEL SUPERVISOR: ' || v_fecha_ingreso_man || CHR(10));
 
 END;
 
  DBMS_OUTPUT.PUT_LINE('BLOKE EXTERNO:' || CHR(10));
  DBMS_OUTPUT.PUT_LINE('APELLIDO DEL EMPLEADO: ' || v_apellido_emp ||  ' | ' || 'FECHA DE INGRESO DEL EMPLEADO: ' || v_fecha_ingreso_emp);
  DBMS_OUTPUT.PUT_LINE('APELLIDO DEL SUPERVISOR: ' || v_apellido_man || ' | ' || 'FECHA DE INGRESO DEL SUPERVISOR: ' || v_fecha_ingreso_man);
END;

----------------------------------------------------------------------------------------------------------------------------------------------------------------------

/* 4.6 Reconstruya el c�digo del ejercicio 4.5 y guarde los valores de las consultas externas e internas en variables con el mismo
nombre. Use las etiquetas para imprimir los valores correspondientes a cada bloque */


       <<EMPLEADO>>
       
DECLARE
 v_apellido VARCHAR2(30);
 v_fecha_ingreso DATE;
 
BEGIN
 SELECT LAST_NAME, HIRE_DATE
 INTO v_apellido, v_fecha_ingreso
 FROM EMPLOYEES
 WHERE EMPLOYEE_ID = 204;
                             
      <<SUPERVISOR>>
      
  DECLARE
   v_apellido VARCHAR2(30);
   v_fecha_ingreso DATE;
 
  BEGIN
   SELECT LAST_NAME, HIRE_DATE 
   INTO v_apellido, v_fecha_ingreso
   FROM EMPLOYEES
   WHERE EMPLOYEE_ID IN (SELECT MANAGER_ID
                         FROM EMPLOYEES
                         WHERE EMPLOYEE_ID = 204);
                         
   DBMS_OUTPUT.PUT_LINE('BLOKE INTERNO:' || CHR(10));   
   DBMS_OUTPUT.PUT_LINE('APELLIDO DEL SUPERVISOR: ' || SUPERVISOR.v_apellido || ' | ' || 'FECHA DE INGRESO DEL SUPERVISOR: ' || SUPERVISOR.v_fecha_ingreso);
   DBMS_OUTPUT.PUT_LINE('APELLIDO DEL EMPLEADO: ' || EMPLEADO.v_apellido ||  ' | ' || 'FECHA DE INGRESO DEL EMPLEADO: ' || EMPLEADO.v_fecha_ingreso || CHR(10));
 
  END SUPERVISOR;
      
 DBMS_OUTPUT.PUT_LINE('BLOKE EXTERNO:' || CHR(10));       
 DBMS_OUTPUT.PUT_LINE('APELLIDO DEL EMPLEADO: ' || EMPLEADO.v_apellido ||  ' | ' || 'FECHA DE INGRESO DEL EMPLEADO: ' || EMPLEADO.v_fecha_ingreso);
 --DBMS_OUTPUT.PUT_LINE('APELLIDO DEL SUPERVISOR: ' || SUPERVISOR.v_apellido || ' | ' || 'FECHA DE INGRESO DEL SUPERVISOR: ' || SUPERVISOR.v_fecha_ingreso);       
 
END EMPLEADO;


-------------------------------------------

SET SERVEROUTPUT ON
BEGIN <<outer>>
DECLARE
   v_sal      NUMBER(7,2) := 30000;
   v_comm     NUMBER(7,2) := v_sal * 0.15;
   v_message  VARCHAR2(255) := ' eligible for commission';
BEGIN
   DECLARE
         v_sal           NUMBER(7,2) := 45000;
         v_comm          NUMBER(7,2) := 0;
         v_total_comp  NUMBER(7,2) := v_sal + v_comm;
   BEGIN
         v_message := 'CLERK not'||v_message; -- Posici�n 1
         outer.v_comm := v_sal * 0.20;
                  DBMS_OUTPUT.PUT_LINE('v_message: ' || v_message);
                  DBMS_OUTPUT.PUT_LINE('v_total_comp: ' || v_total_comp);
                  DBMS_OUTPUT.PUT_LINE('v_comm: ' || v_comm); --(Vale cero)
                  DBMS_OUTPUT.PUT_LINE('outer.v_comm: ' || outer.v_comm); -- Vale (9,000)
   END;
   v_message := 'SALESMAN'||v_message; -- Posici�n 2
   DBMS_OUTPUT.PUT_LINE('v_message posicion 2: ' || v_message);
   --DBMS_OUTPUT.PUT_LINE(v_total_comp); --(No declarado)
   DBMS_OUTPUT.PUT_LINE('v_comm posicion 2: ' || v_comm); -- Vale (9,000)
    DBMS_OUTPUT.PUT_LINE('v_total_comm: ' || v_total_comm);
END;
END outer;
/

---------------------------------------------
















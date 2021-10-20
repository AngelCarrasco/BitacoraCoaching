--------------------------------------------------------
--  DDL for Procedure SP_ACTUALIZAR_COACH
--------------------------------------------------------
set define off;

  CREATE OR REPLACE NONEDITIONABLE PROCEDURE "SP_ACTUALIZAR_COACH" (
V_RUT_COACH IN COACH.RUN_COACH%TYPE,
V_NOMBRE_COACH IN COACH.NOMBRE%TYPE,
V_APATERNO_COACH IN COACH.APELLIDO_P%TYPE,
V_AMATERNO_COACH IN COACH.APELLIDO_M%TYPE,
V_TELEFONO_COACH IN COACH.TELEFONO%TYPE,
V_CORREO_COACH IN COACH.CORREO%TYPE,
V_CONTRASENA_COACH IN COACH.CONTRASENA%TYPE,
V_CONTRATO_COACH IN COACH.CONTRATO%TYPE
)
IS
BEGIN
UPDATE COACH SET NOMBRE = V_NOMBRE_COACH, 
                APELLIDO_P = V_APATERNO_COACH, 
                APELLIDO_M = V_AMATERNO_COACH, 
                TELEFONO = V_TELEFONO_COACH, 
                CORREO = V_CORREO_COACH, 
                CONTRASENA = V_CONTRASENA_COACH, 
                CONTRATO = V_CONTRATO_COACH

WHERE RUN_COACH = V_RUT_COACH;
COMMIT;
EXCEPTION
  WHEN NO_DATA_FOUND THEN 
  RAISE_APPLICATION_ERROR(SEQ_ERROR.NEXTVAL,' Error de dato no encontrado'); 
  WHEN OTHERS THEN 
  RAISE_APPLICATION_ERROR(SEQ_ERROR.NEXTVAL,' Error desconocido');
END;

/
--------------------------------------------------------
--  DDL for Procedure SP_AGREGAR_COACH
--------------------------------------------------------
set define off;

  CREATE OR REPLACE NONEDITIONABLE PROCEDURE "SP_AGREGAR_COACH" (
V_RUT_COACH COACH.RUN_COACH%TYPE,
V_NOMBRE_COACH COACH.NOMBRE%TYPE,
V_APATERNO_COACH COACH.APELLIDO_P%TYPE,
V_AMATERNO_COACH COACH.APELLIDO_M%TYPE,
V_TELEFONO_COACH COACH.TELEFONO%TYPE,
V_CORREO_COACH COACH.CORREO%TYPE,
V_CONTRASENA_COACH COACH.CONTRASENA%TYPE,
V_CONTRATO_COACH COACH.CONTRATO%TYPE,v_salida out number)
IS
BEGIN
INSERT INTO COACH (RUN_COACH,NOMBRE,APELLIDO_P,APELLIDO_M,TELEFONO,CORREO,CONTRASENA,CONTRATO)

VALUES (V_RUT_COACH,V_NOMBRE_COACH,V_APATERNO_COACH,V_AMATERNO_COACH,V_TELEFONO_COACH,V_CORREO_COACH,V_CONTRASENA_COACH,V_CONTRATO_COACH);
COMMIT;
v_salida:=1;
EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN
  RAISE_APPLICATION_ERROR(SEQ_ERROR.NEXTVAL,' Error de dato duplicado');
  WHEN OTHERS THEN 
  v_salida:=0;
  RAISE_APPLICATION_ERROR(SEQ_ERROR.NEXTVAL,' Error desconocido');
END;

/
--------------------------------------------------------
--  DDL for Procedure SP_AGREGAR_COACHEE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE NONEDITIONABLE PROCEDURE "SP_AGREGAR_COACHEE" (V_RUN IN COACHEE.RUN_COACHEE%TYPE, V_APELLIDO_M IN COACHEE.APELLIDO_M%TYPE, V_NOMBRE IN COACHEE.NOMBRE%TYPE, 
V_CARGO IN COACHEE.CARGO%TYPE, V_APELLIDO_P IN COACHEE.APELLIDO_P%TYPE, V_CORREO IN COACHEE.CORREO%TYPE, V_RUT_EMPRESA IN COACHEE.RUT_EMPRESA%TYPE,
V_CONTRASENA IN COACHEE.CONTRASENA%TYPE, V_CONTRATO IN COACHEE.CONTRATO%TYPE, v_salida out number) IS

BEGIN
INSERT INTO COACHEE VALUES (V_RUN, V_APELLIDO_M, V_NOMBRE, V_CARGO, V_APELLIDO_P, V_CORREO, V_RUT_EMPRESA, V_CONTRASENA,V_CONTRATO );
COMMIT;
v_salida:=1;
EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN
  RAISE_APPLICATION_ERROR(SEQ_ERROR.NEXTVAL,' Error de dato duplicado');
  WHEN OTHERS THEN 
  v_salida:=0;
  RAISE_APPLICATION_ERROR(SEQ_ERROR.NEXTVAL,' Error desconocido');
END;

/
--------------------------------------------------------
--  DDL for Procedure SP_AGREGAR_EMPRESA
--------------------------------------------------------
set define off;

  CREATE OR REPLACE NONEDITIONABLE PROCEDURE "SP_AGREGAR_EMPRESA" (v_run in EMPRESA.RUT_EMPRESA%TYPE, v_direccion in empresa.direccion%TYPE, v_telefono in empresa.telefono%type,
v_nombre empresa.nombre%type,v_correo in  empresa.correo%type,v_contrato in empresa.contrato%type,v_salida out number) AS
BEGIN
INSERT INTO EMPRESA VALUES (v_run,v_direccion,v_telefono,v_nombre,v_correo,v_contrato);
COMMIT;
v_salida:=1;
EXCEPTION
  WHEN NO_DATA_FOUND THEN 
  RAISE_APPLICATION_ERROR(SEQ_ERROR.NEXTVAL,' Error de dato no encontrado'); 
  WHEN DUP_VAL_ON_INDEX THEN
  RAISE_APPLICATION_ERROR(SEQ_ERROR.NEXTVAL,' Error de dato duplicado');
  WHEN OTHERS THEN 
  RAISE_APPLICATION_ERROR(SEQ_ERROR.NEXTVAL,' Error desconocido');
  v_salida:=0;
END;

/
--------------------------------------------------------
--  DDL for Procedure SP_ELIMINAR_COACH
--------------------------------------------------------
set define off;

  CREATE OR REPLACE NONEDITIONABLE PROCEDURE "SP_ELIMINAR_COACH" (V_RUN_COACH IN coach.run_coach%TYPE) IS
BEGIN
UPDATE COACH SET CONTRATO = 0
WHERE run_coach = V_RUN_COACH;
COMMIT;
EXCEPTION
  WHEN NO_DATA_FOUND THEN 
  RAISE_APPLICATION_ERROR(SEQ_ERROR.NEXTVAL,' Error de dato no encontrado'); 
  WHEN OTHERS THEN 
  RAISE_APPLICATION_ERROR(SEQ_ERROR.NEXTVAL,' Error desconocido');
END;

/
--------------------------------------------------------
--  DDL for Procedure SP_ELIMINAR_COACHEE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE NONEDITIONABLE PROCEDURE "SP_ELIMINAR_COACHEE" (V_RUN_COACHEE IN coachee.run_coachee%TYPE) IS
BEGIN
UPDATE COACHEE SET CONTRATO = 0
WHERE run_coachee = V_RUN_COACHEE;
COMMIT;
EXCEPTION
  WHEN NO_DATA_FOUND THEN 
  RAISE_APPLICATION_ERROR(SEQ_ERROR.NEXTVAL,' Error de dato no encontrado'); 
  WHEN OTHERS THEN 
  RAISE_APPLICATION_ERROR(SEQ_ERROR.NEXTVAL,' Error desconocido');
END;

/
--------------------------------------------------------
--  DDL for Procedure SP_ELIMINAR_EMPRESA
--------------------------------------------------------
set define off;

  CREATE OR REPLACE NONEDITIONABLE PROCEDURE "SP_ELIMINAR_EMPRESA" (V_RUT_EMPRESA IN empresa.rut_empresa%TYPE) IS
BEGIN
UPDATE EMPRESA SET CONTRATO = 0
WHERE rut_empresa = V_RUT_EMPRESA;
COMMIT;
EXCEPTION
  WHEN NO_DATA_FOUND THEN 
  RAISE_APPLICATION_ERROR(SEQ_ERROR.NEXTVAL,' Error de dato no encontrado'); 
  WHEN OTHERS THEN 
  RAISE_APPLICATION_ERROR(SEQ_ERROR.NEXTVAL,' Error desconocido');
END;

/
--------------------------------------------------------
--  DDL for Procedure SP_LISTA_COACH
--------------------------------------------------------
set define off;

  CREATE OR REPLACE NONEDITIONABLE PROCEDURE "SP_LISTA_COACH" (REG OUT SYS_REFCURSOR)
AS
BEGIN
OPEN REG FOR 
SELECT RUN_COACH, NOMBRE|| ' ' ||APELLIDO_P ||' '||APELLIDO_M AS NOMBRE,TELEFONO,CORREO FROM COACH
WHERE CONTRATO = 1;
END;

/
--------------------------------------------------------
--  DDL for Procedure SP_LISTA_COACHEE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE NONEDITIONABLE PROCEDURE "SP_LISTA_COACHEE" (REG OUT SYS_REFCURSOR)
AS
BEGIN
OPEN REG FOR 
SELECT c.run_coachee as run_coachee, c.nombre|| ' ' ||c.apellido_p ||' '||c.apellido_m as Nombre,c.cargo,
c.correo,e.nombre as empresa
from COACHEE c join empresa e
on (c.rut_empresa = e.rut_empresa)
where c.contrato = 1;
END;

/
--------------------------------------------------------
--  DDL for Procedure SP_LISTA_EMPRESA
--------------------------------------------------------
set define off;

  CREATE OR REPLACE NONEDITIONABLE PROCEDURE "SP_LISTA_EMPRESA" (REG OUT SYS_REFCURSOR)
AS
BEGIN
OPEN REG FOR 
SELECT RUT_EMPRESA,NOMBRE,DIRECCION,TELEFONO,CORREO FROM EMPRESA
WHERE CONTRATO = 1;
END;

/
--------------------------------------------------------
--  DDL for Procedure SP_MODIFICAR_COACHEE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE NONEDITIONABLE PROCEDURE "SP_MODIFICAR_COACHEE" (V_RUN IN COACHEE.RUN_COACHEE%TYPE, V_APELLIDO_M IN COACHEE.APELLIDO_M%TYPE, V_NOMBRE IN COACHEE.NOMBRE%TYPE, 
V_CARGO IN COACHEE.CARGO%TYPE, V_APELLIDO_P IN COACHEE.APELLIDO_P%TYPE, V_CORREO IN COACHEE.CORREO%TYPE, V_RUT_EMPRESA IN COACHEE.RUT_EMPRESA%TYPE, 
V_CONTRATO IN COACHEE.CONTRATO%TYPE) IS
 
BEGIN
UPDATE COACHEE SET APELLIDO_M = V_APELLIDO_M, NOMBRE = V_NOMBRE, CARGO = V_CARGO, APELLIDO_P = V_APELLIDO_P, CORREO = V_CORREO,RUT_EMPRESA = V_RUT_EMPRESA,CONTRATO = V_CONTRATO
WHERE run_coachee = v_run;
COMMIT;
EXCEPTION
  WHEN NO_DATA_FOUND THEN 
  RAISE_APPLICATION_ERROR(SEQ_ERROR.NEXTVAL,' Error de dato no encontrado'); 
  WHEN OTHERS THEN 
  RAISE_APPLICATION_ERROR(SEQ_ERROR.NEXTVAL,' Error desconocido');
END;

/
--------------------------------------------------------
--  DDL for Procedure SP_MODIFICAR_EMPRESA
--------------------------------------------------------
set define off;

  CREATE OR REPLACE NONEDITIONABLE PROCEDURE "SP_MODIFICAR_EMPRESA" (v_run in EMPRESA.RUT_EMPRESA%TYPE,v_direccion in empresa.direccion%TYPE, v_telefono in empresa.telefono%type,
v_nombre empresa.nombre%type,v_correo in  empresa.correo%type,v_contrato in empresa.contrato%type) IS
 
BEGIN
UPDATE EMPRESA SET DIRECCION = v_direccion, TELEFONO = v_telefono, NOMBRE = v_nombre, CORREO = V_CORREO,CONTRATO = V_CONTRATO
WHERE RUT_EMPRESA = v_run;
COMMIT;
EXCEPTION
  WHEN NO_DATA_FOUND THEN 
  RAISE_APPLICATION_ERROR(SEQ_ERROR.NEXTVAL,' Error de dato no encontrado'); 
  WHEN OTHERS THEN 
  RAISE_APPLICATION_ERROR(SEQ_ERROR.NEXTVAL,' Error desconocido');
END;

/
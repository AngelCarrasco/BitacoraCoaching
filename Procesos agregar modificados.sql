CREATE OR REPLACE PROCEDURE "SP_AGREGAR_COACH" (
V_RUN_COACH COACH.RUN_COACH%TYPE,
V_NOMBRE COACH.NOMBRE%TYPE,
V_APATERNO COACH.APELLIDO_P%TYPE,
V_AMATERNO COACH.APELLIDO_M%TYPE,
V_TELEFONO COACH.TELEFONO%TYPE,
V_CORREO COACH.CORREO%TYPE,
V_CONTRASENA COACH.CONTRASENA%TYPE,
V_CONTRATO COACH.CONTRATO%TYPE)


IS
BEGIN
DECLARE V_RUN COACH.RUN_COACH%TYPE;
BEGIN
    SELECT RUN_COACH
    INTO V_RUN
    FROM COACH;

    IF V_RUN = V_RUN_COACH THEN
        UPDATE COACH SET 
            NOMBRE = V_NOMBRE, 
            APELLIDO_P = V_APATERNO, 
            APELLIDO_M = V_AMATERNO, 
            TELEFONO = V_TELEFONO, 
            CORREO = V_CORREO, 
            CONTRASENA = V_CONTRASENA, 
            CONTRATO = V_CONTRATO
        WHERE RUN_COACH = V_RUN_COACH;
    ELSE
        INSERT INTO COACH(
            RUN_COACH,
            NOMBRE,
            APELLIDO_P,
            APELLIDO_M,
            TELEFONO,
            CORREO,
            CONTRASENA,
            CONTRATO)
            
        VALUES(
            V_RUN_COACH,
            V_NOMBRE,
            V_APATERNO,
            V_AMATERNO,
            V_TELEFONO,
            V_CORREO,
            V_CONTRASENA,
            V_CONTRATO);
        INSERT INTO AUTH_USER VALUES(
            1,
            V_CONTRASENA,
            null,
            0,
            V_RUN_COACH,
            V_NOMBRE,
            V_APATERNO,
            V_CORREO,
            0,
            1,
            SYSDATE);
    END IF;
COMMIT;
END;
EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN
  RAISE_APPLICATION_ERROR(SEQ_ERROR.NEXTVAL,' Error de dato duplicado');
  WHEN OTHERS THEN 
  RAISE_APPLICATION_ERROR(SEQ_ERROR.NEXTVAL,' Error desconocido');
END;

/
----------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE "SP_AGREGAR_COACHEE" (
V_RUN_COACHEE IN COACHEE.RUN_COACHEE%TYPE,
V_APELLIDO_M IN COACHEE.APELLIDO_M%TYPE, 
V_NOMBRE IN COACHEE.NOMBRE%TYPE, 
V_CARGO IN COACHEE.CARGO%TYPE,
V_APELLIDO_P IN COACHEE.APELLIDO_P%TYPE,
V_CORREO IN COACHEE.CORREO%TYPE,
V_RUT_EMPRESA IN COACHEE.RUT_EMPRESA%TYPE,
V_CONTRASENA IN COACHEE.CONTRASENA%TYPE,
V_CONTRATO IN COACHEE.CONTRATO%TYPE,
V_RUT_EMPRESA_C IN COACHEE.RUT_EMPRESA%TYPE,
V_ID_SESION_C IN COACHEE.ID_SESION%TYPE) 

IS
BEGIN
DECLARE V_RUN_C COACHEE.RUN_COACHEE%TYPE;
BEGIN
    SELECT RUN_COACHEE
    INTO V_RUN_C
    FROM COACHEE;
    
    IF V_RUN_C = V_RUN_COACHEE THEN
        UPDATE COACHEE SET 
            APELLIDO_M = V_APELLIDO_M,
            NOMBRE = V_NOMBRE,
            CARGO = V_CARGO,
            APELLIDO_P = V_APELLIDO_P,
            CORREO = V_CORREO,
            CONTRASENA = V_CONTRASENA,
            CONTRATO = V_CONTRATO,
            RUT_EMPRESA = V_RUT_EMPRESA_C,
            ID_SESION = V_ID_SESION_C
        WHERE RUN_COACHEE = V_RUN_COACHEE;
    ELSE
        INSERT INTO COACHEE VALUES (
            V_RUN_COACHEE, 
            V_APELLIDO_M, 
            V_NOMBRE, V_CARGO, 
            V_APELLIDO_P, 
            V_CORREO, 
            V_CONTRASENA,
            V_CONTRATO,
            V_RUT_EMPRESA_C,
            V_ID_SESION_C);
        
        INSERT INTO AUTH_USER VALUES(
            2,
            V_CONTRASENA,
            null,
            0,
            V_RUN_COACHEE,
            V_NOMBRE,
            V_APELLIDO_P,
            V_CORREO,
            0,
            1,
            SYSDATE);
    END IF;
COMMIT;
END;
EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN
  RAISE_APPLICATION_ERROR(SEQ_ERROR.NEXTVAL,' Error de dato duplicado');
  WHEN OTHERS THEN
  RAISE_APPLICATION_ERROR(SEQ_ERROR.NEXTVAL,' Error desconocido');
END;

/

----------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE SP_AGREGAR_PROCESO (
V_ID_PROCESO IN PROCESO.ID_PROCESO%TYPE,
V_NOMBRE_PROCESO IN PROCESO.NOMBRE%TYPE, 
V_MODALIDAD IN PROCESO.MODALIDAD%TYPE, 
V_STATUS IN PROCESO.STATUS%TYPE,
V_FECHA IN proceso.fecha_contrato%TYPE,
v_CLAUSULA IN proceso.clausula%TYPE,
V_RUT_COACH IN PROCESO.RUN_COACH%TYPE,
V_RUT_EMPRESA IN proceso.rut_empresa%TYPE) 

IS
BEGIN
DECLARE V_ID_P PROCESO.ID_PROCESO%TYPE;
BEGIN
    SELECT ID_PROCESO
    INTO V_ID_P
    FROM PROCESO;
    
    IF V_ID_P = V_ID_PROCESO THEN
        UPDATE PROCESO SET 
            NOMBRE = V_NOMBRE_PROCESO, 
            MODALIDAD = V_MODALIDAD, 
            STATUS = V_STATUS, 
            FECHA_CONTRATO = V_FECHA, 
            CLAUSULA = V_CLAUSULA, 
            RUN_COACH = V_RUT_COACH, 
            RUT_EMPRESA = V_RUT_EMPRESA
        WHERE ID_PROCESO = V_ID_PROCESO;
    ELSE
        INSERT INTO PROCESO (
            ID_PROCESO, 
            NOMBRE, 
            MODALIDAD, 
            STATUS,
            FECHA_CONTRATO,
            CLAUSULA, 
            RUN_COACH,
            RUT_EMPRESA) 
        VALUES (
            PROCESO_ID_PROCESO_SEQ.NEXTVAL, 
            V_NOMBRE_PROCESO, 
            V_MODALIDAD, 
            V_STATUS, 
            V_FECHA, 
            V_CLAUSULA, 
            V_RUT_COACH, 
            V_RUT_EMPRESA);
    END IF;
COMMIT;
END;
EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN
  RAISE_APPLICATION_ERROR(SEQ_ERROR.NEXTVAL,' Error de dato duplicado');
  WHEN OTHERS THEN 
  RAISE_APPLICATION_ERROR(SEQ_ERROR.NEXTVAL,' Error desconocido');

END;

/
----------------------------------------------------------------------------------------------------------------
create or replace NONEDITIONABLE PROCEDURE "SP_AGREGAR_EMPRESA" (
v_rut in EMPRESA.RUT_EMPRESA%TYPE,
v_direccion in empresa.direccion%TYPE,
v_telefono in empresa.telefono%type,
v_nombre empresa.nombre%type,
v_correo in  empresa.correo%type,
v_contrato in empresa.contrato%type,
v_nombre_jefe in empresa.nombre_jefe%type,
v_correo_jefe in empresa.correo_jefe%type,
v_telefono_jefe in empresa.telefono_jefe%type,
v_salida out number) AS

BEGIN
INSERT INTO EMPRESA VALUES (v_rut,v_direccion,v_telefono,v_nombre,v_correo,v_contrato,v_nombre_jefe,v_correo_jefe,v_telefono_jefe);
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
---------------------------------------------------------------------------------------------------------------
create or replace procedure SP_AGREGAR_SESION(
v_fecha_acor in sesion.fecha_acordada%type,
v_fecha_rea in sesion.fecha_realizada%type,
v_descripcion in sesion.descripcion%type,
v_estado in sesion.estado%type,
v_asig_acuer in sesion.asignacion_acuerdos%type,
v_id_proceso in sesion.id_proceso%type,
v_run_coach in sesion.run_coach%type,
v_salida out number)

is
begin

insert into sesion(id_sesion,fecha_acordada,fecha_realizada,descripcion,estado,asignacion_acuerdos,id_proceso,run_coach)
values (SESION_ID_SESION_SEQ.NEXTVAL,v_fecha_acor,v_fecha_rea,v_descripcion,v_estado,v_asig_acuer,v_id_proceso,v_run_coach);
commit;
v_salida := 1;

exception
WHEN DUP_VAL_ON_INDEX THEN
  RAISE_APPLICATION_ERROR(SEQ_ERROR.NEXTVAL,' Error de dato duplicado');
  WHEN OTHERS THEN 
  v_salida:=0;
  RAISE_APPLICATION_ERROR(SEQ_ERROR.NEXTVAL,' Error desconocido');

end;

/
---------------------------------------------------------------------------------------------------------------
create or replace NONEDITIONABLE PROCEDURE "SP_LISTA_COACH" (REG OUT SYS_REFCURSOR)
AS
BEGIN
OPEN REG FOR 
SELECT RUN_COACH, NOMBRE,APELLIDO_P,APELLIDO_M ,TELEFONO,CORREO FROM COACH
WHERE CONTRATO = 1;
END;

/
---------------------------------------------------------------------------------------------------------------
create or replace NONEDITIONABLE PROCEDURE "SP_LISTA_COACHEE" (REG OUT SYS_REFCURSOR)
AS
BEGIN
OPEN REG FOR 
SELECT c.run_coachee as run_coachee, c.nombre|| ' ' ||c.apellido_p ||' '||c.apellido_m as Nombre,
c.correo,e.nombre as empresa
from COACHEE c join empresa e
on (c.rut_empresa = e.rut_empresa)
where c.contrato = 1;
END;

/
----------------------------------------------------------------------------------------------------------------
create or replace NONEDITIONABLE PROCEDURE "SP_LISTA_EMPRESA" (REG OUT SYS_REFCURSOR)
AS
BEGIN
OPEN REG FOR 
SELECT RUT_EMPRESA,NOMBRE,CORREO,NOMBRE_JEFE,TELEFONO_JEFE FROM EMPRESA
WHERE CONTRATO = 1;
END;

/
----------------------------------------------------------------------------------------------------------------
create or replace PROCEDURE SP_LISTA_PROCESO (REG OUT SYS_REFCURSOR)
AS
BEGIN
OPEN REG FOR 
SELECT 
P.NOMBRE NOMBRE, 
P.MODALIDAD MODALIDAD, 
C. NOMBRE|| ' ' ||C.APELLIDO_P ||' '||C.APELLIDO_M AS NOMBRE_COACH,
e.nombre EMPRESA
FROM PROCESO P 
JOIN COACH C ON (P.RUN_COACH = C.RUN_COACH)
JOIN EMPRESA e ON (p.rut_empresa = e.rut_empresa)
WHERE C.CONTRATO = 1;
END;

/
--------------------------------------------------------
-- Archivo creado  - martes-noviembre-30-2021   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure SP_ADD_USER
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "C##PY_COACHING"."SP_ADD_USER" (
    v_contrasena coach.contrasena%TYPE,
    v_run        coach.run_coach%TYPE,
    v_nombre     coach.nombre%TYPE,
    v_apaterno   coach.apellido_p%TYPE,
    v_correo     coach.correo%TYPE
) IS
BEGIN
    DECLARE
        CURSOR c_auth IS
        SELECT
            username
        FROM
            auth_user;

        v_user       auth_user.username%TYPE;
        confirmacion NUMBER;
    BEGIN
        confirmacion := 0;
        FOR i IN c_auth LOOP
    --PROBANO ESTO
            v_user := i.username;
            IF v_user = v_run THEN
                UPDATE auth_user
                SET
                    username = v_run,
                    first_name = v_nombre,
                    last_name = v_apaterno,
                    email = v_correo
                WHERE
                    username = v_run;

                confirmacion := 1;
            END IF;

            IF confirmacion != 1 THEN
                INSERT INTO auth_user VALUES (
                    seq_id_auth_user.NEXTVAL,
                    v_contrasena,
                    NULL,
                    0,
                    v_run,
                    v_nombre,
                    v_apaterno,
                    v_correo,
                    0,
                    1,
                    sysdate
                );

            END IF;

        END LOOP;

    END;
END;

/
--------------------------------------------------------
--  DDL for Procedure SP_AGREGAR_ARCHIVO
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "C##PY_COACHING"."SP_AGREGAR_ARCHIVO" 
(
V_ARCHIVO IN documentacion.archivo%TYPE,
v_sesion NUMBER,
v_salida out number) IS

BEGIN
INSERT INTO documentacion(id_doc,ARCHIVO, FECHA_SUBIDA, FECHA_VISTA, id_sesion)
VALUES (DOCUMENTACION_ID_DOC_SEQ.nextval,V_ARCHIVO,sysdate,null, v_sesion);
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
--  DDL for Procedure SP_AGREGAR_COACH
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "C##PY_COACHING"."SP_AGREGAR_COACH" (
V_RUN_COACH COACH.RUN_COACH%TYPE,
V_NOMBRE COACH.NOMBRE%TYPE,
V_APATERNO COACH.APELLIDO_P%TYPE,
V_AMATERNO COACH.APELLIDO_M%TYPE,
V_TELEFONO COACH.TELEFONO%TYPE,
V_CORREO COACH.CORREO%TYPE,
V_CONTRASENA COACH.CONTRASENA%TYPE,
V_CONTRATO COACH.CONTRATO%TYPE,
v_salida out number)


IS
BEGIN
DECLARE 
    CURSOR c_coach IS
        SELECT RUN_COACH
        FROM COACH;

    v_run COACH.RUN_COACH%TYPE;

    confirmacion NUMBER;
BEGIN
confirmacion:=0;
for c in c_coach loop
v_run:=c.run_coach;
    IF v_run = V_RUN_COACH THEN
        UPDATE COACH SET 
            NOMBRE = V_NOMBRE, 
            APELLIDO_P = V_APATERNO, 
            APELLIDO_M = V_AMATERNO, 
            TELEFONO = V_TELEFONO, 
            CORREO = V_CORREO, 
            CONTRASENA = V_CONTRASENA, 
            CONTRATO = V_CONTRATO
        WHERE RUN_COACH = V_RUN_COACH;
        UPDATE CORE_USER SET
            FIRST_NAME = V_NOMBRE,
            LAST_NAME = V_APATERNO,
            EMAIL = V_CORREO
        WHERE USERNAME = V_RUN;
        confirmacion:=1;
    end if;

    end loop;
    if confirmacion !=1 then
        INSERT INTO COACH
        VALUES(
            V_RUN_COACH,
            V_NOMBRE,
            V_APATERNO,
            V_AMATERNO,
            V_TELEFONO,
            V_CORREO,
            V_CONTRASENA,
            V_CONTRATO);

        INSERT INTO CORE_USER 
        VALUES(SEQ_ID_AUTH_USER.nextval,V_CONTRASENA,null,0,V_RUN_COACH,V_NOMBRE,V_APATERNO,V_CORREO,0,1,SYSDATE,0,1,0);
    end if;
COMMIT;
END;
v_salida := 1;
EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN
  RAISE_APPLICATION_ERROR(SEQ_ERROR.NEXTVAL,' Error de dato duplicado');
  WHEN OTHERS THEN 
  v_salida := 0;
  RAISE_APPLICATION_ERROR(SEQ_ERROR.NEXTVAL,' Error desconocido');
END;

/
--------------------------------------------------------
--  DDL for Procedure SP_AGREGAR_COACHEE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "C##PY_COACHING"."SP_AGREGAR_COACHEE" (
V_RUN IN COACHEE.RUN_COACHEE%TYPE,
V_APELLIDO_M IN COACHEE.APELLIDO_M%TYPE, 
V_NOMBRE IN COACHEE.NOMBRE%TYPE, 
V_CARGO IN COACHEE.CARGO%TYPE,
V_APELLIDO_P IN COACHEE.APELLIDO_P%TYPE,
V_CORREO IN COACHEE.CORREO%TYPE,
V_RUT_EMPRESA IN COACHEE.RUT_EMPRESA%TYPE,
V_CONTRASENA IN COACHEE.CONTRASENA%TYPE,
V_CONTRATO IN COACHEE.CONTRATO%TYPE,
v_salida out number) IS

BEGIN

    DECLARE
        CURSOR c_coachee IS
         SELECT RUN_COACHEE
         FROM COACHEE;

        v_run_coachee COACHEE.RUN_COACHEE%TYPE;

    confirmacion NUMBER;
    BEGIN
        confirmacion:=0;
        for c in c_coachee loop
            v_run_coachee:=c.run_coachee;
            IF v_run_coachee = V_RUN THEN
                UPDATE COACHEE SET 
                    NOMBRE = V_NOMBRE, 
                    APELLIDO_P = V_APELLIDO_P, 
                    APELLIDO_M = V_APELLIDO_M,  
                    CORREO = V_CORREO,
                    CARGO = V_CARGO,
                    RUT_EMPRESA = V_RUT_EMPRESA
                WHERE RUN_COACHEE = V_RUN;
                UPDATE CORE_USER SET
                    FIRST_NAME = V_NOMBRE,
                    LAST_NAME = V_APELLIDO_P,
                    EMAIL = V_CORREO
                WHERE USERNAME = V_RUN;
                confirmacion:=1;
            end if;
        end loop;

        if confirmacion !=1 then
            INSERT INTO COACHEE 
            VALUES (V_RUN, V_APELLIDO_M, V_NOMBRE, V_CARGO, V_APELLIDO_P, V_CORREO, V_CONTRASENA,V_CONTRATO,V_RUT_EMPRESA);

            INSERT INTO CORE_USER 
            VALUES(SEQ_ID_AUTH_USER.nextval,V_CONTRASENA,null,0,V_RUN,V_NOMBRE,V_APELLIDO_P,V_CORREO,0,1,SYSDATE,0,0,1);

        end if;
    COMMIT;
    END;
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

  CREATE OR REPLACE EDITIONABLE PROCEDURE "C##PY_COACHING"."SP_AGREGAR_EMPRESA" (
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
--------------------------------------------------------
--  DDL for Procedure SP_AGREGAR_ENCUESTA
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "C##PY_COACHING"."SP_AGREGAR_ENCUESTA" (
v_pregunta IN encuesta.pregunta%TYPE,
v_salida OUT NUMBER)
IS
BEGIN 
INSERT INTO encuesta 
VALUES(ID_PREGUNTA_SEQ.nextval, v_pregunta);
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
--  DDL for Procedure SP_AGREGAR_EVALUACION
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "C##PY_COACHING"."SP_AGREGAR_EVALUACION" (V_FECHA VARCHAR, V_COMENTARIO VARCHAR, V_ID_PROCESO NUMBER, V_RUN_COACH VARCHAR, v_salida OUT NUMBER) 
IS
BEGIN

INSERT INTO EVALUACION VALUES (ID_ENCUESTA_SQ.NEXTVAL,V_FECHA,V_COMENTARIO,V_ID_PROCESO,V_RUN_COACH);
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
--  DDL for Procedure SP_AGREGAR_NOTAS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "C##PY_COACHING"."SP_AGREGAR_NOTAS" (
V_NOTA VARCHAR, 
ID_PREGUNTA NUMBER, 
ID_ENCUESTA NUMBER,
v_salida OUT NUMBER) 
IS
BEGIN

INSERT INTO resultado VALUES (ID_RESULTADO_SEQ.NEXTVAL,V_NOTA,ID_PREGUNTA,ID_ENCUESTA);
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
--  DDL for Procedure SP_AGREGAR_PROCESO
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "C##PY_COACHING"."SP_AGREGAR_PROCESO" (
 
V_NOMBRE_PROCESO IN PROCESO.NOMBRE%TYPE, 
V_MODALIDAD IN PROCESO.MODALIDAD%TYPE, 
V_STATUS IN PROCESO.STATUS%TYPE,
V_FECHA IN proceso.fecha_contrato%TYPE,
v_CLAUSULA IN proceso.clausula%TYPE,
v_INDICADOR IN proceso.indicador_exito%TYPE,
v_OBJETIVO IN proceso.objetivo%TYPE,
V_RUT_COACH IN PROCESO.RUN_COACH%TYPE,
V_RUT_EMPRESA IN proceso.rut_empresa%TYPE,
v_RUN_COACHEE IN proceso.run_coachee%TYPE,
v_salida OUT NUMBER) 


IS
BEGIN

INSERT INTO PROCESO
VALUES (PROCESO_ID_PROCESO_SEQ.NEXTVAL, V_NOMBRE_PROCESO, V_MODALIDAD, V_STATUS, V_FECHA, V_CLAUSULA,v_INDICADOR,
v_OBJETIVO,V_RUT_COACH, V_RUT_EMPRESA,v_RUN_COACHEE);
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
--  DDL for Procedure SP_AGREGAR_SESION
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "C##PY_COACHING"."SP_AGREGAR_SESION" (

v_fecha_acor in sesion.fecha_acordada%type,
v_fecha_rea in sesion.fecha_realizada%type,
v_descripcion in sesion.descripcion%type,
v_estado in sesion.estado%type,
v_asig_acuer in sesion.asignacion_acuerdos%type,
v_id_proceso in sesion.id_proceso%type,
v_run_coach in sesion.run_coach%type,
v_salida out number

)

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
--------------------------------------------------------
--  DDL for Procedure SP_COACHEE_EMPRESA
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "C##PY_COACHING"."SP_COACHEE_EMPRESA" (REG OUT SYS_REFCURSOR,
v_EMPRESA IN proceso.rut_empresa%type
)
IS

BEGIN

    OPEN REG FOR
        SELECT run_coachee, nombre||' '||apellido_p||' '||apellido_m AS NOMBRE FROM coachee
        WHERE rut_empresa = v_EMPRESA;

END;



/
--------------------------------------------------------
--  DDL for Procedure SP_DESHABILITAR_COACH
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "C##PY_COACHING"."SP_DESHABILITAR_COACH" (
    v_run    coach.run_coach%TYPE,
    v_salida OUT NUMBER
) IS
BEGIN
    DECLARE
        CURSOR c_coach_des IS
        SELECT
            run_coach
        FROM
            coach;

        v_run_d      coach.run_coach%TYPE;
        confirmacion NUMBER;
    BEGIN
        confirmacion := 0;
        FOR c IN c_coach_des LOOP
            v_run_d := c.run_coach;
            IF v_run_d = v_run THEN
                UPDATE coach
                SET
                    contrato = 0
                WHERE
                    run_coach = v_run;

                confirmacion := 1;
            END IF;

        END LOOP;

        COMMIT;
    END;

    v_salida := 1;
EXCEPTION
    WHEN dup_val_on_index THEN
        raise_application_error(seq_error.nextval, ' Error de dato duplicado');
    WHEN OTHERS THEN
        v_salida := 0;
        raise_application_error(seq_error.nextval, ' Error desconocido');
END;



/
--------------------------------------------------------
--  DDL for Procedure SP_DESHABILITAR_COACHEE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "C##PY_COACHING"."SP_DESHABILITAR_COACHEE" (
    v_run    coachee.run_coachee%TYPE,
    v_salida OUT NUMBER
) IS
BEGIN
    DECLARE
        CURSOR c_coachee_des IS
        SELECT
            run_coachee
        FROM
            coachee;

        v_run_d      coachee.run_coachee%TYPE;
        confirmacion NUMBER;
    BEGIN
        confirmacion := 0;
        FOR c IN c_coachee_des LOOP
            v_run_d := c.run_coachee;
            IF v_run_d = v_run THEN
                UPDATE coachee
                SET
                    contrato = 0
                WHERE
                    run_coachee = v_run;

                confirmacion := 1;
            END IF;

        END LOOP;

        COMMIT;
    END;

    v_salida := 1;
EXCEPTION
    WHEN dup_val_on_index THEN
        raise_application_error(seq_error.nextval, ' Error de dato duplicado');
    WHEN OTHERS THEN
        v_salida := 0;
        raise_application_error(seq_error.nextval, ' Error desconocido');
END;



/
--------------------------------------------------------
--  DDL for Procedure SP_DESHABILITAR_PROCESO
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "C##PY_COACHING"."SP_DESHABILITAR_PROCESO" (
v_id proceso.id_proceso%type,
v_salida out number
)
IS

BEGIN
    DECLARE
        CURSOR c_proceso IS
            select id_proceso
            FROM proceso;
        v_proceso proceso.id_proceso%type;
    BEGIN
        FOR c IN c_proceso LOOP
            v_proceso := c.id_proceso;

            IF v_proceso = v_id THEN
                UPDATE PROCESO SET
                    STATUS = 0
                WHERE id_proceso = v_id;
                v_salida := 1;

            END IF;
        END LOOP;
        COMMIT;
        v_salida :=0;

    END;

END;



/
--------------------------------------------------------
--  DDL for Procedure SP_DESHABILITAR_SESION
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "C##PY_COACHING"."SP_DESHABILITAR_SESION" (
    v_sesion    coach.run_coach%TYPE,
    v_salida OUT NUMBER
) IS
BEGIN
    DECLARE
        CURSOR c_sesion_des IS
        SELECT
            id_sesion
        FROM sesion;

        v_sesion_d coach.run_coach%TYPE;
        confirmacion NUMBER;
    BEGIN
        confirmacion := 0;
        FOR c IN c_sesion_des LOOP
            v_sesion_d := c.id_sesion;
            IF v_sesion_d = v_sesion THEN
                UPDATE sesion
                SET
                    estado = 0
                WHERE
                    id_sesion = v_sesion;

                confirmacion := 1;
            END IF;

        END LOOP;

        COMMIT;
    END;

    v_salida := 1;
EXCEPTION
    WHEN dup_val_on_index THEN
        raise_application_error(seq_error.nextval, ' Error de dato duplicado');
    WHEN OTHERS THEN
        v_salida := 0;
        raise_application_error(seq_error.nextval, ' Error desconocido');
END;

/
--------------------------------------------------------
--  DDL for Procedure SP_DETALLE_COACHEE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "C##PY_COACHING"."SP_DETALLE_COACHEE" (REG OUT SYS_REFCURSOR,
v_run coachee.run_coachee%type
)
IS

BEGIN
    OPEN REG FOR 
    SELECT p.id_proceso,p.nombre AS NOMBRE_PROCESO,co.nombre||' '||co.apellido_p||' '||co.apellido_m AS COACH
    FROM proceso p JOIN empresa e ON(p.RUT_EMPRESA = e.RUT_EMPRESA)
    JOIN coachee c ON(c.RUT_EMPRESA = e.RUT_EMPRESA)
    JOIN coach co ON(co.RUN_COACH = p.RUN_COACH)
    WHERE c.run_coachee = v_run AND p.status !=0;
END;

/
--------------------------------------------------------
--  DDL for Procedure SP_DETALLE_PROCESO
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "C##PY_COACHING"."SP_DETALLE_PROCESO" (REG OUT SYS_REFCURSOR,
v_proceso proceso.id_proceso%type
)

AS
BEGIN
    OPEN REG FOR 
    SELECT p.nombre AS PROCESO,p.modalidad, 
           c.nombre||' '||c.apellido_p||' '||c.apellido_m AS COACH,
           e.nombre_jefe AS JEFE_COACHEE,e.telefono_jefe,e.correo_jefe,
           e.nombre AS EMPRESA,
           p.run_coachee ,
           cee.nombre ||' '||cee.apellido_p ||' '||cee.apellido_m AS COACHEE,
           p.OBJETIVO,
           p.INDICADOR_EXITO
    FROM proceso p JOIN coach c ON(p.run_coach = c.run_coach)
    JOIN empresa e ON(p.rut_empresa = e.rut_empresa)
    JOIN coachee cee ON(p.RUN_COACHEE = cee.RUN_COACHEE)
    WHERE p.status = 1 AND p.id_proceso = v_proceso;
END;



/
--------------------------------------------------------
--  DDL for Procedure SP_DETALLE_PROCESO_COACH
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "C##PY_COACHING"."SP_DETALLE_PROCESO_COACH" (REG OUT SYS_REFCURSOR,
v_proceso proceso.id_proceso%type,
v_run_coach coach.run_coach%type)
AS
BEGIN
    OPEN REG FOR 
    SELECT p.nombre AS PROCESO,p.modalidad,
           e.nombre_jefe AS JEFE_COACHEE,e.telefono_jefe,e.correo_jefe,
           e.nombre AS EMPRESA,
           p.run_coachee,
           cee.nombre||' '||cee.apellido_p||' '||cee.apellido_m AS COACHEE,
           COUNT(se.id_proceso) AS NRO_SESIONES
    FROM proceso p JOIN coach c ON(p.run_coach = c.run_coach)
    JOIN empresa e ON(p.rut_empresa = e.rut_empresa)
    JOIN coachee cee ON (p.RUN_COACHEE = cee.RUN_COACHEE)
    JOIN sesion se ON (p.ID_PROCESO = se.ID_PROCESO)
    WHERE p.status = 1 AND c.run_coach = v_run_coach  and  p.id_proceso = v_proceso
    GROUP BY p.nombre, p.modalidad, e.nombre_jefe, e.telefono_jefe, e.correo_jefe, 
          e.nombre, p.run_coachee, cee.nombre||' '||cee.apellido_p||' '||cee.apellido_m;

END;

/
--------------------------------------------------------
--  DDL for Procedure SP_DETALLE_PROCESO_COACHEE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "C##PY_COACHING"."SP_DETALLE_PROCESO_COACHEE" (REG OUT SYS_REFCURSOR,
v_run coachee.run_coachee%type,
v_proceso proceso.id_proceso%type
)
IS

BEGIN
OPEN REG FOR 

SELECT p.nombre,p.modalidad,p.run_coachee, c.nombre||' '||c.apellido_p||' '||c.apellido_m AS COACHEE,
       e.nombre EMPRESA,COUNT(s.id_proceso) NRO_SESIONES 
FROM proceso p JOIN coachee c ON (p.run_coachee = c.run_coachee)
JOIN empresa e ON(e.rut_empresa = p.rut_empresa)
JOIN sesion s ON(s.id_proceso = p.id_proceso) 
WHERE p.id_proceso = v_proceso AND p.run_coachee = v_run AND p.status !=0
group by p.nombre, p.modalidad, p.run_coachee, c.nombre||' '||c.apellido_p||' '||c.apellido_m, e.nombre;
END;

/
--------------------------------------------------------
--  DDL for Procedure SP_FILTRO_DOCUMENTO
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "C##PY_COACHING"."SP_FILTRO_DOCUMENTO" (reg OUT SYS_REFCURSOR, v_id_sesion number, v_rut_coachee varchar2)
AS 
BEGIN 
OPEN REG FOR 
SELECT  d.id_sesion, d.id_doc, d.archivo, c.run_coachee FROM  documentacion d
join sesion s on (s.id_sesion = d.id_sesion)
join proceso p on (p.id_proceso = s.id_proceso)
join coachee c on (c.run_coachee = p.run_coachee)
WHERE s.id_sesion = v_id_sesion and c.run_coachee = v_rut_coachee;

exception
    WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR(SEQ_ERROR.NEXTVAL,' Datos no encontrados');
    
END;

/
--------------------------------------------------------
--  DDL for Procedure SP_FILTRO_EMPRESA
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "C##PY_COACHING"."SP_FILTRO_EMPRESA" (REG OUT SYS_REFCURSOR, v_run VARCHAR2)
AS
BEGIN
OPEN REG FOR 
SELECT e.RUT_EMPRESA,e.NOMBRE,e.DIRECCION,e.TELEFONO,e.CORREO FROM EMPRESA e
JOIN proceso p ON (p.rut_empresa = e.rut_empresa)
WHERE e.CONTRATO = 1 AND p.run_coach = v_run AND p.status != 0
group by e.RUT_EMPRESA,e.NOMBRE,e.DIRECCION,e.TELEFONO,e.CORREO
order by e.nombre asc;
END;



/
--------------------------------------------------------
--  DDL for Procedure SP_FILTRO_PROCESOS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "C##PY_COACHING"."SP_FILTRO_PROCESOS" (REG OUT SYS_REFCURSOR, v_run VARCHAR2)
AS
BEGIN
OPEN REG FOR 
SELECT id_proceso,nombre, fecha_contrato, clausula FROM proceso 
WHERE run_coach = v_run AND status !=0;
END;

/
--------------------------------------------------------
--  DDL for Procedure SP_FILTRO_SESION
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "C##PY_COACHING"."SP_FILTRO_SESION" (reg OUT SYS_REFCURSOR, v_proceso NUMBER)
AS 
BEGIN 
OPEN REG FOR 
SELECT  '  Sesion: ' || ROW_NUMBER() OVER (ORDER BY id_sesion) || ',  Fecha: ' || TO_CHAR(fecha_acordada,'DD/MM/YYYY'), id_sesion 
FROM  sesion 
WHERE id_proceso = v_proceso;
END;

/
--------------------------------------------------------
--  DDL for Procedure SP_LISTA_COACH
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "C##PY_COACHING"."SP_LISTA_COACH" (REG OUT SYS_REFCURSOR)
AS

BEGIN
OPEN REG FOR 
SELECT RUN_COACH, NOMBRE,APELLIDO_P,APELLIDO_M ,TELEFONO,CORREO FROM COACH
WHERE CONTRATO = 1;
END;



/
--------------------------------------------------------
--  DDL for Procedure SP_LISTA_COACHEE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "C##PY_COACHING"."SP_LISTA_COACHEE" (REG OUT SYS_REFCURSOR)
AS

BEGIN
OPEN REG FOR 
SELECT c.run_coachee as run_coachee, c.nombre,c.apellido_p,c.apellido_m,
c.correo,c.cargo,e.nombre as empresa
from COACHEE c join empresa e
on (c.rut_empresa = e.rut_empresa)
where c.contrato = 1;
END;



/
--------------------------------------------------------
--  DDL for Procedure SP_LISTA_COACHEE_DOCUMENTO
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "C##PY_COACHING"."SP_LISTA_COACHEE_DOCUMENTO" (reg OUT SYS_REFCURSOR, v_rut_coachee varchar2)
AS 
BEGIN 
OPEN REG FOR
SELECT  '  Sesion: ' || ROW_NUMBER() OVER (ORDER BY s.id_sesion) || ',  Fecha: ' || TO_CHAR(s.fecha_acordada,'DD/MM/YYYY'), s.id_sesion FROM sesion s
join proceso p on (p.id_proceso = s.id_proceso)
WHERE p.run_coachee = v_rut_coachee and p.status != 0;
END;


/
--------------------------------------------------------
--  DDL for Procedure SP_LISTA_EMPRESA
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "C##PY_COACHING"."SP_LISTA_EMPRESA" (REG OUT SYS_REFCURSOR)
AS

BEGIN
OPEN REG FOR 
SELECT RUT_EMPRESA,NOMBRE,CORREO,NOMBRE_JEFE,TELEFONO_JEFE FROM EMPRESA
WHERE CONTRATO = 1;
END;



/
--------------------------------------------------------
--  DDL for Procedure SP_LISTA_ENCUESTA
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "C##PY_COACHING"."SP_LISTA_ENCUESTA" (REG OUT SYS_REFCURSOR)
AS
BEGIN
OPEN REG FOR 
SELECT * FROM encuesta;
END;

/
--------------------------------------------------------
--  DDL for Procedure SP_LISTA_PROCESO
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "C##PY_COACHING"."SP_LISTA_PROCESO" (REG OUT SYS_REFCURSOR)
AS

BEGIN
OPEN REG FOR 
SELECT 
P.ID_PROCESO,
P.NOMBRE NOMBRE, 
P.MODALIDAD MODALIDAD, 
C. NOMBRE|| ' ' ||C.APELLIDO_P ||' '||C.APELLIDO_M AS NOMBRE_COACH,
e.nombre EMPRESA
FROM PROCESO P 
JOIN COACH C ON (P.RUN_COACH = C.RUN_COACH)
JOIN EMPRESA e ON (p.rut_empresa = e.rut_empresa)
WHERE p.status = 1;
END;



/
--------------------------------------------------------
--  DDL for Procedure SP_LISTA_PROCESO_FILT
--------------------------------------------------------
set define off;

  CREATE OR REPLACE NONEDITIONABLE PROCEDURE "C##PY_COACHING"."SP_LISTA_PROCESO_FILT" (REG OUT SYS_REFCURSOR, v_rut varchar2,v_run_coach varchar2)
AS
BEGIN
OPEN REG FOR 
SELECT * FROM proceso Where rut_empresa = v_rut and  run_coach = v_run_coach;
END;

/
--------------------------------------------------------
--  DDL for Procedure SP_LISTA_SESION
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "C##PY_COACHING"."SP_LISTA_SESION" (REG OUT SYS_REFCURSOR, v_rut VARCHAR2)
AS
BEGIN
OPEN REG FOR 
SELECT * FROM SESION
WHERE RUN_COACH = v_rut;
END;



/
--------------------------------------------------------
--  DDL for Procedure SP_LISTA_SESION_COACHEE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "C##PY_COACHING"."SP_LISTA_SESION_COACHEE" (REG OUT SYS_REFCURSOR, v_rut VARCHAR2)
AS
BEGIN
OPEN REG FOR 
SELECT s.fecha_acordada,s.descripcion FROM SESION s join proceso p
on(p.id_proceso = s.id_proceso)
join empresa e
on(e.rut_empresa = p.rut_empresa)
join coachee c
on(c.rut_empresa = e.rut_empresa)
WHERE c.run_coachee = v_rut;
END;



/
--------------------------------------------------------
--  DDL for Procedure SP_LISTA_SESION_PROCESO_COACH
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "C##PY_COACHING"."SP_LISTA_SESION_PROCESO_COACH" (REG OUT SYS_REFCURSOR,
v_proceso IN sesion.id_proceso%TYPE)
AS
BEGIN
OPEN REG FOR
    SELECT COUNT(id_sesion)AS NRO_SESIONES
    FROM SESION
    WHERE id_proceso = v_proceso AND estado = 0;

END;

/
--------------------------------------------------------
--  DDL for Procedure SP_PROCESO_COACHEE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "C##PY_COACHING"."SP_PROCESO_COACHEE" (REG OUT SYS_REFCURSOR,
v_run coachee.run_coachee%type
)
IS

BEGIN
    OPEN REG FOR 
    SELECT p.id_proceso,p.nombre AS NOMBRE_PROCESO,co.nombre||' '||co.apellido_p||' '||co.apellido_m AS COACH
    FROM proceso p JOIN empresa e ON(p.RUT_EMPRESA = e.RUT_EMPRESA)
    JOIN coachee c ON(c.RUT_EMPRESA = e.RUT_EMPRESA)
    JOIN coach co ON(co.RUN_COACH = p.RUN_COACH)
    WHERE c.run_coachee = v_run AND p.status !=0;
END;

/
--------------------------------------------------------
--  DDL for Procedure SP_RUN_SESION
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "C##PY_COACHING"."SP_RUN_SESION" (reg   OUT SYS_REFCURSOR,v_run VARCHAR2) 
AS 
BEGIN 
OPEN REG FOR  
SELECT  c.nombre  ||  c.apellido_p  ||  c.apellido_m  || '('|| c.run_coachee ||')', p.id_proceso
FROM proceso p
JOIN coachee c ON ( p.run_coachee = c.run_coachee )
JOIN empresa emp ON ( emp.rut_empresa = p.rut_empresa )
WHERE p.run_coach = v_run AND p.status != 0;
end;


/
--------------------------------------------------------
--  DDL for Procedure SP_SESION_PROCESO
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "C##PY_COACHING"."SP_SESION_PROCESO" (REG OUT SYS_REFCURSOR, 
v_rut VARCHAR2, 
v_proceso IN sesion.id_proceso%TYPE)
AS
BEGIN
OPEN REG FOR 
SELECT s.id_sesion, s.descripcion,s.fecha_acordada,p.nombre 
FROM sesion s JOIN proceso p ON(s.id_proceso = p.id_proceso) 
WHERE s.RUN_COACH = v_rut AND s.id_proceso = v_proceso AND s.estado !=0;
END;

/

--------------------------------------------------------
-- Archivo creado  - viernes-octubre-29-2021   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure SP_ADD_USER
--------------------------------------------------------
SET DEFINE OFF;

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
--  DDL for Procedure SP_AGREGAR_COACH
--------------------------------------------------------
SET DEFINE OFF;

CREATE OR REPLACE EDITIONABLE PROCEDURE "C##PY_COACHING"."SP_AGREGAR_COACH" (
    v_run_coach  coach.run_coach%TYPE,
    v_nombre     coach.nombre%TYPE,
    v_apaterno   coach.apellido_p%TYPE,
    v_amaterno   coach.apellido_m%TYPE,
    v_telefono   coach.telefono%TYPE,
    v_correo     coach.correo%TYPE,
    v_contrasena coach.contrasena%TYPE,
    v_contrato   coach.contrato%TYPE,
    v_salida     OUT NUMBER
) IS
BEGIN
    DECLARE
        CURSOR c_coach IS
        SELECT
            run_coach
        FROM
            coach;

        v_run        coach.run_coach%TYPE;
        confirmacion NUMBER;
    BEGIN
        confirmacion := 0;
        FOR c IN c_coach LOOP
            v_run := c.run_coach;
            IF v_run = v_run_coach THEN
                UPDATE coach
                SET
                    nombre = v_nombre,
                    apellido_p = v_apaterno,
                    apellido_m = v_amaterno,
                    telefono = v_telefono,
                    correo = v_correo,
                    contrasena = v_contrasena,
                    contrato = v_contrato
                WHERE
                    run_coach = v_run_coach;

                confirmacion := 1;
            END IF;

        END LOOP;

        IF confirmacion != 1 THEN
            INSERT INTO coach VALUES (
                v_run_coach,
                v_nombre,
                v_apaterno,
                v_amaterno,
                v_telefono,
                v_correo,
                v_contrasena,
                v_contrato
            );

            INSERT INTO auth_user VALUES (
                seq_id_auth_user.NEXTVAL,
                v_contrasena,
                NULL,
                0,
                v_run_coach,
                v_nombre,
                v_apaterno,
                v_correo,
                0,
                1,
                sysdate
            );

        END IF;

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
--  DDL for Procedure SP_AGREGAR_COACHEE
--------------------------------------------------------
SET DEFINE OFF;

CREATE OR REPLACE EDITIONABLE PROCEDURE "C##PY_COACHING"."SP_AGREGAR_COACHEE" (
    v_run         IN coachee.run_coachee%TYPE,
    v_apellido_m  IN coachee.apellido_m%TYPE,
    v_nombre      IN coachee.nombre%TYPE,
    v_cargo       IN coachee.cargo%TYPE,
    v_apellido_p  IN coachee.apellido_p%TYPE,
    v_correo      IN coachee.correo%TYPE,
    v_rut_empresa IN coachee.rut_empresa%TYPE,
    v_contrasena  IN coachee.contrasena%TYPE,
    v_contrato    IN coachee.contrato%TYPE,
    v_salida      OUT NUMBER
) IS
BEGIN
    DECLARE
        CURSOR c_coachee IS
        SELECT
            run_coachee
        FROM
            coachee;

        v_run_coachee coachee.run_coachee%TYPE;
        confirmacion  NUMBER;
    BEGIN
        confirmacion := 0;
        FOR c IN c_coachee LOOP
            v_run_coachee := c.run_coachee;
            IF v_run_coachee = v_run THEN
                UPDATE coachee
                SET
                    nombre = v_nombre,
                    apellido_p = v_apellido_p,
                    apellido_m = v_apellido_m,
                    correo = v_correo,
                    cargo = v_cargo,
                    rut_empresa = v_rut_empresa
                WHERE
                    run_coachee = v_run;

                confirmacion := 1;
            END IF;

        END LOOP;

        IF confirmacion != 1 THEN
            INSERT INTO coachee VALUES (
                v_run,
                v_apellido_m,
                v_nombre,
                v_cargo,
                v_apellido_p,
                v_correo,
                v_contrasena,
                v_contrato,
                v_rut_empresa
            );

            INSERT INTO auth_user VALUES (
                seq_id_auth_user.NEXTVAL,
                v_contrasena,
                NULL,
                0,
                v_run,
                v_nombre,
                v_apellido_p,
                v_correo,
                0,
                1,
                sysdate
            );

        END IF;

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
--  DDL for Procedure SP_AGREGAR_EMPRESA
--------------------------------------------------------
SET DEFINE OFF;

CREATE OR REPLACE EDITIONABLE PROCEDURE "C##PY_COACHING"."SP_AGREGAR_EMPRESA" (
    v_rut           IN empresa.rut_empresa%TYPE,
    v_direccion     IN empresa.direccion%TYPE,
    v_telefono      IN empresa.telefono%TYPE,
    v_nombre        empresa.nombre%TYPE,
    v_correo        IN empresa.correo%TYPE,
    v_contrato      IN empresa.contrato%TYPE,
    v_nombre_jefe   IN empresa.nombre_jefe%TYPE,
    v_correo_jefe   IN empresa.correo_jefe%TYPE,
    v_telefono_jefe IN empresa.telefono_jefe%TYPE,
    v_salida        OUT NUMBER
) AS
BEGIN
    INSERT INTO empresa VALUES (
        v_rut,
        v_direccion,
        v_telefono,
        v_nombre,
        v_correo,
        v_contrato,
        v_nombre_jefe,
        v_correo_jefe,
        v_telefono_jefe
    );

    COMMIT;
    v_salida := 1;
EXCEPTION
    WHEN no_data_found THEN
        raise_application_error(seq_error.nextval, ' Error de dato no encontrado');
    WHEN dup_val_on_index THEN
        raise_application_error(seq_error.nextval, ' Error de dato duplicado');
    WHEN OTHERS THEN
        raise_application_error(seq_error.nextval, ' Error desconocido');
        v_salida := 0;
END;
/
--------------------------------------------------------
--  DDL for Procedure SP_AGREGAR_PROCESO
--------------------------------------------------------
SET DEFINE OFF;

CREATE OR REPLACE EDITIONABLE PROCEDURE "C##PY_COACHING"."SP_AGREGAR_PROCESO" (
    v_nombre_proceso IN proceso.nombre%TYPE,
    v_modalidad      IN proceso.modalidad%TYPE,
    v_status         IN proceso.status%TYPE,
    v_fecha          IN proceso.fecha_contrato%TYPE,
    v_clausula       IN proceso.clausula%TYPE,
    v_rut_coach      IN proceso.run_coach%TYPE,
    v_rut_empresa    IN proceso.rut_empresa%TYPE,
    v_salida         OUT NUMBER
) IS
BEGIN
    INSERT INTO proceso (
        id_proceso,
        nombre,
        modalidad,
        status,
        fecha_contrato,
        clausula,
        run_coach,
        rut_empresa
    ) VALUES (
        proceso_id_proceso_seq.NEXTVAL,
        v_nombre_proceso,
        v_modalidad,
        v_status,
        v_fecha,
        v_clausula,
        v_rut_coach,
        v_rut_empresa
    );

    COMMIT;
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
--  DDL for Procedure SP_AGREGAR_SESION
--------------------------------------------------------
SET DEFINE OFF;

CREATE OR REPLACE EDITIONABLE PROCEDURE "C##PY_COACHING"."SP_AGREGAR_SESION" (
    v_fecha_acor  IN sesion.fecha_acordada%TYPE,
    v_fecha_rea   IN sesion.fecha_realizada%TYPE,
    v_descripcion IN sesion.descripcion%TYPE,
    v_estado      IN sesion.estado%TYPE,
    v_asig_acuer  IN sesion.asignacion_acuerdos%TYPE,
    v_id_proceso  IN sesion.id_proceso%TYPE,
    v_run_coach   IN sesion.run_coach%TYPE,
    v_salida      OUT NUMBER
) IS
BEGIN
    INSERT INTO sesion (
        id_sesion,
        fecha_acordada,
        fecha_realizada,
        descripcion,
        estado,
        asignacion_acuerdos,
        id_proceso,
        run_coach
    ) VALUES (
        sesion_id_sesion_seq.NEXTVAL,
        v_fecha_acor,
        v_fecha_rea,
        v_descripcion,
        v_estado,
        v_asig_acuer,
        v_id_proceso,
        v_run_coach
    );

    COMMIT;
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
--  DDL for Procedure SP_DETALLE_PROCESO
--------------------------------------------------------
SET DEFINE OFF;

CREATE OR REPLACE EDITIONABLE PROCEDURE "C##PY_COACHING"."SP_DETALLE_PROCESO" (
    reg       OUT SYS_REFCURSOR,
    v_proceso proceso.id_proceso%TYPE
) AS
BEGIN
    OPEN reg FOR SELECT
                     p.nombre        AS proceso,
                     p.modalidad,
                     p.fecha_contrato,
                     c.nombre
                     || ' '
                     || c.apellido_p
                     || ' '
                     || c.apellido_m AS coach,
                     e.nombre_jefe   AS jefe_coachee,
                     e.telefono_jefe,
                     e.correo_jefe
                 FROM
                          proceso p
                     JOIN coach   c ON ( p.run_coach = c.run_coach )
                     JOIN empresa e ON ( p.rut_empresa = e.rut_empresa )
                 WHERE
                         p.status = 1
                     AND p.id_proceso = v_proceso;

END;
/
--------------------------------------------------------
--  DDL for Procedure SP_LISTA_COACH
--------------------------------------------------------
SET DEFINE OFF;

CREATE OR REPLACE EDITIONABLE PROCEDURE "C##PY_COACHING"."SP_LISTA_COACH" (
    reg OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN reg FOR SELECT
                     run_coach,
                     nombre,
                     apellido_p,
                     apellido_m,
                     telefono,
                     correo
                 FROM
                     coach
                 WHERE
                     contrato = 1;

END;
/
--------------------------------------------------------
--  DDL for Procedure SP_LISTA_COACHEE
--------------------------------------------------------
SET DEFINE OFF;

CREATE OR REPLACE EDITIONABLE PROCEDURE "C##PY_COACHING"."SP_LISTA_COACHEE" (
    reg OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN reg FOR SELECT
                     c.run_coachee AS run_coachee,
                     c.nombre,
                     c.apellido_p,
                     c.apellido_m,
                     c.correo,
                     c.cargo,
                     e.nombre      AS empresa
                 FROM
                          coachee c
                     JOIN empresa e ON ( c.rut_empresa = e.rut_empresa )
                 WHERE
                     c.contrato = 1;

END;
/
--------------------------------------------------------
--  DDL for Procedure SP_LISTA_EMPRESA
--------------------------------------------------------
SET DEFINE OFF;

CREATE OR REPLACE EDITIONABLE PROCEDURE "C##PY_COACHING"."SP_LISTA_EMPRESA" (
    reg OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN reg FOR SELECT
                     rut_empresa,
                     nombre,
                     correo,
                     nombre_jefe,
                     telefono_jefe
                 FROM
                     empresa
                 WHERE
                     contrato = 1;

END;
/
--------------------------------------------------------
--  DDL for Procedure SP_LISTA_PROCESO
--------------------------------------------------------
SET DEFINE OFF;

CREATE OR REPLACE EDITIONABLE PROCEDURE "C##PY_COACHING"."SP_LISTA_PROCESO" (
    reg OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN reg FOR SELECT
                     p.id_proceso,
                     p.nombre        nombre,
                     p.modalidad     modalidad,
                     c.nombre
                     || ' '
                     || c.apellido_p
                     || ' '
                     || c.apellido_m AS nombre_coach,
                     e.nombre        empresa
                 FROM
                          proceso p
                     JOIN coach   c ON ( p.run_coach = c.run_coach )
                     JOIN empresa e ON ( p.rut_empresa = e.rut_empresa )
                 WHERE
                     p.status = 1;

END;
/
--------------------------------------------------------
--  DDL for Procedure SP_DESHABILITAR_PROCESO
--------------------------------------------------------
SET DEFINE OFF;

CREATE OR REPLACE PROCEDURE "SP_DESHABILITAR_PROCESO" (
    v_proceso proceso.id_proceso%TYPE,
    v_salida  OUT NUMBER
) IS
BEGIN
    DECLARE
        CURSOR c_proceso IS
        SELECT
            id_proceso
        FROM
            proceso;

        v_procesos   proceso.id_proceso%TYPE;
        confirmacion NUMBER;
    BEGIN
        confirmacion := 0;
        FOR c IN c_proceso LOOP
            v_procesos := c.id_proceso;
            IF v_procesos = v_proceso THEN
                UPDATE proceso
                SET
                    status = 0
                WHERE
                    id_proceso = v_proceso;

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
--  DDL for Procedure SP_DESHABILITAR_COACH
--------------------------------------------------------
SET DEFINE OFF;

CREATE OR REPLACE PROCEDURE "SP_DESHABILITAR_COACH" (
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
SET DEFINE OFF;

CREATE OR REPLACE PROCEDURE "SP_DESHABILITAR_COACHEE" (
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
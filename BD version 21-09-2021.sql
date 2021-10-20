-- Generado por Oracle SQL Developer Data Modeler 20.4.1.406.0906
--   en:        2021-09-21 19:36:23 CLST
--   sitio:      Oracle Database 12c
--   tipo:      Oracle Database 12c



DROP TABLE coach CASCADE CONSTRAINTS;

DROP TABLE coachee CASCADE CONSTRAINTS;

DROP TABLE contrato CASCADE CONSTRAINTS;

DROP TABLE documentacion CASCADE CONSTRAINTS;

DROP TABLE empresa CASCADE CONSTRAINTS;

DROP TABLE encuesta CASCADE CONSTRAINTS;

DROP TABLE evaluacion CASCADE CONSTRAINTS;

DROP TABLE indicador CASCADE CONSTRAINTS;

DROP TABLE objetivo CASCADE CONSTRAINTS;

DROP TABLE plan_accion CASCADE CONSTRAINTS;

DROP TABLE proceso CASCADE CONSTRAINTS;

DROP TABLE reunion_avance CASCADE CONSTRAINTS;

DROP TABLE reunion_ini CASCADE CONSTRAINTS;

DROP TABLE sesion CASCADE CONSTRAINTS;

-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

CREATE TABLE coach (
    run_coach   VARCHAR2(13) NOT NULL,
    nombre      VARCHAR2(50) NOT NULL,
    apellido_p  VARCHAR2(50) NOT NULL,
    apellido_m  VARCHAR2(50) NOT NULL,
    telefono    NUMBER(9) NOT NULL,
    correo      VARCHAR2(50) NOT NULL,
    contrasena  VARCHAR2(16) NOT NULL,
    contrato    NUMBER NOT NULL
);

ALTER TABLE coach ADD CONSTRAINT coach_pk PRIMARY KEY ( run_coach );

CREATE TABLE coachee (
    run_coachee  VARCHAR2(13) NOT NULL,
    apellido_m   VARCHAR2(50) NOT NULL,
    nombre       VARCHAR2(50) NOT NULL,
    cargo        VARCHAR2(20) NOT NULL,
    apellido_p   VARCHAR2(50) NOT NULL,
    correo       VARCHAR2(50) NOT NULL,
    rut_empresa  VARCHAR2(13) NOT NULL,
    contrasena   VARCHAR2(16) NOT NULL,
    contrato     NUMBER NOT NULL
);

ALTER TABLE coachee ADD CONSTRAINT coachee_pk PRIMARY KEY ( run_coachee );

CREATE TABLE contrato (
    id_contrato   NUMBER NOT NULL,
    fecha_cantro  DATE NOT NULL,
    clausula      CLOB NOT NULL,
    id_proceso    NUMBER NOT NULL,
    run_coach     VARCHAR2(13) NOT NULL,
    run_coachee   VARCHAR2(13) NOT NULL
);

ALTER TABLE contrato ADD CONSTRAINT contrato_pk PRIMARY KEY ( id_contrato );

CREATE TABLE documentacion (
    archivo       CLOB NOT NULL,
    fecha_subida  DATE NOT NULL,
    run_coachee   VARCHAR2(13) NOT NULL,
    run_coach     VARCHAR2(13) NOT NULL,
    fecha_vista   DATE
);

ALTER TABLE documentacion ADD CONSTRAINT documentacion_pk PRIMARY KEY ( run_coach,
                                                                        run_coachee );

CREATE TABLE empresa (
    rut_empresa  VARCHAR2(13) NOT NULL,
    direccion    VARCHAR2(30) NOT NULL,
    telefono     NUMBER(9) NOT NULL,
    nombre       VARCHAR2(30) NOT NULL,
    correo       VARCHAR2(50) NOT NULL,
    contrato     NUMBER NOT NULL
);

ALTER TABLE empresa ADD CONSTRAINT empresa_pk PRIMARY KEY ( rut_empresa );

CREATE TABLE encuesta (
    id_pregunta  NUMBER NOT NULL,
    pregunta     VARCHAR2(20) NOT NULL,
    nota         FLOAT
);

ALTER TABLE encuesta ADD CONSTRAINT encuesta_pk PRIMARY KEY ( id_pregunta );

CREATE TABLE evaluacion (
    id_encuesta  NUMBER NOT NULL,
    fecha        DATE NOT NULL,
    comentario   VARCHAR2(100),
    promedio     FLOAT,
    id_proceso   NUMBER NOT NULL,
    run_coach    VARCHAR2(13) NOT NULL,
    id_pregunta  NUMBER NOT NULL
);

ALTER TABLE evaluacion
    ADD CONSTRAINT evaluacion_pk PRIMARY KEY ( id_proceso,
                                               run_coach,
                                               id_encuesta );

CREATE TABLE indicador (
    id_incador   NUMBER NOT NULL,
    nombre       VARCHAR2(50) NOT NULL,
    valor_meta   NUMBER NOT NULL,
    descripcion  VARCHAR2(150) NOT NULL,
    id_objetivo  NUMBER NOT NULL
);

ALTER TABLE indicador ADD CONSTRAINT indicador_pk PRIMARY KEY ( id_incador );

CREATE TABLE objetivo (
    id_objetivo  NUMBER NOT NULL,
    nombre       VARCHAR2(150) NOT NULL,
    id_proceso   NUMBER NOT NULL,
    run_coach    VARCHAR2(13) NOT NULL,
    id_reunion   NUMBER NOT NULL
);

ALTER TABLE objetivo ADD CONSTRAINT objetivo_pk PRIMARY KEY ( id_objetivo );

CREATE TABLE plan_accion (
    id_plan      NUMBER NOT NULL,
    fecha        DATE NOT NULL,
    tema         VARCHAR2(50) NOT NULL,
    accion       VARCHAR2(150) NOT NULL,
    id_sesion    NUMBER(4) NOT NULL,
    id_proceso   NUMBER NOT NULL,
    run_coach    VARCHAR2(13) NOT NULL,
    run_coachee  VARCHAR2(13) NOT NULL
);

ALTER TABLE plan_accion ADD CONSTRAINT plan_accion_pk PRIMARY KEY ( id_plan );

CREATE TABLE proceso (
    id_proceso  NUMBER NOT NULL,
    nombre      VARCHAR2(50) NOT NULL,
    modalidad   VARCHAR2(15) NOT NULL,
    status      VARCHAR2(50) NOT NULL,
    run_coach   VARCHAR2(13) NOT NULL
);

ALTER TABLE proceso ADD CONSTRAINT proceso_pk PRIMARY KEY ( id_proceso,
                                                            run_coach );

CREATE TABLE reunion_avance (
    id_avance    NUMBER NOT NULL,
    fecha        DATE NOT NULL,
    observacion  VARCHAR2(250) NOT NULL,
    id_sesion    NUMBER(4) NOT NULL,
    id_proceso   NUMBER NOT NULL,
    run_coach    VARCHAR2(13) NOT NULL,
    run_coachee  VARCHAR2(13) NOT NULL
);

ALTER TABLE reunion_avance ADD CONSTRAINT reunion_avance_pk PRIMARY KEY ( id_avance );

CREATE TABLE reunion_ini (
    id_reunion           NUMBER NOT NULL,
    fecha                DATE NOT NULL,
    antecedente_coachee  CLOB NOT NULL,
    objetivo_proceso     CLOB NOT NULL,
    indicador_exito      CLOB NOT NULL,
    participante         CLOB NOT NULL
);

ALTER TABLE reunion_ini ADD CONSTRAINT reunion_ini_pk PRIMARY KEY ( id_reunion );

CREATE TABLE sesion (
    id_sesion            NUMBER(4) NOT NULL,
    fecha_acordada       DATE NOT NULL,
    fecha_realizada      DATE,
    estado               NUMBER NOT NULL,
    asignacion_acuerdos  CLOB NOT NULL,
    id_proceso           NUMBER NOT NULL,
    run_coach            VARCHAR2(13) NOT NULL,
    run_coachee          VARCHAR2(13) NOT NULL
);

ALTER TABLE sesion
    ADD CONSTRAINT sesion_pk PRIMARY KEY ( id_sesion,
                                           id_proceso,
                                           run_coach,
                                           run_coachee );

ALTER TABLE coachee
    ADD CONSTRAINT coachee_empresa_fk FOREIGN KEY ( rut_empresa )
        REFERENCES empresa ( rut_empresa );

ALTER TABLE contrato
    ADD CONSTRAINT contrato_coachee_fk FOREIGN KEY ( run_coachee )
        REFERENCES coachee ( run_coachee );

ALTER TABLE contrato
    ADD CONSTRAINT contrato_proceso_fk FOREIGN KEY ( id_proceso,
                                                     run_coach )
        REFERENCES proceso ( id_proceso,
                             run_coach );

ALTER TABLE documentacion
    ADD CONSTRAINT documentacion_coach_fk FOREIGN KEY ( run_coach )
        REFERENCES coach ( run_coach );

ALTER TABLE documentacion
    ADD CONSTRAINT documentacion_coachee_fk FOREIGN KEY ( run_coachee )
        REFERENCES coachee ( run_coachee );

ALTER TABLE evaluacion
    ADD CONSTRAINT evaluacion_encuesta_fk FOREIGN KEY ( id_pregunta )
        REFERENCES encuesta ( id_pregunta );

ALTER TABLE evaluacion
    ADD CONSTRAINT evaluacion_proceso_fk FOREIGN KEY ( id_proceso,
                                                       run_coach )
        REFERENCES proceso ( id_proceso,
                             run_coach );

ALTER TABLE indicador
    ADD CONSTRAINT indicador_objetivo_fk FOREIGN KEY ( id_objetivo )
        REFERENCES objetivo ( id_objetivo );

ALTER TABLE objetivo
    ADD CONSTRAINT objetivo_proceso_fk FOREIGN KEY ( id_proceso,
                                                     run_coach )
        REFERENCES proceso ( id_proceso,
                             run_coach );

ALTER TABLE objetivo
    ADD CONSTRAINT objetivo_reunion_ini_fk FOREIGN KEY ( id_reunion )
        REFERENCES reunion_ini ( id_reunion );

ALTER TABLE plan_accion
    ADD CONSTRAINT plan_accion_sesion_fk FOREIGN KEY ( id_sesion,
                                                       id_proceso,
                                                       run_coach,
                                                       run_coachee )
        REFERENCES sesion ( id_sesion,
                            id_proceso,
                            run_coach,
                            run_coachee );

ALTER TABLE proceso
    ADD CONSTRAINT proceso_coach_fk FOREIGN KEY ( run_coach )
        REFERENCES coach ( run_coach );

ALTER TABLE reunion_avance
    ADD CONSTRAINT reunion_avance_sesion_fk FOREIGN KEY ( id_sesion,
                                                          id_proceso,
                                                          run_coach,
                                                          run_coachee )
        REFERENCES sesion ( id_sesion,
                            id_proceso,
                            run_coach,
                            run_coachee );

ALTER TABLE sesion
    ADD CONSTRAINT sesion_coachee_fk FOREIGN KEY ( run_coachee )
        REFERENCES coachee ( run_coachee );

ALTER TABLE sesion
    ADD CONSTRAINT sesion_proceso_fk FOREIGN KEY ( id_proceso,
                                                   run_coach )
        REFERENCES proceso ( id_proceso,
                             run_coach );

CREATE SEQUENCE contrato_id_contrato_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER contrato_id_contrato_trg BEFORE
    INSERT ON contrato
    FOR EACH ROW
    WHEN ( new.id_contrato IS NULL )
BEGIN
    :new.id_contrato := contrato_id_contrato_seq.nextval;
END;
/

CREATE SEQUENCE encuesta_id_pregunta_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER encuesta_id_pregunta_trg BEFORE
    INSERT ON encuesta
    FOR EACH ROW
    WHEN ( new.id_pregunta IS NULL )
BEGIN
    :new.id_pregunta := encuesta_id_pregunta_seq.nextval;
END;
/

CREATE SEQUENCE evaluacion_id_encuesta_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER evaluacion_id_encuesta_trg BEFORE
    INSERT ON evaluacion
    FOR EACH ROW
    WHEN ( new.id_encuesta IS NULL )
BEGIN
    :new.id_encuesta := evaluacion_id_encuesta_seq.nextval;
END;
/

CREATE SEQUENCE indicador_id_incador_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER indicador_id_incador_trg BEFORE
    INSERT ON indicador
    FOR EACH ROW
    WHEN ( new.id_incador IS NULL )
BEGIN
    :new.id_incador := indicador_id_incador_seq.nextval;
END;
/

CREATE SEQUENCE objetivo_id_objetivo_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER objetivo_id_objetivo_trg BEFORE
    INSERT ON objetivo
    FOR EACH ROW
    WHEN ( new.id_objetivo IS NULL )
BEGIN
    :new.id_objetivo := objetivo_id_objetivo_seq.nextval;
END;
/

CREATE SEQUENCE plan_accion_id_plan_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER plan_accion_id_plan_trg BEFORE
    INSERT ON plan_accion
    FOR EACH ROW
    WHEN ( new.id_plan IS NULL )
BEGIN
    :new.id_plan := plan_accion_id_plan_seq.nextval;
END;
/

CREATE SEQUENCE proceso_id_proceso_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER proceso_id_proceso_trg BEFORE
    INSERT ON proceso
    FOR EACH ROW
    WHEN ( new.id_proceso IS NULL )
BEGIN
    :new.id_proceso := proceso_id_proceso_seq.nextval;
END;
/

CREATE SEQUENCE reunion_ini_id_reunion_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER reunion_ini_id_reunion_trg BEFORE
    INSERT ON reunion_ini
    FOR EACH ROW
    WHEN ( new.id_reunion IS NULL )
BEGIN
    :new.id_reunion := reunion_ini_id_reunion_seq.nextval;
END;
/

CREATE SEQUENCE sesion_id_sesion_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER sesion_id_sesion_trg BEFORE
    INSERT ON sesion
    FOR EACH ROW
    WHEN ( new.id_sesion IS NULL )
BEGIN
    :new.id_sesion := sesion_id_sesion_seq.nextval;
END;
/



-- Informe de Resumen de Oracle SQL Developer Data Modeler: 
-- 
-- CREATE TABLE                            14
-- CREATE INDEX                             0
-- ALTER TABLE                             29
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           9
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          9
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- TSDP POLICY                              0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0

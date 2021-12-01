


DROP TABLE coach CASCADE CONSTRAINTS;

DROP TABLE coachee CASCADE CONSTRAINTS;

DROP TABLE documentacion CASCADE CONSTRAINTS;

DROP TABLE empresa CASCADE CONSTRAINTS;

DROP TABLE encuesta CASCADE CONSTRAINTS;

DROP TABLE evaluacion CASCADE CONSTRAINTS;

DROP TABLE plan_accion CASCADE CONSTRAINTS;

DROP TABLE proceso CASCADE CONSTRAINTS;

DROP TABLE resultado CASCADE CONSTRAINTS;

DROP TABLE reunion CASCADE CONSTRAINTS;

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
    contrasena  VARCHAR2(200) NOT NULL,
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
    contrasena   VARCHAR2(200) NOT NULL,
    contrato     NUMBER NOT NULL,
    rut_empresa  VARCHAR2(13) NOT NULL
);

ALTER TABLE coachee ADD CONSTRAINT coachee_pk PRIMARY KEY ( run_coachee );

CREATE TABLE documentacion (
    id_doc        NUMBER NOT NULL,
    archivo       CLOB NOT NULL,
    fecha_subida  DATE NOT NULL,
    fecha_vista   DATE,
    id_sesion     NUMBER(4) NOT NULL
);

ALTER TABLE documentacion ADD CONSTRAINT documentacion_pk PRIMARY KEY ( id_doc );

CREATE TABLE empresa (
    rut_empresa    VARCHAR2(13) NOT NULL,
    direccion      VARCHAR2(30) NOT NULL,
    telefono       NUMBER(9) NOT NULL,
    nombre         VARCHAR2(30) NOT NULL,
    correo         VARCHAR2(50) NOT NULL,
    contrato       NUMBER NOT NULL,
    nombre_jefe    VARCHAR2(50) NOT NULL,
    correo_jefe    VARCHAR2(60) NOT NULL,
    telefono_jefe  NUMBER(9) NOT NULL
);

ALTER TABLE empresa ADD CONSTRAINT empresa_pk PRIMARY KEY ( rut_empresa );

CREATE TABLE encuesta (
    id_pregunta  NUMBER NOT NULL,
    pregunta     VARCHAR2(20) NOT NULL
);

ALTER TABLE encuesta ADD CONSTRAINT encuesta_pk PRIMARY KEY ( id_pregunta );

CREATE TABLE evaluacion (
    id_encuesta  NUMBER NOT NULL,
    fecha        DATE NOT NULL,
    comentario   VARCHAR2(100),
    id_proceso   NUMBER NOT NULL,
    run_coach    VARCHAR2(13) NOT NULL
);

ALTER TABLE evaluacion ADD CONSTRAINT evaluacion_pk PRIMARY KEY ( id_encuesta );

CREATE TABLE plan_accion (
    id_plan     NUMBER NOT NULL,
    fecha       DATE NOT NULL,
    tema        VARCHAR2(50) NOT NULL,
    accion      VARCHAR2(150) NOT NULL,
    id_proceso  NUMBER NOT NULL,
    run_coach   VARCHAR2(13) NOT NULL
);

ALTER TABLE plan_accion ADD CONSTRAINT plan_accion_pk PRIMARY KEY ( id_plan );

CREATE TABLE proceso (
    id_proceso       NUMBER NOT NULL,
    nombre           VARCHAR2(50) NOT NULL,
    modalidad        VARCHAR2(15) NOT NULL,
    status           VARCHAR2(50) NOT NULL,
    fecha_contrato   DATE NOT NULL,
    clausula         CLOB NOT NULL,
    indicador_exito  VARCHAR2(200) NOT NULL,
    objetivo         VARCHAR2(200) NOT NULL,
    run_coach        VARCHAR2(13) NOT NULL,
    rut_empresa      VARCHAR2(13) NOT NULL,
    run_coachee      VARCHAR2(13) NOT NULL
);

ALTER TABLE proceso ADD CONSTRAINT proceso_pk PRIMARY KEY ( id_proceso,
                                                            run_coach );

CREATE TABLE resultado (
    id_resultado  NUMBER NOT NULL,
    nota          FLOAT NOT NULL,
    id_pregunta   NUMBER NOT NULL,
    id_encuesta   NUMBER NOT NULL
);

ALTER TABLE resultado ADD CONSTRAINT resultado_pk PRIMARY KEY ( id_resultado );

CREATE TABLE reunion (
    id_reunion           NUMBER NOT NULL,
    fecha                DATE NOT NULL,
    participante         CLOB NOT NULL,
    tipo_reunion         VARCHAR2(15) NOT NULL,
    observacion          VARCHAR2(200),
    antecedente_coachee  CLOB,
    id_proceso           NUMBER NOT NULL,
    run_coach            VARCHAR2(13) NOT NULL
);

ALTER TABLE reunion ADD CONSTRAINT reunion_pk PRIMARY KEY ( id_reunion );

CREATE TABLE sesion (
    id_sesion            NUMBER(4) NOT NULL,
    fecha_acordada       DATE NOT NULL,
    fecha_realizada      DATE,
    descripcion          VARCHAR2(200) NOT NULL,
    estado               NUMBER NOT NULL,
    asignacion_acuerdos  CLOB NOT NULL,
    id_proceso           NUMBER NOT NULL,
    run_coach            VARCHAR2(13) NOT NULL
);

ALTER TABLE sesion ADD CONSTRAINT sesion_pk PRIMARY KEY ( id_sesion );

ALTER TABLE coachee
    ADD CONSTRAINT coachee_empresa_fk FOREIGN KEY ( rut_empresa )
        REFERENCES empresa ( rut_empresa );

ALTER TABLE documentacion
    ADD CONSTRAINT documentacion_sesion_fk FOREIGN KEY ( id_sesion )
        REFERENCES sesion ( id_sesion );

ALTER TABLE evaluacion
    ADD CONSTRAINT evaluacionv1_proceso_fk FOREIGN KEY ( id_proceso,
                                                         run_coach )
        REFERENCES proceso ( id_proceso,
                             run_coach );

ALTER TABLE plan_accion
    ADD CONSTRAINT plan_accion_proceso_fk FOREIGN KEY ( id_proceso,
                                                        run_coach )
        REFERENCES proceso ( id_proceso,
                             run_coach );

ALTER TABLE proceso
    ADD CONSTRAINT proceso_coach_fk FOREIGN KEY ( run_coach )
        REFERENCES coach ( run_coach );

ALTER TABLE proceso
    ADD CONSTRAINT proceso_coachee_fk FOREIGN KEY ( run_coachee )
        REFERENCES coachee ( run_coachee );

ALTER TABLE proceso
    ADD CONSTRAINT proceso_empresa_fk FOREIGN KEY ( rut_empresa )
        REFERENCES empresa ( rut_empresa );

ALTER TABLE resultado
    ADD CONSTRAINT resultado_encuesta_fk FOREIGN KEY ( id_pregunta )
        REFERENCES encuesta ( id_pregunta );

ALTER TABLE resultado
    ADD CONSTRAINT resultado_evaluacion_fk FOREIGN KEY ( id_encuesta )
        REFERENCES evaluacion ( id_encuesta );

ALTER TABLE reunion
    ADD CONSTRAINT reunion_proceso_fk FOREIGN KEY ( id_proceso,
                                                    run_coach )
        REFERENCES proceso ( id_proceso,
                             run_coach );

ALTER TABLE sesion
    ADD CONSTRAINT sesion_proceso_fk FOREIGN KEY ( id_proceso,
                                                   run_coach )
        REFERENCES proceso ( id_proceso,
                             run_coach );

CREATE SEQUENCE documentacion_id_doc_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER documentacion_id_doc_trg BEFORE
    INSERT ON documentacion
    FOR EACH ROW
    WHEN ( new.id_doc IS NULL )
BEGIN
    :new.id_doc := documentacion_id_doc_seq.nextval;
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

CREATE SEQUENCE resultado_id_resultado_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER resultado_id_resultado_trg BEFORE
    INSERT ON resultado
    FOR EACH ROW
    WHEN ( new.id_resultado IS NULL )
BEGIN
    :new.id_resultado := resultado_id_resultado_seq.nextval;
END;
/

CREATE SEQUENCE reunion_id_reunion_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER reunion_id_reunion_trg BEFORE
    INSERT ON reunion
    FOR EACH ROW
    WHEN ( new.id_reunion IS NULL )
BEGIN
    :new.id_reunion := reunion_id_reunion_seq.nextval;
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
-- CREATE TABLE                            11
-- CREATE INDEX                             0
-- ALTER TABLE                             22
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           8
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
-- CREATE SEQUENCE                          8
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

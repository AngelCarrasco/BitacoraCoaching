-- Generado por Oracle SQL Developer Data Modeler 20.4.1.406.0906
--   en:        2021-10-15 00:01:23 CLST
--   sitio:      Oracle Database 12c
--   tipo:      Oracle Database 12c



DROP TABLE coach CASCADE CONSTRAINTS;

DROP TABLE coachee CASCADE CONSTRAINTS;

DROP TABLE documentacion CASCADE CONSTRAINTS;

DROP TABLE empresa CASCADE CONSTRAINTS;

DROP TABLE encuesta CASCADE CONSTRAINTS;

DROP TABLE evaluacion CASCADE CONSTRAINTS;

DROP TABLE indicador CASCADE CONSTRAINTS;

DROP TABLE objetivo CASCADE CONSTRAINTS;

DROP TABLE plan_accion CASCADE CONSTRAINTS;

DROP TABLE proceso CASCADE CONSTRAINTS;

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
    contrasena   VARCHAR2(200) NOT NULL,
    contrato     NUMBER NOT NULL,
    rut_empresa  VARCHAR2(13) NOT NULL,
    id_sesion    NUMBER(4) NOT NULL
);

ALTER TABLE coachee ADD CONSTRAINT coachee_pk PRIMARY KEY ( run_coachee );

CREATE TABLE documentacion (
    id_doc        NUMBER NOT NULL,
    archivo       CLOB NOT NULL,
    fecha_subida  DATE NOT NULL,
    fecha_vista   DATE,
    run_coachee   VARCHAR2(13) NOT NULL,
    run_coach     VARCHAR2(13) NOT NULL
);

ALTER TABLE documentacion
    ADD CONSTRAINT documentacion_pk PRIMARY KEY ( id_doc,
                                                  run_coach,
                                                  run_coachee );

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
    run_coach    VARCHAR2(13) NOT NULL
);

ALTER TABLE objetivo ADD CONSTRAINT objetivo_pk PRIMARY KEY ( id_objetivo );

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
    id_proceso      NUMBER NOT NULL,
    nombre          VARCHAR2(50) NOT NULL,
    modalidad       VARCHAR2(15) NOT NULL,
    status          VARCHAR2(50) NOT NULL,
    fecha_contrato  DATE NOT NULL,
    clausula        CLOB NOT NULL,
    run_coach       VARCHAR2(13) NOT NULL,
    rut_empresa     VARCHAR2(13) NOT NULL
);

ALTER TABLE proceso ADD CONSTRAINT proceso_pk PRIMARY KEY ( id_proceso,
                                                            run_coach );

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

ALTER TABLE coachee
    ADD CONSTRAINT coachee_sesion_fk FOREIGN KEY ( id_sesion )
        REFERENCES sesion ( id_sesion );

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

ALTER TABLE plan_accion
    ADD CONSTRAINT plan_accion_proceso_fk FOREIGN KEY ( id_proceso,
                                                        run_coach )
        REFERENCES proceso ( id_proceso,
                             run_coach );

ALTER TABLE proceso
    ADD CONSTRAINT proceso_coach_fk FOREIGN KEY ( run_coach )
        REFERENCES coach ( run_coach );

ALTER TABLE proceso
    ADD CONSTRAINT proceso_empresa_fk FOREIGN KEY ( rut_empresa )
        REFERENCES empresa ( rut_empresa );

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



-- Informe de Resumen de Oracle SQL Developer Data Modeler: 
-- 
-- CREATE TABLE                            12
-- CREATE INDEX                             0
-- ALTER TABLE                             25
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
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
-- CREATE SEQUENCE                          0
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


DROP TABLE coach CASCADE CONSTRAINTS;

DROP TABLE coachee CASCADE CONSTRAINTS;

DROP TABLE documentacion CASCADE CONSTRAINTS;

DROP TABLE empresa CASCADE CONSTRAINTS;

DROP TABLE encuesta CASCADE CONSTRAINTS;

DROP TABLE evaluacion CASCADE CONSTRAINTS;

DROP TABLE indicador CASCADE CONSTRAINTS;

DROP TABLE objetivo CASCADE CONSTRAINTS;

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
    contrato    CHAR(1) NOT NULL
);

ALTER TABLE coach ADD CONSTRAINT coach_pk PRIMARY KEY ( run_coach );

ALTER TABLE coach ADD CONSTRAINT coach_contrasena_un UNIQUE ( contrasena );

CREATE TABLE coachee (
    run_coachee          VARCHAR2(13) NOT NULL,
    apellido_m           VARCHAR2(50) NOT NULL,
    nombre               VARCHAR2(50) NOT NULL,
    cargo                VARCHAR2(20) NOT NULL,
    apellido_p           VARCHAR2(50) NOT NULL,
    correo               VARCHAR2(50) NOT NULL,
    empresa_rut_empresa  VARCHAR2(13) NOT NULL,
    contrasena           VARCHAR2(16) NOT NULL,
    contrato             CHAR(1) NOT NULL
);

ALTER TABLE coachee ADD CONSTRAINT coachee_pk PRIMARY KEY ( run_coachee );

ALTER TABLE coachee ADD CONSTRAINT coachee_contrasena_un UNIQUE ( contrasena );

CREATE TABLE documentacion (
    archivo              CLOB NOT NULL,
    fecha_subida         DATE NOT NULL,
    coachee_run_coachee  VARCHAR2(13) NOT NULL,
    coach_run_coach      VARCHAR2(13) NOT NULL,
    fecha_vista          DATE
);

ALTER TABLE documentacion ADD CONSTRAINT documentacion_pk PRIMARY KEY ( coach_run_coach,
                                                                        coachee_run_coachee );

CREATE TABLE empresa (
    rut_empresa  VARCHAR2(13) NOT NULL,
    direccion    VARCHAR2(30) NOT NULL,
    telefono     NUMBER(9) NOT NULL,
    nombre       VARCHAR2(30) NOT NULL,
    correo       VARCHAR2(50) NOT NULL,
    contrato     CHAR(1) NOT NULL
);

ALTER TABLE empresa ADD CONSTRAINT empresa_pk PRIMARY KEY ( rut_empresa );

CREATE TABLE encuesta (
    id_pregunta  NUMBER NOT NULL,
    pregunta     VARCHAR2(20) NOT NULL,
    nota         FLOAT
);

ALTER TABLE encuesta ADD CONSTRAINT encuesta_pk PRIMARY KEY ( id_pregunta );

CREATE TABLE evaluacion (
    id_encuesta              NUMBER NOT NULL,
    fecha                    DATE NOT NULL,
    comentario               VARCHAR2(100),
    promedio                 FLOAT,
    proceso_id_proceso       NUMBER NOT NULL,
    proceso_coach_run_coach  VARCHAR2(13) NOT NULL,
    proceso_run_coachee      VARCHAR2(13) NOT NULL,
    encuesta_id_pregunta     NUMBER NOT NULL
);

ALTER TABLE evaluacion
    ADD CONSTRAINT evaluacion_pk PRIMARY KEY ( proceso_id_proceso,
                                               proceso_coach_run_coach,
                                               proceso_run_coachee,
                                               id_encuesta );

CREATE TABLE indicador (
    id_incador            NUMBER NOT NULL,
    nombre                VARCHAR2(150) NOT NULL,
    objetivo_id_objetivo  NUMBER NOT NULL
);

ALTER TABLE indicador ADD CONSTRAINT indicador_pk PRIMARY KEY ( id_incador );

CREATE TABLE objetivo (
    id_objetivo             NUMBER NOT NULL,
    nombre                  VARCHAR2(150) NOT NULL,
    proceso_id_proceso      NUMBER NOT NULL,
    proceso_run_coach       VARCHAR2(13) NOT NULL,
    proceso_run_coachee     VARCHAR2(13) NOT NULL,
    reunion_ini_id_reunion  NUMBER NOT NULL
);

ALTER TABLE objetivo ADD CONSTRAINT objetivo_pk PRIMARY KEY ( id_objetivo );

CREATE TABLE proceso (
    id_proceso           NUMBER NOT NULL,
    nombre               VARCHAR2(50) NOT NULL,
    modalidad            VARCHAR2(15) NOT NULL,
    status               VARCHAR2(50) NOT NULL,
    plan_accion          VARCHAR2(200),
    coach_run_coach      VARCHAR2(13) NOT NULL,
    coachee_run_coachee  VARCHAR2(13) NOT NULL,
    empresa_rut_empresa  VARCHAR2(13) NOT NULL
);

ALTER TABLE proceso
    ADD CONSTRAINT proceso_pk PRIMARY KEY ( id_proceso,
                                            coach_run_coach,
                                            coachee_run_coachee );

CREATE TABLE reunion_avance (
    id_avance           NUMBER NOT NULL,
    fecha               DATE NOT NULL,
    observacion         VARCHAR2(250) NOT NULL,
    sesion_id_sesion    NUMBER(4) NOT NULL,
    sesion_id_proceso   NUMBER NOT NULL,
    sesion_run_coach    VARCHAR2(13) NOT NULL,
    sesion_run_coachee  VARCHAR2(13) NOT NULL
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
    estado               CHAR(1) NOT NULL,
    asignacion_acuer     CLOB NOT NULL,
    proceso_id_proceso   NUMBER NOT NULL,
    proceso_run_coach    VARCHAR2(13) NOT NULL,
    proceso_run_coachee  VARCHAR2(13) NOT NULL
);

ALTER TABLE sesion
    ADD CONSTRAINT sesion_pk PRIMARY KEY ( id_sesion,
                                           proceso_id_proceso,
                                           proceso_run_coach,
                                           proceso_run_coachee );

ALTER TABLE coachee
    ADD CONSTRAINT coachee_empresa_fk FOREIGN KEY ( empresa_rut_empresa )
        REFERENCES empresa ( rut_empresa );

ALTER TABLE documentacion
    ADD CONSTRAINT documentacion_coach_fk FOREIGN KEY ( coach_run_coach )
        REFERENCES coach ( run_coach );

ALTER TABLE documentacion
    ADD CONSTRAINT documentacion_coachee_fk FOREIGN KEY ( coachee_run_coachee )
        REFERENCES coachee ( run_coachee );

ALTER TABLE evaluacion
    ADD CONSTRAINT evaluacion_encuesta_fk FOREIGN KEY ( encuesta_id_pregunta )
        REFERENCES encuesta ( id_pregunta );

ALTER TABLE evaluacion
    ADD CONSTRAINT evaluacion_proceso_fk FOREIGN KEY ( proceso_id_proceso,
                                                       proceso_coach_run_coach,
                                                       proceso_run_coachee )
        REFERENCES proceso ( id_proceso,
                             coach_run_coach,
                             coachee_run_coachee );

ALTER TABLE indicador
    ADD CONSTRAINT indicador_objetivo_fk FOREIGN KEY ( objetivo_id_objetivo )
        REFERENCES objetivo ( id_objetivo );

ALTER TABLE objetivo
    ADD CONSTRAINT objetivo_proceso_fk FOREIGN KEY ( proceso_id_proceso,
                                                     proceso_run_coach,
                                                     proceso_run_coachee )
        REFERENCES proceso ( id_proceso,
                             coach_run_coach,
                             coachee_run_coachee );

ALTER TABLE objetivo
    ADD CONSTRAINT objetivo_reunion_ini_fk FOREIGN KEY ( reunion_ini_id_reunion )
        REFERENCES reunion_ini ( id_reunion );

ALTER TABLE proceso
    ADD CONSTRAINT proceso_coach_fk FOREIGN KEY ( coach_run_coach )
        REFERENCES coach ( run_coach );

ALTER TABLE proceso
    ADD CONSTRAINT proceso_coachee_fk FOREIGN KEY ( coachee_run_coachee )
        REFERENCES coachee ( run_coachee );

ALTER TABLE proceso
    ADD CONSTRAINT proceso_empresa_fk FOREIGN KEY ( empresa_rut_empresa )
        REFERENCES empresa ( rut_empresa );

ALTER TABLE reunion_avance
    ADD CONSTRAINT reunion_avance_sesion_fk FOREIGN KEY ( sesion_id_sesion,
                                                          sesion_id_proceso,
                                                          sesion_run_coach,
                                                          sesion_run_coachee )
        REFERENCES sesion ( id_sesion,
                            proceso_id_proceso,
                            proceso_run_coach,
                            proceso_run_coachee );

ALTER TABLE sesion
    ADD CONSTRAINT sesion_proceso_fk FOREIGN KEY ( proceso_id_proceso,
                                                   proceso_run_coach,
                                                   proceso_run_coachee )
        REFERENCES proceso ( id_proceso,
                             coach_run_coach,
                             coachee_run_coachee );



-- Informe de Resumen de Oracle SQL Developer Data Modeler: 
-- 
-- CREATE TABLE                            12
-- CREATE INDEX                             0
-- ALTER TABLE                             27
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
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0

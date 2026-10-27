/*-----------------------------------------------------------------------------
0. LIMPIEZA / ELIMINACIÓN DE TABLAS 
-- ----------------------------------------------------------------------------
*/
DROP TABLE IF EXISTS PAGO;
DROP TABLE IF EXISTS COMPROBANTE;
DROP TABLE IF EXISTS FORMA_PAGO;

DROP TABLE IF EXISTS DETALLE_RECETA;
DROP TABLE IF EXISTS RECETA;
DROP TABLE IF EXISTS MEDICAMENTO;
DROP TABLE IF EXISTS PRESENTACION;

DROP TABLE IF EXISTS CONSULTA;
DROP TABLE IF EXISTS CITA;
DROP TABLE IF EXISTS ESTADO_CITA;
DROP TABLE IF EXISTS PSIQUIATRA;
DROP TABLE IF EXISTS ESPECIALIDAD;

DROP TABLE IF EXISTS ANTECEDENTE;
DROP TABLE IF EXISTS TIPO_ANTECEDENTE;
DROP TABLE IF EXISTS HISTORIA_CLINICA;
DROP TABLE IF EXISTS PACIENTE;
/*
------------------------------------------------------------------------------
MÓDULO 1: GESTIÓN DE PACIENTES E HISTORIAS CLÍNICAS
-- ----------------------------------------------------------------------------
*/
-- 1. Tabla PACIENTE
CREATE TABLE PACIENTE (
    id_paciente        INTEGER       NOT NULL,
    dni                VARCHAR(15)   NOT NULL,
    nombres            VARCHAR(100)  NOT NULL,
    apellidos          VARCHAR(100)  NOT NULL,
    fcha_ncmnto        DATE          NOT NULL,
    sexo               CHAR(1)       NOT NULL,
    telefono           VARCHAR(20)   NOT NULL,
    correo_electronico VARCHAR(120),
    CONSTRAINT pk_paciente PRIMARY KEY (id_paciente),
    CONSTRAINT uq_paciente_dni UNIQUE (dni)
);

-- 2. Tabla HISTORIA_CLINICA
CREATE TABLE HISTORIA_CLINICA (
    id_historia      INTEGER       NOT NULL,
    num_expediente   VARCHAR(30)   NOT NULL,
    fcha_apertura    DATE          NOT NULL,
    observacion_gral VARCHAR(500),
    id_paciente      INTEGER       NOT NULL,
    CONSTRAINT pk_historia_clinica PRIMARY KEY (id_historia),
    CONSTRAINT uq_historia_expediente UNIQUE (num_expediente),
    CONSTRAINT uq_historia_paciente UNIQUE (id_paciente),
    CONSTRAINT fk_historia_paciente FOREIGN KEY (id_paciente)
        REFERENCES PACIENTE (id_paciente)
);

-- 3. Tabla TIPO_ANTECEDENTE
CREATE TABLE TIPO_ANTECEDENTE (
    id_tipo_antecedente INTEGER      NOT NULL,
    nombre_tipo         VARCHAR(80)  NOT NULL,
    CONSTRAINT pk_tipo_antecedente PRIMARY KEY (id_tipo_antecedente)
);

-- 4. Tabla ANTECEDENTE 
CREATE TABLE ANTECEDENTE (
    id_antecedente      INTEGER       NOT NULL,
    descripcion         VARCHAR(500)  NOT NULL,
    fcha_registro       DATE          NOT NULL,
    id_historia         INTEGER       NOT NULL,
    id_tipo_antecedente INTEGER       NOT NULL,
    CONSTRAINT pk_antecedente PRIMARY KEY (id_antecedente),
    CONSTRAINT fk_antecedente_historia FOREIGN KEY (id_historia)
        REFERENCES HISTORIA_CLINICA (id_historia),
    CONSTRAINT fk_antecedente_tipo FOREIGN KEY (id_tipo_antecedente)
        REFERENCES TIPO_ANTECEDENTE (id_tipo_antecedente)
);


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
/*
-- ----------------------------------------------------------------------------
-- MÓDULO 2: GESTIÓN DE CITAS Y ATENCIÓN MÉDICA
-- ----------------------------------------------------------------------------
*/

-- 5. Tabla ESPECIALIDAD 
CREATE TABLE ESPECIALIDAD (
    id_especialidad INTEGER       NOT NULL,
    nombre_esp      VARCHAR(100)  NOT NULL,
    CONSTRAINT pk_especialidad PRIMARY KEY (id_especialidad)
);

-- 6. Tabla PSIQUIATRA 
CREATE TABLE PSIQUIATRA (
    id_psiquiatra        INTEGER       NOT NULL,
    cmp                  VARCHAR(20)   NOT NULL,
    nombres              VARCHAR(100)  NOT NULL,
    apellidos            VARCHAR(100)  NOT NULL,
    telefono             VARCHAR(20)   NOT NULL,
    correo_institucional VARCHAR(120),
    id_especialidad      INTEGER       NOT NULL,
    CONSTRAINT pk_psiquiatra PRIMARY KEY (id_psiquiatra),
    CONSTRAINT uq_psiquiatra_cmp UNIQUE (cmp),
    CONSTRAINT fk_psiquiatra_especialidad FOREIGN KEY (id_especialidad)
        REFERENCES ESPECIALIDAD (id_especialidad)
);

-- 7. Tabla ESTADO_CITA 
CREATE TABLE ESTADO_CITA (
    id_estado     INTEGER      NOT NULL,
    nombre_estado VARCHAR(50)  NOT NULL,
    CONSTRAINT pk_estado_cita PRIMARY KEY (id_estado)
);

-- 8. Tabla CITA 
CREATE TABLE CITA (
    id_cita        INTEGER       NOT NULL,
    fcha_cita      DATE          NOT NULL,
    hora_cita      VARCHAR(10)   NOT NULL,
    motivo_reserva VARCHAR(300),
    id_paciente    INTEGER       NOT NULL,
    id_psiquiatra  INTEGER       NOT NULL,
    id_estado      INTEGER       NOT NULL,
    CONSTRAINT pk_cita PRIMARY KEY (id_cita),
    CONSTRAINT fk_cita_paciente FOREIGN KEY (id_paciente)
        REFERENCES PACIENTE (id_paciente),
    CONSTRAINT fk_cita_psiquiatra FOREIGN KEY (id_psiquiatra)
        REFERENCES PSIQUIATRA (id_psiquiatra),
    CONSTRAINT fk_cita_estado FOREIGN KEY (id_estado)
        REFERENCES ESTADO_CITA (id_estado)
);

-- 9. Tabla CONSULTA 
CREATE TABLE CONSULTA (
    id_consulta      INTEGER        NOT NULL,
    fcha_consulta    DATE           NOT NULL,
    motivo_atencion  VARCHAR(300)   NOT NULL,
    diagnostico_ppal VARCHAR(300)   NOT NULL,
    nota_evolucion   VARCHAR(1000)  NOT NULL,
    id_cita          INTEGER        NOT NULL,
    CONSTRAINT pk_consulta PRIMARY KEY (id_consulta),
    CONSTRAINT uq_consulta_cita UNIQUE (id_cita),
    CONSTRAINT fk_consulta_cita FOREIGN KEY (id_cita)
        REFERENCES CITA (id_cita)
);

-- ----------------------------------------------------------------------------
-- MÓDULO 3: PRESCRIPCIÓN Y FARMACOTERAPIA
-- ----------------------------------------------------------------------------

-- 10. Tabla PRESENTACION 
CREATE TABLE PRESENTACION (
    id_presentacion   INTEGER       NOT NULL,
    descripcion_forma VARCHAR(100)  NOT NULL,
    CONSTRAINT pk_presentacion PRIMARY KEY (id_presentacion)
);

-- 11. Tabla MEDICAMENTO 
CREATE TABLE MEDICAMENTO (
    id_medicamento   INTEGER       NOT NULL,
    nombre_comercial VARCHAR(120)  NOT NULL,
    principio_activo VARCHAR(120)  NOT NULL,
    concentracion    VARCHAR(60)   NOT NULL,
    id_presentacion  INTEGER       NOT NULL,
    CONSTRAINT pk_medicamento PRIMARY KEY (id_medicamento),
    CONSTRAINT fk_medicamento_presentacion FOREIGN KEY (id_presentacion)
        REFERENCES PRESENTACION (id_presentacion)
);

-- 12. Tabla RECETA 
CREATE TABLE RECETA (
    id_receta     INTEGER      NOT NULL,
    num_receta    VARCHAR(30)  NOT NULL,
    fcha_emision  DATE         NOT NULL,
    vigencia_dias INTEGER      NOT NULL,
    id_consulta   INTEGER      NOT NULL,
    CONSTRAINT pk_receta PRIMARY KEY (id_receta),
    CONSTRAINT uq_receta_numero UNIQUE (num_receta),
    CONSTRAINT fk_receta_consulta FOREIGN KEY (id_consulta)
        REFERENCES CONSULTA (id_consulta)
);

-- 13. Tabla DETALLE_RECETA 
CREATE TABLE DETALLE_RECETA (
    id_detalle           INTEGER       NOT NULL,
    dosis                VARCHAR(100)  NOT NULL,
    frecuencia_hrs       INTEGER       NOT NULL,
    duracion_dias        INTEGER       NOT NULL,
    indicacion_adicional VARCHAR(300),
    id_receta            INTEGER       NOT NULL,
    id_medicamento       INTEGER       NOT NULL,
    CONSTRAINT pk_detalle_receta PRIMARY KEY (id_detalle),
    CONSTRAINT fk_detalle_receta FOREIGN KEY (id_receta)
        REFERENCES RECETA (id_receta),
    CONSTRAINT fk_detalle_medicamento FOREIGN KEY (id_medicamento)
        REFERENCES MEDICAMENTO (id_medicamento)
);

-- ----------------------------------------------------------------------------
-- MÓDULO 4: FACTURACIÓN Y PAGOS
-- ----------------------------------------------------------------------------

-- 14. Tabla COMPROBANTE 
CREATE TABLE COMPROBANTE (
    id_comprobante INTEGER        NOT NULL,
    serie_numero   VARCHAR(30)    NOT NULL,
    fcha_emision   DATE           NOT NULL,
    monto_total    NUMERIC(10, 2) NOT NULL,
    id_consulta    INTEGER        NOT NULL,
    CONSTRAINT pk_comprobante PRIMARY KEY (id_comprobante),
    CONSTRAINT uq_comprobante_serie UNIQUE (serie_numero),
    CONSTRAINT uq_comprobante_consulta UNIQUE (id_consulta),
    CONSTRAINT fk_comprobante_consulta FOREIGN KEY (id_consulta)
        REFERENCES CONSULTA (id_consulta)
);

-- 15. Tabla FORMA_PAGO 
CREATE TABLE FORMA_PAGO (
    id_forma_pago INTEGER      NOT NULL,
    nombre_forma  VARCHAR(60)  NOT NULL,
    CONSTRAINT pk_forma_pago PRIMARY KEY (id_forma_pago)
);

-- 16. Tabla PAGO 
CREATE TABLE PAGO (
    id_pago        INTEGER        NOT NULL,
    fcha_pago      DATE           NOT NULL,
    monto_abonado  NUMERIC(10, 2) NOT NULL,
    num_operacion  VARCHAR(50),
    id_comprobante INTEGER        NOT NULL,
    id_forma_pago  INTEGER        NOT NULL,
    CONSTRAINT pk_pago PRIMARY KEY (id_pago),
    CONSTRAINT fk_pago_comprobante FOREIGN KEY (id_comprobante)
        REFERENCES COMPROBANTE (id_comprobante),
    CONSTRAINT fk_pago_forma_pago FOREIGN KEY (id_forma_pago)
        REFERENCES FORMA_PAGO (id_forma_pago)
);

-- ============================================================================
-- 0. LIMPIEZA DE TABLAS
-- ============================================================================
DROP TABLE IF EXISTS PAGO CASCADE;
DROP TABLE IF EXISTS COMPROBANTE CASCADE;
DROP TABLE IF EXISTS FORMA_PAGO CASCADE;
DROP TABLE IF EXISTS DETALLE_RECETA CASCADE;
DROP TABLE IF EXISTS RECETA CASCADE;
DROP TABLE IF EXISTS MEDICAMENTO CASCADE;
DROP TABLE IF EXISTS PRESENTACION CASCADE;
DROP TABLE IF EXISTS CONSULTA CASCADE;
DROP TABLE IF EXISTS CITA CASCADE;
DROP TABLE IF EXISTS ESTADO_CITA CASCADE;
DROP TABLE IF EXISTS PSIQUIATRA CASCADE;
DROP TABLE IF EXISTS ESPECIALIDAD CASCADE;
DROP TABLE IF EXISTS ANTECEDENTE CASCADE;
DROP TABLE IF EXISTS TIPO_ANTECEDENTE CASCADE;
DROP TABLE IF EXISTS HISTORIA_CLINICA CASCADE;
DROP TABLE IF EXISTS PACIENTE CASCADE;

-- ============================================================================
-- MÓDULO 1: GESTIÓN DE PACIENTES E HISTORIAS CLÍNICAS
-- ============================================================================

CREATE TABLE PACIENTE (
    id_paciente        SERIAL,
    dni                VARCHAR(15)   NOT NULL,
    nombres            VARCHAR(100)  NOT NULL,
    apellidos          VARCHAR(100)  NOT NULL,
    fcha_ncmnto        DATE          NOT NULL,
    sexo               CHAR(1)       NOT NULL,
    telefono           VARCHAR(20)   NOT NULL,
    correo_electronico VARCHAR(120),
    CONSTRAINT pk_paciente PRIMARY KEY (id_paciente),
    CONSTRAINT uq_paciente_dni UNIQUE (dni),
    CONSTRAINT chk_paciente_sexo CHECK (sexo IN ('M', 'F'))
);

CREATE TABLE HISTORIA_CLINICA (
    id_historia      SERIAL,
    num_expediente   VARCHAR(30)   NOT NULL,
    fcha_apertura    DATE          NOT NULL DEFAULT CURRENT_DATE,
    observacion_gral VARCHAR(500),
    id_paciente      INTEGER       NOT NULL,
    CONSTRAINT pk_historia_clinica PRIMARY KEY (id_historia),
    CONSTRAINT uq_historia_expediente UNIQUE (num_expediente),
    CONSTRAINT uq_historia_paciente UNIQUE (id_paciente),
    CONSTRAINT fk_historia_paciente FOREIGN KEY (id_paciente)
        REFERENCES PACIENTE (id_paciente) ON DELETE CASCADE
);

CREATE TABLE TIPO_ANTECEDENTE (
    id_tipo_antecedente SERIAL,
    nombre_tipo         VARCHAR(80)  NOT NULL,
    CONSTRAINT pk_tipo_antecedente PRIMARY KEY (id_tipo_antecedente)
);

CREATE TABLE ANTECEDENTE (
    id_antecedente      SERIAL,
    descripcion         VARCHAR(500)  NOT NULL,
    fcha_registro       DATE          NOT NULL DEFAULT CURRENT_DATE,
    id_historia         INTEGER       NOT NULL,
    id_tipo_antecedente INTEGER       NOT NULL,
    CONSTRAINT pk_antecedente PRIMARY KEY (id_antecedente),
    CONSTRAINT fk_antecedente_historia FOREIGN KEY (id_historia)
        REFERENCES HISTORIA_CLINICA (id_historia) ON DELETE CASCADE,
    CONSTRAINT fk_antecedente_tipo FOREIGN KEY (id_tipo_antecedente)
        REFERENCES TIPO_ANTECEDENTE (id_tipo_antecedente) ON DELETE RESTRICT
);

-- ============================================================================
-- MÓDULO 2: GESTIÓN DE CITAS Y ATENCIÓN MÉDICA
-- ============================================================================

CREATE TABLE ESPECIALIDAD (
    id_especialidad SERIAL,
    nombre_esp      VARCHAR(100)  NOT NULL,
    CONSTRAINT pk_especialidad PRIMARY KEY (id_especialidad)
);

CREATE TABLE PSIQUIATRA (
    id_psiquiatra        SERIAL,
    cmp                  VARCHAR(20)   NOT NULL,
    nombres              VARCHAR(100)  NOT NULL,
    apellidos            VARCHAR(100)  NOT NULL,
    telefono             VARCHAR(20)   NOT NULL,
    correo_institucional VARCHAR(120),
    id_especialidad      INTEGER       NOT NULL,
    CONSTRAINT pk_psiquiatra PRIMARY KEY (id_psiquiatra),
    CONSTRAINT uq_psiquiatra_cmp UNIQUE (cmp),
    CONSTRAINT fk_psiquiatra_especialidad FOREIGN KEY (id_especialidad)
        REFERENCES ESPECIALIDAD (id_especialidad) ON DELETE RESTRICT
);

CREATE TABLE ESTADO_CITA (
    id_estado     SERIAL,
    nombre_estado VARCHAR(50)  NOT NULL,
    CONSTRAINT pk_estado_cita PRIMARY KEY (id_estado)
);

CREATE TABLE CITA (
    id_cita        SERIAL,
    fcha_cita      DATE          NOT NULL,
    hora_cita      VARCHAR(10)   NOT NULL,
    motivo_reserva VARCHAR(300),
    id_paciente    INTEGER       NOT NULL,
    id_psiquiatra  INTEGER       NOT NULL,
    id_estado      INTEGER       NOT NULL,
    CONSTRAINT pk_cita PRIMARY KEY (id_cita),
    CONSTRAINT fk_cita_paciente FOREIGN KEY (id_paciente)
        REFERENCES PACIENTE (id_paciente) ON DELETE CASCADE,
    CONSTRAINT fk_cita_psiquiatra FOREIGN KEY (id_psiquiatra)
        REFERENCES PSIQUIATRA (id_psiquiatra) ON DELETE RESTRICT,
    CONSTRAINT fk_cita_estado FOREIGN KEY (id_estado)
        REFERENCES ESTADO_CITA (id_estado) ON DELETE RESTRICT
);

CREATE TABLE CONSULTA (
    id_consulta             SERIAL,
    fcha_consulta           DATE           NOT NULL DEFAULT CURRENT_DATE,
    motivo_atencion         VARCHAR(300)   NOT NULL,
    diagnostico_ppal        VARCHAR(300)   NOT NULL,
    nota_evolucion          VARCHAR(1000)  NOT NULL,
    evaluacion_psicometrica JSONB,
    id_cita                 INTEGER        NOT NULL,
    CONSTRAINT pk_consulta PRIMARY KEY (id_consulta),
    CONSTRAINT uq_consulta_cita UNIQUE (id_cita),
    CONSTRAINT fk_consulta_cita FOREIGN KEY (id_cita)
        REFERENCES CITA (id_cita) ON DELETE CASCADE
);

-- ============================================================================
-- MÓDULO 3: PRESCRIPCIÓN Y FARMACOTERAPIA
-- ============================================================================

CREATE TABLE PRESENTACION (
    id_presentacion   SERIAL,
    descripcion_forma VARCHAR(100)  NOT NULL,
    CONSTRAINT pk_presentacion PRIMARY KEY (id_presentacion)
);

CREATE TABLE MEDICAMENTO (
    id_medicamento   SERIAL,
    nombre_comercial VARCHAR(120)  NOT NULL,
    principio_activo VARCHAR(120)  NOT NULL,
    concentracion    VARCHAR(60)   NOT NULL,
    id_presentacion  INTEGER       NOT NULL,
    CONSTRAINT pk_medicamento PRIMARY KEY (id_medicamento),
    CONSTRAINT fk_medicamento_presentacion FOREIGN KEY (id_presentacion)
        REFERENCES PRESENTACION (id_presentacion) ON DELETE RESTRICT
);

CREATE TABLE RECETA (
    id_receta     SERIAL,
    num_receta    VARCHAR(30)  NOT NULL,
    fcha_emision  DATE         NOT NULL DEFAULT CURRENT_DATE,
    vigencia_dias INTEGER      NOT NULL,
    id_consulta   INTEGER      NOT NULL,
    CONSTRAINT pk_receta PRIMARY KEY (id_receta),
    CONSTRAINT uq_receta_numero UNIQUE (num_receta),
    CONSTRAINT chk_receta_vigencia CHECK (vigencia_dias > 0),
    CONSTRAINT fk_receta_consulta FOREIGN KEY (id_consulta)
        REFERENCES CONSULTA (id_consulta) ON DELETE CASCADE
);

CREATE TABLE DETALLE_RECETA (
    id_detalle           SERIAL,
    dosis                VARCHAR(100)  NOT NULL,
    frecuencia_hrs       INTEGER       NOT NULL,
    duracion_dias        INTEGER       NOT NULL,
    indicacion_adicional VARCHAR(300),
    id_receta            INTEGER       NOT NULL,
    id_medicamento       INTEGER       NOT NULL,
    CONSTRAINT pk_detalle_receta PRIMARY KEY (id_detalle),
    CONSTRAINT chk_detalle_frecuencia CHECK (frecuencia_hrs > 0),
    CONSTRAINT chk_detalle_duracion CHECK (duracion_dias > 0),
    CONSTRAINT fk_detalle_receta FOREIGN KEY (id_receta)
        REFERENCES RECETA (id_receta) ON DELETE CASCADE,
    CONSTRAINT fk_detalle_medicamento FOREIGN KEY (id_medicamento)
        REFERENCES MEDICAMENTO (id_medicamento) ON DELETE RESTRICT
);

-- ============================================================================
-- MÓDULO 4: FACTURACIÓN Y PAGOS
-- ============================================================================

CREATE TABLE COMPROBANTE (
    id_comprobante SERIAL,
    serie_numero   VARCHAR(30)    NOT NULL,
    fcha_emision   DATE           NOT NULL DEFAULT CURRENT_DATE,
    monto_total    NUMERIC(10, 2) NOT NULL,
    id_consulta    INTEGER        NOT NULL,
    CONSTRAINT pk_comprobante PRIMARY KEY (id_comprobante),
    CONSTRAINT uq_comprobante_serie UNIQUE (serie_numero),
    CONSTRAINT uq_comprobante_consulta UNIQUE (id_consulta),
    CONSTRAINT chk_comprobante_monto CHECK (monto_total > 0),
    CONSTRAINT fk_comprobante_consulta FOREIGN KEY (id_consulta)
        REFERENCES CONSULTA (id_consulta) ON DELETE RESTRICT
);

CREATE TABLE FORMA_PAGO (
    id_forma_pago SERIAL,
    nombre_forma  VARCHAR(60)  NOT NULL,
    CONSTRAINT pk_forma_pago PRIMARY KEY (id_forma_pago)
);

CREATE TABLE PAGO (
    id_pago        SERIAL,
    fcha_pago      DATE           NOT NULL DEFAULT CURRENT_DATE,
    monto_abonado  NUMERIC(10, 2) NOT NULL,
    num_operacion  VARCHAR(50),
    id_comprobante INTEGER        NOT NULL,
    id_forma_pago  INTEGER        NOT NULL,
    CONSTRAINT pk_pago PRIMARY KEY (id_pago),
    CONSTRAINT chk_pago_monto CHECK (monto_abonado > 0),
    CONSTRAINT fk_pago_comprobante FOREIGN KEY (id_comprobante)
        REFERENCES COMPROBANTE (id_comprobante) ON DELETE RESTRICT,
    CONSTRAINT fk_pago_forma_pago FOREIGN KEY (id_forma_pago)
        REFERENCES FORMA_PAGO (id_forma_pago) ON DELETE RESTRICT
);

-- ============================================================================
-- ÍNDICES DE OPTIMIZACIÓN
-- ============================================================================
CREATE INDEX idx_cita_psiquiatra_fecha ON CITA (id_psiquiatra, fcha_cita);
CREATE INDEX idx_consulta_diagnostico ON CONSULTA (diagnostico_ppal);
CREATE INDEX idx_consulta_psicometria_gin ON CONSULTA USING GIN (evaluacion_psicometrica);

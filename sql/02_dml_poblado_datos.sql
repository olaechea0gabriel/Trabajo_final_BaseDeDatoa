-- TABLA 1: PACIENTE
-- ----------------------------------------------------------------------------
INSERT INTO PACIENTE (id_paciente, dni, nombres, apellidos, fcha_ncmnto, sexo, telefono, correo_electronico)
VALUES 
    (1, '72458912', 'Lucia', 'Paredes Gomez', '1998-05-14', 'F', '959112233', 'lucia.paredes@email.com'),
    (2, '45892310', 'Carlos', 'Huaylla Basilio', '2004-02-21', 'M', '959445566', NULL),
    (3, '70123456', 'Camila', 'Torres Mendoza', '2001-03-30', 'F', '958771122', 'camila.torres@email.com'),
    (4, '29567812', 'Diego', 'Alvarez Ramos', '1976-08-19', 'M', '957334411', 'diego.alvarez@email.com'),
    (5, '73890123', 'Valeria', 'Flores Cardenas', '1995-12-05', 'F', '956889900', NULL);

-- ----------------------------------------------------------------------------
-- TABLA 2: HISTORIA_CLINICA 
-- ----------------------------------------------------------------------------
INSERT INTO HISTORIA_CLINICA (id_historia, num_expediente, fcha_apertura, observacion_gral, id_paciente)
VALUES 
    (1, 'EXP-2026-001', '2026-10-01', 'Paciente acude referida por cuadro de ansiedad generalizada.', 1),
    (2, 'EXP-2026-002', '2026-10-05', 'Derivado de neurología por alteraciones persistentes del sueño.', 2),
    (3, 'EXP-2026-003', '2026-10-08', 'Apertura de expediente por consulta de control preventivo.', 3),
    (4, 'EXP-2026-004', '2026-10-12', 'Antecedente de tratamiento previo descontinuado.', 4),
    (5, 'EXP-2026-005', '2026-10-15', 'Paciente refiere episodios agudos de estrés académico.', 5);

-- ----------------------------------------------------------------------------
-- TABLA 3: ESPECIALIDAD 
-- ----------------------------------------------------------------------------
INSERT INTO ESPECIALIDAD (id_especialidad, nombre_esp)
VALUES 
    (1, 'Psiquiatría General'),
    (2, 'Psiquiatría Infanto-Juvenil'),
    (3, 'Psicogeriatría'),
    (4, 'Psiquiatría de Adicciones'),
    (5, 'Neuropsiquiatría');

-- ----------------------------------------------------------------------------
-- TABLA 4: PSIQUIATRA 
-- ----------------------------------------------------------------------------
INSERT INTO PSIQUIATRA (id_psiquiatra, cmp, nombres, apellidos, telefono, correo_institucional, id_especialidad)
VALUES 
    (1, 'CMP-45821', 'Roberto', 'Mendoza Carpio', '958778899', 'rmendoza@consultorio.pe', 1),
    (2, 'CMP-51204', 'Elena', 'Villanueva Paz', '958334455', 'evillanueva@consultorio.pe', 2),
    (3, 'CMP-38910', 'Carlos', 'Montesinos Prado', '954112288', 'cmontesinos@consultorio.pe', 3),
    (4, 'CMP-60142', 'Patricia', 'Quispe Huaman', '952667744', 'pquispe@consultorio.pe', 4),
    (5, 'CMP-48731', 'Andres', 'Bustamante Zeballos', '951009988', 'abustamante@consultorio.pe', 5);
-------------------------------------------------------------------------------
--1 update por estudiante

-- ----------------------------------------------------------------------------
-- TABLA 5: ESTADO_CITA 
-- ----------------------------------------------------------------------------
INSERT INTO ESTADO_CITA (id_estado, nombre_estado)
VALUES 
    (1, 'Programada'),
    (2, 'Confirmada'),
    (3, 'Atendida'),
    (4, 'Cancelada'),
    (5, 'Reprogramada');

-- ----------------------------------------------------------------------------
-- TABLA 6: CITA 
-- ----------------------------------------------------------------------------
INSERT INTO CITA (id_cita, fcha_cita, hora_cita, motivo_reserva, id_paciente, id_psiquiatra, id_estado)
VALUES 
    (1, '2026-10-10', '09:30', 'Evaluación inicial por cuadro ansioso', 1, 1, 3),
    (2, '2026-10-12', '16:00', 'Evaluación clínica por insomnio prolongado', 2, 1, 3),
    (3, '2026-10-15', '11:00', 'Consulta por desgano y fatiga constante', 3, 2, 3),
    (4, '2026-10-18', '17:30', 'Evaluación por cambios de ánimo severos', 4, 4, 3),
    (5, '2026-10-20', '08:30', 'Crisis de estrés y sobrecarga laboral', 5, 5, 3);

-- ----------------------------------------------------------------------------
-- TABLA 7: CONSULTA 
-- ----------------------------------------------------------------------------
INSERT INTO CONSULTA (id_consulta, fcha_consulta, motivo_atencion, diagnostico_ppal, nota_evolucion, id_cita)
VALUES 
    (1, '2026-10-10', 'Crisis de ansiedad e inquietud constante', 'F41.1 Trastorno de ansiedad generalizada', 'Paciente orientada, se inicia esquema farmacológico y psicoterapia.', 1),
    (2, '2026-10-12', 'Dificultad severa para conciliar el sueño', 'G47.0 Trastorno de inicio del sueño', 'Se pautan medidas de higiene del sueño y tratamiento nocturno por 30 días.', 2),
    (3, '2026-10-15', 'Apatía persistente y tristeza no reactiva', 'F32.1 Episodio depresivo moderado', 'Se explican pautas de alerta y se programa reevaluación quincenal.', 3),
    (4, '2026-10-18', 'Irritabilidad extrema y consumo problemático', 'F10.1 Uso nocivo de sustancias', 'Se coordina abordaje interdisciplinario y monitoreo estrecho.', 4),
    (5, '2026-10-20', 'Cefalea tensional asociada a sobrecarga', 'F43.2 Trastorno de adaptación con ansiedad', 'Evolución favorable en consulta; se indican técnicas de relajación.', 5);

-- ----------------------------------------------------------------------------
-- TABLA 8: COMPROBANTE 
-- ----------------------------------------------------------------------------
INSERT INTO COMPROBANTE (id_comprobante, serie_numero, fcha_emision, monto_total, id_consulta)
VALUES 
    (1, 'B001-000101', '2026-10-10', 180.00, 1),
    (2, 'B001-000102', '2026-10-12', 180.00, 2),
    (3, 'B001-000103', '2026-10-15', 200.00, 3),
    (4, 'B001-000104', '2026-10-18', 220.00, 4),
    (5, 'B001-000105', '2026-10-20', 190.00, 5);



-- PARTE 4: CONSULTAS DE MODIFICACIÓN (UPDATE)

-- 1. Tabla PACIENTE:

UPDATE PACIENTE
SET 
    telefono = '959998877',
    correo_electronico = 'marco.valdivia@email.com'
WHERE id_paciente = 2;

-- 2. Tabla HISTORIA_CLINICA:

UPDATE HISTORIA_CLINICA
SET observacion_gral = 'Se adjuntan resultados de perfil tiroideo; paciente responde favorablemente al tratamiento inicial.'
WHERE num_expediente = 'EXP-2026-001';

-- 3. Tabla PSIQUIATRA: 

UPDATE PSIQUIATRA
SET correo_institucional = 'roberto.mendoza@redpsiquiatrica.pe'
WHERE cmp = 'CMP-45821';

-- 4. Tabla CITA: 

UPDATE CITA
SET 
    fcha_cita = '2026-10-25',
    hora_cita = '15:00',
    id_estado = 2 
WHERE id_cita = 1;

-- 5. Tabla COMPROBANTE:

UPDATE COMPROBANTE
SET monto_total = 160.00
WHERE serie_numero = 'B001-000101';

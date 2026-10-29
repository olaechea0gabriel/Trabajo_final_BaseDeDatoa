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


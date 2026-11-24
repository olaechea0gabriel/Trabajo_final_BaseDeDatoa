-- ============================================================================
-- POBLADO INICIAL DE DATOS (16 TABLAS) + ACTUALIZACIÓN DE SECUENCIAS
-- ============================================================================

-- 1. PACIENTE
INSERT INTO PACIENTE (id_paciente, dni, nombres, apellidos, fcha_ncmnto, sexo, telefono, correo_electronico)
VALUES 
    (1, '72458912', 'Lucia', 'Paredes Gomez', '1998-05-14', 'F', '959112233', 'lucia.paredes@email.com'),
    (2, '45892310', 'Carlos', 'Huaylla Basilio', '2004-02-21', 'M', '959445566', NULL),
    (3, '70123456', 'Camila', 'Torres Mendoza', '2001-03-30', 'F', '958771122', 'camila.torres@email.com'),
    (4, '29567812', 'Diego', 'Alvarez Ramos', '1976-08-19', 'M', '957334411', 'diego.alvarez@email.com'),
    (5, '73890123', 'Valeria', 'Flores Cardenas', '1995-12-05', 'F', '956889900', NULL);

-- 2. HISTORIA_CLINICA
INSERT INTO HISTORIA_CLINICA (id_historia, num_expediente, fcha_apertura, observacion_gral, id_paciente)
VALUES 
    (1, 'EXP-2026-001', '2026-10-01', 'Paciente acude referida por cuadro de ansiedad generalizada.', 1),
    (2, 'EXP-2026-002', '2026-10-05', 'Derivado de neurología por alteraciones persistentes del sueño.', 2),
    (3, 'EXP-2026-003', '2026-10-08', 'Apertura de expediente por consulta de control preventivo.', 3),
    (4, 'EXP-2026-004', '2026-10-12', 'Antecedente de tratamiento previo descontinuado.', 4),
    (5, 'EXP-2026-005', '2026-10-15', 'Paciente refiere episodios agudos de estrés académico.', 5);

-- 3. TIPO_ANTECEDENTE
INSERT INTO TIPO_ANTECEDENTE (id_tipo_antecedente, nombre_tipo)
VALUES
    (1, 'Psiquiátrico Personal'),
    (2, 'Psiquiátrico Familiar'),
    (3, 'Alergias Medicamentosas'),
    (4, 'Patológico Crónico');

-- 4. ANTECEDENTE
INSERT INTO ANTECEDENTE (id_antecedente, descripcion, fcha_registro, id_historia, id_tipo_antecedente)
VALUES
    (1, 'Episodio de crisis de pánico en 2024 sin hospitalización.', '2026-10-01', 1, 1),
    (2, 'Padre con diagnóstico de trastorno depresivo recurrente.', '2026-10-05', 2, 2),
    (3, 'Niega alergias a psicofármacos conocidos.', '2026-10-08', 3, 3);

-- 5. ESPECIALIDAD
INSERT INTO ESPECIALIDAD (id_especialidad, nombre_esp)
VALUES 
    (1, 'Psiquiatría General'),
    (2, 'Psiquiatría Infanto-Juvenil'),
    (3, 'Psicogeriatría'),
    (4, 'Psiquiatría de Adicciones'),
    (5, 'Neuropsiquiatría');

-- 6. PSIQUIATRA
INSERT INTO PSIQUIATRA (id_psiquiatra, cmp, nombres, apellidos, telefono, correo_institucional, id_especialidad)
VALUES 
    (1, 'CMP-45821', 'Roberto', 'Mendoza Carpio', '958778899', 'rmendoza@consultorio.pe', 1),
    (2, 'CMP-51204', 'Elena', 'Villanueva Paz', '958334455', 'evillanueva@consultorio.pe', 2),
    (3, 'CMP-38910', 'Carlos', 'Montesinos Prado', '954112288', 'cmontesinos@consultorio.pe', 3),
    (4, 'CMP-60142', 'Patricia', 'Quispe Huaman', '952667744', 'pquispe@consultorio.pe', 4),
    (5, 'CMP-48731', 'Andres', 'Bustamante Zeballos', '951009988', 'abustamante@consultorio.pe', 5);

-- 7. ESTADO_CITA
INSERT INTO ESTADO_CITA (id_estado, nombre_estado)
VALUES 
    (1, 'Programada'),
    (2, 'Confirmada'),
    (3, 'Atendida'),
    (4, 'Cancelada'),
    (5, 'Reprogramada');

-- 8. CITA
INSERT INTO CITA (id_cita, fcha_cita, hora_cita, motivo_reserva, id_paciente, id_psiquiatra, id_estado)
VALUES 
    (1, '2026-10-10', '09:30', 'Evaluación inicial por cuadro ansioso', 1, 1, 3),
    (2, '2026-10-12', '16:00', 'Evaluación clínica por insomnio prolongado', 2, 1, 3),
    (3, '2026-10-15', '11:00', 'Consulta por desgano y fatiga constante', 3, 2, 3),
    (4, '2026-10-18', '17:30', 'Evaluación por cambios de ánimo severos', 4, 4, 3),
    (5, '2026-10-20', '08:30', 'Crisis de estrés y sobrecarga laboral', 5, 5, 3);

-- 9. CONSULTA (Incluye datos JSONB de ejemplo en evaluacion_psicometrica)
INSERT INTO CONSULTA (id_consulta, fcha_consulta, motivo_atencion, diagnostico_ppal, nota_evolucion, evaluacion_psicometrica, id_cita)
VALUES 
    (1, '2026-10-10', 'Crisis de ansiedad e inquietud constante', 'F41.1 Trastorno de ansiedad generalizada', 'Paciente orientada, se inicia esquema farmacológico y psicoterapia.', '{"escala": "GAD-7", "puntaje_total": 16, "severidad": "Severa", "items": [3,2,3,2,2,2,2]}'::jsonb, 1),
    (2, '2026-10-12', 'Dificultad severa para conciliar el sueño', 'G47.0 Trastorno de inicio del sueño', 'Se pautan medidas de higiene del sueño y tratamiento nocturno por 30 días.', '{"escala": "ISI", "puntaje_total": 18, "severidad": "Insomnio clínico moderado"}'::jsonb, 2),
    (3, '2026-10-15', 'Apatía persistente y tristeza no reactiva', 'F32.1 Episodio depresivo moderado', 'Se explican pautas de alerta y se programa reevaluación quincenal.', '{"escala": "PHQ-9", "puntaje_total": 14, "severidad": "Moderada", "riesgo_suicida": false}'::jsonb, 3),
    (4, '2026-10-18', 'Irritabilidad extrema y consumo problemático', 'F10.1 Uso nocivo de sustancias', 'Se coordina abordaje interdisciplinario y monitoreo estrecho.', NULL, 4),
    (5, '2026-10-20', 'Cefalea tensional asociada a sobrecarga', 'F43.2 Trastorno de adaptación con ansiedad', 'Evolución favorable en consulta; se indican técnicas de relajación.', '{"escala": "GAD-7", "puntaje_total": 9, "severidad": "Leve"}'::jsonb, 5);

-- 10. PRESENTACION
INSERT INTO PRESENTACION (id_presentacion, descripcion_forma)
VALUES
    (1, 'Tableta recubierta'),
    (2, 'Cápsula'),
    (3, 'Solución oral en gotas');

-- 11. MEDICAMENTO
INSERT INTO MEDICAMENTO (id_medicamento, nombre_comercial, principio_activo, concentracion, id_presentacion)
VALUES
    (1, 'Zoloft', 'Sertralina', '50 mg', 1),
    (2, 'Lexapro', 'Escitalopram', '10 mg', 1),
    (3, 'Rivotril', 'Clonazepam', '2.5 mg/ml', 3);

-- 12. RECETA
INSERT INTO RECETA (id_receta, num_receta, fcha_emision, vigencia_dias, id_consulta)
VALUES
    (1, 'REC-2026-001', '2026-10-10', 30, 1),
    (2, 'REC-2026-002', '2026-10-15', 30, 3);

-- 13. DETALLE_RECETA
INSERT INTO DETALLE_RECETA (id_detalle, dosis, frecuencia_hrs, duracion_dias, indicacion_adicional, id_receta, id_medicamento)
VALUES
    (1, '1 tableta (50 mg)', 24, 30, 'Tomar después del desayuno', 1, 1),
    (2, '1 tableta (10 mg)', 24, 30, 'Tomar por la mañana', 2, 2);

-- 14. COMPROBANTE
INSERT INTO COMPROBANTE (id_comprobante, serie_numero, fcha_emision, monto_total, id_consulta)
VALUES 
    (1, 'B001-000101', '2026-10-10', 180.00, 1),
    (2, 'B001-000102', '2026-10-12', 180.00, 2),
    (3, 'B001-000103', '2026-10-15', 200.00, 3),
    (4, 'B001-000104', '2026-10-18', 220.00, 4),
    (5, 'B001-000105', '2026-10-20', 190.00, 5);

-- 15. FORMA_PAGO
INSERT INTO FORMA_PAGO (id_forma_pago, nombre_forma)
VALUES
    (1, 'Efectivo'),
    (2, 'Tarjeta Crédito/Débito'),
    (3, 'Transferencia / Yape / Plin');

-- 16. PAGO
INSERT INTO PAGO (id_pago, fcha_pago, monto_abonado, num_operacion, id_comprobante, id_forma_pago)
VALUES
    (1, '2026-10-10', 180.00, 'OP-998121', 1, 3),
    (2, '2026-10-12', 180.00, NULL, 2, 1),
    (3, '2026-10-15', 200.00, 'OP-998450', 3, 2);

-- ============================================================================
-- CONSULTAS DE MODIFICACIÓN (UPDATE)
-- ============================================================================
UPDATE PACIENTE SET telefono = '959998877', correo_electronico = 'carlos.huaylla@email.com' WHERE id_paciente = 2;
UPDATE HISTORIA_CLINICA SET observacion_gral = 'Se adjuntan resultados de perfil tiroideo; paciente responde favorablemente.' WHERE num_expediente = 'EXP-2026-001';
UPDATE PSIQUIATRA SET correo_institucional = 'roberto.mendoza@redpsiquiatrica.pe' WHERE cmp = 'CMP-45821';
UPDATE CITA SET fcha_cita = '2026-10-25', hora_cita = '15:00', id_estado = 2 WHERE id_cita = 1;
UPDATE COMPROBANTE SET monto_total = 160.00 WHERE serie_numero = 'B001-000101';

-- ============================================================================
-- SINCRONIZACIÓN DE SECUENCIAS SERIAL PARA NUEVOS INSERTS DESDE LA API
-- ============================================================================
SELECT setval('paciente_id_paciente_seq', (SELECT MAX(id_paciente) FROM PACIENTE));
SELECT setval('historia_clinica_id_historia_seq', (SELECT MAX(id_historia) FROM HISTORIA_CLINICA));
SELECT setval('tipo_antecedente_id_tipo_antecedente_seq', (SELECT MAX(id_tipo_antecedente) FROM TIPO_ANTECEDENTE));
SELECT setval('antecedente_id_antecedente_seq', (SELECT MAX(id_antecedente) FROM ANTECEDENTE));
SELECT setval('especialidad_id_especialidad_seq', (SELECT MAX(id_especialidad) FROM ESPECIALIDAD));
SELECT setval('psiquiatra_id_psiquiatra_seq', (SELECT MAX(id_psiquiatra) FROM PSIQUIATRA));
SELECT setval('estado_cita_id_estado_seq', (SELECT MAX(id_estado) FROM ESTADO_CITA));
SELECT setval('cita_id_cita_seq', (SELECT MAX(id_cita) FROM CITA));
SELECT setval('consulta_id_consulta_seq', (SELECT MAX(id_consulta) FROM CONSULTA));
SELECT setval('presentacion_id_presentacion_seq', (SELECT MAX(id_presentacion) FROM PRESENTACION));
SELECT setval('medicamento_id_medicamento_seq', (SELECT MAX(id_medicamento) FROM MEDICAMENTO));
SELECT setval('receta_id_receta_seq', (SELECT MAX(id_receta) FROM RECETA));
SELECT setval('detalle_receta_id_detalle_seq', (SELECT MAX(id_detalle) FROM DETALLE_RECETA));
SELECT setval('comprobante_id_comprobante_seq', (SELECT MAX(id_comprobante) FROM COMPROBANTE));
SELECT setval('forma_pago_id_forma_pago_seq', (SELECT MAX(id_forma_pago) FROM FORMA_PAGO));
SELECT setval('pago_id_pago_seq', (SELECT MAX(id_pago) FROM PAGO));

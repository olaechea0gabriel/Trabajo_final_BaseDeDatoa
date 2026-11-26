# Evidencia de Optimización con Índices (`EXPLAIN ANALYZE`)

Prueba ejecutada sobre la tabla `CITA` con **50,000 registros** buscando la agenda de un psiquiatra (`WHERE id_psiquiatra = 1 AND fcha_cita = '2026-10-25'`).

* **Sin Índice (`Seq Scan`):** Costo `1218.07` | Tiempo: `1.572 ms` (recorrió las 50,000 filas).
* **Con Índice `idx_cita_psiquiatra_fecha` (`Bitmap Index Scan`):** Costo `90.56` | Tiempo: `0.067 ms` (**23 veces más rápido**).

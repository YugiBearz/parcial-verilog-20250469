# Registro de Asistencia por IA — Sistemas Digitales (ITLA)

**Estudiante:** Urik Valenzuela · Matrícula: 20250469  
**Asignatura:** Sistemas Digitales con FPGA · Reto 14: Procesador de Verificación  

| Fecha | Herramienta | Prompt / Consulta Realizada | Resumen de Acción y Respuesta | Verificación Humana |
| :--- | :--- | :--- | :--- | :--- |
| 2026-10-06 | Antigravity AI | "Lectura del mandato y tutorial de parcial, configuración del proyecto" | Planificación de la estructura de carpetas, reglas Verilog 2005 y configuración inicial de Git | Revisión de carpetas creadas y validación de identidad en terminal |
| 2026-10-07 | Antigravity AI | "Análisis de mapas de Karnaugh y deducción SOP para u y v" | Generación de tabla de 16 estados, K-maps 4x4, implicantes esenciales y respuestas a preguntas del reto | Revisión de minitérminos, agrupaciones y conteo de literales |
| 2026-10-07 | Antigravity AI | "Implementación RTL de módulos de control, datapath y registro" | Redacción de control_logic.v, datapath.v y result_register.v en Verilog 2001 sin latches, validados con Verilator | Verificación de sintaxis, reglas de estilo y cero warnings de linter |
| 2026-10-07 | Antigravity AI | "Integración estructural de la unidad digital en top_20250469" | Creación de top_20250469.v interconectando los tres módulos RTL con puertos de observabilidad | Inspección visual de la jerarquía de señales |
| 2026-10-07 | Antigravity AI | "Diseño de testbench exhaustivo y funciones de verificación dorada" | Creación del andamiaje base de tb_top_20250469.v con generador de reloj a 50 MHz y Golden Model | Inspección de funciones lógicas de referencia y tiempos de reloj |
| 2026-10-07 | Antigravity AI | "Implementación del bucle de 4096 vectores de prueba exhaustivos" | Adición de tarea de prueba con barrido exhaustivo 16x16x16 verificando u, v, Y, flag_comb, Q y flag_q | Supervisión de condiciones de flanco de reloj y tolerancias temporales |
| 2026-10-07 | Antigravity AI | "Casos temporales de esquina, VCD y automatización Makefile" | Adición de 12 pruebas de esquina temporales, volcado VCD, script Makefile y ejecución exitosa de simulación | Ejecución de make check y validación de 0 fallos |
| 2026-10-08 | Antigravity AI | "Implementación de sincronizador de dos etapas contra metaestabilidad" | Creación de sync2ff.v parametrizable para mitigar metaestabilidad en entradas físicas de FPGA | Revisión de estructura de biestables en cascada y análisis de linter Verilator |
| 2026-10-08 | Antigravity AI | "Verificación de latencia y propagación de sync2ff" | Creación y ejecución de tb_sync2ff.v confirmando latencia exacta de 2 ciclos e inmunidad asíncrona | Verificación de formas de onda y paso de pruebas unitarias |
| 2026-10-08 | Antigravity AI | "Definición de puertos e interfaz física de tang_top_20250469" | Especificación de puertos físicos para Tang Primer 25K con inversión de pulsador activo en bajo y cableado interno | Validación de polaridades y nomenclatura de pines |








# Primer Parcial — Sistemas Digitales con FPGA (ITLA)
## Reto 14: Procesador de Verificación

- **Estudiante:** Urik Camilo Valenzuela Flynn
- **Matrícula:** 20250469
- **Correo Institucional:** 20250469@itla.edu.do
- **Placa de Desarrollo:** Sipeed Tang Primer 25K (Gowin GW5A-LV25MG121)
- **Repositorio Oficial:** [GitHub - YugiBearz/parcial-verilog-20250469](https://github.com/YugiBearz/parcial-verilog-20250469)
- **Versión de Entrega:** `v1.0-entrega`

---

### Descripción del Proyecto
Diseño, implementación, simulación y verificación en Verilog 2001 de una unidad digital de procesamiento para FPGA que opera sobre dos operandos sin signo de 4 bits (`A` y `B`), decodifica una operación aritmética o lógica mediante 4 variables de control (`a, b, c, d`) minimizadas por Mapas de Karnaugh, y almacena el resultado junto a sus banderas en un registro de salida con habilitador y reset asíncrono. El diseño incluye un adaptador físico con 8 sincronizadores de doble biestable (2FF) para mitigar metaestabilidad en las 13 entradas del Sipeed Tang Primer 25K.

### Especificaciones del Reto 14
- **Lógica de Control Minimizada (SOP):**
  - $u(a,b,c,d) = \sum m(1, 5, 9, 10, 11, 12, 13, 14, 15) = ab + ac + \bar{c}d$
  - $v(a,b,c,d) = \sum m(2, 4, 5, 6, 7, 10, 13, 14, 15) = \bar{a}b + bd + c\bar{d}$
- **Operaciones del Datapath {v, u}:**
  - `00` $\rightarrow$ **XOR:** $Y = A \oplus B$, `flag` = paridad impar (`^Y`).
  - `01` $\rightarrow$ **SUMA:** $Y = (A + B)[3:0]$, `flag` = acarreo de salida ($A + B > 15$).
  - `10` $\rightarrow$ **MAYOR:** $Y = \max(A, B)$, `flag` = igualdad ($A == B$).
  - `11` $\rightarrow$ **RESTA:** $Y = (A - B)[3:0]$, `flag` = préstamo ($A < B$).

---

### Estado del Desarrollo
- [x] **Paso 01-03:** Estructura del proyecto, .gitignore y configuración de control de versiones.
- [x] **Fase 1:** Tablas de verdad de 16 estados, mapas de Karnaugh, esquemáticos y preguntas teóricas (`docs/analisis_karnaugh.md`).
- [x] **Fase 2:** Implementación RTL en Verilog 2001 (`control_logic.v`, `datapath.v`, `result_register.v`) validados con Verilator.
- [x] **Fase 3:** Integración estructural (`top_20250469.v`) y testbench exhaustivo (`sim/tb_top_20250469.v`) con 4096 vectores y 12 pruebas temporales.
- [x] **Fase 4:** Adaptador físico para Tang Primer 25K (`tang_top_20250469.v`, `sync2ff.v`), restricciones `top.cst`, temporización `top.sdc` y mapa de pines.
- [x] **Fase 5:** Automatización con Makefile, script Tcl para Gowin EDA, bitácora de IA completada y versión etiquetada `v1.0-entrega`.

---

### Organización del Repositorio
- `src/`: Módulos RTL en Verilog 2001 (`control_logic.v`, `datapath.v`, `result_register.v`, `top_20250469.v`, `sync2ff.v`, `tang_top_20250469.v`).
- `sim/`: Bancos de prueba (`tb_top_20250469.v`, `tb_sync2ff.v`) y registro de resultados de simulación.
- `docs/`: Análisis teórico (`analisis_karnaugh.md`), mapa de pines (`mapa_de_pines.md`) y guía Gowin (`guia_gowin_eda.md`).
- `fpga/`: Restricciones físicas (`top.cst`), temporización (`top.sdc`) y script de automatización (`run_gowin.tcl`).
- `evidencias/`: Plantilla para fotografías del montaje y enlace al video demostrativo (`README.md`).
- `README.md`: Identificación, estado del proyecto e instrucciones de reproducción.
- `AI_LOG.md`: Bitácora de asistencia por inteligencia artificial y registro de auditoría.
- `Makefile`: Automatización de compilación, simulación, linting y síntesis.
- `.gitignore`: Exclusión de artefactos compilados y temporales.

---

### Instrucciones de Reproducción y Verificación

El proyecto está completamente automatizado y puede ejecutarse tanto desde la terminal como directamente desde la interfaz gráfica de **VS Code / VSCodium**.

---

#### Opción A: Desde la Interfaz Gráfica de VS Code / VSCodium (Recomendado)

El repositorio incluye la configuración oficial [`.vscode/tasks.json`](.vscode/tasks.json) que permite compilar, simular, sintetizar y programar con un solo clic o atajo de teclado:

1. **Abrir el Menú de Tareas:**
   * Presiona `Ctrl + Shift + P` (o `Cmd + Shift + P` en macOS) y escribe:  
     `Tasks: Run Task` (o accede en el menú superior a **Terminal > Run Task...**).
2. **Seleccionar la Acción Deseada:**
   * **`1. Verilog: Testbench & Lint`** (`Ctrl + Shift + B` como tarea de prueba):  
     Ejecuta la simulación completa de los 4,096 vectores, los 12 casos temporales y valida el diseño con el linter Verilator (-Wall).
   * **`2. FPGA: Build Bitstream`** (`Ctrl + Shift + B` como compilación por defecto):  
     Invoca el sintetizador de Gowin EDA en modo batch en segundo plano y genera el bitstream físico `fpga/impl/pnr/tang_top_20250469.fs`.
   * **`3. FPGA: Upload to Board (SRAM)`**:  
     Carga el bitstream a la memoria volátil SRAM de la Tang Primer 25K mediante `openFPGALoader` para pruebas rápidas en la placa.
   * **`4. FPGA: Flash to Board (Permanent)`**:  
     Graba el bitstream en la memoria SPI Flash integrada para que el diseño persista al desconectar la alimentación.

---

#### Opción B: Desde la Terminal Integrada (Makefile)

Si prefieres ejecutar los comandos manualmente desde la terminal de Linux:

1. **Ejecutar Verificación Exhaustiva (4096 vectores + 12 pruebas temporales):**
   ```bash
   make check
   ```

2. **Ejecutar Verificación Unitaria del Sincronizador 2FF:**
   ```bash
   make check-sync
   ```

3. **Verificar Reglas de Linter sin Advertencias (Verilator):**
   ```bash
   make lint
   ```

4. **Visualizar Formas de Onda de Simulación (GTKWave):**
   ```bash
   make wave
   ```

5. **Compilar y Generar Bitstream para FPGA (Gowin EDA):**
   ```bash
   make fpga
   ```

6. **Cargar Bitstream a la Placa (SRAM volátil):**
   ```bash
   make prog
   ```

7. **Grabar Bitstream en la Placa (Flash permanente):**
   ```bash
   make flash
   ```

---

### Resumen de Métricas de Verificación
- **Vectores Combinacionales Probados:** 4,096 / 4,096 (**0 errores — 100% PASS**).
- **Pruebas Temporales de Esquina:** 12 / 12 (**0 errores — 100% PASS**).
- **Pruebas de Sincronizador 2FF:** Inmunidad asíncrona y latencia de 2 ciclos (**100% PASS**).
- **Linter Verilator (-Wall):** 0 errores, 0 advertencias.
- **Reloj del Sistema:** 50 MHz (Periodo = 20.0 ns, SDC verificado).
- **Video Demostrativo en YouTube:** [https://youtu.be/Fu_dqSa0cHM](https://youtu.be/Fu_dqSa0cHM)
- **Evidencias y Fotografía:** [evidencias/README.md](evidencias/README.md)
- **Versión Oficial Evaluada:** Etiqueta Git `v1.0-entrega`.

# Guía de Compilación, Síntesis y Programación en Gowin EDA
## Reto 14: Procesador de Verificación (Sipeed Tang Primer 25K)

- **Estudiante:** Urik Camilo Valenzuela Flynn · Matrícula: 20250469
- **Asignatura:** Sistemas Digitales con FPGA (ITLA)
- **Docente:** Prof. Wilkins Gabriel Cedano Del Rosario

---

## 1. Parámetros del Dispositivo en Gowin EDA

| Parámetro | Configuración Oficial |
| :--- | :--- |
| **Dispositivo (Device):** | GW5A-25A |
| **Part Number:** | GW5A-LV25MG121NC1/I0 |
| **Package:** | MBGA121 |
| **Speed Grade:** | C1/I0 |
| **Voltaje de Núcleo:** | LV (1.0V) |

---

## 2. Flujo de Trabajo en Gowin EDA (Modo Gráfico)

1. **Crear o Abrir Proyecto:**
   - Nombre del proyecto: `parcial_reto14_20250469`.
   - Seleccionar el dispositivo `GW5A-LV25MG121NC1/I0`.
2. **Importar Archivos Fuente (RTL):**
   - Desde la pestaña *Design*: añadir los archivos dentro de la carpeta `src/`:
     - `src/control_logic.v`
     - `src/datapath.v`
     - `src/result_register.v`
     - `src/top_20250469.v`
     - `src/sync2ff.v`
     - `src/tang_top_20250469.v` (Establecer como módulo superior: **Set as Top Module**).
3. **Importar Restricciones Físicas y de Temporización:**
   - En *Physical Constraints*: añadir `fpga/top.cst`.
   - En *Timing Constraints*: añadir `fpga/top.sdc`.
4. **Ejecutar el Flujo de Implementación:**
   - Hacer doble clic en **Synthesize** para procesar la lógica combinacional y secuencial.
   - Hacer doble clic en **Place & Route** para realizar el enrutamiento físico y análisis estático de tiempos (STA).
   - El sistema generará el archivo de configuración binario (*bitstream*) con extensión `.fs` dentro de `impl/pnr/`.

---

## 3. Estimación y Uso de Recursos de Hardware
- **Elementos Lógicos (LUT4):** Menos del 1% del total disponible (arquitectura altamente optimizada).
- **Registros (Flip-Flops):** 5 biestables en `result_register` + 16 biestables en los 8 sincronizadores `sync2ff` = 21 FFs.
- **Pines de Entrada/Salida (I/O Pins):** 13 entradas + 7 salidas = 20 pines de usuario LVCMOS33.
- **Frecuencia Máxima Estimada ($F_{\max}$):** > 150 MHz (ampliamente holgado frente a los 50 MHz del oscilador `sys_clk`).

---

## 4. Programación en la Placa Sipeed Tang Primer 25K

1. Conectar la placa Tang Primer 25K al computador mediante cable USB-C (conector UART/JTAG).
2. Abrir **Gowin Programmer** desde las herramientas de Gowin EDA.
3. Presionar **Scan Device** para detectar el chip GW5A-25.
4. Seleccionar el modo de programación:
   - **SRAM Mode:** Carga el bitstream en la memoria RAM volátil para pruebas inmediatas y desarrollo rápido.
   - **embFlash Mode:** Graba permanentemente en la memoria Flash interna del chip para que el circuito arranque de forma autónoma al conectar la alimentación.
5. Seleccionar el archivo bitstream generado (`tang_top_20250469.fs`).
6. Presionar **Program/Configure**. Tras unos segundos, los LEDs de la placa cobrarán vida reflejando la operación seleccionada.

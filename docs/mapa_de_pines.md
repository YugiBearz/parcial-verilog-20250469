# Mapa de Pines y Restricciones Físicas — Reto 14
## Tarjeta de Desarrollo: Sipeed Tang Primer 25K (Gowin GW5A-LV25MG121)

- **Estudiante:** Urik Camilo Valenzuela Flynn
- **Matrícula:** 20250469
- **Asignatura:** Sistemas Digitales con FPGA (ITLA)
- **Docente:** Prof. Wilkins Gabriel Cedano Del Rosario

---

## 1. Descripción de la Interfaz Física

El diseño implementado en la FPGA requiere una interfaz física para conectar el oscilador de reloj, los elementos de entrada mecánica (pulsadores y DIP switches) y los indicadores visuales (LEDs). Todos los pines operan bajo el estándar de E/S **LVCMOS33** (3.3V).

Para garantizar la integridad de las señales y evitar estados indeterminados por ruido de conmutación:
- Las entradas mecánicas cuentan con resistencias internas de polarización (`PULL_MODE=UP` para pulsadores activos en bajo y `PULL_MODE=DOWN` para switches activos en alto).
- Cada una de las 13 entradas pasa por un módulo de doble biestable (`sync2ff`) para mitigar cualquier riesgo de metaestabilidad.
- Las salidas a LEDs están configuradas con una capacidad de corriente de 8 mA (`DRIVE=8`).

---

## 2. Tabla de Asignación de Pines por Conector / Dock PMOD (Según Serigrafía de la Placa)

Las entradas y salidas del sistema se encuentran agrupadas físicamente en los tres conectores PMOD de la placa base (Dock) de la Sipeed Tang Primer 25K:
- **Dock F5:** Switches de control `sw_ctrl[3:0]` (`a, b, c, d`) + 2 Pulsadores (`btn_rst_n` y `btn_en`).
- **Dock G11:** Switches de datos de entrada: Operando `sw_A[3:0]` (Fila superior) y Operando `sw_B[3:0]` (Fila inferior).
- **Dock A11:** Salidas a LEDs: `led_Q[3:0]`, `led_flag`, `led_u` y `led_v`.

| Puerto RTL | Pin Físico | Conector Dock | Posición Fila / Serigrafía | Dirección | Estándar I/O | Polarización / Drive | Componente Externo / Placa | Descripción Funcional |
| :--- | :---: | :---: | :---: | :---: | :---: | :--- | :--- | :--- |
| `sys_clk` | `E2` | Onboard | N/A | Entrada | LVCMOS33 | Ninguna | Cristal Oscilador 50 MHz | Señal de reloj maestra del sistema (periodo 20.0 ns). |
| `sw_ctrl[3]` | `H5` | **Dock F5** | Top, Pin 4 (`H5`) | Entrada | LVCMOS33 | Pull-down (`DOWN`) | DIP Switch Control bit 3 (`a`) | Variable de control $a$ (MSB de selector). |
| `sw_ctrl[2]` | `H8` | **Dock F5** | Top, Pin 3 (`H8`) | Entrada | LVCMOS33 | Pull-down (`DOWN`) | DIP Switch Control bit 2 (`b`) | Variable de control $b$. |
| `sw_ctrl[1]` | `G7` | **Dock F5** | Top, Pin 2 (`G7`) | Entrada | LVCMOS33 | Pull-down (`DOWN`) | DIP Switch Control bit 1 (`c`) | Variable de control $c$. |
| `sw_ctrl[0]` | `G8` | **Dock F5** | Bottom, Pin 2 (`G8`) | Entrada | LVCMOS33 | Pull-down (`DOWN`) | DIP Switch Control bit 0 (`d`) | Variable de control $d$ (LSB de selector). |
| `btn_rst_n` | `G5` | **Dock F5** | Bottom, Pin 1 (`G5`) | Entrada | LVCMOS33 | Pull-up (`UP`) | Pulsador Reset (KEY1) | Reset asíncrono del sistema (activo en bajo, $0 = \text{Reset}$). |
| `btn_en` | `F5` | **Dock F5** | Top, Pin 1 (`F5`) | Entrada | LVCMOS33 | Pull-down (`DOWN`) | Pulsador / Switch Enable (KEY2) | Habilitador de captura del registro (nivel alto). |
| `sw_A[3]` | `C11` | **Dock G11** | Top, Pin 4 (`C11`) | Entrada | LVCMOS33 | Pull-down (`DOWN`) | DIP Switch A bit 3 ($A_3$) | Bit 3 del operando A (MSB). |
| `sw_A[2]` | `B11` | **Dock G11** | Top, Pin 3 (`B11`) | Entrada | LVCMOS33 | Pull-down (`DOWN`) | DIP Switch A bit 2 ($A_2$) | Bit 2 del operando A. |
| `sw_A[1]` | `D11` | **Dock G11** | Top, Pin 2 (`D11`) | Entrada | LVCMOS33 | Pull-down (`DOWN`) | DIP Switch A bit 1 ($A_1$) | Bit 1 del operando A. |
| `sw_A[0]` | `G11` | **Dock G11** | Top, Pin 1 (`G11`) | Entrada | LVCMOS33 | Pull-down (`DOWN`) | DIP Switch A bit 0 ($A_0$) | Bit 0 del operando A (LSB). |
| `sw_B[3]` | `C10` | **Dock G11** | Bottom, Pin 4 (`C10`) | Entrada | LVCMOS33 | Pull-down (`DOWN`) | DIP Switch B bit 3 ($B_3$) | Bit 3 del operando B (MSB). |
| `sw_B[2]` | `B10` | **Dock G11** | Bottom, Pin 3 (`B10`) | Entrada | LVCMOS33 | Pull-down (`DOWN`) | DIP Switch B bit 2 ($B_2$) | Bit 2 del operando B. |
| `sw_B[1]` | `D10` | **Dock G11** | Bottom, Pin 2 (`D10`) | Entrada | LVCMOS33 | Pull-down (`DOWN`) | DIP Switch B bit 1 ($B_1$) | Bit 1 del operando B. |
| `sw_B[0]` | `G10` | **Dock G11** | Bottom, Pin 1 (`G10`) | Entrada | LVCMOS33 | Pull-down (`DOWN`) | DIP Switch B bit 0 ($B_0$) | Bit 0 del operando B (LSB). |
| `led_Q[3]` | `A11` | **Dock A11** | Top, Pin 1 (`A11`) | Salida | LVCMOS33 | Drive 8mA | Diodo LED Q3 | Bit 3 del resultado registrado $Q$. |
| `led_Q[2]` | `E11` | **Dock A11** | Top, Pin 2 (`E11`) | Salida | LVCMOS33 | Drive 8mA | Diodo LED Q2 | Bit 2 del resultado registrado $Q$. |
| `led_Q[1]` | `K11` | **Dock A11** | Top, Pin 3 (`K11`) | Salida | LVCMOS33 | Drive 8mA | Diodo LED Q1 | Bit 1 del resultado registrado $Q$. |
| `led_Q[0]` | `L5` | **Dock A11** | Top, Pin 4 (`L5`) | Salida | LVCMOS33 | Drive 8mA | Diodo LED Q0 | Bit 0 del resultado registrado $Q$. |
| `led_flag` | `A10` | **Dock A11** | Bottom, Pin 1 (`A10`) | Salida | LVCMOS33 | Drive 8mA | Diodo LED FLAG | Bandera registrada de la operación activa. |
| `led_u` | `E10` | **Dock A11** | Bottom, Pin 2 (`E10`) | Salida | LVCMOS33 | Drive 8mA | Diodo LED U | Indicador en tiempo real de señal de control $u$. |
| `led_v` | `L11` | **Dock A11** | Bottom, Pin 3 (`L11`) | Salida | LVCMOS33 | Drive 8mA | Diodo LED V | Indicador en tiempo real de señal de control $v$. |

---

## 3. Disposición de Pines en Conectores PMOD (Vista Frontal del Header)

Cada conector PMOD en el Dock posee 12 pines distribuidos en dos filas de 6 pines (paso 2.54 mm):

```text
       Fila Superior (Pines 1 a 6)     Fila Inferior (Pines 7 a 12)
       [ 1 ] [ 2 ] [ 3 ] [ 4 ] [GND] [3V3]   <-- Pines 1, 2, 3, 4, 5 (GND), 6 (VCC)
       [ 7 ] [ 8 ] [ 9 ] [10 ] [GND] [3V3]   <-- Pines 7, 8, 9, 10, 11 (GND), 12 (VCC)
```

- **Alimentación Común:** Los pines 6 y 12 entregan 3.3V (`VCC`); los pines 5 y 11 son masa (`GND`).
- **Conexión a Protoboard:** Llevar cables Dupont hembra-macho desde cada conector hacia los buses de alimentación y líneas de señal en la protoboard.

---

## 4. Consideraciones Eléctricas de la Tang Primer 25K
- **Tensión de Banco:** Todos los bancos donde residen estos pines están alimentados a VCCIO = 3.3V.
- **Inversión de Lógica en Botones:** El pulsador físico conecta el pin a masa cuando se oprime; el módulo `tang_top_20250469` invierte esta señal mediante `assign rst_raw = ~btn_rst_n;` para entregar una lógica positiva limpia y predecible al núcleo síncrono.

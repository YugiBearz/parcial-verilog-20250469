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

## 2. Tabla de Asignación de Pines (Pinout Oficial)

| Puerto RTL | Pin Físico | Dirección | Estándar I/O | Polarización / Drive | Componente Físico en Placa | Descripción Funcional |
| :--- | :---: | :---: | :---: | :---: | :--- | :--- |
| `sys_clk` | `E2` | Entrada | LVCMOS33 | Ninguna | Cristal Oscilador 50 MHz | Señal de reloj maestra del sistema (periodo 20.0 ns). |
| `btn_rst_n` | `H11` | Entrada | LVCMOS33 | Pull-up (`UP`) | Pulsador S1 (KEY1) | Reset asíncrono del sistema (activo en bajo, $0 = \text{Reset}$). |
| `btn_en` | `H10` | Entrada | LVCMOS33 | Pull-down (`DOWN`) | Pulsador S2 (KEY2) | Habilitador de captura del registro (nivel alto). |
| `sw_ctrl[3]` | `K5` | Entrada | LVCMOS33 | Pull-down (`DOWN`) | DIP Switch SW1-4 (`a`) | Variable de control $a$ (MSB de selector). |
| `sw_ctrl[2]` | `L5` | Entrada | LVCMOS33 | Pull-down (`DOWN`) | DIP Switch SW1-3 (`b`) | Variable de control $b$. |
| `sw_ctrl[1]` | `J5` | Entrada | LVCMOS33 | Pull-down (`DOWN`) | DIP Switch SW1-2 (`c`) | Variable de control $c$. |
| `sw_ctrl[0]` | `G5` | Entrada | LVCMOS33 | Pull-down (`DOWN`) | DIP Switch SW1-1 (`d`) | Variable de control $d$ (LSB de selector). |
| `sw_A[3]` | `F5` | Entrada | LVCMOS33 | Pull-down (`DOWN`) | DIP Switch SW2-4 ($A_3$) | Bit 3 del operando A (MSB). |
| `sw_A[2]` | `G7` | Entrada | LVCMOS33 | Pull-down (`DOWN`) | DIP Switch SW2-3 ($A_2$) | Bit 2 del operando A. |
| `sw_A[1]` | `F7` | Entrada | LVCMOS33 | Pull-down (`DOWN`) | DIP Switch SW2-2 ($A_1$) | Bit 1 del operando A. |
| `sw_A[0]` | `D7` | Entrada | LVCMOS33 | Pull-down (`DOWN`) | DIP Switch SW2-1 ($A_0$) | Bit 0 del operando A (LSB). |
| `sw_B[3]` | `E8` | Entrada | LVCMOS33 | Pull-down (`DOWN`) | DIP Switch SW3-4 ($B_3$) | Bit 3 del operando B (MSB). |
| `sw_B[2]` | `D8` | Entrada | LVCMOS33 | Pull-down (`DOWN`) | DIP Switch SW3-3 ($B_2$) | Bit 2 del operando B. |
| `sw_B[1]` | `C8` | Entrada | LVCMOS33 | Pull-down (`DOWN`) | DIP Switch SW3-2 ($B_1$) | Bit 1 del operando B. |
| `sw_B[0]` | `B8` | Entrada | LVCMOS33 | Pull-down (`DOWN`) | DIP Switch SW3-1 ($B_0$) | Bit 0 del operando B (LSB). |
| `led_Q[3]` | `L10` | Salida | LVCMOS33 | Drive 8mA | Diodo LED D4 ($Q_3$) | Bit 3 del resultado registrado $Q$. |
| `led_Q[2]` | `K10` | Salida | LVCMOS33 | Drive 8mA | Diodo LED D3 ($Q_2$) | Bit 2 del resultado registrado $Q$. |
| `led_Q[1]` | `J11` | Salida | LVCMOS33 | Drive 8mA | Diodo LED D2 ($Q_1$) | Bit 1 del resultado registrado $Q$. |
| `led_Q[0]` | `G11` | Salida | LVCMOS33 | Drive 8mA | Diodo LED D1 ($Q_0$) | Bit 0 del resultado registrado $Q$. |
| `led_flag` | `L11` | Salida | LVCMOS33 | Drive 8mA | Diodo LED D5 (`flag_q`) | Bandera registrada de la operación activa. |
| `led_u` | `K11` | Salida | LVCMOS33 | Drive 8mA | Diodo LED D6 (`u`) | Indicador en tiempo real de señal de control $u$. |
| `led_v` | `E10` | Salida | LVCMOS33 | Drive 8mA | Diodo LED D7 (`v`) | Indicador en tiempo real de señal de control $v$. |

---

## 3. Consideraciones Eléctricas de la Tang Primer 25K
- **Tensión de Banco:** Todos los bancos donde residen estos pines están alimentados a VCCIO = 3.3V.
- **Inversión de Lógica en Botones:** El pulsador físico conecta el pin a masa cuando se oprime; el módulo `tang_top_20250469` invierte esta señal mediante `assign rst_raw = ~btn_rst_n;` para entregar una lógica positiva limpia y predecible al núcleo síncrono.

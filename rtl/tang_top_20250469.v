// ============================================================================
// Asignatura: Sistemas Digitales con FPGA (ITLA)
// Estudiante: Urik Camilo Valenzuela Flynn · Matricula: 20250469
// Reto 14: Procesador de Verificacion
// Modulo: tang_top_20250469.v
// Descripcion: Modulo superior de integracion fisica para la tarjeta Sipeed
//              Tang Primer 25K (Gowin GW5A-LV25MG121).
//              - Reloj maestro de 50 MHz en pin E2.
//              - Adaptacion de polaridad para pulsadores activos en bajo.
//              - Interfaz de 13 entradas fisicas (switches y botones).
//              - Salidas a diodos LED integrados en la placa.
// ============================================================================

`timescale 1ns / 1ps

module tang_top_20250469 (
    input  wire       sys_clk,    // Oscilador de 50 MHz (Pin E2)
    input  wire       btn_rst_n,  // Pulsador de Reset (Activo en bajo, hardware)
    input  wire       btn_en,     // Pulsador/Switch de Enable
    input  wire [3:0] sw_ctrl,    // Switches de control: sw_ctrl[3:0] = {a, b, c, d}
    input  wire [3:0] sw_A,       // Switches para operando A[3:0]
    input  wire [3:0] sw_B,       // Switches para operando B[3:0]
    output wire [3:0] led_Q,      // LEDs para el resultado registrado Q[3:0]
    output wire       led_flag,   // LED para la bandera registrada flag_q
    output wire       led_u,      // LED para la señal u de control
    output wire       led_v       // LED para la señal v de control
);

    // ------------------------------------------------------------------------
    // 1. Acondicionamiento de polaridad de entradas
    // ------------------------------------------------------------------------
    // En el Tang Primer 25K, los pulsadores conectan a GND al presionarse (activo en bajo).
    // Invertimos la señal para obtener un reset activo en alto para el nucleo RTL.
    wire rst_raw;
    assign rst_raw = ~btn_rst_n;

    wire en_raw;
    assign en_raw  = btn_en;

    // Desglose de variables de control {a, b, c, d}
    wire a_raw = sw_ctrl[3];
    wire b_raw = sw_ctrl[2];
    wire c_raw = sw_ctrl[1];
    wire d_raw = sw_ctrl[0];

    // Buses de datos crudos
    wire [3:0] A_raw = sw_A;
    wire [3:0] B_raw = sw_B;

    // ------------------------------------------------------------------------
    // 2. Declaracion de buses sincronizados (13 canales en total)
    // ------------------------------------------------------------------------
    wire       rst_sync;
    wire       en_sync;
    wire       a_sync;
    wire       b_sync;
    wire       c_sync;
    wire       d_sync;
    wire [3:0] A_sync;
    wire [3:0] B_sync;

    // Señales de observabilidad generadas por el nucleo
    wire       u_core;
    wire       v_core;
    wire [3:0] Y_core;
    wire       flag_comb_core;
    wire [3:0] Q_core;
    wire       flag_q_core;

    // Asignacion directa de salidas a los pines de los LEDs
    assign led_Q    = Q_core;
    assign led_flag = flag_q_core;
    assign led_u    = u_core;
    assign led_v    = v_core;

endmodule

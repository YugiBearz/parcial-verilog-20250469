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
//              - 8 sincronizadores 2FF en cascada contra metaestabilidad.
//              - Salidas a diodos LED integrados en la placa.
// ============================================================================

`timescale 1ns / 1ps

/* verilator lint_off SIMILARNAME */
/* verilator lint_off PINCONNECTEMPTY */
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
    // 2. Declaracion de buses sincronizados (13 canales de entrada protegidos)
    // ------------------------------------------------------------------------
    wire       rst_sync;
    wire       en_sync;
    wire       a_sync;
    wire       b_sync;
    wire       c_sync;
    wire       d_sync;
    wire [3:0] A_sync;
    wire [3:0] B_sync;

    // Señales de observabilidad generadas por el nucleo hacia los LEDs
    wire       core_u;
    wire       core_v;
    wire [3:0] core_Q;
    wire       core_flag_q;

    // ------------------------------------------------------------------------
    // 3. Instanciacion de sincronizadores 2FF (13 canales de proteccion)
    // ------------------------------------------------------------------------
    // Sincronizador para Reset (1 bit)
    sync2ff #(.WIDTH(1)) u_sync_rst (
        .clk(sys_clk),
        .din(rst_raw),
        .dout(rst_sync)
    );

    // Sincronizador para Enable (1 bit)
    sync2ff #(.WIDTH(1)) u_sync_en (
        .clk(sys_clk),
        .din(en_raw),
        .dout(en_sync)
    );

    // Sincronizadores para variables de control (1 bit cada una)
    sync2ff #(.WIDTH(1)) u_sync_a (.clk(sys_clk), .din(a_raw), .dout(a_sync));
    sync2ff #(.WIDTH(1)) u_sync_b (.clk(sys_clk), .din(b_raw), .dout(b_sync));
    sync2ff #(.WIDTH(1)) u_sync_c (.clk(sys_clk), .din(c_raw), .dout(c_sync));
    sync2ff #(.WIDTH(1)) u_sync_d (.clk(sys_clk), .din(d_raw), .dout(d_sync));

    // Sincronizadores para buses de operandos A y B (4 bits cada uno)
    sync2ff #(.WIDTH(4)) u_sync_bus_A (
        .clk(sys_clk),
        .din(A_raw),
        .dout(A_sync)
    );

    sync2ff #(.WIDTH(4)) u_sync_bus_B (
        .clk(sys_clk),
        .din(B_raw),
        .dout(B_sync)
    );

    // ------------------------------------------------------------------------
    // 4. Instanciacion del nucleo del procesador digital
    // ------------------------------------------------------------------------
    top_20250469 inst_top_core (
        .clk(sys_clk),
        .rst(rst_sync),
        .en(en_sync),
        .a(a_sync),
        .b(b_sync),
        .c(c_sync),
        .d(d_sync),
        .A(A_sync),
        .B(B_sync),
        .u(core_u),
        .v(core_v),
        .Y(),
        .flag_comb(),
        .Q(core_Q),
        .flag_q(core_flag_q)
    );

    // Asignacion directa de salidas a los pines de los LEDs
    assign led_Q    = core_Q;
    assign led_flag = core_flag_q;
    assign led_u    = core_u;
    assign led_v    = core_v;

endmodule
/* verilator lint_on SIMILARNAME */

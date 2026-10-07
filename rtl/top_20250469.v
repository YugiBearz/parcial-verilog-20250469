// ============================================================================
// Asignatura: Sistemas Digitales con FPGA (ITLA)
// Estudiante: Urik Camilo Valenzuela Flynn · Matricula: 20250469
// Reto 14: Procesador de Verificacion
// Modulo: top_20250469.v
// Descripcion: Modulo superior para simulacion y verificacion que integra
//              estructuralmente la logica de control, el datapath y el registro
//              de salida. Expone tanto las señales combinacionales como las
//              salidas registradas para su observabilidad directa en el testbench.
// ============================================================================

`timescale 1ns / 1ps

/* verilator lint_off SIMILARNAME */
module top_20250469 (
    input  wire       clk,
    input  wire       rst,
    input  wire       en,
    input  wire       a,
    input  wire       b,
    input  wire       c,
    input  wire       d,
    input  wire [3:0] A,
    input  wire [3:0] B,
    output wire       u,
    output wire       v,
    output wire [3:0] Y,
    output wire       flag_comb,
    output wire [3:0] Q,
    output wire       flag_q
);

    // 1. Instanciacion de la logica de control minimizada (u, v)
    control_logic u_control_logic (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .u(u),
        .v(v)
    );

    // 2. Instanciacion del Datapath (Y, flag_comb)
    datapath u_datapath (
        .u(u),
        .v(v),
        .A(A),
        .B(B),
        .Y(Y),
        .flag_comb(flag_comb)
    );

    // 3. Instanciacion del Registro de salida (Q, flag_q)
    result_register u_result_register (
        .clk(clk),
        .rst(rst),
        .en(en),
        .Y(Y),
        .flag_comb(flag_comb),
        .Q(Q),
        .flag_q(flag_q)
    );

endmodule
/* verilator lint_on SIMILARNAME */


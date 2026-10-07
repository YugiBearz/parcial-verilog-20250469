// ============================================================================
// Asignatura: Sistemas Digitales con FPGA (ITLA)
// Estudiante: Urik Camilo Valenzuela Flynn · Matricula: 20250469
// Reto 14: Procesador de Verificacion
// Modulo: control_logic.v
// Descripcion: Decodificador combinacional de senales u y v a partir de
//              4 variables de control (a, b, c, d) mediante ecuaciones
//              minimas deducidas por Mapas de Karnaugh:
//                u = (a & b) | (a & c) | (~c & d)
//                v = (~a & b) | (b & d) | (c & ~d)
// ============================================================================

`timescale 1ns / 1ps

module control_logic (
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    output wire u,
    output wire v
);

    // Ecuacion minima SOP para u(a, b, c, d)
    // 3 terminos producto: ab, ac, c_neg*d
    assign u = (a & b) | (a & c) | ((~c) & d);

    // Ecuacion minima SOP para v(a, b, c, d)
    // 3 terminos producto: a_neg*b, bd, c*d_neg
    assign v = ((~a) & b) | (b & d) | (c & (~d));

endmodule

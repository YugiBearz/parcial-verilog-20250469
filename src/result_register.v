// ============================================================================
// Asignatura: Sistemas Digitales con FPGA (ITLA)
// Estudiante: Urik Camilo Valenzuela Flynn · Matricula: 20250469
// Reto 14: Procesador de Verificacion
// Modulo: result_register.v
// Descripcion: Registro secuencial de 5 bits (4 bits para el resultado Q y
//              1 bit para la bandera flag_q).
//              - Reset asincrono activo en alto (rst).
//              - Habilitador de captura sincronico activo en nivel alto (en).
//              - Disparado por flanco de subida de reloj (posedge clk).
// ============================================================================

`timescale 1ns / 1ps

module result_register (
    input  wire       clk,
    input  wire       rst,
    input  wire       en,
    input  wire [3:0] Y,
    input  wire       flag_comb,
    output reg  [3:0] Q,
    output reg        flag_q
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            Q      <= 4'b0000;
            flag_q <= 1'b0;
        end else if (en) begin
            Q      <= Y;
            flag_q <= flag_comb;
        end
        // Si en == 0, retiene su valor actual
    end

endmodule

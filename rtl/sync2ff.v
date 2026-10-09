// ============================================================================
// Asignatura: Sistemas Digitales con FPGA (ITLA)
// Estudiante: Urik Camilo Valenzuela Flynn · Matricula: 20250469
// Reto 14: Procesador de Verificacion
// Modulo: sync2ff.v
// Descripcion: Sincronizador de dos biestables (2FF) parametrizable en ancho
//              de bus (WIDTH) para absorber estados metaestables provenientes
//              de entradas asincronas del mundo exterior (switches, pulsadores).
// ============================================================================

`timescale 1ns / 1ps

module sync2ff #(
    parameter integer WIDTH = 1
) (
    input  wire             clk,
    input  wire [WIDTH-1:0] din,
    output reg  [WIDTH-1:0] dout
);

    // Primer biestable de captura (posible metaestabilidad)
    reg [WIDTH-1:0] stage1;

    always @(posedge clk) begin
        stage1 <= din;
        dout   <= stage1;
    end

endmodule

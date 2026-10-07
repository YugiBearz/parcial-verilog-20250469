// ============================================================================
// Asignatura: Sistemas Digitales con FPGA (ITLA)
// Estudiante: Urik Camilo Valenzuela Flynn · Matricula: 20250469
// Reto 14: Procesador de Verificacion
// Modulo: datapath.v
// Descripcion: Datapath combinacional que ejecuta 4 operaciones sobre
//              operandos sin signo de 4 bits (A y B) segun el selector {v, u}:
//                2'b00 -> XOR:   Y = A ^ B;      flag_comb = ^Y (paridad impar)
//                2'b01 -> SUMA:  Y = A + B;      flag_comb = acarreo (carry out)
//                2'b10 -> MAYOR: Y = max(A, B);  flag_comb = igualdad (A == B)
//                2'b11 -> RESTA: Y = A - B;      flag_comb = prestamo (borrow: A < B)
// ============================================================================

`timescale 1ns / 1ps

module datapath (
    input  wire       u,
    input  wire       v,
    input  wire [3:0] A,
    input  wire [3:0] B,
    output reg  [3:0] Y,
    output reg        flag_comb
);

    wire [1:0] sel;
    assign sel = {v, u};

    // Señales auxiliares para calculo de acarreo y comparaciones
    wire [4:0] sum_ext;
    assign sum_ext = {1'b0, A} + {1'b0, B};

    always @(*) begin
        // Valores por defecto para evitar inferencia de latches
        Y         = 4'b0000;
        flag_comb = 1'b0;

        case (sel)
            2'b00: begin
                // Operacion XOR: Y = A ^ B
                // Bandera: paridad impar del resultado (^Y)
                Y         = A ^ B;
                flag_comb = ^(A ^ B);
            end

            2'b01: begin
                // Operacion SUMA: Y = (A + B)[3:0]
                // Bandera: acarreo de salida (carry out, bit 4)
                Y         = sum_ext[3:0];
                flag_comb = sum_ext[4];
            end

            2'b10: begin
                // Operacion MAYOR: Y = max(A, B)
                // Bandera: igualdad (A == B)
                Y         = (A >= B) ? A : B;
                flag_comb = (A == B);
            end

            2'b11: begin
                // Operacion RESTA: Y = (A - B)[3:0]
                // Bandera: prestamo (borrow: A < B)
                Y         = A - B;
                flag_comb = (A < B);
            end

            default: begin
                Y         = 4'b0000;
                flag_comb = 1'b0;
            end
        endcase
    end

endmodule

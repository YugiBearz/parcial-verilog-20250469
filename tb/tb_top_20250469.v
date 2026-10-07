// ============================================================================
// Asignatura: Sistemas Digitales con FPGA (ITLA)
// Estudiante: Urik Camilo Valenzuela Flynn · Matricula: 20250469
// Reto 14: Procesador de Verificacion
// Modulo: tb_top_20250469.v
// Descripcion: Banco de pruebas para verificacion exhaustiva del modulo top.
//              Parte 1: Andamiaje, generador de reloj (50 MHz), instanciacion
//              del DUT y modelo de referencia (Golden Model).
// ============================================================================

`timescale 1ns / 1ps

/* verilator lint_off SIMILARNAME */
module tb_top_20250469;

    // Entradas al DUT (estimulos)
    reg        clk;
    reg        rst;
    reg        en;
    reg        a;
    reg        b;
    reg        c;
    reg        d;
    reg  [3:0] A;
    reg  [3:0] B;

    // Salidas del DUT (observadas)
    wire       u;
    wire       v;
    wire [3:0] Y;
    wire       flag_comb;
    wire [3:0] Q;
    wire       flag_q;

    // Contadores de verificacion
    integer errors_comb;
    integer errors_seq;
    integer errors_temporal;
    integer vector_count;

    // Instanciacion del DUT
    top_20250469 dut (
        .clk(clk),
        .rst(rst),
        .en(en),
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .A(A),
        .B(B),
        .u(u),
        .v(v),
        .Y(Y),
        .flag_comb(flag_comb),
        .Q(Q),
        .flag_q(flag_q)
    );

    // Generacion de reloj de 50 MHz (Periodo = 20 ns -> semi-periodo = 10 ns)
    always begin
        #10 clk = ~clk;
    end

    // Modelo Dorado: Funciones de referencia
    function expected_u;
        input fa, fb, fc, fd;
        begin
            expected_u = (fa & fb) | (fa & fc) | ((~fc) & fd);
        end
    endfunction

    function expected_v;
        input fa, fb, fc, fd;
        begin
            expected_v = ((~fa) & fb) | (fb & fd) | (fc & (~fd));
        end
    endfunction

    function [3:0] expected_Y;
        input fu, fv;
        input [3:0] fA, fB;
        reg [4:0] fsum;
        begin
            case ({fv, fu})
                2'b00: expected_Y = fA ^ fB;
                2'b01: begin
                    fsum = {1'b0, fA} + {1'b0, fB};
                    expected_Y = fsum[3:0];
                end
                2'b10: expected_Y = (fA >= fB) ? fA : fB;
                2'b11: expected_Y = fA - fB;
                default: expected_Y = 4'b0000;
            endcase
        end
    endfunction

    function expected_flag;
        input fu, fv;
        input [3:0] fA, fB;
        reg [4:0] fsum;
        reg [3:0] fxor;
        begin
            case ({fv, fu})
                2'b00: begin
                    fxor = fA ^ fB;
                    expected_flag = ^fxor;
                end
                2'b01: begin
                    fsum = {1'b0, fA} + {1'b0, fB};
                    expected_flag = fsum[4];
                end
                2'b10: expected_flag = (fA == fB);
                2'b11: expected_flag = (fA < fB);
                default: expected_flag = 1'b0;
            endcase
        end
    endfunction

    // Bloque inicial temporal para inicializacion de señales
    initial begin
        clk             = 1'b0;
        rst             = 1'b1;
        en              = 1'b0;
        a               = 1'b0;
        b               = 1'b0;
        c               = 1'b0;
        d               = 1'b0;
        A               = 4'd0;
        B               = 4'd0;
        errors_comb     = 0;
        errors_seq      = 0;
        errors_temporal = 0;
        vector_count    = 0;

        #35 rst = 1'b0; // Desasercion asincrona inicial
    end

endmodule
/* verilator lint_on SIMILARNAME */

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
/* verilator lint_off UNUSEDSIGNAL */
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

    // Tarea: Barrido Exhaustivo de 4096 Vectores (16 controles x 16 A x 16 B)
    task run_exhaustive_test;
        integer idx_m;
        integer val_A;
        integer val_B;
        reg exp_u_val;
        reg exp_v_val;
        reg [3:0] exp_Y_val;
        reg exp_flag_val;
        begin
            $display("====================================================================");
            $display("[TB] INICIANDO BARRIDO EXHAUSTIVO DE 4096 VECTORES COMBINACIONALES");
            $display("====================================================================");

            en = 1'b1; // Habilitador activo para verificar captura en cada ciclo

            for (idx_m = 0; idx_m < 16; idx_m = idx_m + 1) begin
                a = idx_m[3];
                b = idx_m[2];
                c = idx_m[1];
                d = idx_m[0];

                for (val_A = 0; val_A < 16; val_A = val_A + 1) begin
                    A = val_A[3:0];

                    for (val_B = 0; val_B < 16; val_B = val_B + 1) begin
                        B = val_B[3:0];

                        // Espera breve para propagacion combinacional antes del flanco de reloj
                        #2;

                        exp_u_val    = expected_u(a, b, c, d);
                        exp_v_val    = expected_v(a, b, c, d);
                        exp_Y_val    = expected_Y(exp_u_val, exp_v_val, A, B);
                        exp_flag_val = expected_flag(exp_u_val, exp_v_val, A, B);

                        // 1. Verificacion combinacional de u y v
                        if (u !== exp_u_val || v !== exp_v_val) begin
                            $display("[ERROR COMB] m=%0d (abcd=%b%b%b%b) -> Esperado u=%b,v=%b | Obtenido u=%b,v=%b",
                                     idx_m, a, b, c, d, exp_u_val, exp_v_val, u, v);
                            errors_comb = errors_comb + 1;
                        end

                        // 2. Verificacion combinacional del datapath (Y, flag_comb)
                        if (Y !== exp_Y_val || flag_comb !== exp_flag_val) begin
                            $display("[ERROR DATAPATH] {v,u}=%b%b, A=%0d, B=%0d -> Esperado Y=%0d,flag=%b | Obtenido Y=%0d,flag=%b",
                                     v, u, A, B, exp_Y_val, exp_flag_val, Y, flag_comb);
                            errors_comb = errors_comb + 1;
                        end

                        // 3. Flanco de reloj para evaluar la captura en el registro
                        @(posedge clk);
                        #1; // Margen post-flanco

                        if (Q !== exp_Y_val || flag_q !== exp_flag_val) begin
                            $display("[ERROR SEQ] {v,u}=%b%b, A=%0d, B=%0d -> Esperado Q=%0d,flag_q=%b | Obtenido Q=%0d,flag_q=%b",
                                     v, u, A, B, exp_Y_val, exp_flag_val, Q, flag_q);
                            errors_seq = errors_seq + 1;
                        end

                        vector_count = vector_count + 1;
                    end
                end
            end

            $display("[TB] BARRIDO EXHAUSTIVO FINALIZADO: %0d vectores probados.", vector_count);
            $display("[TB] Errores combinacionales: %0d | Errores secuenciales: %0d", errors_comb, errors_seq);
        end
    endtask

    // Tarea: 12 Pruebas Temporales de Esquina
    task run_temporal_tests;
        begin
            $display("====================================================================");
            $display("[TB] INICIANDO 12 PRUEBAS TEMPORALES DE ESQUINA (RESET, ENABLE, BANDERAS)");
            $display("====================================================================");

            // 1. Reset asincrono en mitad de ciclo mientras procesa
            en = 1'b1; a = 1'b1; b = 1'b1; c = 1'b0; d = 1'b1; // RESTA {1,1}
            A = 4'd10; B = 4'd2; // Y=8, flag=0
            @(posedge clk); #1;
            if (Q !== 4'd8 || flag_q !== 1'b0) begin
                $display("[ERROR TEMP 1] Captura previa al reset fallo: Q=%0d", Q);
                errors_temporal = errors_temporal + 1;
            end
            #4 rst = 1'b1; #1; // Reset asincrono fuera de flanco
            if (Q !== 4'd0 || flag_q !== 1'b0) begin
                $display("[ERROR TEMP 1] Reset asincrono no borro inmediatamente: Q=%0d, flag_q=%b", Q, flag_q);
                errors_temporal = errors_temporal + 1;
            end else begin
                $display("[PASS TEMP 1] Reset asincrono borro inmediatamente en mitad de ciclo.");
            end

            // 2. Desasercion de reset asincrono fuera de flanco
            #5 rst = 1'b0; #2;
            if (Q !== 4'd0 || flag_q !== 1'b0) begin
                $display("[ERROR TEMP 2] Salida cambio antes del flanco de reloj tras rst=0");
                errors_temporal = errors_temporal + 1;
            end
            @(posedge clk); #1;
            if (Q !== 4'd8 || flag_q !== 1'b0) begin
                $display("[ERROR TEMP 2] Fallo captura tras recuperacion de reset: Q=%0d", Q);
                errors_temporal = errors_temporal + 1;
            end else begin
                $display("[PASS TEMP 2] Recuperacion de reset y captura limpia en siguiente flanco.");
            end

            // 3. Inhibicion por enable (en = 0, reloj activo)
            en = 1'b0;
            A = 4'd15; B = 4'd0;
            repeat (3) @(posedge clk); #1;
            if (Q !== 4'd8 || flag_q !== 1'b0) begin
                $display("[ERROR TEMP 3] El registro no mantuvo su valor con en=0: Q=%0d", Q);
                errors_temporal = errors_temporal + 1;
            end else begin
                $display("[PASS TEMP 3] Retencion de estado confirmada durante 3 ciclos con en=0.");
            end

            // 4. Habilitacion inmediata (en = 1 captura en el siguiente flanco)
            en = 1'b1;
            @(posedge clk); #1;
            if (Q !== 4'd15 || flag_q !== 1'b0) begin
                $display("[ERROR TEMP 4] Fallo captura inmediata al habilitar en=1: Q=%0d", Q);
                errors_temporal = errors_temporal + 1;
            end else begin
                $display("[PASS TEMP 4] Captura inmediata confirmada en primer flanco con en=1.");
            end

            // 5. Inmunidad a glitches en operandos con en=0
            en = 1'b0;
            #2 A = 4'd1; B = 4'd1;
            #2 A = 4'd9; B = 4'd4;
            #2 A = 4'd3; B = 4'd7;
            #2 A = 4'd0; B = 4'd0;
            @(posedge clk); #1;
            if (Q !== 4'd15 || flag_q !== 1'b0) begin
                $display("[ERROR TEMP 5] Glitch filtro a traves del registro con en=0: Q=%0d", Q);
                errors_temporal = errors_temporal + 1;
            end else begin
                $display("[PASS TEMP 5] Inmunidad completa a glitches de entrada con en=0.");
            end

            // 6. Transicion simultanea de control y datos
            en = 1'b1;
            a = 1'b0; b = 1'b0; c = 1'b0; d = 1'b1; // SUMA {0,1}
            A = 4'd6; B = 4'd5; // Y=11, flag=0
            #2; // Propagacion
            @(posedge clk); #1;
            if (Q !== 4'd11 || flag_q !== 1'b0) begin
                $display("[ERROR TEMP 6] Transicion simultanea fallo: Q=%0d, flag_q=%b", Q, flag_q);
                errors_temporal = errors_temporal + 1;
            end else begin
                $display("[PASS TEMP 6] Transicion simultanea de control y datos capturada con exito.");
            end

            // 7. Prioridad estricta de reset sobre enable en el mismo flanco
            rst = 1'b1; en = 1'b1;
            @(posedge clk); #1;
            if (Q !== 4'd0 || flag_q !== 1'b0) begin
                $display("[ERROR TEMP 7] Prioridad de reset fallo ante en=1: Q=%0d", Q);
                errors_temporal = errors_temporal + 1;
            end else begin
                $display("[PASS TEMP 7] Prioridad absoluta de reset sobre enable confirmada.");
            end
            rst = 1'b0; #5;

            // 8. Conmutacion rapida de enable (ON -> OFF -> ON en ciclos consecutivos)
            en = 1'b1; A = 4'd3; B = 4'd2; // SUMA Y=5
            @(posedge clk); #1;
            en = 1'b0; A = 4'd7; B = 4'd7; // Cambio ignorado
            @(posedge clk); #1;
            if (Q !== 4'd5) begin
                $display("[ERROR TEMP 8] Enable OFF no retuvo valor intermedio: Q=%0d", Q);
                errors_temporal = errors_temporal + 1;
            end
            en = 1'b1; // Captura nuevo valor
            @(posedge clk); #1;
            if (Q !== 4'd14) begin // 7+7 = 14
                $display("[ERROR TEMP 8] Enable ON no capturo nuevo valor: Q=%0d", Q);
                errors_temporal = errors_temporal + 1;
            end else begin
                $display("[PASS TEMP 8] Conmutacion rapida de enable ciclo a ciclo exitosa.");
            end

            // 9. Caso extremo: Desbordamiento en SUMA (15 + 15 = 30 -> Y=14, carry=1)
            a = 1'b0; b = 1'b0; c = 1'b0; d = 1'b1; // SUMA
            A = 4'd15; B = 4'd15;
            @(posedge clk); #1;
            if (Q !== 4'd14 || flag_q !== 1'b1) begin
                $display("[ERROR TEMP 9] Desbordamiento de suma fallo: Q=%0d, flag_q=%b", Q, flag_q);
                errors_temporal = errors_temporal + 1;
            end else begin
                $display("[PASS TEMP 9] Desbordamiento maximo en SUMA (15+15) con carry out=1 confirmado.");
            end

            // 10. Caso extremo: Prestamo en RESTA (0 - 15 = -15 -> Y=1, borrow=1)
            a = 1'b1; b = 1'b1; c = 1'b1; d = 1'b1; // RESTA {1,1}
            A = 4'd0; B = 4'd15;
            @(posedge clk); #1;
            if (Q !== 4'd1 || flag_q !== 1'b1) begin
                $display("[ERROR TEMP 10] Prestamo maximo de resta fallo: Q=%0d, flag_q=%b", Q, flag_q);
                errors_temporal = errors_temporal + 1;
            end else begin
                $display("[PASS TEMP 10] Prestamo maximo en RESTA (0-15) con borrow=1 confirmado.");
            end

            // 11. Caso extremo: Igualdad en MAYOR (A == B -> Y=A, flag=1)
            a = 1'b0; b = 1'b0; c = 1'b1; d = 1'b0; // MAYOR {1,0}
            A = 4'd7; B = 4'd7;
            @(posedge clk); #1;
            if (Q !== 4'd7 || flag_q !== 1'b1) begin
                $display("[ERROR TEMP 11] Igualdad en operacion MAYOR fallo: Q=%0d, flag_q=%b", Q, flag_q);
                errors_temporal = errors_temporal + 1;
            end else begin
                $display("[PASS TEMP 11] Igualdad estricta en MAYOR (7==7) con flag_eq=1 confirmada.");
            end

            // 12. Caso extremo: Paridad en XOR
            a = 1'b0; b = 1'b0; c = 1'b0; d = 1'b0; // XOR {0,0}
            A = 4'b1111; B = 4'b0000; // Y=15 (cuatro unos -> paridad impar es 0)
            @(posedge clk); #1;
            if (Q !== 4'b1111 || flag_q !== 1'b0) begin
                $display("[ERROR TEMP 12] Paridad XOR (4 unos) fallo: Q=%b, flag_q=%b", Q, flag_q);
                errors_temporal = errors_temporal + 1;
            end
            A = 4'b0001; B = 4'b0000; // Y=1 (un solo uno -> paridad impar es 1)
            @(posedge clk); #1;
            if (Q !== 4'b0001 || flag_q !== 1'b1) begin
                $display("[ERROR TEMP 12] Paridad XOR (1 uno) fallo: Q=%b, flag_q=%b", Q, flag_q);
                errors_temporal = errors_temporal + 1;
            end else begin
                $display("[PASS TEMP 12] Deteccion de paridad impar en XOR confirmada en ambos casos.");
            end

            $display("[TB] 12 PRUEBAS TEMPORALES FINALIZADAS. Errores temporales: %0d", errors_temporal);
        end
    endtask

    // Bloque inicial principal
    initial begin
        // Volcado de ondas para GTKWave
        $dumpfile("sim/top_20250469.vcd");
        $dumpvars(0, tb_top_20250469);

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

        #35;
        rst = 1'b0; // Desasercion asincrona inicial
        #15;

        // 1. Ejecutar barrido exhaustivo de 4096 vectores
        run_exhaustive_test();

        // 2. Ejecutar 12 pruebas temporales de esquina
        run_temporal_tests();

        // 3. Resumen y evaluacion final
        $display("====================================================================");
        $display("REPORTE FINAL DE VERIFICACION — RETO 14 (MATRICULA: 20250469)");
        $display("====================================================================");
        $display("Vectores combinacionales probados: %0d", vector_count);
        $display("Errores combinacionales:           %0d", errors_comb);
        $display("Errores secuenciales:              %0d", errors_seq);
        $display("Errores temporales (12 pruebas):   %0d", errors_temporal);
        $display("--------------------------------------------------------------------");

        if (errors_comb == 0 && errors_seq == 0 && errors_temporal == 0) begin
            $display(">>> TEST PASSED: TODAS LAS PRUEBAS RESULTARON 100%% EXITOSAS <<<");
        end else begin
            $display(">>> TEST FAILED: SE DETECTARON FALLOS EN LA SIMULACION <<<");
        end
        $display("====================================================================");

        #40;
        $finish;
    end

endmodule
/* verilator lint_on SIMILARNAME */



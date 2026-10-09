// ============================================================================
// Asignatura: Sistemas Digitales con FPGA (ITLA)
// Estudiante: Urik Camilo Valenzuela Flynn · Matricula: 20250469
// Reto 14: Procesador de Verificacion
// Modulo: tb_sync2ff.v
// Descripcion: Banco de pruebas unitario para verificar la latencia determinista
//              de 2 ciclos de reloj y la inmunidad a cambios asincronos fuera
//              de flanco en el modulo sync2ff.
// ============================================================================

`timescale 1ns / 1ps

module tb_sync2ff;

    reg        clk;
    reg        din_1b;
    wire       dout_1b;

    reg  [3:0] din_4b;
    wire [3:0] dout_4b;

    integer errors;

    // Instancia de 1 bit
    sync2ff #(.WIDTH(1)) u_sync1 (
        .clk(clk),
        .din(din_1b),
        .dout(dout_1b)
    );

    // Instancia de 4 bits
    sync2ff #(.WIDTH(4)) u_sync4 (
        .clk(clk),
        .din(din_4b),
        .dout(dout_4b)
    );

    // Reloj de 50 MHz (Periodo = 20 ns)
    always #10 clk = ~clk;

    initial begin
        clk    = 1'b0;
        din_1b = 1'b0;
        din_4b = 4'b0000;
        errors = 0;

        repeat (2) @(posedge clk);
        #1;

        // Prueba 1: Estimulo asincrono entre flancos
        #3 din_1b = 1'b1;
        din_4b = 4'b1010;

        // En este instante (antes del flanco), la salida debe permanecer en 0
        if (dout_1b !== 1'b0 || dout_4b !== 4'b0000) begin
            $display("[ERROR SYNC] Salida cambio asincronamente sin flanco de reloj!");
            errors = errors + 1;
        end

        // Flanco 1: Se captura en stage1, pero dout aun debe ser 0 (latencia = 1 ciclo)
        @(posedge clk);
        #1;
        if (dout_1b !== 1'b0 || dout_4b !== 4'b0000) begin
            $display("[ERROR SYNC] dout se actualizo en 1 solo ciclo (debe requerir 2 ciclos): dout_1b=%b", dout_1b);
            errors = errors + 1;
        end

        // Flanco 2: Se transfiere a dout (latencia = 2 ciclos)
        @(posedge clk);
        #1;
        if (dout_1b !== 1'b1 || dout_4b !== 4'b1010) begin
            $display("[ERROR SYNC] dout no se actualizo tras 2 ciclos de reloj!");
            errors = errors + 1;
        end else begin
            $display("[PASS SYNC] Latencia exacta de 2 ciclos de reloj confirmada.");
        end

        // Prueba 2: Regreso a cero
        #4 din_1b = 1'b0;
        din_4b = 4'b0000;
        @(posedge clk); #1;
        if (dout_1b !== 1'b1 || dout_4b !== 4'b1010) begin
            $display("[ERROR SYNC] dout cayo prematuramente en ciclo 1");
            errors = errors + 1;
        end
        @(posedge clk); #1;
        if (dout_1b !== 1'b0 || dout_4b !== 4'b0000) begin
            $display("[ERROR SYNC] dout no cayo a 0 tras 2 ciclos");
            errors = errors + 1;
        end else begin
            $display("[PASS SYNC] Transicion a 0 confirmada en exactamente 2 ciclos.");
        end

        if (errors == 0) begin
            $display(">>> [SYNC2FF TEST PASSED]: MODULO DE SINCRONIZACION 100%% VALIDO <<<");
        end else begin
            $display(">>> [SYNC2FF TEST FAILED]: %0d ERRORES DETECTADOS <<<", errors);
        end

        #20;
        $finish;
    end

endmodule

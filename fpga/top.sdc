// ============================================================================
// Asignatura: Sistemas Digitales con FPGA (ITLA)
// Estudiante: Urik Camilo Valenzuela Flynn · Matricula: 20250469
// Reto 14: Procesador de Verificacion
// Tarjeta: Sipeed Tang Primer 25K (Gowin GW5A-LV25MG121)
// Archivo: top.sdc (Synopsys Design Constraints para Gowin EDA)
// ============================================================================

// 1. Definicion del reloj maestro de 50 MHz (Periodo = 20.000 ns, Ciclo 50%)
create_clock -name sys_clk -period 20.000 -waveform {0.000 10.000} [get_ports {sys_clk}]

// 2. Margen de incertidumbre y jitter del reloj
set_clock_uncertainty 0.200 -setup -from [get_clocks {sys_clk}] -to [get_clocks {sys_clk}]
set_clock_uncertainty 0.100 -hold  -from [get_clocks {sys_clk}] -to [get_clocks {sys_clk}]

// 3. Retardos de entrada para switches y pulsadores asincronos
set_input_delay -clock sys_clk -max 5.000 [get_ports {btn_rst_n btn_en sw_ctrl[*] sw_A[*] sw_B[*]}]
set_input_delay -clock sys_clk -min 1.000 [get_ports {btn_rst_n btn_en sw_ctrl[*] sw_A[*] sw_B[*]}]

// 4. Retardos de salida hacia diodos LED
set_output_delay -clock sys_clk -max 5.000 [get_ports {led_Q[*] led_flag led_u led_v}]
set_output_delay -clock sys_clk -min 1.000 [get_ports {led_Q[*] led_flag led_u led_v}]

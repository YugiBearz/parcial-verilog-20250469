# ==============================================================================
# Script de Automatizacion Gowin EDA — Sistemas Digitales con FPGA (ITLA)
# Estudiante: Urik Camilo Valenzuela Flynn · Matricula: 20250469
# Reto 14: Procesador de Verificacion (Sipeed Tang Primer 25K)
# ==============================================================================

set_device -name GW5A-25A GW5A-LV25MG121NC1/I0

# 1. Agregar archivos fuente RTL
add_file -type verilog "../src/control_logic.v"
add_file -type verilog "../src/datapath.v"
add_file -type verilog "../src/result_register.v"
add_file -type verilog "../src/top_20250469.v"
add_file -type verilog "../src/sync2ff.v"
add_file -type verilog "../src/tang_top_20250469.v"

# 2. Agregar restricciones fisicas y de reloj
add_file -type cst "top.cst"
add_file -type sdc "top.sdc"

# 3. Definir modulo superior (Top-level)
set_option -top_module tang_top_20250469

# 4. Opciones de sintesis y optimizacion
set_option -output_base_name tang_top_20250469
set_option -verilog_std v2001
set_option -use_cpu_as_gpio 1
set_option -use_sspi_as_gpio 1

# 5. Ejecutar flujo completo de implementacion
run syn
run pnr

puts "======================================================================"
puts ">>> FLUJO GOWIN FINALIZADO: Bitstream generado en impl/pnr/ <<<"
puts "======================================================================"

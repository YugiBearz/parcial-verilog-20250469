# ==============================================================================
# Makefile — Sistemas Digitales con FPGA (ITLA)
# Estudiante: Urik Camilo Valenzuela Flynn · Matricula: 20250469
# Reto 14: Procesador de Verificacion
# ==============================================================================

IVERILOG = iverilog
VVP      = vvp
VERILATOR= verilator
GTKWAVE  = gtkwave

RTL_SRCS = rtl/control_logic.v \
           rtl/datapath.v \
           rtl/result_register.v \
           rtl/top_20250469.v

TB_SRCS  = tb/tb_top_20250469.v

SIM_DIR  = sim
SIM_BIN  = $(SIM_DIR)/sim_top_20250469
VCD_FILE = $(SIM_DIR)/top_20250469.vcd

.PHONY: all check compile run wave lint clean

all: check

compile: $(SIM_BIN)

$(SIM_BIN): $(RTL_SRCS) $(TB_SRCS)
	@mkdir -p $(SIM_DIR)
	$(IVERILOG) -g2001 -Wall -o $(SIM_BIN) $(RTL_SRCS) $(TB_SRCS)

run: $(SIM_BIN)
	$(VVP) $(SIM_BIN)

check: $(SIM_BIN)
	@echo "===================================================================="
	@echo "Ejecutando verificacion exhaustiva (4096 vectores + 12 temporales)..."
	@echo "===================================================================="
	$(VVP) $(SIM_BIN)

wave: run
	$(GTKWAVE) $(VCD_FILE) &

lint:
	$(VERILATOR) --lint-only -Wall $(RTL_SRCS) $(TB_SRCS)

clean:
	rm -rf $(SIM_DIR)/*.vvp $(SIM_DIR)/*.vcd $(SIM_DIR)/sim_top_* build/*

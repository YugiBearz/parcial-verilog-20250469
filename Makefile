# ==============================================================================
# Makefile — Sistemas Digitales con FPGA (ITLA)
# Estudiante: Urik Camilo Valenzuela Flynn · Matricula: 20250469
# Reto 14: Procesador de Verificacion
# ==============================================================================

IVERILOG = iverilog
VVP      = vvp
VERILATOR= verilator
GTKWAVE  = gtkwave
GOWIN_SH = gw_sh

RTL_SRCS = src/control_logic.v \
           src/datapath.v \
           src/result_register.v \
           src/top_20250469.v \
           src/sync2ff.v \
           src/tang_top_20250469.v

TB_SRCS  = sim/tb_top_20250469.v
TB_SYNC  = sim/tb_sync2ff.v

SIM_DIR  = sim
SIM_BIN  = $(SIM_DIR)/sim_top_20250469
SIM_SYNC = $(SIM_DIR)/sim_sync2ff
VCD_FILE = $(SIM_DIR)/top_20250469.vcd

.PHONY: all check check-sync compile run wave lint fpga clean

all: check

compile: $(SIM_BIN)

$(SIM_BIN): $(RTL_SRCS) $(TB_SRCS)
	@mkdir -p $(SIM_DIR)
	$(IVERILOG) -g2001 -Wall -o $(SIM_BIN) src/control_logic.v src/datapath.v src/result_register.v src/top_20250469.v $(TB_SRCS)

$(SIM_SYNC): src/sync2ff.v $(TB_SYNC)
	@mkdir -p $(SIM_DIR)
	$(IVERILOG) -g2001 -Wall -o $(SIM_SYNC) src/sync2ff.v $(TB_SYNC)

check-sync: $(SIM_SYNC)
	$(VVP) $(SIM_SYNC)

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

fpga:
	@echo "===================================================================="
	@echo "Ejecutando sintesis y generacion de bitstream con Gowin EDA..."
	@echo "===================================================================="
	cd fpga && $(GOWIN_SH) run_gowin.tcl

clean:
	rm -rf $(SIM_DIR)/*.vvp $(SIM_DIR)/*.vcd $(SIM_DIR)/sim_top_* $(SIM_DIR)/sim_sync* build/*

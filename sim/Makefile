# Tool commands
IVERILOG = iverilog
VVP      = vvp
WAVEVIEW = gtkwave

# Paths
RTL_DIR = ../rtl
TB_DIR  = ../tb

# Testbench output directory
OUTDIR  = .
# Waveform directory
WAVEDIR = ../sim

# Make sure sim dir exists
$(shell mkdir -p $(WAVEDIR))

.PHONY: help all clean arith go_to input_sel output_sel reg_bank proc view-arith view-go_to view-input_sel view-output_sel view-reg_bank view-proc

help:
	@echo "Usage: make <target>. Available targets:"
	@echo "  all             Run all tests"
	@echo "  arith           Compile & run arithmetic_unit testbench"
	@echo "  go_to           Compile & run go_to testbench"
	@echo "  input_sel       Compile & run input_selection testbench"
	@echo "  output_sel      Compile & run output_selection testbench"
	@echo "  reg_bank        Compile & run register_bank testbench"
	@echo "  proc            Compile & run processor_top testbench"
	@echo "  view-arith      View arith waveform"
	@echo "  view-go_to      View go_to waveform"
	@echo "  view-input_sel  View input_selection waveform"
	@echo "  view-output_sel View output_selection waveform"
	@echo "  view-reg_bank   View register_bank waveform"
	@echo "  view-proc       View processor_top waveform"
	@echo "  clean           Remove build & VCD files"

# =========================== Test Targets ===========================
arith:
	$(IVERILOG) -g2012 -o sim_arith.out $(RTL_DIR)/arithmetic_unit.v $(TB_DIR)/tb_arithmetic.v
	$(VVP) sim_arith.out
	@echo "Run 'make view-arith' to view $(WAVEDIR)/tb_arithmetic.vcd"

go_to:
	$(IVERILOG) -g2012 -o sim_go_to.out $(RTL_DIR)/go_to.v $(TB_DIR)/tb_go_to.v
	$(VVP) sim_go_to.out
	@echo "Run 'make view-go_to' to view $(WAVEDIR)/go_to.vcd"

input_sel:
	$(IVERILOG) -g2012 -o sim_input_sel.out $(RTL_DIR)/input_selection.v $(TB_DIR)/tb_input_selection.v
	$(VVP) sim_input_sel.out
	@echo "Run 'make view-input_sel' to view $(WAVEDIR)/tb_input_selection.vcd"

output_sel:
	$(IVERILOG) -g2012 -o sim_output_sel.out $(RTL_DIR)/output_selection.v $(TB_DIR)/tb_output_selection.v
	$(VVP) sim_output_sel.out
	@echo "Run 'make view-output_sel' to view $(WAVEDIR)/tb_output_selection.vcd"

reg_bank:
	$(IVERILOG) -g2012 -o sim_reg_bank.out $(RTL_DIR)/register_bank.v $(TB_DIR)/tb_register_bank.v
	$(VVP) sim_reg_bank.out
	@echo "Run 'make view-reg_bank' to view $(WAVEDIR)/tb_register_bank.vcd"

proc:
	$(IVERILOG) -g2012 -o sim_proc.out $(RTL_DIR)/*.v $(TB_DIR)/tb_processor.v
	$(VVP) sim_proc.out
	@echo "Run 'make view-proc' to view $(WAVEDIR)/tb_processor.vcd"

# =========================== View Targets ===========================
view-arith:
	$(WAVEVIEW) $(WAVEDIR)/tb_arithmetic.vcd &

view-go_to:
	$(WAVEVIEW) $(WAVEDIR)/tb_go_to.vcd &

view-input_sel:
	$(WAVEVIEW) $(WAVEDIR)/tb_input_selection.vcd &

view-output_sel:
	$(WAVEVIEW) $(WAVEDIR)/tb_output_selection.vcd &

view-reg_bank:
	$(WAVEVIEW) $(WAVEDIR)/tb_register_bank.vcd &

view-proc:
	$(WAVEVIEW) $(WAVEDIR)/tb_processor.vcd &

# =========================== Housekeeping ===========================
all: arith go_to input_sel output_sel reg_bank proc

clean:
	rm -f sim_*.out $(WAVEDIR)/*.vcd

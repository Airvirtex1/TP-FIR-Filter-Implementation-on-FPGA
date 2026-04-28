# Root Makefile

# Directory containing the VHDL files (e.g., Buffer)
DIR ?= ./*
# Top-level entity (testbench)
TOP ?= TB
# GHDL options
GHDL := /opt/ghdl/bin/ghdl
GHDLOPTS := --std=08 --ieee=synopsys
WORKDIR := ./tmp/ghdl
STOP_TIME := 500ns
# Create the work directory if it doesn't exist
$(shell mkdir -p $(WORKDIR))

# Explicit compilation order to respect dependencies
VHDL_FILES := UT.vhd  UC.vhd TB.vhd

analyze:
	$(GHDL) -a $(GHDLOPTS) --workdir=$(WORKDIR) $(VHDL_FILES)

elaborate: analyze
	$(GHDL) -e $(GHDLOPTS) --workdir=$(WORKDIR) -P$(DIR) $(TOP)

run: elaborate
	$(GHDL) -r $(GHDLOPTS) --workdir=$(WORKDIR) -P$(DIR) $(TOP)

wave: elaborate
	$(GHDL) -r $(GHDLOPTS) --workdir=$(WORKDIR) -P$(DIR) $(TOP) --wave=$(TOP)-wave.ghw --stop-time=$(STOP_TIME)

vcd: elaborate
	$(GHDL) -r $(GHDLOPTS) --workdir=$(WORKDIR) -P$(DIR) $(TOP) --vcd=$(TOP)-wave.vcd --stop-time=$(STOP_TIME)


clean:
	rm -rf $(WORKDIR) $(TOP) e~$(TOP).o $(TOP)-wave.ghw
GHDL = ghdl

TOP = cpu_tb

WORKDIR = work

FLAGS = --std=08 --workdir=$(WORKDIR)

SOURCE = \
	alu.vhdl \
	cpu_tb.vhdl \
	cpu_types.vhdl \
	cpu.vhdl \
	instruction_counter.vhdl \
	instruction_decoder.vhdl \
	memfile.vhdl \
	regfile.vhdl \

all:
	$(GHDL) -i $(FLAGS) $(SOURCE)
	$(GHDL) -a $(FLAGS) $(shell $(GHDL) --elab-order $(FLAGS) $(TOP))
	$(GHDL) -e $(FLAGS) $(TOP)
	# $(GHDL) -m $(FLAGS) $(TOP)
	$(GHDL) -r $(FLAGS) $(TOP)

GHDL = ghdl
FLAGS = --std=08

SOURCE = \
	cpu_types.vhdl \
	alu.vhdl \
	memfile.vhdl \
	regfile.vhdl \
	instruction_counter.vhdl \
	instruction_decoder.vhdl \
	cpu.vhdl \
	cpu_tb.vhdl \

all:
	$(GHDL) -a $(FLAGS) $(SOURCE)

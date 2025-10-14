GHDL = ghdl
FLAGS = --std=08

SOURCE = \
	cpu_types.vhdl \
	alu.vhdl \
	regfile.vhdl \
	instruction_counter.vhdl \
	instruction_decoder.vhdl \

all:
	$(GHDL) -c $(FLAGS) $(SOURCE)

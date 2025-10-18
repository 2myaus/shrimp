PY = python3
GHDL = ghdl

TESTVEC_IN = shrimptest.bin
TESTVEC_OUT = testvec.vhdl

TOP = cpu_tb

WORKDIR = work

FLAGS = --std=08 --workdir=$(WORKDIR)
RUNFLAGS = --stop-time=1000ns --wave=$(WORKDIR)/shrimpwave.ghw --ieee-asserts=disable -gdebug_logs=true

SOURCE = \
	alu.vhdl \
	cpu_tb.vhdl \
	cpu_types.vhdl \
	cpu.vhdl \
	instruction_counter.vhdl \
	instruction_decoder.vhdl \
	memfile.vhdl \
	regfile.vhdl \
	$(TESTVEC_OUT) \

all:
	$(PY) bin_to_vhdl.py $(TESTVEC_IN) $(TESTVEC_OUT)
	$(GHDL) -i $(FLAGS) $(SOURCE)
	# $(GHDL) -a $(FLAGS) $(shell $(GHDL) --elab-order $(FLAGS) $(TOP))
	# $(GHDL) -e $(FLAGS) $(TOP)
	$(GHDL) -m $(FLAGS) $(TOP)
	$(GHDL) -r $(FLAGS) $(TOP) $(RUNFLAGS)

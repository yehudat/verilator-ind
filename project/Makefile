# Makefile for Verilator simulation

# Verilator flags
VFLAGS = --cc --exe --build --trace

# Target executable
TARGET = obj_dir/Vcounter_tb

# Source files
SRCS = counter.v counter_tb.v
TB_CPP = counter_tb.cpp

.PHONY: all sim waves clean

all: $(TARGET)

# Build the simulation executable
$(TARGET): $(SRCS) $(TB_CPP)
	verilator $(VFLAGS) -o $(notdir $(TARGET)) $(SRCS) $(TB_CPP)

# Run simulation
sim: $(TARGET)
	./$(TARGET)

# Open waveform viewer
waves: counter.vcd
	gtkwave counter.vcd &

# Clean build artifacts
clean:
	rm -rf obj_dir *.vcd

help:
	@echo "Makefile targets:"
	@echo "  all    - Build the simulation (default)"
	@echo "  sim    - Build and run simulation"
	@echo "  waves  - Open GTKWave with generated VCD file"
	@echo "  clean  - Remove build artifacts and waveforms"

# Verilator + GTKWave Docker Environment

A complete Dockerized development environment with the latest Verilator and GTKWave for Verilog/SystemVerilog simulation and waveform viewing.

## Contents

- **Verilator**: Latest version built from source
- **GTKWave**: Open-source waveform viewer
- **Testing Project**: Counter module with testbench

## Prerequisites

- Docker
- Docker Compose
- X11 server

## Testing the Setup

After building, verify everything works:

```bash
# Make test script executable
chmod +x test.sh

# Run tests
./test.sh
```

Expected output:

```
==========================================
Testing Verilator Docker Container
==========================================

Test 1: Checking Verilator version...
Verilator 5.030 2024-11-23 rev v5.030
✓ Verilator is installed and working

Test 2: Checking GTKWave installation...
/usr/bin/gtkwave
✓ GTKWave is installed

Test 3: Running example simulation...
✓ Example simulation completed successfully
✓ VCD file generated: project/counter.vcd

==========================================
All tests passed! ✓
==========================================
```

## Quick Start

### 1. Build the Docker Image

This script will guide you through the Docker-Compose build process and optionally run a test simulation.

```bash
docker-compose build
```

### 2. Run the Container

#### **Linux

```bash
# Allow X11 connections
xhost +local:docker

# Run with docker-compose
docker-compose run --rm verilator

# Or with docker directly
docker run -it --rm \
  -v $(pwd)/project:/project \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -e DISPLAY=$DISPLAY \
  verilator-gtkwave:latest
```

#### **macOS

```bash
# Start XQuartz and allow connections
# In XQuartz preferences, enable "Allow connections from network clients"

# Get your IP
IP=$(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}')

# Allow X11 forwarding
xhost + $IP

# Run container
docker run -it --rm \
  -v $(pwd)/project:/project \
  -e DISPLAY=$IP:0 \
  verilator-gtkwave:latest
```

## Usage

### Running the Example Project

Inside the container:

```bash
cd /project

# Build and run simulation
make sim

# View waveforms in GTKWave
make waves

# Clean build artifacts
make clean
```

### Manual Verilator Usage

```bash
# Verilate your design
verilator --cc --exe --build --trace your_module.v testbench.cpp

# Run simulation
./obj_dir/Vyour_module

# View waveforms
gtkwave waveform.vcd
```

## Project Structure

```
.
├── Dockerfile              # Docker image definition
├── docker-compose.yml      # Docker Compose configuration
├── project/
│   ├── counter.v          # Example Verilog module
│   ├── counter_tb.v       # Verilog testbench
│   ├── counter_tb.cpp     # C++ testbench wrapper
│   └── Makefile           # Build automation
└── README.md              # This file
```

## Example Output

When running `make sim`, you should see:

```
Time=0 reset=1 enable=0 count=  0
Time=20 reset=0 enable=0 count=  0
Time=30 reset=0 enable=1 count=  0
Time=40 reset=0 enable=1 count=  1
...
Simulation completed
```

The simulation generates `counter.vcd` which can be viewed with GTKWave.

## Verilator Commands

```bash
# Check version
verilator --version

# Lint a design
verilator --lint-only your_design.v

# Generate C++ model
verilator --cc your_design.v

# Generate with tracing
verilator --cc --trace your_design.v

# Full build with executable
verilator --cc --exe --build --trace design.v testbench.cpp
```

## GTKWave Tips

- **Zoom**: Use mouse wheel or View menu
- **Add signals**: Drag from signal list to waveform viewer
- **Search signals**: Ctrl+F in signal list
- **Save configuration**: File → Write Save File
- **Reload waveform**: Ctrl+Shift+R

## Troubleshooting

### Build Issues

**Build takes too long**
- Use the quick build option: `docker build -f Dockerfile.quick -t verilator-gtkwave:quick .`
- Or use pre-built Ubuntu packages (Verilator 5.x)

**Out of memory during build**
- Reduce parallel jobs in Dockerfile: Change `make -j$(nproc)` to `make -j2`
- Increase Docker memory limit in Docker Desktop settings

**Network timeouts**
- The build needs to clone Verilator from GitHub
- Check your internet connection and GitHub access
- Try again or use the quick build option

### GTKWave won't open

1. **Check X11 forwarding**: Ensure `xhost` permissions are set
2. **Verify DISPLAY**: `echo $DISPLAY` should show your display
3. **Test X11**: Run `xeyes` or similar X11 app in container

### Permission issues

```bash
# On host, fix permissions
chmod -R 755 project/
```

### Build errors

```bash
# Clean and rebuild
make clean
docker-compose build --no-cache
```

## Advanced Usage

### Custom Verilator Flags

Edit the Makefile to add custom flags:

```makefile
VFLAGS = --cc --exe --build --trace --timing -Wall -Wno-fatal
```

### Using SystemVerilog

Verilator supports SystemVerilog. Just use `.sv` extension:

```bash
verilator --cc --exe --build --trace module.sv testbench.cpp
```

### Profiling

Enable profiling in Verilator:

```bash
verilator --cc --exe --build --trace --profile-cfuncs design.v testbench.cpp
```

## Resources

- [Verilator Documentation](https://verilator.org/guide/latest/)
- [GTKWave Documentation](http://gtkwave.sourceforge.net/)
- [Verilator GitHub](https://github.com/verilator/verilator)

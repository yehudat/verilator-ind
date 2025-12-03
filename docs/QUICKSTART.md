# Quick Start Guide - Verilator + GTKWave Docker

## ⚡ 30-Second Start

```bash
# 1. Build (choose one)
./build_and_test.sh              # Interactive (recommended)
# OR
docker build -f Dockerfile.quick -t verilator-gtkwave:quick .  # Fast

# 2. Test
docker run --rm -v $(pwd)/project:/project verilator-gtkwave:quick \
  bash -c "cd /project && make sim"

# 3. Done! VCD file created at project/counter.vcd
```

## 📋 What You Get

```
verilator-docker/
├── Dockerfile              # Full build (latest Verilator from source)
├── Dockerfile.quick        # Quick build (Ubuntu packages)
├── docker-compose.yml      # Easy container management
├── build_and_test.sh       # Automated build & test
├── validate_dockerfiles.sh # Syntax checker
├── README.md               # Full documentation
├── BUILD_NOTES.md          # Validation details
└── project/
    ├── counter.v           # Example Verilog module
    ├── counter_tb.v        # Testbench
    ├── counter_tb.cpp      # C++ wrapper
    └── Makefile            # Build automation
```

## 🚀 Usage Commands

### Build Options
```bash
./build_and_test.sh                    # Interactive (best for first time)
docker build -f Dockerfile.quick ...   # 2-3 min (Verilator 5.x)
docker build -t verilator-gtkwave ...  # 5-10 min (latest stable)
```

### Run Simulation
```bash
# Inside container
cd /project
make sim        # Compile and run
make waves      # View waveforms (needs X11)
make clean      # Clean build files

# From host (one-liner)
docker run --rm -v $(pwd)/project:/project IMAGE bash -c "cd /project && make sim"
```

### Interactive Shell
```bash
docker run -it --rm -v $(pwd)/project:/project verilator-gtkwave:quick
```

### With GUI (GTKWave)
```bash
# Linux
xhost +local:docker
docker-compose run --rm verilator

# macOS (needs XQuartz)
# See README.md for detailed setup
```

## 🔧 Common Tasks

### Add Your Own Design
```bash
# 1. Put your .v files in project/
# 2. Update Makefile SRCS variable
# 3. Build and run
docker run --rm -v $(pwd)/project:/project verilator-gtkwave:quick \
  bash -c "cd /project && make sim"
```

### Check Versions
```bash
docker run --rm verilator-gtkwave:quick verilator --version
```

### Lint Verilog
```bash
docker run --rm -v $(pwd)/project:/project verilator-gtkwave:quick \
  verilator --lint-only /project/counter.v
```

## ❓ Troubleshooting

| Problem | Solution |
|---------|----------|
| Build too slow | Use `Dockerfile.quick` |
| Out of memory | Use quick build or reduce `-j` in Dockerfile |
| GTKWave won't open | Check X11 setup: `echo $DISPLAY` |
| Permission denied | `chmod -R 755 project/` |

## 📚 Files to Read

1. **README.md** - Complete documentation
2. **BUILD_NOTES.md** - Validation and testing info
3. **project/Makefile** - Build targets and flags

## 🎯 Next Steps

1. ✅ Validate: `./validate_dockerfiles.sh`
2. ✅ Build: `./build_and_test.sh`
3. ✅ Test: Run example simulation
4. ✅ Develop: Add your own designs

**Success Indicator**: You should see `counter.vcd` file created in project/ directory after running `make sim`.

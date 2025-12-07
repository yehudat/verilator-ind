# Verilator + GTKWave Docker Setup - Complete Package

## ✅ What's Included

This package provides a complete, ready-to-use Docker environment for Verilog/SystemVerilog development with:

- **Verilator 5.030** (stable) - Latest open-source Verilog simulator
- **GTKWave** - Popular open-source waveform viewer  
- **Working example** - Counter module with testbench
- **Testing scripts** - Automated verification
- **Documentation** - Complete usage guides

## 📁 Files Overview

```
.
├── Dockerfile              # Main Docker image definition
├── docker-compose.yml      # Easy container management
├── README.md              # Main documentation
├── TESTING.md             # Manual testing guide
├── test.sh                # Automated test script
├── run.sh                 # Convenience launcher
├── .gitignore             # Git ignore patterns
└── project/               # Example project directory
    ├── counter.v          # Verilog counter module
    ├── counter_tb.v       # Verilog testbench
    ├── counter_tb.cpp     # C++ testbench wrapper
    └── Makefile           # Build automation
```

## 🚀 Quick Start (30 seconds)

```bash
# 1. Build image (5-10 minutes, first time only)
docker build -t verilator-gtkwave:latest .

# 2. Test installation
./test.sh

# 3. Run example
docker run -it --rm -v $(pwd)/project:/project verilator-gtkwave:latest
cd /project && make sim
```

## ✨ Key Features

### Verilator
- ✅ Built from official stable branch
- ✅ Includes all standard tools (verilator_coverage, verilator_gantt, etc.)
- ✅ Optimized with ccache for faster builds
- ✅ Full SystemVerilog support
- ✅ VCD/FST waveform generation

### GTKWave  
- ✅ Latest version from Ubuntu repos
- ✅ X11 forwarding configured
- ✅ Ready for waveform viewing
- ✅ Works on Linux/macOS/Windows

### Example Project
- ✅ 8-bit counter with enable/reset
- ✅ Complete testbench with stimulus
- ✅ C++ wrapper for Verilator
- ✅ VCD generation included
- ✅ Makefile for easy building

## 📊 Expected Test Output

When you run `./test.sh`, you should see:

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

## 🎯 Common Use Cases

### 1. Quick Simulation
```bash
docker run --rm -v $(pwd)/project:/project verilator-gtkwave:latest \
    bash -c "cd /project && make sim"
```

### 2. Interactive Development
```bash
docker-compose run --rm verilator
# Now you're inside the container with all tools
cd /project
make sim
```

### 3. View Waveforms (with X11)
```bash
xhost +local:docker
docker-compose run --rm verilator
cd /project && make waves
```

### 4. Lint Verilog Code
```bash
docker run --rm -v $(pwd)/mycode:/mycode verilator-gtkwave:latest \
    verilator --lint-only /mycode/mymodule.v
```

## 🔧 Build Details

**Dockerfile builds:**
1. Base: Ubuntu 24.04 LTS
2. Installs: build-essential, perl, python3, flex, bison
3. Clones: Verilator from GitHub (stable branch)
4. Compiles: Verilator from source with optimizations
5. Installs: GTKWave from apt repos
6. Verifies: Both tools with version checks
7. Cleans: Build artifacts to reduce image size

**Final image size:** ~1.5 GB

## 💡 Tips & Best Practices

1. **Use docker-compose** - It handles X11 and volumes automatically
2. **Mount project directory** - Keep your work persistent
3. **Run tests first** - Verify everything works before starting
4. **Use Makefile** - Simplifies build/sim/view workflow
5. **Check TESTING.md** - For troubleshooting common issues

## 🐛 Troubleshooting

### Build fails
```bash
# Clean rebuild
docker build --no-cache -t verilator-gtkwave:latest .
```

### GTKWave won't open
```bash
# Check X11
echo $DISPLAY
xhost +local:docker
```

### Permission errors
```bash
# Fix permissions
chmod -R 755 project/
```

### Container can't be found
```bash
# List images
docker images | grep verilator

# If missing, rebuild
docker build -t verilator-gtkwave:latest .
```

## 📚 Documentation Files

- **README.md** - Main documentation with full details
- **TESTING.md** - Step-by-step testing guide
- **test.sh** - Automated testing script
- **run.sh** - Convenience launcher script

## 🎓 Learning Resources

- [Verilator Manual](https://verilator.org/guide/latest/)
- [GTKWave Documentation](http://gtkwave.sourceforge.net/)
- [Verilog Tutorial](https://www.asic-world.com/verilog/)

## ⚡ Performance

- **Container startup:** ~1 second
- **Example simulation:** <1 second  
- **Verilator compile time:** Depends on design size
- **GTKWave load time:** <2 seconds for small VCDs

## 🔐 Security Notes

- Container runs as root (for X11 access)
- Network access enabled for package installation
- Privileged mode used for GUI forwarding
- Consider security implications for production use

## 🤝 Contributing

Feel free to:
- Modify the Dockerfile for your needs
- Add more examples to the project/ directory
- Update documentation with your findings
- Share improvements with the community

## 📝 License

- Verilator: LGPL 3.0 / Artistic 2.0
- GTKWave: GPL 2.0
- This Docker setup: Use freely for any purpose

## ✉️ Support

If you encounter issues:
1. Check TESTING.md for common solutions
2. Verify Docker is running: `docker info`
3. Test with the included example first
4. Check logs: `docker logs <container-id>`

---

**Ready to get started?** Run `./test.sh` to verify everything works!

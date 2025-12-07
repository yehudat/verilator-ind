# Manual Testing Guide

This guide walks through manually testing the Verilator Docker setup.

## Step 1: Build the Image

```bash
docker build -t verilator-gtkwave:latest .
```

**Expected output:**
- Should complete without errors
- Final message: "Successfully tagged verilator-gtkwave:latest"

**Estimated time:** 5-10 minutes (depending on your internet speed and CPU)

## Step 2: Verify Verilator Installation

```bash
docker run --rm verilator-gtkwave:latest verilator --version
```

**Expected output:**
```
Verilator 5.030 2024-11-23 rev v5.030

Copyright 2003-2024 by Wilson Snyder. Verilator is free software; you can
redistribute it and/or modify the Verilator internals under the terms of
either the GNU Lesser General Public License Version 3 or the Perl Artistic
License Version 2.0.

See https://verilator.org for documentation
```

## Step 3: Verify GTKWave Installation

```bash
docker run --rm verilator-gtkwave:latest which gtkwave
```

**Expected output:**
```
/usr/bin/gtkwave
```

Or check version:
```bash
docker run --rm verilator-gtkwave:latest gtkwave --version
```

**Expected output:**
```
GTKWave Analyzer v3.3.104 (w)1999-2020 BSI
```

## Step 4: Test Basic Verilator Functionality

```bash
docker run --rm verilator-gtkwave:latest verilator --lint-only --help
```

**Expected output:**
- Should display help text for lint-only mode
- No errors

## Step 5: Run the Example Simulation

```bash
# Enter the container
docker run -it --rm -v $(pwd)/project:/project verilator-gtkwave:latest

# Inside container:
cd /project
make clean
make sim
```

**Expected output:**
```
verilator --cc --exe --build --trace -o Vcounter_tb counter.v counter_tb.v counter_tb.cpp
...
%Info: Building...
./obj_dir/Vcounter_tb
Time=0 reset=1 enable=0 count=  0
Time=20 reset=0 enable=0 count=  0
Time=30 reset=0 enable=1 count=  0
Time=40 reset=0 enable=1 count=  1
...
Simulation completed
- ./obj_dir/Vcounter_tb
```

**Verify outputs:**
```bash
ls -la counter.vcd
ls -la obj_dir/Vcounter_tb
```

Both files should exist.

## Step 6: Verify VCD File

```bash
# Check VCD file is valid
head -20 counter.vcd
```

**Expected output:**
```
$date
    Wed Dec  4 00:00:00 2024
$end
$version
    Verilator 5.030 2024-11-23 rev v5.030
$end
$timescale
    1ps
$end
...
```

## Step 7: Test GTKWave (Optional - Requires X11)

```bash
# On Linux with X11
xhost +local:docker
docker run -it --rm \
    -v $(pwd)/project:/project \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -e DISPLAY=$DISPLAY \
    verilator-gtkwave:latest

# Inside container:
cd /project
gtkwave counter.vcd &
```

**Expected result:**
- GTKWave window should open
- Waveform viewer should be visible
- You can browse signals in the left panel

## Common Issues and Solutions

### Issue: "docker: command not found"

**Solution:** Install Docker:
```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install docker.io

# macOS
brew install --cask docker
```

### Issue: Build fails with "E: Unable to locate package"

**Solution:** The base image might not be available. Try:
```bash
docker pull ubuntu:24.04
docker build -t verilator-gtkwave:latest .
```

### Issue: Verilator compilation errors

**Solution:** Check you have enough disk space and memory:
```bash
df -h  # Check disk space
free -h  # Check memory
```

Verilator compilation needs ~2GB disk space and ~2GB RAM.

### Issue: GTKWave won't open

**Solution:** 
1. Verify X11 is working: `echo $DISPLAY`
2. Test with: `xeyes` (should open X11 test app)
3. Allow Docker: `xhost +local:docker`
4. Check container can access X11:
   ```bash
   docker run --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix verilator-gtkwave:latest xeyes
   ```

### Issue: Permission denied on project files

**Solution:**
```bash
# Fix permissions
chmod -R 755 project/
sudo chown -R $USER:$USER project/
```

## Performance Notes

- **Build time:** First build takes 5-10 minutes
- **Simulation time:** Example runs in <1 second
- **Container startup:** ~1 second
- **Image size:** ~1.5 GB

## Next Steps

Once all tests pass:
1. Try modifying the counter.v module
2. Add more signals to the testbench
3. Experiment with Verilator flags in the Makefile
4. Create your own Verilog modules

## Getting Help

If tests fail:
1. Check Docker is running: `docker info`
2. Check logs: `docker logs <container-id>`
3. Verify disk space: `df -h`
4. Verify permissions: `ls -la project/`
5. Try rebuilding: `docker build --no-cache -t verilator-gtkwave:latest .`

## Verilator Docker Setup - Verification Checklist

Use this checklist to verify your setup is working correctly.

### Pre-Build Checks
- [ ] Docker is installed: `docker --version`
- [ ] Docker daemon is running: `docker info`
- [ ] You have at least 3GB free disk space: `df -h`
- [ ] You have at least 2GB free RAM: `free -h`

### Build Checks
- [ ] Dockerfile exists in current directory
- [ ] Build command runs: `docker build -t verilator-gtkwave:latest .`
- [ ] Build completes without errors (may take 5-10 minutes)
- [ ] Image is created: `docker images | grep verilator-gtkwave`

### Verilator Checks
- [ ] Verilator version shows: `docker run --rm verilator-gtkwave:latest verilator --version`
- [ ] Output shows: "Verilator 5.030" or similar
- [ ] Verilator binary exists: `docker run --rm verilator-gtkwave:latest which verilator`
- [ ] Shows: `/usr/local/bin/verilator`

### GTKWave Checks  
- [ ] GTKWave exists: `docker run --rm verilator-gtkwave:latest which gtkwave`
- [ ] Shows: `/usr/bin/gtkwave`
- [ ] GTKWave version works: `docker run --rm verilator-gtkwave:latest gtkwave --version`

### Example Project Checks
- [ ] Project directory exists: `ls -la project/`
- [ ] Contains: counter.v, counter_tb.v, counter_tb.cpp, Makefile
- [ ] Can enter container: `docker run -it --rm -v $(pwd)/project:/project verilator-gtkwave:latest`

### Simulation Checks (inside container)
- [ ] Can navigate: `cd /project`
- [ ] Make clean works: `make clean`
- [ ] Make sim works: `make sim`
- [ ] Simulation runs without errors
- [ ] VCD file created: `ls -la counter.vcd`
- [ ] Executable created: `ls -la obj_dir/Vcounter_tb`

### VCD File Checks
- [ ] VCD file is not empty: `wc -l counter.vcd` (should show 100+ lines)
- [ ] VCD header present: `head -10 counter.vcd | grep '\$version'`
- [ ] Contains Verilator version string

### X11/GTKWave Checks (Linux only)
- [ ] DISPLAY variable set: `echo $DISPLAY`
- [ ] X11 socket exists: `ls /tmp/.X11-unix/`
- [ ] xhost permissions: `xhost +local:docker`
- [ ] Can run xeyes test: `docker run --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix verilator-gtkwave:latest xeyes`
- [ ] GTKWave opens: `make waves` (inside container)

### Automated Test Checks
- [ ] Test script exists: `ls -la test.sh`
- [ ] Test script is executable: `test -x test.sh`
- [ ] Test script runs: `./test.sh`
- [ ] All tests pass (shows green checkmarks ✓)

### Performance Checks
- [ ] Container starts quickly (<2 seconds): `time docker run --rm verilator-gtkwave:latest echo "test"`
- [ ] Simulation is fast (<2 seconds for example)
- [ ] Image size reasonable: `docker images verilator-gtkwave:latest` (should be ~1.5GB)

### Troubleshooting Items (if any checks fail)

If Verilator version check fails:
```bash
docker run --rm verilator-gtkwave:latest bash -c "ls -la /usr/local/bin/verilator*"
docker run --rm verilator-gtkwave:latest bash -c "echo $PATH"
```

If GTKWave check fails:
```bash
docker run --rm verilator-gtkwave:latest apt list --installed | grep gtkwave
```

If simulation fails:
```bash
docker run --rm -v $(pwd)/project:/project verilator-gtkwave:latest bash -c "cd /project && make clean && make sim 2>&1 | tee build.log"
cat project/build.log
```

If X11 fails:
```bash
echo $DISPLAY
xauth list
xhost +local:docker
docker run --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix verilator-gtkwave:latest env | grep DISPLAY
```

### Sign-Off

Date: _______________

Setup verified by: _______________

Notes:
_________________________________
_________________________________
_________________________________

All critical checks passed: [ ] YES [ ] NO

Ready for development: [ ] YES [ ] NO

#!/bin/bash
# Test script to verify Verilator and GTKWave installation

set -e

echo "=========================================="
echo "Testing Verilator Docker Container"
echo "=========================================="
echo ""

# Test 1: Check Verilator version
echo "Test 1: Checking Verilator version..."
docker run --rm verilator-gtkwave:latest verilator --version
if [ $? -eq 0 ]; then
    echo "✓ Verilator is installed and working"
else
    echo "✗ Verilator test failed"
    exit 1
fi
echo ""

# Test 2: Check GTKWave
echo "Test 2: Checking GTKWave installation..."
docker run --rm verilator-gtkwave:latest which gtkwave
if [ $? -eq 0 ]; then
    echo "✓ GTKWave is installed"
else
    echo "✗ GTKWave test failed"
    exit 1
fi
echo ""

# Test 3: Run example simulation
echo "Test 3: Running example simulation..."
docker run --rm \
    -v $(pwd)/project:/project \
    verilator-gtkwave:latest \
    bash -c "cd /project && make clean && make sim"

if [ $? -eq 0 ] && [ -f project/counter.vcd ]; then
    echo "✓ Example simulation completed successfully"
    echo "✓ VCD file generated: project/counter.vcd"
else
    echo "✗ Simulation test failed"
    exit 1
fi
echo ""

echo "=========================================="
echo "All tests passed! ✓"
echo "=========================================="
echo ""
echo "You can now:"
echo "  1. Run container: docker-compose run --rm verilator"
echo "  2. Inside container: cd /project && make sim && make waves"

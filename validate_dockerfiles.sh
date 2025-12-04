#!/bin/bash
# Validate Dockerfile syntax and structure

echo "Validating Dockerfiles..."
echo

# Check if dockerfiles exist
if [ ! -f Dockerfile ]; then
    echo "ERROR: Dockerfile not found"
    exit 1
fi

echo "Checking Dockerfile..."

# Basic syntax checks
if ! grep -q "FROM debian:trixie-slim" "Dockerfile"; then
    echo "  WARNING: Base image not found or incorrect"
else
    echo "  ✓ Base image: debian:trixie-slim"
fi

if ! grep -q "WORKDIR" "Dockerfile"; then
    echo "  WARNING: No WORKDIR set"
else
    echo "  ✓ WORKDIR set"
fi

if ! grep -q "verilator" "Dockerfile"; then
    echo "  ERROR: Verilator not installed"
    exit 1
else
    echo "  ✓ Verilator installation found"
fi

if ! grep -q "gtkwave" "Dockerfile"; then
    echo "  ERROR: GTKWave not installed"
    exit 1
else
    echo "  ✓ GTKWave installation found"
fi

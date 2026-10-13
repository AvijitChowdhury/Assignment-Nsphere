#!/bin/bash
# Quick test - no SLURM needed
# Runs on the login node or GPU node directly

echo "================================"
echo "QUICK TEST - No SLURM Required"
echo "================================"
echo ""

if ! command -v nvcc &> /dev/null; then
    echo "⚠️  CUDA not loaded. Trying: module load cuda"
    module load cuda 2>/dev/null || {
        echo "❌ CUDA not available"
        exit 1
    }
fi

echo "Step 1: Compile"
echo "==============="
make clean && make
if [ ! -f nsphere ]; then
    echo "❌ Compilation failed"
    exit 1
fi
echo "✓ Compiled successfully"
echo ""

echo "Step 2: Verify Correctness"
echo "=========================="
echo "These should output: 51, 13, 19"
echo ""

echo "Test: ./nsphere 1 25.5 (expected 51)"
./nsphere 1 25.5 2>&1 | grep "GPU count"
echo ""

echo "Test: ./nsphere 2 2.05 (expected 13)"
./nsphere 2 2.05 2>&1 | grep "GPU count"
echo ""

echo "Test: ./nsphere 3 1.5 (expected 19)"
./nsphere 3 1.5 2>&1 | grep "GPU count"
echo ""

echo "Step 3: Dimension Scaling (D effect)"
echo "===================================="
echo "Shows exponential growth with dimension"
echo ""

for D in 4 5 6 7 8 9; do
    echo "D=$D: "
    ./nsphere $D 8.0 256 1 2>&1 | grep "kernel time"
done
echo ""

echo "Step 4: Radius Scaling (R effect)"
echo "=================================="
echo "Shows slower growth with radius"
echo ""

for R in 4 6 8 10 12 16; do
    echo "R=$R: "
    ./nsphere 7 $R 256 1 2>&1 | grep "kernel time"
done
echo ""

echo "================================"
echo "✓ QUICK TEST COMPLETED"
echo "================================"
echo ""
echo "For stress testing, run: bash stress_gpu.sh"
echo "For SLURM submission, run: sbatch submit_nsphere_scaling.sh"

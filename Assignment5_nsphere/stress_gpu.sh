#!/bin/bash
# GPU Stress Test - Find GPU breaking points
# Tests extreme D and R values until overflow/failure

echo "=========================================="
echo "GPU STRESS TEST - FIND BREAKING POINT"
echo "Tesla T4 / V100 Limits"
echo "=========================================="
echo ""

echo "=== PHASE 1: PUSH D (DIMENSION) ==="
echo "Testing D from 10 to 20 at R=8.0"
echo "Expected: Overflow around D=12 (64-bit limit)"
echo ""

for D in 10 11 12 13 14 15 16 17 18 19 20; do
    echo "D=$D, R=8.0:"
    timeout 60 ./nsphere $D 8.0 256 1 2>&1 | grep -E "(kernel time|overflows|GPU count|rows=)"
    if timeout 60 ./nsphere $D 8.0 256 1 2>&1 | grep -q "overflows"; then
        echo "❌ OVERFLOW - D limit reached at D=$D"
        echo ""
        break
    fi
    echo ""
done

echo ""
echo "=== PHASE 2: PUSH R (RADIUS) ==="
echo "Testing R from 20 to 200 at D=7"
echo "Expected: R can go very high before overflow"
echo ""

for R in 20 30 40 50 60 80 100 120 150 200; do
    echo "D=7, R=$R:"
    timeout 60 ./nsphere 7 $R 256 1 2>&1 | grep -E "(kernel time|overflows|GPU count|rows=)"
    if timeout 60 ./nsphere 7 $R 256 1 2>&1 | grep -q "overflows"; then
        echo "❌ OVERFLOW - R limit reached at R=$R"
        echo ""
        break
    fi
    echo ""
done

echo ""
echo "=== PHASE 3: MASSIVE COMBINATIONS ==="
echo "Increase both D and R to extreme levels"
echo ""

for pair in "10 15" "11 12" "12 10" "13 8" "14 6" "15 5" "16 4" "17 3" "18 2"; do
    D=$(echo $pair | awk '{print $1}')
    R=$(echo $pair | awk '{print $2}')
    echo "D=$D, R=$R:"
    timeout 60 ./nsphere $D $R 256 1 2>&1 | grep -E "(kernel time|overflows|GPU count|rows=)"
    if timeout 60 ./nsphere $D $R 256 1 2>&1 | grep -q "overflows"; then
        echo "❌ OVERFLOW at D=$D, R=$R"
        echo ""
        break
    fi
    echo ""
done

echo ""
echo "=== PHASE 4: EXTREME TESTS ==="
echo ""

echo "Test: D=8, R=200 (ultra-massive radius)"
timeout 60 ./nsphere 8 200.0 256 1 2>&1 | grep -E "(kernel time|overflows|GPU count|CUDA error)" || echo "Test completed or timed out"
echo ""

echo "Test: D=20, R=8 (ultra-high dimension)"
timeout 60 ./nsphere 20 8.0 256 1 2>&1 | grep -E "(kernel time|overflows|GPU count|CUDA error)" || echo "Test completed or timed out"
echo ""

echo "Test: D=15, R=15 (balanced extreme)"
timeout 60 ./nsphere 15 15.0 256 1 2>&1 | grep -E "(kernel time|overflows|GPU count|CUDA error)" || echo "Test completed or timed out"
echo ""

echo "Test: D=10, R=50 (very large radius)"
timeout 60 ./nsphere 10 50.0 256 1 2>&1 | grep -E "(kernel time|overflows|GPU count|CUDA error)" || echo "Test completed or timed out"
echo ""

echo "=========================================="
echo "STRESS TEST COMPLETED"
echo "=========================================="

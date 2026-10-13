#!/bin/bash
# Scaling study for Assignment 5: increase r and D, watch what the GPU does.
# N = (2r+1)^D candidate points. Keep your course #SBATCH header if you have one.
#SBATCH --job-name=nsphere_scale
#SBATCH --output=nsphere_scale_%j.out
#SBATCH --gres=gpu:1
#SBATCH --time=01:00:00
module load cuda 2>/dev/null || true
cd "$SLURM_SUBMIT_DIR"
nvidia-smi --query-gpu=name,memory.total,compute_cap --format=csv
make || exit 1

echo "== correctness (expect 13, 19, 51) =="
./nsphere 2 2.05 ; ./nsphere 3 1.5 ; ./nsphere 1 25.5

echo "== baseline from the whiteboard: r=8, D=7  (17^7 = 410,338,673) =="
./nsphere 7 8.0

echo "== vary D at fixed r=8 (CPU check skipped automatically when N > 4e9) =="
for D in 4 5 6 7 8 9 10 11 12; do ./nsphere $D 8.0 256 1; done

echo "== vary r at fixed D=7 =="
for r in 4.0 6.0 8.0 10.0 12.0 16.0 20.0; do ./nsphere 7 $r 256 1; done

echo "== increase both together =="
for pair in "5 4.0" "6 6.0" "7 8.0" "8 10.0" "9 12.0" "10 16.0"; do ./nsphere $pair 256 1; done

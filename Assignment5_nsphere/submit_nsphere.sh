#!/bin/bash
# SLURM script. If the course supplied its own #SBATCH header, keep that one.
#SBATCH --job-name=nsphere
#SBATCH --output=nsphere_%j.out
#SBATCH --gres=gpu:1
#SBATCH --time=00:20:00
module load cuda 2>/dev/null || true     # use the exact name from `module avail`
cd "$SLURM_SUBMIT_DIR"
nvidia-smi --query-gpu=name,memory.total,compute_cap --format=csv
make || exit 1
./nsphere 2 2.05 ; ./nsphere 3 1.5 ; ./nsphere 1 25.5          # correctness (13, 19, 51)
for n in 4 5 6 7 8; do ./nsphere $n 8.0 ; done                    # scaling with dimension
for t in 32 64 128 256 512 1024; do ./nsphere 7 6.0 $t ; done     # threads/block sweep

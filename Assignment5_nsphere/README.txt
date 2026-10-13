Assignment 5 - nsphere on CTCP
  unzip Assignment5_nsphere.zip ; cd Assignment5_nsphere
  module avail 2>&1 | grep -i cuda ; module load <exact name>
  sbatch submit_nsphere.sh            # original tests + dimension and threads/block sweeps
  sbatch submit_nsphere_scaling.sh    # r and D scaling study (N=(2r+1)^D)
  squeue -u $USER ; cat nsphere_*.out nsphere_scale_*.out
Interactive (GPU node):  make ; ./nsphere 7 8.0 ; ./nsphere 3 1.5
Usage: ./nsphere <ndim> <radius> [threads_per_block=256] [skipcpu=0|1]
If nvcc < 11.5:  make ARCH=sm_XX

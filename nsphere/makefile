ARCH ?= native      # or e.g. sm_75 / sm_86 (see: nvidia-smi --query-gpu=name,compute_cap --format=csv)
all: nsphere
nsphere: nsphere.cu
	nvcc -O3 -w -arch=$(ARCH) -o $@ nsphere.cu
clean:
	rm -f nsphere

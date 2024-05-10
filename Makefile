NVCC = /usr/local/cuda/bin/nvcc

solver: solver.cu
	$(NVCC) solver.cu -o solver -arch=sm_60 -std=c++11 -I/usr/local/cuda/include

clean:
	rm -f solver

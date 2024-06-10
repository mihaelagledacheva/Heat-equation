NVCC = /usr/local/cuda/bin/nvcc

main: main.cu
	$(NVCC) main.cu -o main -arch=sm_60 -std=c++11 -I/usr/local/cuda/include

clean:
	rm -f main
	rm -f *.txt
	rm -f *.png

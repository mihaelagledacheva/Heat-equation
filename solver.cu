/**
 * @brief Computes the solutions of the heat equation sequentually
 * @param U - array representing the heat function
 * @param lambda - the lambda parameter used in the heat equation
 * @param rows - number of rows in the heat function grid
 * @param cols - number of columns in the heat function grid
 * @param iterations - number of iterations
*/
void ComputeSequential1(double* U, double lambda, int rows, int cols, int iterations) {
    double* U_next = (double*) malloc(rows * cols * sizeof(double));
    for (int n = 0; n < iterations; ++n) {
        for (int i = 0; i < rows; ++i) {
            for (int j = 0; j < cols; ++j) {
                double a = (i < rows - 1) ? U[(i + 1) * cols + j] : 0;
                double b = (i > 0) ? U[(i - 1) * cols + j] : 0;
                double c = (j < cols - 1) ? U[i * cols + (j + 1)] : 0;
                double d = (j > 0) ? U[i * cols + (j - 1)] : 0;
                U_next[i * cols + j] = (1 - 4 * lambda) * U[i * cols + j] + lambda * (a + b + c + d);
            }
        }
        std::swap(U, U_next);
    }
    delete[] U_next;
}

/**
 * @brief Computes the solutions of the heat equation in parallel
 * @param U - array representing the current state of the heat function
 * @param U_next - array representing the next state of the heat function
 * @param rows - number of rows in the heat function grid
 * @param cols - number of columns in the heat function grid
 * @param lambda - the lambda parameter used in the heat equation
 * @param size - chunk size
*/
__global__
void ComputeGPUAux1(double* U, double* U_next, int rows, int cols, double lambda, int size) {
    int index = blockIdx.x * blockDim.x + threadIdx.x;
    int begin = size * index;
    int end = (size * (index + 1) < rows * cols) ? size * (index + 1) : rows * cols;
    
    for (int k = begin; k < end; ++k) {
        int i = k / cols;
        int j = k % cols;

        double a = (i < rows - 1) ? U[(i + 1) * cols + j] : 0;
        double b = (i > 0) ? U[(i - 1) * cols + j] : 0;
        double c = (j < cols - 1) ? U[i * cols + (j + 1)] : 0;
        double d = (j > 0) ? U[i * cols + (j - 1)] : 0;
                
        U_next[i * cols + j] = (1 - 4 * lambda) * U[i * cols + j] + lambda * (a + b + c + d);
    }
}

/**
 * @brief Parallelizes the numerical scheme for GPU acceleration
 * @param U - array representing the state of the heat function
 * @param lambda - the lambda parameter used in the heat equation
 * @param rows - number of rows in the heat function grid
 * @param cols - number of columns in the heat function grid
 * @param iterations - number of iterations
*/
void ComputeGPU1(double* U, double lambda, int rows, int cols, int iterations) {
    const int BLOCKS_NUM = 48;
    const int THREADS_PER_BLOCK = 256;
    const int TOTAL_THREADS = BLOCKS_NUM  * THREADS_PER_BLOCK;
    int size = (rows * cols + TOTAL_THREADS + 1) / TOTAL_THREADS;

    double *d_U, *d_U_next;

    cudaMalloc(&d_U, rows * cols * sizeof(double));
    cudaMalloc(&d_U_next, rows * cols * sizeof(double));

    cudaMemcpy(d_U, U, rows * cols * sizeof(double), cudaMemcpyHostToDevice);

    for (int n = 0; n < iterations; ++n) {
        ComputeGPUAux1<<<BLOCKS_NUM, THREADS_PER_BLOCK>>>(d_U, d_U_next, rows, cols, lambda, size);
        cudaDeviceSynchronize();
        std::swap(d_U, d_U_next);
    }

    cudaMemcpy(U, d_U, rows * cols * sizeof(double), cudaMemcpyDeviceToHost);

    cudaFree(d_U);
    cudaFree(d_U_next);
}

//----------------------------------------------------

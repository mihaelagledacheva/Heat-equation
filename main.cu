#include <cassert>
#include <chrono>
#include <iostream>

#include "solver.cu"
#include "test.cpp"

int main(int argc, char* argv[]) {
    if (argc != 3) {
        std::cout << "Usage: ./main <solver number> <test number>" << std::endl;
        return 1;
    }

    int solver = std::atoi(argv[1]);
    int test_case = std::atoi(argv[2]);
    if (solver < 1 || solver > 1 || test_case < 1 || test_case > 3) {
        std::cout << "The solver number must be between 1 and 1" << std::endl;
        std::cout << "The test case number must be between 1 and 3" << std::endl;
        return 1;
    }
    
    std::function<void(Region&, Region&, double&, double&, double&)> test;
    switch (test_case) {
        case 1: {
            test = test1; 
            break;
        }
        case 2: {
            test = test2; 
            break;
        }
        case 3: {
            test = test3; 
            break;
        }
        default: {
            std::cout << "Invalid test case number." << std::endl; 
            return 1;
        }
    }

    std::function<void(double*, double, int, int, int)> sequential_solver;
    std::function<void(double*, double, int, int, int)> gpu_solver;
    switch (solver) {
        case 1: {
            sequential_solver = ComputeSequential1;
            gpu_solver = ComputeGPU1;
            break;
        }
        default: {
            std::cout << "Invalid solver number." << std::endl; 
            return 1;
        }
    }

    // Parameters
    Region base, target;
    double gamma, delta, time;

    test(base, target, gamma, delta, time);
    assert(target.discrete);

    int rows, cols, iterations;
    double lambda;

    set_up(target, gamma, delta, time, rows, cols, iterations, lambda);
    assert(lambda < 0.25);

    // Memory allocation
    double* U_seq = (double*) malloc(rows * cols * sizeof(double));
    double* U_cuda = (double*) malloc(rows * cols * sizeof(double));

    initialize(base, target, U_seq, U_cuda, rows, cols, iterations, delta);

    // Sequential algorithm
    std::cout << "Running sequential algorithm" << std::endl;
    auto start_seq = std::chrono::steady_clock::now();
    sequential_solver(U_seq, lambda, rows, cols, iterations);
    auto finish_seq = std::chrono::steady_clock::now();
    auto elapsed_seq = std::chrono::duration_cast<std::chrono::milliseconds>(finish_seq - start_seq).count(); 
    std::cout << "Time elapsed: " << elapsed_seq << " milliseconds" << std::endl;
    visualize(U_seq, rows, cols, iterations, "heatmap_sequential.txt");
    std::cout << "Result stored in heatmap_sequential.txt" << std::endl;

    // GPU algorithm
    std::cout << "Running GPU algorithm" << std::endl;
    auto start_cuda = std::chrono::steady_clock::now();
    gpu_solver(U_cuda, lambda, rows, cols, iterations);
    auto finish_cuda = std::chrono::steady_clock::now();
    auto elapsed_cuda = std::chrono::duration_cast<std::chrono::milliseconds>(finish_cuda - start_cuda).count(); 
    std::cout << "Time elapsed: " << elapsed_cuda << " milliseconds" << std::endl;
    visualize(U_cuda, rows, cols, iterations, "heatmap_gpu.txt");
    std::cout << "Result stored in heatmap_gpu.txt" << std::endl;

    if (validate(U_seq, U_cuda, rows, cols)) {
        std::cout << "Successful validation" << std::endl;
    } else {
        std::cout << "Validation failed" << std::endl;
    }

    delete[] U_seq;
    delete[] U_cuda;

    return 0;
}

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
    if (solver < 1 || solver > 3 || test_case < 1 || test_case > 30) {
        std::cout << "The solver number must be between 1 and 3" << std::endl;
        std::cout << "The test case number must be between 1 and 30" << std::endl;
        return 1;
    }
    
    std::function<void(Region&, Region&, double&, double&, double&)> test;
    switch (test_case) {
        case 1:  test = test1;  break;
        case 2:  test = test2;  break;
        case 3:  test = test3;  break;
        case 4:  test = test4;  break;
        case 5:  test = test5;  break;
        case 6:  test = test6;  break;
        case 7:  test = test7;  break;
        case 8:  test = test8;  break;
        case 9:  test = test9;  break;
        case 10: test = test10; break;
        case 11: test = test11; break;
        case 12: test = test12; break;
        case 13: test = test13; break;
        case 14: test = test14; break;
        case 15: test = test15; break;
        case 16: test = test16; break;
        case 17: test = test17; break;
        case 18: test = test18; break;
        case 19: test = test19; break;
        case 20: test = test20; break;
        case 21: test = test21; break;
        case 22: test = test22; break;
        case 23: test = test23; break;
        case 24: test = test24; break;
        case 25: test = test25; break;
        case 26: test = test26; break;
        case 27: test = test27; break;
        case 28: test = test28; break;
        case 29: test = test29; break;
        case 30: test = test30; break;
        default: {
            std::cout << "Invalid test case number." << std::endl; 
            return 1;
        }
    }

    std::function<void(double*, double, int, int, int)> sequential_solver;
    std::function<void(double*, double, int, int, int)> gpu_solver;
    switch (solver) {
        case 1: {
            // Equation 1, fixed number of threads
            sequential_solver = ComputeSequential;
            gpu_solver = ComputeGPU1;
            break;
        }
        case 2: {
            // Equation 1, one thread per grid element
            sequential_solver = ComputeSequential;
            gpu_solver = ComputeGPU2;
            break;
        }
        case 3: {
            // Equation 1, one thread per row
            sequential_solver = ComputeSequential;
            gpu_solver = ComputeGPU3;
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

    // GPU algorithm
    std::cout << "Running GPU algorithm" << std::endl;
    auto start_cuda = std::chrono::steady_clock::now();
    gpu_solver(U_cuda, lambda, rows, cols, iterations);
    auto finish_cuda = std::chrono::steady_clock::now();
    auto elapsed_cuda = std::chrono::duration_cast<std::chrono::milliseconds>(finish_cuda - start_cuda).count(); 
    std::cout << "Time elapsed: " << elapsed_cuda << " milliseconds" << std::endl;
    visualize(U_cuda, rows, cols, iterations, "heatmap_gpu.txt");

    assert(validate(U_seq, U_cuda, rows, cols));

    delete[] U_seq;
    delete[] U_cuda;

    return 0;
}

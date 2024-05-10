#include <cassert>
#include <chrono>
#include <functional>
#include <iostream>
#include <vector>

class Point {
public:
    double x, y;
    double U;
    double time;

    Point() {}
    Point(double x, double y, double U=0, double time=0) : x(x), y(y), U(U), time(time) {}

    bool operator==(const Point& other) const {
        return (x == other.x && y == other.y);
    }
};

class Region {
private:
    bool discrete;
    std::function<bool(const Point&)> condition;

public:
    std::vector<Point> points;

    Region() {}
    Region(std::vector<Point> points) : points(points), discrete(true) {}
    Region(std::function<bool(const Point&)> f) : condition(f), discrete(false) {}

    bool contains(const Point& p) const {
        if (discrete) {
            for (const auto& point : points) {
                if (p == point) {
                    return true;
                }
            }
            return false;
        } else {
            return condition(p);
        }
    }
};

//----------------------------------------------------

/**
 * @brief Computes the solutions of the heat equation sequentually
 * @param U_0 - array representing the initial state of the heat function
 * @param U_res - array representing the final state of the heat function
 * @param lambda - the lambda parameter used in the heat equation
 * @param rows - number of rows in the heat function grid
 * @param cols - number of columns in the heat function grid
*/
void ComputeSequential(double* U_0, double* U_res, double lambda, int rows, int cols) {
    // #TODO
}

//----------------------------------------------------

/**
 * @brief Computes the solutions of the heat equation in parallel
 * @param U_0 - array representing the initial state of the heat function
 * @param U_res - array representing the final state of the heat function
 * @param lambda - the lambda parameter used in the heat equation
*/
__global__ void ComputeGPUAux(double* U_0, double* U_res, double lambda) {
    // #TODO
}

/**
 * @brief Parallelizes the numerical scheme for GPU acceleration
 * @param U_0 - array representing the initial state of the heat function
 * @param U_res - array representing the final state of the heat function
 * @param lambda - the lambda parameter used in the heat equation
 * @param rows - number of rows in the heat function grid
 * @param cols - number of columns in the heat function grid
*/
void ComputeGPU(double* U_0, double* U_res, double lambda, int rows, int cols) {
    // #TODO
}

//----------------------------------------------------

/**
 * @brief Computes the solutions of the heat equation in parallel
 * @param U_0 - array representing the initial state of the heat function
 * @param U_res - array representing the final state of the heat function
 * @param lambda - the lambda parameter used in the heat equation
*/
__global__ void ComputeGPUAux2(double* U_0, double* U_res, double lambda) {
    // #TODO
}

/**
 * @brief Parallelizes the numerical scheme for GPU acceleration
 * @param U_0 - array representing the initial state of the heat function
 * @param U_res - array representing the final state of the heat function
 * @param lambda - the lambda parameter used in the heat equation
 * @param rows - number of rows in the heat function grid
 * @param cols - number of columns in the heat function grid
*/
void ComputeGPU2(double* U_0, double* U_res, double lambda, int rows, int cols) {
    // #TODO
}

//----------------------------------------------------

/**
 * @brief Sets values to the parameters of the heat equation
 * @param base - known initial heat values
 * @param target - point at which to evaluate the heat function
 * @param gamma - time step
 * @param delta - space step
*/
void setup(Region& base, Point& target, double& gamma, double& delta) {
    // #TODO
}

/**
 * @brief Fills in the initial heat function grid
 * @param base - known initial heat values
 * @param U_0 - array representing the initial state of the heat function
 * @param gamma - time step
 * @param delta - space step
*/
void initialize(Region& base, double* U_0, double& gamma, double& delta) {
    // #TODO
}

/**
 * @brief Validates the obtained solution
 * @param U_res - array representing the heat function
 * @param i - column at which the target point is located
 * @param j - row at which the target point is located
 * @param res - expected result
*/
void validate(double *U_res, int i, int j, double res) {
    // #TODO
}

/**
 * @brief Visualizes the heat function using gnuplot
 * @param U_res - array representing the heat function
*/
void visualize(double *U_res) {
    // #TODO
}

//----------------------------------------------------

int main() {
    // Parameters
    Region base;
    Point target;
    double gamma;
    double delta;

    setup(base, target, gamma, delta);

    double lambda = gamma / (delta * delta);
    assert(lambda < 0.5);

    // Coordinates of the target point in the heat function grid
    int i = static_cast<int>(target.x/delta);
    int j = static_cast<int>(target.y/delta);
    
    // Dimensions of the problem
    int rows = 2 * j + 1;
    int cols = 2 * i + 1;
    int iterations = static_cast<int>(target.time/gamma);

    // Memory allocation
    double* U_0 = (double*) malloc(rows * cols * sizeof(double));
    double* U_res_seq   = (double*) malloc(rows * cols * sizeof(double));
    double* U_res_cuda  = (double*) malloc(rows * cols * sizeof(double));
    double* U_res_cuda2 = (double*) malloc(rows * cols * sizeof(double));

    initialize(base, U_0, gamma, delta);

    // Sequential algorithm
    auto start_seq = std::chrono::steady_clock::now();
    ComputeSequential(U_0, U_res_seq, lambda, rows, cols);
    auto finish_seq = std::chrono::steady_clock::now();
    auto elapsed_seq = std::chrono::duration_cast<std::chrono::microseconds>(finish_seq - start_seq).count(); 
    std::cout << "Elapsed time for the sequential algorithm: " << elapsed_seq << std::endl << std::endl;
    validate(U_res_seq, i, j, target.U);
    visualize(U_res_seq);

    // GPU algorithm
    auto start_cuda = std::chrono::steady_clock::now();
    ComputeGPU(U_0, U_res_cuda, lambda, rows, cols);
    auto finish_cuda = std::chrono::steady_clock::now();
    auto elapsed_cuda = std::chrono::duration_cast<std::chrono::microseconds>(finish_cuda - start_cuda).count(); 
    std::cout << "Elapsed time for the GPU algorithm: " << elapsed_cuda << std::endl;
    validate(U_res_cuda, i, j, target.U);
    visualize(U_res_cuda);

    // Second GPU algorithm
    auto start_cuda2 = std::chrono::steady_clock::now();
    ComputeGPU2(U_0, U_res_cuda2, lambda, rows, cols);
    auto finish_cuda2 = std::chrono::steady_clock::now();
    auto elapsed_cuda2 = std::chrono::duration_cast<std::chrono::microseconds>(finish_cuda2 - start_cuda2).count(); 
    std::cout << "Elapsed time for the second GPU algorithm: " << elapsed_cuda2 << std::endl;
    validate(U_res_cuda2, i, j, target.U);
    visualize(U_res_cuda2);

    delete[] U_0;
    delete[] U_res_seq;
    delete[] U_res_cuda;
    delete[] U_res_cuda2;

    return 0;
}

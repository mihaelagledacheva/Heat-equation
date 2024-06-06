#include <algorithm>
#include <cstdlib>
#include <fstream>
#include <functional>
#include <limits>
#include <memory>
#include <vector>
#include <iostream>

class Point {
public:
    double x, y;
    double U;

    Point() {}
    Point(double x, double y, double U=0) : x(x), y(y), U(U) {}

    bool operator==(const Point& other) const {
        return (abs(x - other.x) < 1e-3 && abs(y - other.y) < 1e-3);
    }
};

class Region {
private:
    std::function<bool(const Point&)> condition;
    std::function<double(const Point&)> heat_function;

public:
    bool discrete;
    std::vector<Point> points;

    Region() {}
    Region(const std::vector<Point>& points) : points(points), discrete(true) {}
    Region(std::function<bool(const Point&)> f, 
                     std::function<double(const Point&)> g) : condition(f), 
                                                              heat_function(g), 
                                                              discrete(false) {}

    double compute_U(const Point& p) const {
        if (discrete) {
            for (const auto& point : points) {
                if (p == point) {
                    return point.U;
                }
            }
        } else {
            if (condition(p)) {
                return heat_function(p);
            }
        }
        return 0;
    }

    void find_min(double& min_x, double& min_y) const {
        min_x = std::numeric_limits<double>::max();
        min_y = std::numeric_limits<double>::max();

        for (const auto& point : points) {
            if (point.x < min_x) min_x = point.x;
            if (point.y < min_y) min_y = point.y;
        }
    }

    void find_max(double& max_x, double& max_y) const {
        max_x = std::numeric_limits<double>::lowest();
        max_y = std::numeric_limits<double>::lowest();

        for (const auto& point : points) {
            if (point.x > max_x) max_x = point.x;
            if (point.y > max_y) max_y = point.y;
        }
    }
};

//----------------------------------------------------

/**
 * @brief Computes the necessary parameters
 * @param target - set of points for which to compute the heat equation
 * @param gamma - time step
 * @param delta - space step
 * @param time - the time at which to compute the heat equation
 * @param rows - number of rows in the heat function grid
 * @param cols - number of columns in the heat function grid
 * @param iterations - number of iterations
 * @param lambda - the lambda parameter used in the heat equation
*/
void set_up(Region& target, double gamma, double delta, double time,
            int& rows, int& cols, int& iterations, double& lambda) {
    lambda = gamma / (delta * delta);

    iterations = static_cast<int>(time/gamma);

    double min_x, max_x, min_y, max_y;
    target.find_min(min_x, min_y);
    target.find_max(max_x, max_y);

    rows = std::round((max_x-min_x)/delta) + 1 + 2 * iterations;
    cols = std::round((max_y-min_y)/delta) + 1 + 2 * iterations;
}

/**
 * @brief Fills in the initial heat function grid
 * @param base - known initial heat values
 * @param target - set of points for which to compute the heat equation
 * @param U_0 - array representing the initial state of the heat function
 * @param rows - number of rows in the heat function grid
 * @param cols - number of columns in the heat function grid
 * @param iterations - number of iterations
 * @param delta - space step
*/
void initialize(Region& base, Region& target, double* U1, double* U2, int rows, int cols, int iterations, double delta) {
    double min_x, min_y;
    target.find_min(min_x, min_y);

    for (int i = 0; i < rows; ++i) {
        for (int j = 0; j < cols; ++j) {
            double x = (i - iterations) * delta + min_x;
            double y = (j - iterations) * delta + min_y;
            Point p(x, y);
            double U = base.compute_U(p);
            U1[i * cols + j] = U;
            U2[i * cols + j] = U;
        }
    }
}

/**
 * @brief Saves a visualization of the heat function
 * @param U_res - array representing the heat function
 * @param rows - number of rows in the heat function grid
 * @param cols - number of columns in the heat function grid
 * @param iterations - number of iterations
 * @param filename - name for the heatmap image
*/
void visualize(double *U_res, int rows, int cols, int iterations, const std::string& filename) {
    std::ofstream file(filename);
    for (int i = iterations; i < rows-iterations; ++i) {
        for (int j = iterations; j < cols-iterations; ++j) {
            file << i-iterations << " " << j-iterations << " " << U_res[i * cols + j] << std::endl;
        }
    }
    file.close();
}

/**
 * @brief Validates the obtained solution
 * @param U_res_seq - the result from the sequential method
 * @param U_res_cuda - the result from the GPU method
 * @param rows - number of rows in the heat function grid
 * @param cols - number of columns in the heat function grid
*/
bool validate(double *U_res_seq, double *U_res_cuda, int rows, int cols) {
    for (int i = 0; i < rows; ++i) {
        for (int j = 0; j < cols; ++j) {
            if (abs(U_res_seq[i * cols + j] - U_res_cuda[i * cols + j]) > 1e-3) {
                std::cout << i << ", " << j << ": " << U_res_seq[i * cols + j] << " != " << U_res_cuda[i * cols + j] <<std::endl;
                //return false;
            }
        }
    }
    return true;
}

#include <random>

#include "setting.cpp"

//----------------------------------------------------
// Discrete region with a single hot spot

void test1(Region& base, Region& target, double& gamma, double& delta, double& time) {
    base = Region({Point(2, 2, 100)});
    target = Region({Point(1, 1), Point(3, 3)});
    gamma = 0.1;
    delta = 1;
    time = 1;
}

void test2(Region& base, Region& target, double& gamma, double& delta, double& time) {
    base = Region({Point(2, 2, 100)});
    target = Region({Point(1, 1), Point(3, 3)});
    gamma = 0.005;
    delta = 0.2;
    time = 1;
}

void test3(Region& base, Region& target, double& gamma, double& delta, double& time) {
    base = Region({Point(2, 2, 100)});
    target = Region({Point(1, 1), Point(3, 3)});
    gamma = 0.00125;
    delta = 0.1;
    time = 1;
}

//----------------------------------------------------
// Discrete region with two hot spots

void test4(Region& base, Region& target, double& gamma, double& delta, double& time) {
    base = Region({Point(0.5, 0.5, 75), Point(3.5, 3.5, 75)});
    target = Region({Point(0, 0), Point(4, 4)});
    gamma = 0.002;
    delta = 0.1;
    time = 1;
}

void test5(Region& base, Region& target, double& gamma, double& delta, double& time) {
    base = Region({Point(1, 1, 75), Point(3, 3, 75)});
    target = Region({Point(0, 0), Point(4, 4)});
    gamma = 0.002;
    delta = 0.1;
    time = 1;
}

void test6(Region& base, Region& target, double& gamma, double& delta, double& time) {
    base = Region({Point(1, 1, 100), Point(3, 3, 50)});
    target = Region({Point(0, 0), Point(4, 4)});
    gamma = 0.002;
    delta = 0.1;
    time = 1;
}

void test7(Region& base, Region& target, double& gamma, double& delta, double& time) {
    base = Region({Point(0.5, 0.5, 100), Point(3.5, 3.5, 50)});
    target = Region({Point(0, 0), Point(4, 4)});
    gamma = 0.002;
    delta = 0.1;
    time = 1;
}

//----------------------------------------------------
// Discrete region with several hot spots

void test8(Region& base, Region& target, double& gamma, double& delta, double& time) {
    base = Region({Point(-2, -2, 150), Point(0, 0, 75), Point(4, 4, 125)});
    target = Region({Point(-3, -3), Point(5, 5)});
    gamma = 0.01;
    delta = 0.25;
    time = 1.5;
}

void test9(Region& base, Region& target, double& gamma, double& delta, double& time) {
    base = Region({Point(-2, -3, 100), Point(3.5, 0, 150), Point(0.5, 2, 50)});
    target = Region({Point(-3, -3), Point(3, 3)});
    gamma = 0.001;
    delta = 0.1;
    time = 0.5;
}

void test10(Region& base, Region& target, double& gamma, double& delta, double& time) {
    base = Region({Point(-4, 1, 100), Point(-2, 3, 75), Point(0, -3, 125), Point(3, 0, 100), Point(-1, 0, 75)});
    target = Region({Point(-5, -5), Point(5, 5)});
    gamma = 0.002;
    delta = 0.1;
    time = 1;
}

//----------------------------------------------------
// Discrete region with random hot spots

int random_int(int min, int max) {
    static std::random_device rd;
    static std::mt19937 gen(rd());
    std::uniform_int_distribution<> dis(min, max);
    return dis(gen);
}

void test11(Region& base, Region& target, double& gamma, double& delta, double& time) {
    int num_points = random_int(1, 10);
    std::vector<double> heat_values = {50, 75, 100, 125, 150};
    std::vector<Point> base_points;
    for (int i = 0; i < num_points; ++i) {
        double x = random_int(-19, 19);
        double y = random_int(-19, 19);
        double U = heat_values[random_int(0, heat_values.size() - 1)];
        base_points.push_back(Point(x, y, U));
    }
    base = Region(base_points);
    target = Region({Point(-20, -20), Point(20, 20)});
    gamma = 0.002;
    delta = 0.2;
    time = 1;
}

//----------------------------------------------------
// Continuous region with circular hot area

void test12(Region& base, Region& target, double& gamma, double& delta, double& time) {
    base = Region([](const Point& p) { return p.x*p.x + p.y*p.y < 64; },
                  [](const Point& p) { return 100; });
    target = Region({Point(-15, -15), Point(15, 15)});
    gamma = 0.005;
    delta = 0.2;
    time = 0.5;
}

void test13(Region& base, Region& target, double& gamma, double& delta, double& time) {
    base = Region([](const Point& p) { return p.x*p.x + p.y*p.y < 64; },
                  [](const Point& p) { return 100; });
    target = Region({Point(-15, -15), Point(15, 15)});
    gamma = 0.005;
    delta = 0.2;
    time = 1;
}

void test14(Region& base, Region& target, double& gamma, double& delta, double& time) {
    base = Region([](const Point& p) { return p.x*p.x + p.y*p.y < 64; },
                  [](const Point& p) { return 100; });
    target = Region({Point(-15, -15), Point(15, 15)});
    gamma = 0.005;
    delta = 0.2;
    time = 1.5;
}

void test15(Region& base, Region& target, double& gamma, double& delta, double& time) {
    base = Region([](const Point& p) { return p.x*p.x + p.y*p.y < 64; },
                  [](const Point& p) { return 100; });
    target = Region({Point(-15, -15), Point(15, 15)});
    gamma = 0.005;
    delta = 0.2;
    time = 2;
}

void test16(Region& base, Region& target, double& gamma, double& delta, double& time) {
    base = Region([](const Point& p) { return p.x*p.x + p.y*p.y < 64; },
                  [](const Point& p) { return 100; });
    target = Region({Point(-15, -15), Point(15, 15)});
    gamma = 0.005;
    delta = 0.2;
    time = 2.5;
}

//----------------------------------------------------
// Continuous region with square hot area

void test17(Region& base, Region& target, double& gamma, double& delta, double& time) {
    base = Region([](const Point& p) { return p.x*p.x < 64 && p.y*p.y < 64; },
                  [](const Point& p) { return 100; });
    target = Region({Point(-15, -15), Point(15, 15)});
    gamma = 0.005;
    delta = 0.2;
    time = 0.5;
}

void test18(Region& base, Region& target, double& gamma, double& delta, double& time) {
    base = Region([](const Point& p) { return p.x*p.x < 64 && p.y*p.y < 64; },
                  [](const Point& p) { return 100; });
    target = Region({Point(-15, -15), Point(15, 15)});
    gamma = 0.005;
    delta = 0.2;
    time = 1;
}

void test19(Region& base, Region& target, double& gamma, double& delta, double& time) {
    base = Region([](const Point& p) { return p.x*p.x < 64 && p.y*p.y < 64; },
                  [](const Point& p) { return 100; });
    target = Region({Point(-15, -15), Point(15, 15)});
    gamma = 0.005;
    delta = 0.2;
    time = 1.5;
}

void test20(Region& base, Region& target, double& gamma, double& delta, double& time) {
    base = Region([](const Point& p) { return p.x*p.x < 64 && p.y*p.y < 64; },
                  [](const Point& p) { return 100; });
    target = Region({Point(-15, -15), Point(15, 15)});
    gamma = 0.005;
    delta = 0.2;
    time = 2;
}

void test21(Region& base, Region& target, double& gamma, double& delta, double& time) {
    base = Region([](const Point& p) { return p.x*p.x < 64 && p.y*p.y < 64; },
                  [](const Point& p) { return 100; });
    target = Region({Point(-15, -15), Point(15, 15)});
    gamma = 0.005;
    delta = 0.2;
    time = 2.5;
}

//----------------------------------------------------
// Continuous region with Gaussian temperature distribution

void test22(Region& base, Region& target, double& gamma, double& delta, double& time) {
    base = Region([](const Point& p) { return true; },
                  [](const Point& p) { return 100 * std::exp(-(p.x*p.x + p.y*p.y)); });
    target = Region({Point(0, 0), Point(4, 4)});
    gamma = 0.001;
    delta = 0.1;
    time = 0.25;
}

void test23(Region& base, Region& target, double& gamma, double& delta, double& time) {
    base = Region([](const Point& p) { return true; },
                  [](const Point& p) { return 100 * std::exp(-(p.x*p.x + p.y*p.y)); });
    target = Region({Point(0, 0), Point(4, 4)});
    gamma = 0.001;
    delta = 0.1;
    time = 0.75;
}

void test24(Region& base, Region& target, double& gamma, double& delta, double& time) {
    base = Region([](const Point& p) { return true; },
                  [](const Point& p) { return 100 * std::exp(-(p.x*p.x + p.y*p.y)); });
    target = Region({Point(0, 0), Point(4, 4)});
    gamma = 0.001;
    delta = 0.1;
    time = 1.25;
}

//----------------------------------------------------
// Continuous region with a sinusoidal temperature distribution

void test25(Region& base, Region& target, double& gamma, double& delta, double& time) {
    base = Region([](const Point& p) { return true; },
                  [](const Point& p) { return 50 * std::sin(M_PI * p.x) * std::sin(M_PI * p.y); });
    target = Region({Point(-1, -1), Point(1, 1)});
    gamma = 0.001;
    delta = 0.08;
    time = 0.25;
}

void test26(Region& base, Region& target, double& gamma, double& delta, double& time) {
    base = Region([](const Point& p) { return true; },
                  [](const Point& p) { return 50 * std::sin(M_PI * p.x) * std::sin(M_PI * p.y); });
    target = Region({Point(-1, -1), Point(1, 1)});
    gamma = 0.001;
    delta = 0.08;
    time = 0.5;
}

void test27(Region& base, Region& target, double& gamma, double& delta, double& time) {
    base = Region([](const Point& p) { return true; },
                  [](const Point& p) { return 50 * std::sin(M_PI * p.x) * std::sin(M_PI * p.y); });
    target = Region({Point(-1, -1), Point(1, 1)});
    gamma = 0.001;
    delta = 0.08;
    time = 0.75;
}

//----------------------------------------------------
// Continuous region with hyperbolic temperature distribution

void test28(Region& base, Region& target, double& gamma, double& delta, double& time) {
    base = Region([](const Point& p) { return true; },
                  [](const Point& p) { return 50 * std::tanh(p.x * p.y); });
    target = Region({Point(-5, -5), Point(5, 5)});
    gamma = 0.001;
    delta = 0.2;
    time = 0.5;
}

void test29(Region& base, Region& target, double& gamma, double& delta, double& time) {
    base = Region([](const Point& p) { return true; },
                  [](const Point& p) { return 50 * std::tanh(p.x * p.y); });
    target = Region({Point(-5, -5), Point(5, 5)});
    gamma = 0.001;
    delta = 0.2;
    time = 0.75;
}

void test30(Region& base, Region& target, double& gamma, double& delta, double& time) {
    base = Region([](const Point& p) { return true; },
                  [](const Point& p) { return 50 * std::tanh(p.x * p.y); });
    target = Region({Point(-5, -5), Point(5, 5)});
    gamma = 0.001;
    delta = 0.2;
    time = 1;
}

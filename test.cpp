#include "setting.cpp"

void test1(Region& base, Region& target, double& gamma, double& delta, double& time) {
    base = Region({Point(2, 2, 100.0)});
    target = Region({Point(1, 1), Point(3, 3)});
    gamma = 0.2;
    delta = 1;
    time = 1;
}

void test2(Region& base, Region& target, double& gamma, double& delta, double& time) {
    base = Region({Point(2, 2, 100.0)});
    target = Region({Point(1, 1), Point(3, 3)});
    gamma = 0.005;
    delta = 0.2;
    time = 1;
}

void test3(Region& base, Region& target, double& gamma, double& delta, double& time) {
    base = Region({Point(2, 2, 100.0)});
    target = Region({Point(1, 1), Point(3, 3)});
    gamma = 0.00125;
    delta = 0.1;
    time = 1;
}

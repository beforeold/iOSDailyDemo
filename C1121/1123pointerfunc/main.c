

#include <stdio.h>


int sum(int a, int b) {
    return a + b;
}

void foo() {
    printf("i am foo.\n");
}

void test_pointer_func() {
    void (*p)(void) = foo;
    (*p)(); // 等价于 p();
    
    int (*plus)(int, int) = sum;
    printf("sum=%d\n", plus(11, 22));
}

int main() {
    test_pointer_func();
    
    return 0;
}

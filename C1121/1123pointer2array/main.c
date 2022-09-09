
#include <stdio.h>


void test_enumerate_array_with_pointer() {
    int ages[5] = {1, 2, 3, 4, 5};
    int *p = ages;
    p = &ages[0];
    for (int i = 0; i < 5; i++) {
        printf("%d\n", *(p++));
    }
}

void test_enumerate_array_with_pointer_2() {
    int ages[5] = {1, 2, 3, 4, 5};
    int *p = ages;
    p = &ages[0];
    for (int i = 0; i < 5; i++) {
        printf("%d\n", *(p + i));
    }
}

int main() {
    
    test_enumerate_array_with_pointer_2();
    
    return 0;
}

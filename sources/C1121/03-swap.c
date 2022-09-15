
#include <stdio.h>


void swap1() {
    int a = 10;
    int b = 11;
    
    a = a + b; // 21
    b = a - b; // 10
    a = a - b;
    
    printf("a=%d, b=%d\n", a, b);
}

void swap2() {
    int a = 10;
    int b = 20;
    
    a = a * b;
    b = a / b;
    a = a / b;
    
    printf("a=%d, b=%d\n", a, b);
}


int main() {
    swap2();
}

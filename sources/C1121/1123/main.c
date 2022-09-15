

#include <stdio.h>

void print(int a) {
    printf("%d -> %o\n", a, a);
}

int main() {
    int a = 1234;
    print(a);
    print(sizeof(long));
    print(sizeof(long long int));
    
    short unsigned as = 5;
    printf("ret=%hu\n", as);
}

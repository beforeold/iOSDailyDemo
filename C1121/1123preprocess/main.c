
#include <stdio.h>

#define VERSION 2
void test_define_compare() {
#if VERSION > 3
    printf(">>>>>\n");
#else
    printf("no\n");
#endif
    
}

typedef struct Student {
    int age;
} Student;



int main() {
    
    test_define_compare();
    
    return 0;
}

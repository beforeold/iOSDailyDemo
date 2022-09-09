
#include <stdio.h>

void test_pointer() {
    int *p;
    int a;
//    int *p = &a;
    
    
    printf("a的地址\t%p\n", &a);
    printf("p的值\t%p\n", p);
    printf("p的十进制值\t%lu\n", (long unsigned)p);
    printf("p的地址\t%p\n", &p);
}

void test_null_pointer() {
    int *p;
    int *np = NULL;
    
    printf("p\t%p\n", p);
    printf("np\t%p\n", np);
}

void test_p2p() {
    int **pp;
    int a = 33;
    int b = 44;
    
    int *pa = &a;
    int *pb = &b;
    
    pp = &pa;
    **pp = 55;
    printf("%d\n", a);
}

void change(int *val) {
    *val += 10;
}

void test_change() {
    int a = 100;
    change(&a);
    printf("%d\n", a);
}

void swap(int *a, int *b) {
    int temp = *a;
    *a = *b;
    *b = temp;
}

void test_swap() {
    int a = 33;
    int b = 44;
    swap(&a, &b);
    printf("a=%d, b=%d\n", a, b);
}

void test_unintialized_pointer() {
    int *p;
    printf("is null: %d\n", p == NULL);
}


void test_pointer_address() {
    double d = 1.0;
    double *p = &d;
    double **pp = &p;
    
    printf("p\t%p\n", p);
    printf("pp\t%p\n", pp);
    printf("&pp\t%p\n", &pp);
}

void test_change_pointer() {
    int a = 22;
    int b = 33;
    int *p = &a;
    int **pp = &p;
    *pp = &b;
    printf("*p->%d\n", *p);
}

int sumAndMinus(int n1, int n2, int *sub) {
    *sub = n1 - n2;
    return n1 + n2;
}

void test_sum_minus() {
    int sub;
    int sum = sumAndMinus(44, 33, &sub);
    printf("sum=%d, sub=%d\n", sum, sub);
}


void test_wrong_type_pointer() {
    int a = 2; // 0010
    char c = 'A';
    int *p = &c;
    char *cp = &c;
    
    printf("d:%d\n", *p); // 0010 + 0010 0001 = 512 + 65 = 577
    printf("c:%c\n", *p); // 取一个字节 还是 'A'
    
    printf("cp->d:%d\n", *cp); // 取一个字节
    printf("cp->c:%c\n", *cp); // 取一个字节 还是 'A'
    
    // 结论，打印的结果，受到指针类型和格式符的双重影响
}

int main() {
    // test_null_pointer();
    // test_pointer();
    // test_p2p();
    // test_change();
    // test_swap();
    // test_unintialized_pointer();
    
    // test_pointer_address();
    // test_change_pointer();
    // test_sum_minus();
    test_wrong_type_pointer();
    
    return 0;
}

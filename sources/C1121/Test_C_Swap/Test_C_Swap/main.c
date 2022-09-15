//
//  main.c
//  Test_C_Swap
//
//  Created by Brook on 2019/11/22.
//  Copyright © 2019 br. All rights reserved.
//

#include <stdio.h>

void swap_temp(int a, int b) {
    int temp = a;
    a = b;
    b = temp;
    printf("a=%d, b=%d\n", a, b);
}


void swap_plus(int a, int b) {
    a = a + b;
    b = a - b;
    a = a - b;
    
    printf("a=%d, b=%d\n", a, b);
}

void swap_minus(int a, int b) {
    a = a - b; // 多出来的
    b = a + b; // （差 + 原b == 原a） 存入 b
    a = b - a; //  （原 a - 差 == 原 b 存入 a
    
    printf("a=%d, b=%d\n", a, b);
}

void swap_bit_or(int a, int b) {
    a = a ^ b; // 异或体 ab
    b = a ^ b; // ab ^ 原 b 得到原 a，存入 b
    a = a ^ b; // ab ^ 原 a 得到原 b，存入 a
    printf("a=%d, b=%d\n", a, b);
}

int is_even_divide(int a) {
    return a % 2 == 0;
}

int is_even_bit_and(int a) {
    return (a & 1) == 0;
}

void test_swap() {
    int a = 11, b = 22;
    swap_temp(a, b);
    swap_plus(a, b);
    swap_minus(a, b);
    swap_bit_or(a, b);
}

void test_is_even() {
    int a;
    a = is_even_divide(5);
    printf("a=%d\n", a);
    a = is_even_divide(6);
    printf("a=%d\n", a);
    
    a = is_even_bit_and(5);
    printf("a=%d\n", a);
    a = is_even_bit_and(6);
    printf("a=%d\n", a);
}

void test_print_binary_2() {
    int a = 0b10101010;
    
    // 32bit
    int start = (sizeof(int) << 3) - 1; // 4 * 8 = 32 位
    for (int i = start; i >= 0; i--) {
        printf("%d", (a >> i) & 1);
        if (i % 4 == 0) {
            printf(" ");
        }
    }
    printf("\n");
}

int main(int argc, const char * argv[]) {
    // insert code here...
   
    // test_is_even();
    // test_is_even();
    
    test_print_binary_2();
    
    
    return 0;
}

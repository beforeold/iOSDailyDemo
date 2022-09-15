//
//  main.c
//  TestConversion
//
//  Created by Brook on 2019/11/21.
//  Copyright © 2019 br. All rights reserved.
//

#include <stdio.h>

void test() {
    printf("Hello, World!\n");
       
       long long a = 10.1;
       printf("%lld\n", a);
       
       int c = 10;
       int b = (++c) + (c++);
       printf("b = %d\n", b);
       
       printf("size=%lu\n", sizeof(short));
       
       typedef struct {
           int age;
       } Person;
       
       Person p;
       p.age = 5;
       int age;
       printf("age:%d\n", p.age);
       
       if (1) {
           printf("true\n");
       } else {
           printf("false\n");
       }
       
       /*
       if (10 > 5)
           int cc;
        */
       
       int val = 5;
       switch (val) {
           case 3:
               printf("3333\n");
               
               
           default:
               printf("efault\n");
       }
       
}

void print(int a) {
    printf("==》%d\n", a);
}

void test1() {
    int i; // 一定要初始化
    if (i <= 0) {
        printf("end===%d\n", i);
    }
    
    int a = 5;
    for (int i = 0, a = 55; i < 10; i++) {
        int i = 100;
        print(i);
        print(a);
    }
}

void printLines() {
    for (int i = 5; i > 0; i--) {
        for(int j = 0; j < i; j++) {
            printf("*");
        }
        printf("\n");
    }
}

void printMath() {
    for (int row = 1; row <= 9; row++) {
        for (int line = 1; line <= row; line++) {
            printf("%dx%d=%d\t", line, row, line * row);
        }
        printf("\n");
    }
}



int main(int argc, const char * argv[]) {
    // insert code here...
   
    printMath();
    
    return 0;
}

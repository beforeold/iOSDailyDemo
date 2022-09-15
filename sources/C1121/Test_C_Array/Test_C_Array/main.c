//
//  main.c
//  Test_C_Array
//
//  Created by Brook on 2019/11/22.
//  Copyright © 2019 br. All rights reserved.
//

#include <stdio.h>


void test_char_array() {
    char array[4] = {11, 22, [3] = 33};
    
    printf("%p\n", array);
    printf("%p\n", &array);
    printf("%p\n", &array[0]);
    printf("%p\n", &array[1]);
    printf("%p\n", &array[2]);
    
    for (int i = 0; i < 4; i++) {
        printf("[%d]->%d\n", i, array[i]);
    }
}

void test_array() {
    int a['A'];
    printf("size:%lu\n", sizeof(a));
    
    int count = 5;
    int ages[count];
    ages[0] = 5;
    
    int b[] = {1, 2, 3, 4, 5};
    int c[] = {1, 2, [3] = 5, [8] = 8};
    
    count = sizeof(c) / sizeof(int);
    
    //
    for (int i = 0; i < count; i++) {
        printf("v:%d\n", c[i]);
    }
}

void change(int a[]) {
    printf("change:%p\n", a);
    a[0] = 5;
}

void test_change() {
    int ages[5];
    printf("change:%p\n", ages);
    change(ages);
    printf("%d\n", ages[0]);
}


int max(int array[], int count) {
    int max = array[0];
    for (int i = 1; i < count; i++) {
        if (array[i] > max) {
            max = array[i];
        }
    }
    
    return max;
}


void test_max() {
    int a[5] = {1, 2, 3, 4, 5};
    printf("max:%d\n",max(a, 5));
}


void test_binary_array() {
    int a[2][3] = {1, 2, 3, 4};
    for (int i = 0; i < 2; i++) {
        for (int j = 0; j < 3; j++) {
            printf("%d,", a[i][j]);
        }
        printf("\n");
    }
}

int main(int argc, const char * argv[]) {
    // insert code here...
    
    // test_char_array();
    
    // test_max();
    test_binary_array();
    
    return 0;
}

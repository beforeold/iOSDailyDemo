//
//  function.c
//  Test_C_static
//
//  Created by Brook on 2020/1/14.
//  Copyright © 2020 br. All rights reserved.
//

#include "function.h"
#include "Header.h"
#include <stdio.h>

extern int a = 10;

void printFunction(void) {
//    kValue = 5;
    printf("a = %d\n", a);
    printf("func: %p ~> %d\n", &kValue, kValue);
}

int a;

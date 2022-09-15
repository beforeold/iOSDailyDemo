//
//  main.c
//  Test_C_static
//
//  Created by Brook on 2020/1/14.
//  Copyright © 2020 br. All rights reserved.
//

#include <stdio.h>
#include "Header.h"
#include "function.h"

int main(int argc, const char * argv[]) {
    
//    kValue = 1111;
    printf("Hello, World! %p ~> %d\n", &kValue, kValue);
    printFunction();
    
    return 0;
}

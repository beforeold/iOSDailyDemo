//
//  main.c
//  TestCConstPointer
//
//  Created by Brook on 2019/12/12.
//  Copyright © 2019 br. All rights reserved.
//

#include <stdio.h>



void printString(/*const*/char *str) {
    str[0] = 'a';
    printf("%s\n", str);
}



int main(int argc, const char * argv[]) {
    // insert code here...
    
    char str[10] = {'b', 'r'};
    printString(str);
    
    return 0;
}

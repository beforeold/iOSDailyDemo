//
//  main.c
//  Test_C_Struct_Size
//
//  Created by Brook on 2019/12/13.
//  Copyright © 2019 br. All rights reserved.
//

#include <stdio.h>

int main(int argc, const char * argv[]) {
    // insert code here...
    
    float a;
    double b;
    int c;
    
    
    struct Stu {
        char c;
        int a;
        double b;
    };
    
    union Ss {
        int a;
        char b;
        struct Stu c;
    };
    
    
    printf("a: %lu, b: %lu, c:%lu\n", sizeof(a), sizeof(b), sizeof(union Ss));
    
    return 0;
}

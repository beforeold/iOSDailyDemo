//
//  main.c
//  Test_C_var_address
//
//  Created by Brook on 2019/11/22.
//  Copyright © 2019 br. All rights reserved.
//

#include <stdio.h>

void test_char() {
        
        
    //    char aa = 'a';
    //    char bb = 'a';
        int ii = 1;
        char cc = 'a';
    //    printf("aa= %p\n", &aa);
    //    printf("bb= %p\n", &bb);
        printf("ii= %p\n", &ii);
        printf("cc= %p\n", &cc);
        
        printf("%d\n", 'a');
        printf("%c\n", 97);
        
        
        printf("%d\n", (int)'6');
        
        printf("%d\n", '6' > 6);
        
        char x = '\n'; // -128~127
        printf("x= %d\n", x);
}


char uppercase(char a) {
    int not_lowercase = a < 'a' || a > 'z';
    if (not_lowercase) return a;
    
    return a - ('c' - 'C');
}

int main(int argc, const char * argv[]) {
    // insert code here...

    printf("%c\n", uppercase('a')); // A a 均可
    
    
    return 0;
}


//
//  main.c
//  TestCStatic
//
//  Created by 席萍萍Brook.dinglan on 2021/10/11.
//

#include <stdio.h>
#include "First.h"
#include "Second.h"
#include "Third.h"

extern char *name;

int main(int argc, const char * argv[]) {
    // insert code here...
    printf("Hello, World! name: %p\n", name);
    
    first_foo();
    second_foo();
    
    return 0;
}

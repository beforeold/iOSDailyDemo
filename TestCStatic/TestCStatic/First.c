//
//  First.c
//  TestCStatic
//
//  Created by 席萍萍Brook.dinglan on 2021/10/11.
//

#include "First.h"
#include <stdio.h>
#include "Third.h"

//static char *name = "brook 1";

static void foo() {
    printf("hello world first name: %p\n", name);
}

void first_foo(void) {
    foo();
}

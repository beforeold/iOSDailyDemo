//
//  Second.c
//  TestCStatic
//
//  Created by 席萍萍Brook.dinglan on 2021/10/11.
//

#include "Second.h"
#include <stdio.h>
#include "Third.h"

//static char *name = "brook 2";

static void foo(void) {
    printf("hello world second name: %p\n", name);
}

void second_foo(void) {
    foo();
}

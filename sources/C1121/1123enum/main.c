

#include <stdio.h>

int main() {
    enum Season {
        spring, summer, autumn, winter,
    };
    
    enum Season ss = winter;
    
    printf("%d\n", ss);
}

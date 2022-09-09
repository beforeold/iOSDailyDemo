

#include <stdio.h>


void test_const_string() {
    char *s1 = "jack";
    char *s2 = "jack";
    printf("%p-%p\n", s1, s2);
}

void test_string_array() {
    char *names[] = {"jack", "rose"};
    printf("%lu\n", sizeof(names));
    
    char names2[][10] = {"jack", "rose"};
    printf("%lu\n", sizeof(names2));
}

char *return_const_string() {
    return "this is const";
}

char *return_stack_string() {
    char str[20] = "this is stack";
    return str; // 无效，栈内存回收
}

void test_return_string() {
    printf("const:%s\n", return_const_string());
    printf("stack:%s\n", return_stack_string());
}

void test_input_string() {
    char name[20] = {'-', '>'};
    scanf("%s", &name[2]);
    printf("%s\n", name);
}


int main() {
    
    // test_const_string();
    // test_string_array();
    // test_return_string();
    test_input_string();
    
    return 0;
}

//
//  main.c
//  Test_C_String
//
//  Created by Brook on 2019/11/22.
//  Copyright © 2019 br. All rights reserved.
//

#include <stdio.h>

void test_array() {
    int a[5];
    int b[5];
    // a = b;
}

void test_string_assign() {
    char s1[] = "jack";
    printf("size=%lu\n", sizeof(s1));
    
    char s2[5];
    // s2 = s1;
}

void test_make_string() {
//    int a = 233333333;
    char name1[10] = "rose";
    char name2[10] = {'K', 'a', 'c', 'k', '\0'};
    char name3[10] = {'L', 'a', 'c', 'k', 0};
    char name4[4] = {'j', 'a', 'c', 'k'}; // array is long enough for string
    char name5[10] = {'M', 'a', 'c', 'k', 0};
    char name6[10] = {'N', 'a', 'c', 'k', 0};

    
    printf("%p, %p, %p, %p, %p\n", name1, name2, name3, name4, name6);
    printf("%s, %s, %s, %s, %s\n", name1, name2, name3, name4, name5);
}

void test_print_string() {
    double a = 1.1;
    char name[] = {'o', 'k'};
    printf("%s\n", name);
}


// string_char_count(<#char *str#>);
int string_char_count(char str[]) {
    int index = 0;
    int count = 0;
    while (str[index++]) {
        count ++;
    }
    return count;
}

int string_contains_char(char str[], char c) {
    int i = -1;
    while (str[++i]) {
        if (c == str[i]) return 1;
    }
    return 0;
}

void test_string_contains() {
    printf("%d\n", string_contains_char("hello", '\0'));
}

void test_string_array() {
    char names[2][10] = {"jack", "rose"};
    char names2[][10] = {"hello", "world"};
    printf("first:%s\n", names[0]);
}
 
void test_string_char_count() {
    char s[] = {1, 2, 3}; // 错误
    char str[] = "good";
    printf("%d\n", string_char_count(str));
}

int main(int argc, const char * argv[]) {
    // insert code here...
    
    // test_string_assign();
    // test_make_string();
    // test_print_string();
    // test_string_char_count();
    // test_string_contains();
    test_string_array();
    
    return 0;
}

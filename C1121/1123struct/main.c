
#include <stdio.h>


struct Person {
    int age; // 4
    double height; // 8
    char *name; //  8
};

void test_struct_init() {
    struct Person p = {10, 2.0, "jack"};
    p.age = 11;
    p.height = 2.1;
    p.name = "rose";
    
    printf("%d, %f, %s \n", p.age, p.height, p.name);
    
    struct Person p2 = {10, 2.2, "blok"};
    
    p = p2;
    printf("%d, %f, %s \n", p.age, p.height, p.name);
    
    printf("%p, %p, %p\n", &p.age, &p.height, &p.name);
    
    printf("size: %lu\n", sizeof(struct Person));
}

void test_define_struct() {
    struct {
        int age;
        char *name;
    } stu1;
    
    struct {
        int age;
        char *name;
    } stu2;
    
    // stu1 = stu2; // 错误，类型不一致，都是匿名类型
    stu1.age = stu2.age;
}

void test_struct_array() {
    struct Person class[] = {
        {1, 1.0, "jack"},
        {2, 2.0, "rose"},
    };
    
    for (int i = 0; i < sizeof(class) / sizeof(struct Person); i++) {
        printf("%d\t%f\t%s\n", class[i].age, class[i].height, class[i].name);
    }
}

void test_struct_pointer() {
    struct Person stu = {1, 2.2, "jack"};
    struct Person *p = &stu;
    
    p->age = 555;
    
    printf("age: %d\n", stu.age);
    printf("age: %d\n", (*p).age);
    printf("age: %d\n", p->age); // 等价
}

void test_nested_struct() {
    struct Date {
        int year;
        int month;
        int day;
    };
    
    
    struct Student {
        int age; // 4
        double height; // 8
        struct Date birthday; // 12
    };
    
    printf("size: %lu\n", sizeof(struct Student));
}

int main() {
    
    // test_struct_init();
    // test_struct_array();
    // test_struct_pointer();
    
    test_nested_struct();
    
    return 0;
}

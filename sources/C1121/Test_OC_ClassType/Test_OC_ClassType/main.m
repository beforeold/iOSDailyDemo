//
//  main.m
//  Test_OC_ClassType
//
//  Created by Brook on 2019/11/23.
//  Copyright © 2019 br. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <objc/runtime.h>

@interface Person : NSObject

@end

@implementation Person

+ (void)load {
    NSLog(@"Person loaded");
}

+ (void)initialize {
    NSLog(@"Person initialize");
}

@end

@interface Student : Person

@end

@implementation Student

+ (void)load {
    NSLog(@"student loaded");
}

+ (void)initialize {
    NSLog(@"Student initialize");
}


@end

@implementation Person (XPXP)
    
+ (void)load {
    NSLog(@"Person category loaded");
}

+ (NSString *)description {
    NSLog(@"---- person desc");
    return @"Person__";
}

@end


// 原类的 load 方法 先父类后子类
// category 的 load 方法调用顺序与代码加载的顺序一致

@implementation Student (XPXP)
    
+ (void)load {
    NSLog(@"Student category loaded");
}


@end


@implementation NSObject (XPXP)

+ (void)load {
    NSLog(@"NSObject loaded");
}

@end


@interface Dog : NSObject

@end

@implementation Dog

+ (void)play {
    NSLog(@"play");
}

@end

typedef struct xp_class * XPClass;
struct xp_class {
    XPClass isa;
};


struct xp_object {
    XPClass isa;
};

void test_understanding_class() {
    
}


void test_fetch_metaclass() {
    id class_objc = [Person class];
    id class_runtime = object_getClass([Person new]);
    id class_of_class = object_getClass(class_runtime);
    
    Class pClass = [Person class];
    [pClass description];
    
    NSLog(@"class_objc    %p", class_objc);
    NSLog(@"class_runtime %p", class_runtime);
    NSLog(@"class_of_class %p", class_of_class);
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        [Student description];
    }
    return 0;
}

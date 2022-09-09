//
//  main.m
//  Test_OC_Class_Size_02
//
//  Created by Brook on 2019/11/28.
//  Copyright © 2019 br. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <objc/runtime.h>

@interface Person : NSObject

{
    char c1;
    char c2;
    char c3;
    
    int age;
    char c4;
    
    int cc;
    double dd;
}

@end

@implementation Person

@end

typedef struct PersonStruct {
    Class isa;
    
    char c1;
    char c2;
    char c3;
    
    int age;
    char c4;
    
    int cc;
    double dd;
} PersonStruct;

typedef struct StudentStruct {
    PersonStruct pp;
    int cc;
    double dd;
} StudentStruct;



int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        
        [[[NSObject alloc] init] performSelector:nil onThread:nil withObject:nil waitUntilDone:NO modes:nil];
        
        NSLog(@"----sizeof\t%lu", sizeof(PersonStruct));
//        NSLog(@"----sizeof\t%lu", sizeof(StudentStruct));
//        NSLog(@"instancesize\t%lu", class_getInstanceSize(Person.class));
    }
    return 0;
}

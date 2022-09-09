//
//  main.m
//  Test_OC_MRC
//
//  Created by Brook on 2019/11/23.
//  Copyright © 2019 br. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Driver.h"
#import "Car.h"

void printCount(NSObject *obj, NSString *sufix);

@interface Person : NSObject

@property int age;

@end

@implementation Person

- (instancetype)init {
    self = [super init];
    if (self) {
        NSLog(@"init");
    }
    return self;
}

- (void)dealloc {
    NSLog(@"person dealloc");
    printCount(self, @"dealloc");
    
    [super dealloc];
}

- (void)playPerson:(Person *)obj {
    
}

@end


void test_type_size() {
    NSLog(@"int %lu", sizeof(int));
    NSLog(@"int %lu", sizeof(1));
    NSLog(@"int %lu", sizeof(NSObject *));
    NSLog(@"int %lu", sizeof(NSInteger));
}

void test_retain_release() {
    Person *p = [[Person alloc] init];
    printCount(p, nil);
    
    [p retain];
    printCount(p, nil);
    
    [p release];
    [p release];
    
    [p retain];
    p.age = 10;
    
    [p release];
    [p release];
    NSLog(@"relesed");
}

void test_assign_zombie() {
    Person *p = [[Person alloc] init];
    [p release];
    
    NSLog(@"p\t%p", p);
    Person *p2 = p;
    p = nil;
    NSLog(@"p2\t%p", p2);
    
    NSLog(@"p2 obj:%@", p2.className);
}


void test_double_setter() {
    Driver *pp = [[Driver alloc] init];
    Car *cc = [[Car alloc] init];
    
    pp.car = cc;
    [cc release];
    
    pp.car = cc;
    
    [pp release];
}

void test_size_property() {
    Driver *dd = [[Driver alloc] init];
    // dd.size.height = 8;
    
    [dd release];
}


int main(int argc, const char * argv[]) {
    // test_type_size();
    // test_retain_release();
    // test_assign_zombie();
    test_double_setter();
    
    
    return 0;
}

void printCount(NSObject *obj, NSString *sufix) {
    NSLog(@"%@ count: %lu", sufix, obj.retainCount);
}

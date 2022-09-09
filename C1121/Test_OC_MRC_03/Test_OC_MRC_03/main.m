//
//  main.m
//  Test_OC_MRC_03
//
//  Created by Brook on 2019/11/27.
//  Copyright © 2019 br. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Person.h"


int main(int argc, const char * argv[]) {
    
    NSObject *p = [[Person alloc] init];
    // 实际指向 Person 类型
    return 0;
}

void test_autoreleasepool() {
    
    NSString *str1 = [NSString stringWithFormat:@"%d", 123];
    @autoreleasepool {
        Person *pp = [[[Person alloc] init] autorelease];
        [Person person];
        NSString *className = str1.className;
        NSLog(@"str %p, %@", className, className);
        NSLog(@"count %ld", pp.retainCount);
        [NSAutoreleasePool showPools];
    }
    
    
    
    
    
    NSString *s1 = @"123";
    NSString *s2 = @"123";
    NSLog(@"s1 %p %@", s1, s1);
    NSLog(@"s2 %p %@", s2, s2);
    
}

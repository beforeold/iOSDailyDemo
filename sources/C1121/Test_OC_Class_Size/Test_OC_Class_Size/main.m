//
//  main.m
//  Test_OC_Class_Size
//
//  Created by Brook on 2019/11/28.
//  Copyright © 2019 br. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <malloc/malloc.h>

@interface Person : NSObject
{
@public
    int _age;
    int _height;
    char _c1;
}

@property (nonatomic) int sex;

@end

@implementation Person

//- (void)dealloc {
//    NSLog(@"----- dealloc");
//}

@end
//
//void test_size() {
//    Person *pp = [[Person alloc] init];
//    NSLog(@"instance size: %lu", class_getInstanceSize(Person.class));
//    NSLog(@"instance size: %lu", malloc_size((__bridge void *)pp));
//
//}
//
//void test_autorelease_without_explicit_pool() {
//    Person *p = [Person new];
//    p->_age = 9; // 9
//    p->_height = 011;// 9
//    NSLog(@"end");
//
//    // Class poolClass = NSStringFromClass(@"NSAutoreleasePool");
//    // [poolClass performSelector:@selector(showPools)];
//}

int main(int argc, const char * argv[]) {
    [NSObject description];
    
    return 0;
}

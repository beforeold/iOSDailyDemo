//
//  main.m
//  Test_OC_ARC
//
//  Created by Brook on 2019/11/27.
//  Copyright © 2019 br. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@end

@implementation Person

- (void)dealloc {
    NSLog(@"dealloc");
}

@end

int main(int argc, const char * argv[]) {
    
    Person *p = [Person new];
    p = nil;
    NSLog(@"end");
    
    return 0;
}

//
//  main.m
//  Test_OC_main_load
//
//  Created by Brook on 2019/12/17.
//  Copyright © 2019 br. All rights reserved.
//

#import <Foundation/Foundation.h>


@implementation NSObject (XP)

+ (void)load {
    NSLog(@"loaded");
}

@end

int main(int argc, const char * argv[]) {
    NSLog(@"Hello, World!");
    
    @autoreleasepool {
        // insert code here...
        
    }
    return 0;
}

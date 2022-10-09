//
//  main.m
//  TestClosureFunctionLine
//
//  Created by beforeold on 2022/10/9.
//

#import <Foundation/Foundation.h>

#import "TestClosureFunctionLine-Swift.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        
        void(^block)(NSInteger) = [^(NSInteger value) {
            NSLog(@"OC value: %ld, func: %s, line: %d", value, __FUNCTION__, __LINE__);
        } copy];
        
        block(20);
        
        [Closure test];
    }
    return 0;
}

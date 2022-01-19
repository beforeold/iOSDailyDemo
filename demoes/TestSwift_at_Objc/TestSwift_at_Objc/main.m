//
//  main.m
//  TestSwift_at_Objc
//
//  Created by BrookXy on 2022/1/9.
//

#import <Foundation/Foundation.h>
#import "TestSwift_at_Objc-Swift.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        
        __auto_type dog = [[Dog alloc] init];
        [dog name];
    }
    return 0;
}

//
//  main.m
//  TestOC
//
//  Created by Brook on 2019/11/21.
//  Copyright © 2019 br. All rights reserved.
//

#import <Foundation/Foundation.h>
@import Cocoa;


void test() {
    
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSLog(@"Hello, World!----%ld", sizeof(NSInteger));
        NSLog(@"Hello, World!----%ld", sizeof(double));
        NSLog(@"Hello, World!----%ld", sizeof(int));
        NSLog(@"Hello, World!----%ld", sizeof(long));
        NSLog(@"Hello, World!----%ld", sizeof(long long));
        NSLog(@"Hello, World!----%ld", sizeof(CGFloat));
    }
    return 0;
}

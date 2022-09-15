//
//  main.m
//  Test_OC_GCD
//
//  Created by Brook on 2019/12/16.
//  Copyright © 2019 br. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        dispatch_queue_t serial = dispatch_queue_create("searial", DISPATCH_QUEUE_SERIAL);
        dispatch_queue_t concurrent = dispatch_queue_create("concurrent", DISPATCH_QUEUE_CONCURRENT);
        
        NSLog(@"111");
        dispatch_sync(serial, ^{
            NSLog(@"333 %@", [NSThread currentThread]);
            dispatch_sync(concurrent, ^{
                NSLog(@"444 %@", [NSThread currentThread]);
            });
            NSLog(@"555 %@", [NSThread currentThread]);
        });
        NSLog(@"2222, %@", NSThread.currentThread);
    }
    return 0;
}

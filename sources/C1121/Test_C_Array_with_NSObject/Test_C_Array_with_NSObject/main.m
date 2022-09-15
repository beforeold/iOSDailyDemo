//
//  main.m
//  Test_C_Array_with_NSObject
//
//  Created by Brook on 2019/11/23.
//  Copyright © 2019 br. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        NSObject *array[5];
        NSObject *first = [NSObject new];
        array[0] = first;
        void *p = array;
        NSLog(@"%p", ((double **)p)[0]);
        NSLog(@"%p", array);
        NSLog(@"%p", array[0]);
        NSLog(@"first%@", first);
    }
    return 0;
}

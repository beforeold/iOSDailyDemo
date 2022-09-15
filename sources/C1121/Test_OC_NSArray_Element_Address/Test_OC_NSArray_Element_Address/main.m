//
//  main.m
//  Test_OC_NSArray_Element_Address
//
//  Created by Brook on 2019/11/22.
//  Copyright © 2019 br. All rights reserved.
//

#import <Foundation/Foundation.h>


void test_array_element_address() {
    NSArray <NSObject *> *array = @[NSObject.new,
                                    NSObject.new,
    ];
    NSLog(@"%p", array);
    NSObject *first = array[0];
    NSObject *last = array[1];
    //    NSLog(@"first:%p", &array[0]); // fail
    NSLog(@"last :%p", &last);
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSString *str = @"abc\\0xyz";
        NSLog(@"%@", str);
    }
    return 0;
}

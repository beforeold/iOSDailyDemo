//
//  main.m
//  TestOCInstanceMethodClassMethod
//
//  Created by beforeold on 2022/9/28.
//

#import <Foundation/Foundation.h>

#import "Person.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSString *string = @"main func";
        
        id cls = [Person class];
        void *obj = &cls;
        [(__bridge id)obj speek];
        
        NSLog(@"stack string %p", &string);
        NSLog(@"stack class: %p", &cls);
        
        [Person showPointer];
    }
    return 0;
}

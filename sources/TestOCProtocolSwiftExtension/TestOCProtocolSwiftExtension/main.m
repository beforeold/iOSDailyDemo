//
//  main.m
//  TestOCProtocolSwiftExtension
//
//  Created by 席萍萍Brook.dinglan on 2021/11/11.
//

#import <Foundation/Foundation.h>

#import "Person.h"


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        __auto_type pp = [[Person alloc] init];
        [pp play];
        
        NSLog(@"Hello, World!");
    }
    return 0;
}

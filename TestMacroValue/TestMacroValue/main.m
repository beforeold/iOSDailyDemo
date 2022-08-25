//
//  main.m
//  TestMacroValue
//
//  Created by 席萍萍Brook.dinglan on 2021/9/3.
//

#import <Foundation/Foundation.h>

#define NICE 0

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
#if NICE
        NSLog(@"done");
#else
        NSLog(@"fail");
#endif
        
    }
    return 0;
}

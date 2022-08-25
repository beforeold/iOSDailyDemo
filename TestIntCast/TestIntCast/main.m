//
//  main.m
//  TestIntCast
//
//  Created by 席萍萍Brook.dinglan on 2021/7/12.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        
        double a = 399.9;
        double b = 400.1;
        NSLog(@"a: %d, b: %d", (int)a, (int)b);
    }
    return 0;
}

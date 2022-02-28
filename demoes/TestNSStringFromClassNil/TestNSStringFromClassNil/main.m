//
//  main.m
//  TestNSStringFromClassNil
//
//  Created by BrookXy on 2022/2/25.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World! : %@", NSStringFromClass(nil));
    }
    return 0;
}

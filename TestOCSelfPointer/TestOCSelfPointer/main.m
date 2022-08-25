//
//  main.m
//  TestOCSelfPointer
//
//  Created by BrookXy on 2022/3/11.
//

#import <Foundation/Foundation.h>

@interface MySelf : NSObject

@end

@implementation MySelf

- (void)test {
    NSLog(@"print self %@", [NSNumber numberWithUnsignedLong:(uintptr_t)self]);
}

@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        
        __auto_type ins = [[MySelf alloc] init];
        [ins test];
    }
    return 0;
}

//
//  main.m
//  TestCatchSelectorException
//
//  Created by BrookXy on 2022/3/23.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@end

@implementation Person

@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        
        @try {
            __auto_type p1 = [[Person alloc] init];
            [p1 performSelector:@selector(unkown_method)];
        } @catch (NSException *exception) {
            NSLog(@"catched exception: %@", exception);
        }
        
        NSLog(@"end");
    }
    return 0;
}

//
//  main.m
//  TestNilSelector
//
//  Created by 席萍萍Brook.dinglan on 2021/12/30.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        
        __auto_type ins = [[NSObject alloc] init];
        SEL sel = NSSelectorFromString(@"do_not_exist");
        if ([ins respondsToSelector:sel]) {
            NSLog(@"succ");
        } else {
            NSLog(@"fail");
        }
        
    }
    return 0;
}

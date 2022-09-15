//
//  main.m
//  TestDealloc
//
//  Created by 席萍萍Brook.dinglan on 2021/8/23.
//

#import <Foundation/Foundation.h>

@interface ABC : NSObject

@end

@implementation ABC

- (void)dealloc {
    NSLog(@"-----");
}

@end

extern BOOL _objc_rootIsDeallocating(id obj);

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        
        __auto_type ins = [[ABC alloc] init];
        
        NSLog(@"ret: %d", _objc_rootIsDeallocating(ins));
        NSLog(@"end");
    }
    return 0;
}

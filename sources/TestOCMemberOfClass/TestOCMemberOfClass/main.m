//
//  main.m
//  TestOCMemberOfClass
//
//  Created by 席萍萍Brook.dinglan on 2021/11/24.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@end

@implementation Person


@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!---- %d", [[[Person alloc] init] isMemberOfClass:NSObject.class]);
    }
    return 0;
}

//
//  main.m
//  TestObjcGenericClass
//
//  Created by 席萍萍Brook.dinglan on 2021/12/15.
//

#import <Foundation/Foundation.h>

@class VeryCool;
@class KKK;

// 验证是否可以声明一个 @class
// 但是这样其实没有实际的意义

@interface Wrap<Model: VeryCool *>: NSObject
@end

@implementation Wrap

@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
    }
    return 0;
}

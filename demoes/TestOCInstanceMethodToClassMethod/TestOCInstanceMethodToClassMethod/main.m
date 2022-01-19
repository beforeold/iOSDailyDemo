//
//  main.m
//  TestOCInstanceMethodToClassMethod
//
//  Created by 席萍萍Brook.dinglan on 2021/11/8.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

+ (void)classPlay;

@end

@implementation Person

+ (void)classPlay {
    NSLog(@"class play");
}

@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        
        
        id pp = [[Person alloc] init];
        [pp classPlay];
        
        
        NSLog(@"end");
    }
    return 0;
}

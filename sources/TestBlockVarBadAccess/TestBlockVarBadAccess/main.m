//
//  main.m
//  TestBlockVarBadAccess
//
//  Created by beforeold on 2022/9/27.
//

#import <Foundation/Foundation.h>

@interface SomeManager : NSObject

@property (nonatomic, copy) void(^block)(void);

@end

@implementation SomeManager

- (void)startWithBlock:(void(^)(void))block {
    self.block = block;
    
    block();
    
    [self doSomething];
}

- (void)doSomething {
    
}

@end
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        
        __block SomeManager *ins = [[SomeManager alloc] init];
        [ins startWithBlock:^{
            NSLog(@"will call clear %@", ins);
            ins = nil;
        }];
    }
    return 0;
}

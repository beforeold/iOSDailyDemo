//
//  main.m
//  TestBOOLKVCPerformSelector
//
//  Created by 席萍萍Brook.dinglan on 2022/1/4.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property (nonatomic, assign) NSInteger age;

@property (nonatomic, assign) BOOL flag;

@end

@implementation Person

@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        
        __auto_type per = [[Person alloc] init];
        [per performSelector:@selector(setAge:) withObject:@10];
        NSLog(@"age1: %ld", (long)per.age);
        
        if ([per respondsToSelector:@selector(unkownSel:)]) {
            
        }
        
        __auto_type sel = NSSelectorFromString(@"setFlag:");
        
        IMP imp = [per methodForSelector:@selector(setFlag:)];
        void(*pointer)(id, SEL, BOOL) = (void(*)(id, SEL, BOOL))imp;
        pointer(per, @selector(setFlag:), YES);
        
        NSLog(@"imp flag: %ld", (long)per.flag);
        
        
        __auto_type arg1 = NO;
        __auto_type sig = [per methodSignatureForSelector:sel];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
        invocation.target = per;
        invocation.selector = sel;
        [invocation setArgument:&arg1 atIndex:2];
        [invocation invoke];
        NSLog(@"invo flag: %ld", (long)per.flag);
        
        
//        [per setValue:@YES forKey:@"flag"];
        NSLog(@"flag: %ld", (long)per.flag);
        
        [per setValue:@20 forKey:@"age"];
        NSLog(@"age2: %ld", (long)per.age);
        
    }
    return 0;
}

//
//  main.m
//  TestPerformSelectorWarning
//
//  Created by BrookXy on 2022/1/7.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        Class object = NSClassFromString(@"Person");
        
          
        NSObject *ins = [[object alloc] init];
        
        SEL sel = @selector(playInstanceWithObject:);
        
        if ([ins respondsToSelector:sel]) {
            [ins performSelector:sel withObject:@"arg1"];
        }
        
        
        if ([ins respondsToSelector:sel]) {
            IMP imp = [ins methodForSelector:sel];
            BOOL(*func)(id, SEL, id) = (void *)imp;
            func(ins, sel, @"arg1");
        }
        
if ([ins respondsToSelector:sel]) {
    NSMethodSignature *sig = [ins methodSignatureForSelector:sel];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
    invocation.target = ins;
    invocation.selector = sel;
    NSString *arg1 = @"arg1";
    [invocation setArgument:&arg1 atIndex:2];
    [invocation invoke];
    BOOL ret;
    [invocation getReturnValue:&ret];
}
    }
    return 0;
}

//
//  main.m
//  TestPerformSelector
//
//  Created by dinglan on 2021/5/14.
//

#import <Foundation/Foundation.h>

@interface LAObject : NSObject

@end

@implementation LAObject

- (int)playWithInt:(int)age {
    printf("play: %d\n", age);
    return age + 2000;
}

@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        __auto_type object = [[LAObject alloc] init];
        int ret = [object performSelector:@selector(playWithInt:) withObject:@5];
        NSLog(@"ret: %d", ret);
        
        Class cl = NSClassFromString(@"LAAdapterLocalCountry");
        SEL selector = NSSelectorFromString(@"playWithInt:");
        IMP imp = [object methodForSelector:selector];
        if(imp)
        {
            int (*func)(id, SEL, int) = (void *)imp;
            int ret = func(object, selector, 18);
            NSLog(@"ret: %d", ret);
        }
    }
    return 0;
}

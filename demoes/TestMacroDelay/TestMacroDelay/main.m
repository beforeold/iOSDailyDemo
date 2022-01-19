//
//  main.m
//  TestMacroDelay
//
//  Created by BrookXy on 2022/1/19.
//

#import <Foundation/Foundation.h>

#define delay_call(time, block) \
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{ \
        block(); \
    })

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        
        delay_call(0.5, ^{
            NSLog(@"delayed");
        });
        sleep(5);
        NSLog(@"end");
    }
    return 0;
}

void RUNAFTER(NSTimeInterval timewaitmsec, dispatch_block_t body) {
    
}

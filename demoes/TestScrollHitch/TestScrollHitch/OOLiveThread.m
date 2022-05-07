//
//  OOLiveThread.m
//  TestScrollHitch
//
//  Created by BrookXy on 2022/4/21.
//

#import "OOLiveThread.h"

// refernce
// https://www.jianshu.com/p/eb0612eb6fe3
@implementation OOLiveThread

- (void)loop {
    NSLog(@"hit loop thread");
    
    // 向runloop里面添加事件source/timer/observer
    
    __auto_type timer = [NSTimer timerWithTimeInterval:2
                                               repeats:YES
                                                 block:^(NSTimer * _Nonnull timer) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [NSThread sleepForTimeInterval:0.05];
        });
    }];
    
    [[NSRunLoop currentRunLoop] addTimer:timer
                                 forMode:NSRunLoopCommonModes];

    [timer fire];
    
    [[NSRunLoop currentRunLoop] addPort:[NSPort port]
                                forMode:NSDefaultRunLoopMode];
    [[NSRunLoop currentRunLoop] run];
}

@end

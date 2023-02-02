//
//  ViewController.m
//  TestTimeProfiler
//
//  Created by Brook_Mobius on 2023/2/2.
//

#import "ViewController.h"

// Instruments — Time Profiler使用 - 简书 - https://www.jianshu.com/p/a1aa8d7469a8

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self printf];
  [self nslog];
  [self nslog2];
  [self logFromGlobalQueue];
  
  self.view.backgroundColor = UIColor.blueColor;
}


/// NSLog
- (void)nslog {
  //代码方式获取运行时间
  double dateStart = CFAbsoluteTimeGetCurrent();
  for (int i = 0; i < 10000; i++) {
    NSLog(@"---->NSLOG:%d", i);
  }
  double dateEnd = CFAbsoluteTimeGetCurrent() - dateStart;
  NSLog(@"NSLog timeConsuming = %f", dateEnd * 1000);
}

/// NSLog
- (void)nslog2 {
  //代码方式获取运行时间
  double dateStart = CFAbsoluteTimeGetCurrent();
  for (int i = 0; i < 10000; i++) {
    NSLog(@"---->NSLOG:%d", i);
  }
  double dateEnd = CFAbsoluteTimeGetCurrent() - dateStart;
  NSLog(@"NSLog timeConsuming = %f", dateEnd * 1000);
}

/// printf
- (void)printf {
  for (int i = 0; i < 10000; i++) {
    printf("====>printf:%d", i);
  }
}

/// 子线程中forLoop
- (void)logFromGlobalQueue {
  dispatch_async(dispatch_get_global_queue(0, 0), ^{
    for (int i = 0; i < 10000; i++) {
      NSLog(@"****>%d", i);
    }
  });
}

@end

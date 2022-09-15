//
//  ViewController.m
//  TestiOSRunloop
//
//  Created by Brook on 2019/11/15.
//  Copyright © 2019 br. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

+ (void)action {
    NSRunLoop *loop = NSRunLoop.currentRunLoop;
    [loop addPort:NSPort.new forMode:NSDefaultRunLoopMode];
    [loop run];
}

+ (NSThread *)test {
    static NSThread *thread = nil;
    thread = [[NSThread alloc] initWithTarget:self selector:@selector(action) object:nil];
    [thread start];
    
    return thread;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = arc4random() % 2 ? UIColor.whiteColor : UIColor.blueColor;
    
    // NSThread *thread = [self.class test];
    // [self performSelector:@selector(print) onThread:thread withObject:nil waitUntilDone:NO];
    
    
//    NSLog(@"%@", NSRunLoop.currentRunLoop);
}

- (void)print {
    NSLog(@"------%@", NSRunLoop.currentRunLoop);
}


- (void)log {
    NSLog(@"---- log");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"-------");
    
    
    ViewController *vc = [[ViewController alloc] init];
    
    [self presentViewController:vc animated:true completion:^{
        [vc performSelector:@selector(log) withObject:nil afterDelay:5];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"dismiss");
            [self dismissViewControllerAnimated:true completion:nil];
        });
    }];
}

- (void)dealloc {
    NSLog(@"dealloc %@", self);
}

@end

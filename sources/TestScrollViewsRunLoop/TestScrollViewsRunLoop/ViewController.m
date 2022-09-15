//
//  ViewController.m
//  TestScrollViewsRunLoop
//
//  Created by BrookXy on 2022/5/18.
//

#import "ViewController.h"


@interface ViewController ()

@property (nonatomic, strong) UIScrollView *superScrollView;
@property (nonatomic, strong) UIScrollView *subScrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = UIColor.redColor;
    
    CGFloat y = 300;
    CGFloat height = 1000;
    
    __auto_type superScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    superScrollView.backgroundColor = UIColor.lightGrayColor;
    superScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    superScrollView.contentSize = CGSizeMake(0, y + height);
    [self.view addSubview:superScrollView];
    self.superScrollView = superScrollView;
    
    __auto_type subScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, y, self.view.bounds.size.width, height)];
    subScrollView.backgroundColor = UIColor.cyanColor;
    subScrollView.contentSize = CGSizeMake(0, y + height + 1);
    [superScrollView addSubview:subScrollView];
    self.subScrollView = subScrollView;
    
    
    for (NSInteger i = 0; i < 100; i += 1) {
        __auto_type frame = CGRectMake(0, i * 40, self.view.frame.size.width, 40);
        __auto_type label = [[UILabel alloc] initWithFrame:frame];
        label.text = [NSString stringWithFormat:@"---- %ld", (long)i];
        [subScrollView addSubview:label];
    }
    
    [self observeDefaultRunloop];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}


// MARK: - runloop obseving
- (void)observeDefaultRunloop {
    __weak __auto_type weakSelf = self;
    __auto_type observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault,
                                                              kCFRunLoopEntry | kCFRunLoopExit,
                                                              YES,
                                                              0,
                                                              ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        __auto_type self = weakSelf;
        if (nil == self) return;
        
        static CFTimeInterval time = 0;
        __auto_type current = CACurrentMediaTime();
        __auto_type span = current - time;
        time = current;
        
        
        NSLog(@"fpsmonitor activity mode: %@ type:%@ span: %.1f"
                 , NSRunLoop.currentRunLoop.currentMode
                 , activity == kCFRunLoopEntry  ? @"Entry" : @"Exit"
                 , span * 1000);
    });
    
    CFRunLoopAddObserver(CFRunLoopGetMain(),
                         observer,
                         (__bridge CFStringRef)NSRunLoopCommonModes);
    
}


@end

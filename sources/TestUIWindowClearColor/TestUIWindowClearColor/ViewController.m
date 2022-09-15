//
//  ViewController.m
//  TestUIWindowClearColor
//
//  Created by 席萍萍Brook.dinglan on 2021/10/20.
//

#import "ViewController.h"


@interface LADURootViewController : UIViewController

@property (nonatomic, copy) dispatch_block_t callback;

@end
@implementation LADURootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.clearColor;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 100, 100, 100);
    button.backgroundColor = UIColor.blueColor;
    [self.view addSubview:button];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.callback();
}

@end


@interface LADUWindow : UIWindow

@end

@implementation LADUWindow

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
    }
    return self;
}

- (void)dealloc {
    NSLog(@"dealloc --- %@", self);
}

@end

@interface ViewController ()

@property (nonatomic, strong) LADUWindow *myWindow;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.myWindow) {
        [self dismissWindow];
    } else {
        __weak __auto_type weakSelf = self;
        self.myWindow = [[LADUWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
        __auto_type vc = [[LADURootViewController alloc] init];
        vc.callback = ^{
            __strong __auto_type self = weakSelf; if (!self) return;
            [self dismissWindow];
        };
        self.myWindow.rootViewController = vc;
        self.myWindow.hidden = NO;
    }
}

- (void)dismissWindow {
    self.myWindow.hidden = YES;
    self.myWindow = nil;
}

@end

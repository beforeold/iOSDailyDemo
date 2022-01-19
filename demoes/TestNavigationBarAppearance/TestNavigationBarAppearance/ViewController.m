//
//  ViewController.m
//  TestNavigationBarAppearance
//
//  Created by 席萍萍Brook.dinglan on 2021/10/14.
//

#import "ViewController.h"
#import "SecondViewController.h"
#import "UINavigationController+LAUK.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"First";
    self.view.backgroundColor = UIColor.grayColor;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    __auto_type vc = [[SecondViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


@end

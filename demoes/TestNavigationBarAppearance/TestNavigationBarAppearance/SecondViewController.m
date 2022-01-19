//
//  SecondViewController.m
//  TestNavigationBarAppearance
//
//  Created by 席萍萍Brook.dinglan on 2021/10/14.
//

#import "SecondViewController.h"
#import "UINavigationController+LAUK.h"

@interface SecondViewController ()

@property (nonatomic, assign) BOOL customFlag;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"Second";
    self.view.backgroundColor = UIColor.lightGrayColor;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.customFlag = !self.customFlag;
    
    __auto_type backgroundColor = self.customFlag ? UIColor.orangeColor : UIColor.whiteColor;
    __auto_type font = [UIFont systemFontOfSize:self.customFlag ? 20: 15];
    __auto_type titleColor = self.customFlag ? UIColor.whiteColor : UIColor.blackColor;
    __auto_type statusBarStyle = self.customFlag ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault;
    
    [self.navigationController lauk_displayCustomNavigationBarFromColor:backgroundColor
                                                                toColor:backgroundColor
                                                              titleFont:font
                                                             titleColor:titleColor
                                                         statusBarStyle:statusBarStyle];
}


@end

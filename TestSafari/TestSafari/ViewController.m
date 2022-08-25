//
//  ViewController.m
//  TestSafari
//
//  Created by dinglan on 2021/1/10.
//

#import "ViewController.h"
#import <SafariServices/SafariServices.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self show];
    });
}
- (void)show {
    __auto_type URL = [NSURL URLWithString:@"https://m.you.163.com/item/detail?id=3487199&purchaseType=3#/?_k=utkc5s"];
    __auto_type vc = [[SFSafariViewController alloc] initWithURL:URL];
    [self presentViewController:vc animated:YES completion:nil];
}


@end

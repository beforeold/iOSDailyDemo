//
//  ViewController.m
//  hahaApp
//
//  Created by dinglan on 2021/1/8.
//

#import "ViewController.h"
#import <shared/shared.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    __auto_type obj = [[SharedGreeting alloc] init];
    NSLog(@"😸😸😸😸😸😸😸: %@, %p", [obj greeting], obj);
}


@end

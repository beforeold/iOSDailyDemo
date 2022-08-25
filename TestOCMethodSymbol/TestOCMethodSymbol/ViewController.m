//
//  ViewController.m
//  TestOCMethodSymbol
//
//  Created by 席萍萍Brook.dinglan on 2021/8/29.
//

#import "ViewController.h"

@import MyLib;

@interface Hello : NSObject

- (void)play;

@end

@implementation Hello



@end

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [[[Hello alloc] init] play];
    
    [MyClass play];
}


@end

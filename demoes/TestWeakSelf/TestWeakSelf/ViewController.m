//
//  ViewController.m
//  TestWeakSelf
//
//  Created by 席萍萍Brook.dinglan on 2021/12/31.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

struct Weak {
    void *pointer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak ViewController *weakSelf = self;
    
    __strong self = weakSelf;
    
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        __strong strongSelf = weakSelf;
        if (!weakSelf) {
            return ;
        }
        // nil
        weakSelf.title = @"";
    })
    NSMutableArray *array = [NSMutableArray array];
    
    [array addObject:weakSelf.title];
}


@end

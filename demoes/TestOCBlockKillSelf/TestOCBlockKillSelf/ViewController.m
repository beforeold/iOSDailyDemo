//
//  ViewController.m
//  TestOCBlockKillSelf
//
//  Created by BrookXy on 2022/2/10.
//

#import "ViewController.h"

@interface BaseMananger : NSObject

@property (nullable, nonatomic, copy) dispatch_block_t handler;

- (void)actionWithCompletionHandler:(dispatch_block_t)handler;

@end

@implementation BaseMananger

- (void)actionWithCompletionHandler:(dispatch_block_t)handler {
    self.handler = handler;
    [self callback];
}

- (void)callback {
    self.handler();
    
    // option 2
    // self.handler = nil;
}

- (void)dealloc {
    NSLog(@"BaseMananger dealloc");
}

@end

@interface MyMananger : BaseMananger

@end

@implementation MyMananger

- (void)actionWithCompletionHandler:(dispatch_block_t)handler {
    [super actionWithCompletionHandler:handler];
    [self someThing];
}

- (void)someThing {
    NSLog(@"call something");
}

@end

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     __block __auto_type ins = [[MyMananger alloc] init];
    [ins actionWithCompletionHandler:^{
        NSLog(@"completion");
        
        // unsafe to nil-out self synchrously
        // error option
        // ins = nil
        
        // option 1
        ins.handler = nil;
    }];
}


@end

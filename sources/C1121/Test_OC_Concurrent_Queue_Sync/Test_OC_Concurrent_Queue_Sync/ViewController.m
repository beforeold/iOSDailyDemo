//
//  ViewController.m
//  Test_OC_Concurrent_Queue_Sync
//
//  Created by Brook on 2019/12/26.
//  Copyright © 2019 br. All rights reserved.
//

#import "ViewController.h"

@interface Cool : NSObject

@property (weak, nonatomic) ViewController *vc;

@end


@interface ViewController ()

@property (assign) int money;

@property (nonatomic, strong) dispatch_queue_t serialQueue;

@property (nonatomic, assign) char age;

@property (nonatomic, strong) NSMutableArray *array;


@property (nonatomic, strong) id<NSLocking> lock;

@end

@implementation Cool

- (void)releaseAndPlay {
    [self.vc.array removeAllObjects];
    
    [self play];
}

- (void)play {
    NSLog(@"play");
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    // [self test_serial_queue_sync];
    // [self test_nonatomic_setter];
    [self test_lock_s1];
}

- (void)test_release {
    self.array = [NSMutableArray array];
    Cool *ccc = [[Cool alloc] init];
    ccc.vc = self;
    [self.array addObject:ccc];
    
    [ccc releaseAndPlay];
}

- (void)test_nonatomic_setter {
    for (int i = 0; i < 1000; i++) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            self.age = i; // nonatomic
        });
    }
}


- (void)test_lock_s1 {
    self.lock = [[NSRecursiveLock alloc] init];
    
    [self.lock lock];
    NSLog(@"__%s__", __func__);
    [self test_lock_s2];
    [self.lock unlock];
}

- (void)test_lock_s2 {
    [self.lock lock];
    NSLog(@"__%s__", __func__);
    [self.lock unlock];
}

- (void)test_serial_queue_sync {
    self.serialQueue = dispatch_queue_create("good", NULL);
    [[[NSThread alloc] initWithBlock:^{
        NSLog(@"outer %@", NSThread.currentThread);
        dispatch_sync(self.serialQueue, ^{
            NSLog(@"inner %@", NSThread.currentThread);
        });
    }] start];
}

- (void)test_serial_queue_async {
    self.serialQueue = dispatch_queue_create("good", NULL);
    [[[NSThread alloc] initWithBlock:^{
        NSLog(@"outer %@", NSThread.currentThread);
        dispatch_async(self.serialQueue, ^{
            NSLog(@"inner %@", NSThread.currentThread);
        });
    }] start];
}

- (void)test_pointer {
    int money = self.money;
    [self printPointer:&money];
    [self printPointer:&_money];
}


- (void)printPointer:(void *)p {
    NSLog(@"pointer: %p", p);
}

- (void)test_money {
    self.money = 1000;
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 10; i++) {
            [self plusMoney];
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 10; i++) {
            [self plusMoney];
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 10; i++) {
            [self minusMoney];
        }
    });
    
//
//    dispatch_async(queue, ^{
//        for (int i = 0; i < 10; i++) {
//            [self minusMoney];
//        }
//    });
}

- (void)plusMoney {
    self.money += 50;
    
    NSLog(@"plus end %d", self.money);
}

- (void)minusMoney {
    self.money -= 20;
    
    NSLog(@"minus end %d", self.money);
}


- (void)testPrint {
    NSLog(@"test print");
}

- (void)test_thread {
    NSThread *thread = [[NSThread alloc] initWithBlock:^{
        sleep(2);
        NSLog(@"%@", [NSThread currentThread]);
    }];
    [thread start];
    NSLog(@"will perform");
    [self performSelector:@selector(testPrint) onThread:thread withObject:nil waitUntilDone:YES];
    NSLog(@"did perform");
}

- (void)test_concurrent {
    
    dispatch_queue_t concurrent = dispatch_get_global_queue(0, 0);
    dispatch_async(concurrent, ^{
        for (int i = 0; i < 1000; i++) {
            NSLog(@"11111");
            NSLog(@"1111100000000");
            NSLog(@"1111100000000oooooooooooo");
        }
    });
    
    dispatch_sync(concurrent, ^{
        for (int i = 0; i < 1000; i++) {
            NSLog(@"222222");
        }
    });
}



@end

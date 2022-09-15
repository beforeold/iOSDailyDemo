//
//  AppDelegate.m
//  Test_EXC_BAD_ACCESS
//
//  Created by Brook on 2020/1/2.
//  Copyright © 2020 br. All rights reserved.
//

#import "AppDelegate.h"
#import "UITextView+Test.h"

@interface AppDelegate ()

@property (nonatomic, assign) id unsafeDelegate;

@end


@interface Dummy : NSObject

@property (nonatomic, assign) uintptr_t age;

@end

typedef struct DummyStruct {
    void *isa;
    uintptr_t age;
} DummyStruct;

@implementation Dummy

- (instancetype)init {
    self = [super init];
    if (self) {
        _age = 0xdeadbeefcafebabe;
        NSLog(@"sizeof %ld", sizeof(0xdeadbeefcafebabe)); // 16进制，一个值表示4位 16 == 2^4 
        NSLog(@"struct sizeof %ld", sizeof(DummyStruct));
    }
    return self;
}

@end
@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    UITextView *textView = [[UITextView alloc] init];
    [textView xp_add];
    self.unsafeDelegate = textView;
    
    [self test_zombie];
    
    return YES;
}


- (void)test_zombie {
    id number = Dummy.new;
    NSString *str = [NSString stringWithFormat:@"%@", [NSData dataWithBytes:CFBridgingRetain(number) length:4]];
    printf("%s\n", str.UTF8String);
}

#pragma mark - UISceneSession lifecycle

//
//- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
//    // Called when a new scene session is being created.
//    // Use this method to select a configuration to create the new scene with.
//    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
//}
//
//
//- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
//    // Called when the user discards a scene session.
//    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // [self.unsafeDelegate description];
}


@end

//
//  OCClass.m
//  TestARKitRealityKit
//
//  Created by BrookXy on 2022/1/9.
//

#import "OCClass.h"
@import MySDK;

//#import <RealityKit/Reality-Swift.h>

@implementation OCClass

+ (void)load {
    id ins = [[NSClassFromString(@"RealityKit.ARView") alloc] init];
    NSLog(@"---%@", ins);
}

+ (void)foo {
    [[Person alloc] init];
}

@end

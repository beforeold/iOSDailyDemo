//
//  KSTextField.m
//  TestKaleidoscopeWrap2
//
//  Created by BrookXy on 2022/2/10.
//

#import "KSTextField.h"
#import "TestKaleidoscopeWrap2-Swift.h"
@import UIKit;

static BOOL _enableUIKIt = YES;

@implementation KSTextField

+ (BOOL)enableUIKIt {
    return _enableUIKIt;
}

+ (void)setEnableUIKIt:(BOOL)enableUIKIt {
    _enableUIKIt = enableUIKIt;
}

- (instancetype)init {
    if ([KSTextField enableUIKIt]) {
        return [[UITextField alloc] init];
    } else {
        return [[TextField alloc] init];
    }
}

@end

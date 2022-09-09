//
//  UITextView+Test.m
//  Test_EXC_BAD_ACCESS
//
//  Created by Brook on 2020/1/2.
//  Copyright © 2020 br. All rights reserved.
//

#import "UITextView+Test.h"


@implementation UITextView (Test)

- (void)xp_add {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(xp_callback)
                                               name:UITextViewTextDidChangeNotification
                                             object:self];
}

- (void)xp_callback {
    NSLog(@"callback");
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self
                                                  name:UITextViewTextDidChangeNotification
                                                object:self];
}

@end

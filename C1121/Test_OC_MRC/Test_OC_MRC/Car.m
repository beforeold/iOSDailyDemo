//
//  Car.m
//  Test_OC_MRC
//
//  Created by Brook on 2019/11/27.
//  Copyright © 2019 br. All rights reserved.
//

#import "Car.h"

@implementation Car

- (void)dealloc {
    NSLog(@"car dealloc, %@", self);
    
    [super dealloc];
}

@end

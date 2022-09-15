//
//  Driver.m
//  Test_OC_MRC
//
//  Created by Brook on 2019/11/27.
//  Copyright © 2019 br. All rights reserved.
//

#import "Driver.h"
#import "Car.h"

@implementation Driver
{
    Car *_car;
}

- (void)setCar:(Car *)car {
    if (_car != car) {
        [_car release];
        _car = [car retain];
    }
    
    /* 等效
    [car retain];
     
    [_car release];
    _car = car;
    */
}

- (Car *)car {
    return _car;
}

- (void)dealloc {
    [_car release];
    
    NSLog(@"Driver dealloc");
    [super dealloc];
}

@end

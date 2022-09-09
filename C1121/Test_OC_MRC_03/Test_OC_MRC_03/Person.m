//
//  Person.m
//  Test_OC_MRC_03
//
//  Created by Brook on 2019/11/27.
//  Copyright © 2019 br. All rights reserved.
//

#import "Person.h"

@implementation Person

+ (instancetype)person {
    return [[[self alloc] init] autorelease];
}

- (void)dealloc {
    NSLog(@"dealloc");
    
    [super dealloc];
}

@end

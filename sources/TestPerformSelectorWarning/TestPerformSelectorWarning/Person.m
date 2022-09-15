//
//  Person.m
//  TestPerformSelectorWarning
//
//  Created by BrookXy on 2022/1/7.
//

#import "Person.h"

@implementation Person

+ (void)playClass {
    
}

- (BOOL)playInstanceWithObject:(id)object {
    NSLog(@"arg1 = %@", object);
    return YES;
}

@end

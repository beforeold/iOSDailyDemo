//
//  OCObject.m
//  TestOCBoolNumber
//
//  Created by Brook_Mobius on 2/17/25.
//

#import "OCObject.h"

@implementation OCObject

+ (void)printNumber:(NSNumber *)number {
  NSLog(@"value: %@, class: %@", number, [number class]);
}

@end

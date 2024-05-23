//
//  NSObject+TryCatch.m
//  TestOCTryCatch
//
//  Created by xipingping on 5/23/24.
//

#import "NSObject+TryCatch.h"

@implementation NSObject (TryCatch)

- (void)tryCatch {
    @try {
        NSLog(@"try");

        // throw an exception here
        __auto_type excep = [NSException exceptionWithName: @"test" reason: @"test" userInfo: nil];
        [excep raise];
    } @catch (NSException *exception) {
        NSLog(@"catched %@", exception);
    }
}

@end

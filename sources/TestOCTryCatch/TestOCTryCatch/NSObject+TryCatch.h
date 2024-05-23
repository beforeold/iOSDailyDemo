//
//  NSObject+TryCatch.h
//  TestOCTryCatch
//
//  Created by xipingping on 5/23/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (TryCatch)

- (void)tryCatch;

@end

// a function to catch objective-c exception with a block parameter as action
static inline void tryCatch(void (^action)(void)) {
    @try {
        action();
    } @catch (NSException *exception) {
        NSLog(@"function catched %@", exception);
    }
}

NS_ASSUME_NONNULL_END

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyObject : NSObject

- (void)foo;

// call a block
- (void)callBlock:(void (^)(void))block;

@end

NS_ASSUME_NONNULL_END

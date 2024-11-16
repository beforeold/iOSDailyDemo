#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Container<T> : NSObject

- (instancetype)initWithValue:(T)value;

@property (nonatomic, strong) T value;

@end

NS_ASSUME_NONNULL_END

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject

@property (nonatomic, readonly) NSArray<NSString *> *array;

@property (nonatomic, readonly) NSMutableArray<NSString *> *mutableArray;

- (NSArray<NSString *> *)getArray;

- (NSMutableArray<NSString *> *)getMutableArray;

@end

NS_ASSUME_NONNULL_END

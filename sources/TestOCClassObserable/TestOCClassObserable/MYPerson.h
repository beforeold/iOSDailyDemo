#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MYPerson : NSObject

@property (nonatomic, copy, nullable) NSString *name;

@property (nonatomic, assign) NSInteger age;

@property (nonatomic, assign) BOOL isPresented;

@end

NS_ASSUME_NONNULL_END

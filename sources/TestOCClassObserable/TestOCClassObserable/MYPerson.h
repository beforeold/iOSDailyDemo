#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MYPerson : NSObject

@property (nonatomic, copy, nullable) NSString *name;

@property (nonatomic, assign) NSInteger age;

@property (nonatomic, assign) BOOL isPresented;

- (void)updateName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END

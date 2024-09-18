#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JSONPrinter : NSObject

+ (void)printDictionary:(NSDictionary *)dict;

+ (void)printObject:(id)object;

@end

NS_ASSUME_NONNULL_END

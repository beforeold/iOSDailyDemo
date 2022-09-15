//
// AppMonitorDimensionValueSet.h
// 
// UserTrack 
// 开发团队：数据通道团队 
// UT答疑群：11791581(钉钉) 
// UT埋点平台答疑群：11779226(钉钉) 
// 
// Copyright (c) 2014-2017 Taobao. All rights reserved. 
//

#import <Foundation/Foundation.h>
/**
  其实就是个字典
 */
NS_ASSUME_NONNULL_BEGIN
@interface AppMonitorDimensionValueSet : NSObject<NSCopying>

/**
 * 存储维度值
 */
@property (nonatomic, strong) NSMutableDictionary *dict;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (void)setValue:(NSString *)value forName:(NSString *)name;
- (BOOL)containValueForName:(NSString *)name;
- (NSString *)valueForName:(NSString *)name;

@end
NS_ASSUME_NONNULL_END

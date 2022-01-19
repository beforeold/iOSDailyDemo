//
//  LAKMMMtopExtRequest.h
//  LAKMMAdapter
//
//  Created by banmalu on 2021/3/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// request 对象
@interface LAKMMMtopExtRequest : NSObject
@property(nonatomic,assign) NSInteger timeoutInSeconds; ///< 超时时间
@property(nonatomic,assign) BOOL useHttpPost ; ///< 是否使用http post
@property(nonatomic,assign) NSInteger retryTimes ; ///< 重试次数
@property(nonatomic,copy) NSMutableDictionary *params ; ///< 参数


@end

NS_ASSUME_NONNULL_END

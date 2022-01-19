//
//  LAKMMMtopService.h
//  LAKMMAdapter
//
//  Created by banmalu on 2021/3/1.
//

#import <Foundation/Foundation.h>
#import <LAKMMAdapter/LAKMMMtopExtRequest.h>
#import <LAKMMAdapter/LAKMMMtopExtRequestDelegate.h>

NS_ASSUME_NONNULL_BEGIN

@interface LAKMMMtopService : NSObject


/// 异步调用API, 跳过startFilter之前的filter
/// @param kmmRequest 请求对象
/// @param kmmDelegate 回调
/// @param startFilter 跳过startFilter之前的filter
+ (void)async_call: (LAKMMMtopExtRequest*)kmmRequest delegate: (nullable id<LAKMMMtopExtRequestDelegate>)kmmDelegate startFilter: (nullable NSString*)startFilter ;

@end

NS_ASSUME_NONNULL_END

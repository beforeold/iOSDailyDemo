//
//  LAKMMMtopExtRequestDelegate.h
//  LAKMMAdapter
//
//  Created by banmalu on 2021/3/1.
//

#import <Foundation/Foundation.h>
#import <LAKMMAdapter/LAKMMMtopExtRequest.h>
#import <LAKMMAdapter/LAKMMMtopExtResponse.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LAKMMMtopExtRequestDelegate <NSObject>


@optional
/*!
 * 请求开始执行时回调 (开始发送网络请求)
 *
 */
-(void) started: (LAKMMMtopExtRequest*) request;

/*!
 * 失败回调, 注意: 我们用的是主线程回调
 * @param response   response.error 是错误信息
 */
-(void) failed: (LAKMMMtopExtResponse*) response;

/*!
 * 成功回调, 注意: 我们用的是主线程回调
 * @param response   response.error 是错误信息
 */
-(void) succeed: (LAKMMMtopExtResponse*) response;

@end

NS_ASSUME_NONNULL_END

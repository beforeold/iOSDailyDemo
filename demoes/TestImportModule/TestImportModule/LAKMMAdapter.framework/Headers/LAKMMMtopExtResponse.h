//
//  LAKMMMtopExtResponse.h
//  LAKMMAdapter
//
//  Created by banmalu on 2021/3/1.
//

#import <Foundation/Foundation.h>
//#import <MtopCore/Constants.h>
#import <LAKMMAdapter/LAKMMMtopExtRequest.h>
#import <LAKMMAdapter/LAKMMError.h>

NS_ASSUME_NONNULL_BEGIN

@class MtopExtResponse;
@interface LAKMMMtopExtResponse : NSObject
@property(assign, nonatomic) int httpResponseCode;          // http 响应码
@property(strong, nonatomic) LAKMMError* error;                  // 错误信息
@property(strong, nonatomic) NSMutableDictionary* headers;  // http响应头
@property(strong, nonatomic) NSData* rawbody;               // 原始的http响应body
@property(strong, nonatomic) NSString* body;                // 原始的http响应body
@property(strong, nonatomic) NSDictionary* json;            // json响应，从http body 解析
@property(assign, nonatomic) BOOL isFromCache;              // 响应是否来至cache
@property(assign, nonatomic) BOOL isCacheExpired;           // cache是否失效了
@property(strong, nonatomic) LAKMMMtopExtRequest* request;       // 响应对应的API Request

// 为问题排查准备的
@property(strong, nonatomic) NSURL* requestURL;             // 底层发出去的URL
@property(strong, nonatomic) NSString* requestMethod;       // 底层http 请求方法
@property(strong, nonatomic) NSDictionary* requestHeaders;  // 底层发出去的http headers
@property(strong, nonatomic) NSData* requestBody;           // 底层发出去的http body
@property(assign, nonatomic) BOOL isLoginCancel;
@property(nonatomic,assign) BOOL isSucceed ; ///< 判断响应是否成功


/// 初始化对象（MtopExtResponse转LAKMMMtopExtResponse）
/// @param response MtopExtResponse 类型对象
/// @param kmmRequest 请求
+ (instancetype)response:(MtopExtResponse *)response request:(LAKMMMtopExtRequest *)kmmRequest;

@end

NS_ASSUME_NONNULL_END

//
//  LAKMMError.h
//  LAKMMAdapter
//
//  Created by banmalu on 2021/3/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class Error;

@interface LAKMMError : NSObject
// http响应码
@property(assign, nonatomic) int                    httpResponseCode;

// 错误码
@property(copy, nonatomic) NSString               *code;

// 错误提示信息
@property(copy, nonatomic) NSString               *msg;

// 错误提示信息
@property(copy, nonatomic) NSString               *originalMsg;

// 子错误码
@property(copy, nonatomic) NSString               *subCode;

// 子错误提示信息
@property(copy, nonatomic) NSString               *subMsg;

// 原始的错误
@property(copy, nonatomic) NSError                *rawError;

// 新增错误映射码
@property(copy, nonatomic) NSString               *mappingCode;

// 新增透传TBUIKit错误信息
@property(strong, nonatomic) NSError                *uikitError;

// 新增420限流透出retCode错误信息
@property(copy, nonatomic) NSString               *limitFlowRawCode;

@property(nonatomic,assign) BOOL isSucceed ; ///< 判断是否成功

@property(nonatomic,assign) BOOL isNetworkError ; ///< 判断是否为网络错误

@property(nonatomic,assign) BOOL isResponseDataParseError ; ///< 判断是否为响应错误


/// 初始化对象（Error转LAKMMError）
/// @param err Error 类型对象
+ (instancetype)error:(Error *)err;


@end

NS_ASSUME_NONNULL_END

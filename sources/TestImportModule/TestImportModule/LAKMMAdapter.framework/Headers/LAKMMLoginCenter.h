//
//  LAKMMLoginCenter.h
//  LAKMMAdapter
//
//  Created by dinglan on 2021/3/1.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface LAKMMLoginAuthArgs : NSObject

- (instancetype)initWithBizScene:(NSString * _Nullable)bizScene NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

/// In concret business scene, it should not be nil or empty
@property (nonatomic, copy, nullable) NSString *bizScene;
/// for kmm android
@property (nonatomic, copy, nullable) NSString *spm;

/// success with login type, wheter is from register
@property (nonatomic, copy, nullable) void(^successBlock)(BOOL isRegister);
@property (nonatomic, copy, nullable) void(^failureBlock)(void);

@end

@interface LAKMMLoginCenter : NSObject

/**
 To auth page
 
 @param args    write all your arguments here
 */
+ (void)toAuthWithArgs:(LAKMMLoginAuthArgs *)args;

/**
 just check local session has sessionId && refreshToken
 server may verify the sessionId expired
 
 @return current app is login or not
 */
+ (BOOL)isLogin;

@end

NS_ASSUME_NONNULL_END

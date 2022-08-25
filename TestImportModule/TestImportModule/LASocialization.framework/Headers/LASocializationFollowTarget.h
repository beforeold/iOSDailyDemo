//
//  LASocializationFollowTarget.h
//  LASocialization
//
//  Created by guobing.sgb on 2018/10/10.
//  Copyright © 2018年 lazada.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, LASocializationFollowTargetType) {
    LASocializationFollowTargetShop     = 1,
    LASocializationFollowTargetKOL      = 2
};

@interface LASocializationFollowTarget : NSObject

@property(nonatomic, assign) LASocializationFollowTargetType targetType;
@property(nonatomic, assign) NSInteger targetId;
@property(nonatomic, assign) BOOL follow;

/// whether notify the observers when request success
/// @note default to be YES
@property(nonatomic, assign) BOOL notifyObservers;

@property(nonatomic, strong) NSString *pageName;
@property(nonatomic, strong) NSString *tabName;
@property(nonatomic, strong) NSString *followExtArgs;

/// the scene, such as feed_home_pop, since 20210111
@property (nonatomic, copy) NSString *scene;

+ (instancetype)shopTargetWithTargetId:(NSInteger)targetId;

+ (instancetype)targetWithType:(LASocializationFollowTargetType)targetType
                      targetId:(NSInteger)targetId;

+ (instancetype)targetWithType:(LASocializationFollowTargetType)targetType
                      targetId:(NSInteger)targetId
                       tabName:(NSString *)tabName
                 followExtArgs:(NSString *)followExtArgs;

@end

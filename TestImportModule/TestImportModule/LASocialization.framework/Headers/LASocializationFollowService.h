//
//  LASocializationFollowService.h
//  LASocialization
//
//  Created by guobing.sgb on 2018/10/10.
//  Copyright © 2018年 lazada.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LASocializationFollowTarget;

@protocol LASocializationFollowUpdateDelegate <NSObject>

@optional

- (void)followUpdateWithTarget:(LASocializationFollowTarget *)target;

@end

@protocol LASocializationErrorProtocol;

typedef void(^LASocializationFollowResult)(BOOL follow, NSInteger followersNumber, id<LASocializationErrorProtocol> error);
typedef void(^LASocializationFollowCancel)(void);

@interface LASocializationFollowService : NSObject

+ (instancetype)sharedService;

- (void)addFollowUpdateObserver:(nonnull id<LASocializationFollowUpdateDelegate>)observer withTarget:(nonnull LASocializationFollowTarget *)target;
- (void)removeFollowUpdateObserver:(nonnull id<LASocializationFollowUpdateDelegate>)observer withTarget:(nonnull LASocializationFollowTarget *)target;

/**
 * If you use this api to notify observers, please make sure follow/unfollow target.notifyObservers is NO.
 */
- (void)notifyObserversWithTarget:(nonnull LASocializationFollowTarget *)target;

/**
 * Follow. If not login will open login page first, after login then it will call the follow service.
 * When target.notifyObservers is YES, and follow success, it will notify observers.
 *
 * @param complete follow complete block, followersNumber should not be used.
 * @param cancel Login cancel
 */
- (void)followTarget:(nonnull LASocializationFollowTarget *)target complete:(LASocializationFollowResult)complete cancel:(LASocializationFollowCancel)cancel;

/**
 * UnFollow.
 * When target.notifyObservers is YES, and unfollow success, it will notify observers.
 *
 * @param complete follow complete block, followersNumber should not be used.
 */
- (void)unFollowTarget:(nonnull LASocializationFollowTarget *)target complete:(LASocializationFollowResult)complete;

/**
 * Query follow status. If not login will open login page first, after login then it will call the query service.
 *
 * @param complete follow complete block
 * @param cancel Login cancel
 */
- (void)isFollowTarget:(nonnull LASocializationFollowTarget *)target complete:(LASocializationFollowResult)complete cancel:(LASocializationFollowCancel)cancel;

@end

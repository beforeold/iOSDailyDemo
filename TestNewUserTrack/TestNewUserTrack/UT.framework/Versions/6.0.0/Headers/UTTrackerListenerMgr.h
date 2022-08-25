//
//  UTTrackerListenerMgr.h
//  miniUTSDK
//
//  Created by ljianfeng on 2019/3/5.
//  Copyright © 2019 Taobao.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UT/UTTracker.h>
@class UTEvent;
NS_ASSUME_NONNULL_BEGIN
@protocol UTTrackerListener <NSObject>
@required
- (NSString *)trackerListenerName;
@optional
//tracker
- (void)send:(NSDictionary *)logMap tracker:(UTTracker *)tracker;
- (void)updatePageProperties:(id)pPageObject properties:(NSDictionary *)pProperties tracker:(UTTracker *)tracker;
- (void)updatePageName:(id)pPageObject pageName:(NSString *)pPageName tracker:(UTTracker *)tracker;
- (void)updateNextPageProperties:(NSDictionary *)properties tracker:(UTTracker *)tracker;
- (void)pageDisAppear:(id)pPageObject tracker:(UTTracker *)tracker;
- (void)pageAppear:(id)pPageObject withPageName:(NSString *)pPageName tracker:(UTTracker *)tracker;
//autoexposure
- (void)addExposureViewToCommitWithBlock:(NSString *)block
                                  viewId:(NSString *)viewId
                                    args:(NSDictionary *)args;
/** * 自动曝光的视图进入屏幕区域可见 * */
- (void)viewBecomeVisible:(NSString *)pageName
                    block:(NSString *)block
                    viewId:(NSString *)viewId;
/** * 自动曝光的视图离开屏幕区域,变得不可见 * */
- (void)viewBecomeInvisible:(NSString *)pageName
                      block:(NSString *)block
                     viewId:(NSString *)viewId;

/**
    以下为持续性接口回调，为同步回调，严禁耗时操作
 */
/** * 持续性事件开始回调* */
- (void)beginEvent:(UTEvent *)event;

/** * 持续性事件Args更新回调* */
- (void)updateEvent:(UTEvent *)event;

/** * 持续性事件pageName更新回调，目前pageAppear会回调* */
- (void)updateEventPageName:(UTEvent *)event;

/** * 持续性事件结束更新回调* */
- (void)endEvent:(UTEvent *)event;

/** * 单点事件回调，目前h5的windvane  2001事件会走这个回调* */
- (void)sendEvent:(UTEvent *)event;
@end
@interface UTTrackerListenerMgr : NSObject
+ (void)registerTrackerListener:(id<UTTrackerListener> )listener;
+ (void)unregisterTrackerListener:(id<UTTrackerListener> )listener;

+ (NSArray<id<UTTrackerListener> > *)getActiveListeners;
@end

NS_ASSUME_NONNULL_END

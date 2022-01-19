//
//  UTBehaviorTracker.h
//  UT
//
//  Created by ljianfeng on 2020/5/6.
//  Copyright © 2020 Taobao.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UTEvent.h"
#import "UTTrackerListenerMgr.h"

NS_ASSUME_NONNULL_BEGIN
@protocol UTTriggerObserver
//触发器被触发
- (void)onTriggerName:(NSString *)triggerName eventArgs:(NSDictionary *)eventArgs;
@end
@interface UTEventTracker : NSObject

+ (instancetype)sharedInstance;
//基础接口
-(void)sendEvent:(UTEvent *)event;

-(void)beginEvent:(UTEvent *)event;
-(void)updateEvent:(UTEvent *)event;
-(void)updateEventPageName:(UTEvent *)event;

-(void)endEventByKey:(NSString *)key;
-(UTEvent *)getEventByKey:(NSString *)key;
//扩展工具接口
- (void)updateEventBykey:(NSString *)key
              properties:(NSDictionary *)properties;


//获取eventkey
- (NSString *)eventKeyForObj:(NSObject *)obj;

//trigger接口
- (void)observeTrigger:(id<UTTriggerObserver>)observer triggerName:(NSString *)triggerName;
- (void)sendTriggerName:(NSString *)triggerName event:(NSDictionary *)args;

@end

@interface UTPageEventTracker:NSObject<UTTrackerListener>
+ (instancetype)sharedInstance;
@end

NS_ASSUME_NONNULL_END

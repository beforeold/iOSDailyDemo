//
//  UTEvent.h
//  UT
//
//  Created by ljianfeng on 2020/5/6.
//  Copyright © 2020 Taobao.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, UTEventState){
    UTEventStateBegin = 0,
    UTEventStateUpdate,   //1
    UTEventStateEnd  //2
};

@interface UTEvent : NSObject
@property (nonatomic,strong)NSString *key;
@property (nonatomic,strong)NSString *pageName;
@property (nonatomic,strong)NSString *eventId;

@property (nonatomic,strong)NSString *scene;
@property (nonatomic,strong)NSString *bizId;
@property (nonatomic,weak)id context;

@property (nonatomic,strong)NSString *arg1;
@property (nonatomic,strong)NSString *arg2;
@property (nonatomic,strong)NSString *arg3;

@property (nonatomic,assign)BOOL toLog;
@property (nonatomic,strong)NSDictionary *args;

@property (nonatomic,assign )NSTimeInterval beginTime;
@property (nonatomic,assign )NSTimeInterval duration;
@property (nonatomic,assign )UTEventState state;
@property (nonatomic,assign)BOOL isH5;

+ (instancetype)eventWithKey:(NSString *)key
                    pageName:(NSString *)pageName
                     eventId:(NSString *)eventId;

+ (instancetype)eventWithKey:(NSString *)key
                    pageName:(NSString *)pageName
                     eventId:(NSString *)eventId
                        arg1:(NSString *)arg1
                        arg2:(NSString *)arg2
                        arg3:(NSString *)arg3
                        args:(NSDictionary *)args;
+ (instancetype)eventWithKey:(NSString *)key
                    pageName:(NSString *)pageName;
+ (UTEvent *)eventWithUTLog:(NSDictionary  *)utlog;
- (void)updateProperties:(NSDictionary *)properties;
- (void)copyProperties:(UTEvent *)event;
- (NSDictionary *)toLogParam;
@end

NS_ASSUME_NONNULL_END

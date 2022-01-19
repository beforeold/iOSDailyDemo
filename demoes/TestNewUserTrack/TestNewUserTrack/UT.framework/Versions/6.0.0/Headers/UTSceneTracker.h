//
//  UTSceneTracker.h
//  miniUTSDK
//
//  Created by ljianfeng on 2020/4/29.
//  Copyright © 2020 Taobao.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UTSceneTracker : NSObject
/**
 * @brief 一个场景的开始
 * @param scene  必传 场景名称 比如小程序为miniApp
 * @param properties  非必传 场景属性,场景的属性会挂在一个场景内的所有PV的args里 如@{@"miniAppId":@"1234"}
 * @param propertiesRule 非必传 自动获取场景开始后第一个pv事件args的字段,并映射成自定义字段,
 *                             作为场景的属性,如@{"spm-url":@"spm-ori"}
 */
+ (void)beginScene:(NSString *)scene
       properties:(NSDictionary *)properties
   propertiesRule:(NSDictionary *)propertiesRule;
/**
 * @brief 更新场景属性
 * @param scene 必传 场景名称 比如小程序为miniApp
 * @param properties  非必传 场景属性,场景的属性会挂在一个场景内的所有PV的args里
 */

+ (void)updateScene:(NSString *)scene
         properties:(NSDictionary *)properties;

/**
 * @brief 结束场景 必须在最后一个pv之后执行
 * @param scene  必传 场景名称 比如小程序为miniApp
 * @return  返回场景属性
 */
+ (NSDictionary *)endScene:(NSString *)scene;
@end

NS_ASSUME_NONNULL_END

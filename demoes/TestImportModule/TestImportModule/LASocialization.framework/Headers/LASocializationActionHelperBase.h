//
//  LASocializationActionHelperBase.h
//  LASocialization
//
//  Created by guobing.sgb on 2018/11/15.
//  Copyright © 2018年 lazada.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LASocializationActionHelperBase : NSObject

- (instancetype)initWithPageName:(NSString *)pageName;

- (void)actionWithModel:(id)model args:(NSDictionary *)args;

- (void)clickEventWithArg1:(NSString *)arg1 args:(NSDictionary *)args;

@end

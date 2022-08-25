//
//  LASocializationErrorProtocol.h
//  LASocialization
//
//  Created by guobing.sgb on 2018/9/18.
//  Copyright © 2018年 lazada.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LASocializationErrorProtocol <NSObject>

@property(nonatomic, copy, readonly) NSString *errorCode;
@property(nonatomic, copy, readonly) NSString *errorMessage;

@end

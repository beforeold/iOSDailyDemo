//
//  LASocializationLinkProtocol.h
//  LASocialization
//
//  Created by guobing.sgb on 2018/11/16.
//  Copyright © 2018年 lazada.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LASocializationLinkProtocol <NSObject>

@property(nonatomic, strong) NSString *link;

@optional

@property(nonatomic, strong) NSString *text;

@property(nonatomic, strong) NSString *spmCD;

@end

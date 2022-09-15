//
//  LASocializationTableViewDataProtocol.h
//  LASocialization
//
//  Created by guobing.sgb on 2018/9/18.
//  Copyright © 2018年 lazada.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LASocializationTableViewCellDataProtocol <NSObject>
@end

@protocol LASocializationTableViewSectionDataProtocol <NSObject>

@property(nonatomic, strong) NSString *sectionTitle;
@property(nonatomic, strong) NSArray<LASocializationTableViewCellDataProtocol> *list;

@end

@protocol LASocializationTableViewDataProtocol <NSObject>

@property(nonatomic, strong) NSArray<LASocializationTableViewSectionDataProtocol> *sections;

@end

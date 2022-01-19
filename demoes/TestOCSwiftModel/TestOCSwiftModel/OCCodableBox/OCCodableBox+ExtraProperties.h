//
//  OCCodableBox+ExtraProperties.h
//  TestOCSwiftModel
//
//  Created by 席萍萍Brook.dinglan on 2021/11/2.
//

#import "OCCodableBox.h"

NS_ASSUME_NONNULL_BEGIN

/// extenson to store extra properties
@interface OCCodableBox ()

@property (nonatomic, copy) NSDictionary *jsonDictionary;

@property (nonatomic, strong) NSMutableArray *modelContainer;

@end

NS_ASSUME_NONNULL_END

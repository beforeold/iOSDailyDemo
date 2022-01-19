//
//  Model.h
//  TestOCSwiftGenerics
//
//  Created by dinglan on 2021/5/20.
//

#import <Foundation/Foundation.h>
#import "BaseJsonModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseModel <__covariant JsonModelType: BaseJsonModel *> : NSObject

@property (nonatomic, strong) JsonModelType jsonModel;

@end

NS_ASSUME_NONNULL_END

//
//  SubModel.h
//  TestOCSwiftGenerics
//
//  Created by dinglan on 2021/5/20.
//

#import "BaseModel.h"
#import "SubJsonModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SubModel<JsonModelType: SubJsonModel *> : BaseModel<JsonModelType>

@end

NS_ASSUME_NONNULL_END

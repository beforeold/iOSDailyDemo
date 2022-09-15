//
//  OCCodableBox.h
//  TestOCSwiftModel
//
//  Created by 席萍萍Brook.dinglan on 2021/11/2.
//

#import <Foundation/Foundation.h>

#import "TBJSONModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 为避免 OC 访问 Swift 类型，CodableBox 由 OC 进行实现，再由 swift extension 向 swift 提供 API 进行 unbox
@interface OCCodableBox : TBJSONModel

@end

NS_ASSUME_NONNULL_END

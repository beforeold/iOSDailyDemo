//
//  OCRootModel.h
//  TestOCSwiftModel
//
//  Created by 席萍萍Brook.dinglan on 2021/10/19.
//

#import "TBJSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@class SwiftCodableBox;

@class OCCodableBox;

@interface OCRootModel : TBJSONModel

@property (nullable, nonatomic, strong) OCCodableBox *king;

@property (nullable, nonatomic, strong) SwiftCodableBox *person;


@end

NS_ASSUME_NONNULL_END

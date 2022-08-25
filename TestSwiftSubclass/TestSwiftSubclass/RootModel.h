//
//  RootModel.h
//  TestSwiftSubclass
//
//  Created by 席萍萍Brook.dinglan on 2021/11/9.
//

#import "TBJSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@class LAPerson;

@interface RootModel : TBJSONModel

@property (nullable, nonatomic, strong) LAPerson *person;

@end

NS_ASSUME_NONNULL_END

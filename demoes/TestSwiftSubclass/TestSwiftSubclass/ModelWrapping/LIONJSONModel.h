//
//  LIONJSONModel.h
//  TestSwiftSubclass
//
//  Created by 席萍萍Brook.dinglan on 2021/11/9.
//

#import "TBJSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LIONJSONModel : TBJSONModel


- (BOOL)lion_decodeData:(NSData *)data;

@end

NS_ASSUME_NONNULL_END

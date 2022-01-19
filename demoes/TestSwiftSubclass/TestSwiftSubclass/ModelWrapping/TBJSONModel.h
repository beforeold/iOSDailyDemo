//
//  BaseClass.h
//  TestSwiftSubclass
//
//  Created by 席萍萍Brook.dinglan on 2021/11/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface TBJSONModel : NSObject 

- (nullable instancetype)initWithJSONDictionary:(NSDictionary *)dict
                                          error:(NSError *__autoreleasing *_Nullable)error;

@end


NS_ASSUME_NONNULL_END

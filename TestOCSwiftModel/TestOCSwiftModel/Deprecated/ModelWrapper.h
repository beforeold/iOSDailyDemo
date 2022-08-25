//
//  ModelWrapper.h
//  TestOCSwiftModel
//
//  Created by 席萍萍Brook.dinglan on 2021/10/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ModelWrapper <Model> : NSObject

@property Model model;

+ (nullable id)modelWithJSONDictionary:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END

//
//  BaseClass.m
//  TestSwiftSubclass
//
//  Created by 席萍萍Brook.dinglan on 2021/11/9.
//

#import "TBJSONModel.h"

@interface TBJSONModel ()

@end

@implementation TBJSONModel

- (id)initWithJSONDictionary:(NSDictionary *)dict
                       error:(NSError *__autoreleasing  _Nullable *)error
{
    self = [super init];
    
    return self;
}

@end

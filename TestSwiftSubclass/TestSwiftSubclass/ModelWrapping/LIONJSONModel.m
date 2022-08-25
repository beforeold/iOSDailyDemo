//
//  LIONJSONModel.m
//  TestSwiftSubclass
//
//  Created by 席萍萍Brook.dinglan on 2021/11/9.
//

#import "LIONJSONModel.h"


@implementation LIONJSONModel

- (instancetype)initWithJSONDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing  _Nullable *)error {
    // override super
    if (!dict) {
        return nil;
    }
    
    __auto_type data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:error];
    if (!data) {
        return nil;
    }
    
    __auto_type ret = [self lion_decodeData:data];
    return ret ? self : nil;
}

- (BOOL)lion_decodeData:(NSData *)data {
    return NO;
}

@end


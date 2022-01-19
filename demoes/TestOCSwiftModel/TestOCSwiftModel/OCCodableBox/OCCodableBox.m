//
//  OCCodableBox.m
//  TestOCSwiftModel
//
//  Created by 席萍萍Brook.dinglan on 2021/11/2.
//

#import "OCCodableBox.h"
#import "OCCodableBox+ExtraProperties.h"

@implementation OCCodableBox

- (id)initWithJSONDictionary:(NSDictionary *)dict {
    self = [super initWithJSONDictionary:dict];
    if (self) {
        _modelContainer = [NSMutableArray arrayWithCapacity:1];
        _jsonDictionary = dict;
    }
    return self;
}

@end

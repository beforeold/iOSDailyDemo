//
//  RootModel.m
//  TestSwiftSubclass
//
//  Created by 席萍萍Brook.dinglan on 2021/11/9.
//

#import "RootModel.h"
#import "TestSwiftSubclass-Swift.h"

@implementation RootModel

- (instancetype)initWithJSONDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing  _Nullable *)error {
    self = [super initWithJSONDictionary:dict error:error];
    if (self) {
        _person = [[LAPerson alloc] initWithJSONDictionary:dict[@"person"]
                                                     error:nil];
    }
    return self;
}

@end

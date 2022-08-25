//
//  SomeManager.m
//  TestSwiftImplementOCProtocol
//
//  Created by 席萍萍Brook.dinglan on 2021/11/4.
//

#import "SomeManager.h"
#import "TestSwiftImplementOCProtocol-Swift.h"

@implementation SomeManager

+ (void)run {
//    Class clz = NSClassFromString(@"SomeController");
//    id swiftController = [clz alloc];
//    swiftController = [(id)swiftController performSelector:NSSelectorFromString(@"initWithName:")
//                                                withObject:@"brook"];

    SwiftController *swiftController = [[SwiftController alloc] initWithName:@""];
    [swiftController foo];
}

@end

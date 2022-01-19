//
//  Target_Brook.m
//  ServiceBridge
//
//  Created by 席萍萍Brook.dinglan on 2021/9/30.
//

#import "Target_Brook.h"

@implementation Target_Brook

- (NSDictionary *)action_fun:(NSDictionary *)param {
    NSLog(@"action_fun: %@", param);
    
    dispatch_block_t callback = param[@"callback"];
    
    return @{
        @"boxed" : NSNull.null,
    };
}

@end

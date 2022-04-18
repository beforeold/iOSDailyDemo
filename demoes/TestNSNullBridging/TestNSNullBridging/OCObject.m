//
//  OCObject.m
//  TestNSNullBridging
//
//  Created by BrookXy on 2022/4/18.
//

#import "OCObject.h"

@implementation OCObject

- (void)playWithArgs:(NSArray *)args {
    __auto_type temp = [NSMutableArray arrayWithCapacity:args.count];
    for (id ins in args) {
        id val = ins;
        if (nil == val) {
            val = NSNull.null;
        }
        [temp addObject:val];
    }
    
    [self subclass_playWithArgs:[temp copy]];
}

- (void)subclass_playWithArgs:(NSArray *)args {
    NSLog(@"args: %@", args);
}

@end

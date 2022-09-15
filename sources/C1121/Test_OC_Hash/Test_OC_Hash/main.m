//
//  main.m
//  Test_OC_Hash
//
//  Created by Brook on 2019/12/4.
//  Copyright © 2019 br. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject <NSCopying>

@end

@implementation Person

- (NSUInteger)hash {
    return 1;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

//- (BOOL)isEqual:(id)object {
//    return true;
//}

@end


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:2];
        
        Person *p = [Person new];
        Person *p2 = [Person new];
        dic[p] = @"Person1";
        dic[@1] = @1;
        
        
        NSLog(@"p->%@", dic[p]);
        NSLog(@"p2->%@", dic[p2]);
        NSLog(@"n->%@", dic[@1]);
        
        
        NSString *str;
        [str isEqual:@""];
        [str isEqualToString:@"abc"];
        
        
    }
    return 0;
}

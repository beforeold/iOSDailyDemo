//
//  NSString+Add.m
//  TestSwiftOCStringCateogry
//
//  Created by BrookXy on 2022/6/15.
//

#import "NSString+Add.h"

@implementation NSString (Add)

- (NSString *)add_foo {
    return [NSString stringWithFormat:@"add_%@", self];
}

- (void)barBarBar {
    NSLog(@"barBarBar");
}

@end

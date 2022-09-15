//
//  main.m
//  TestSubString
//
//  Created by BrookXy on 2022/4/20.
//

#import <Foundation/Foundation.h>

@implementation NSString (lll)

- (void)xtest {
    NSString* fragement = @"";
    NSString* stringWithoutFragment = self;
    if ([self rangeOfString:@"#"].location != NSNotFound) {
        NSRange fragmentRange = [self rangeOfString:@"#"];
        stringWithoutFragment = [self substringToIndex:fragmentRange.location];
        fragement = [self substringFromIndex:[self rangeOfString:@"#"].location];
    }
    
    NSLog(@"%@", stringWithoutFragment.class);
}

@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        

        [@"#ok" xtest];
    }
    return 0;
}

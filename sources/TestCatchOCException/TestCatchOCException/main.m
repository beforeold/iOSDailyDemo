//
//  main.m
//  TestCatchOCException
//
//  Created by 席萍萍Brook.dinglan on 2021/8/29.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSArray <NSNumber *> *array = @[@1, @2];
        
        id value = nil;
        
        @try {
            value = array[3];
        } @catch (NSException *exception) {
            NSLog(@"catched error: %@", exception);
        } @finally {
            NSLog(@"value: %@", value);
        }
        
        NSLog(@"done");
    }
    return 0;
}

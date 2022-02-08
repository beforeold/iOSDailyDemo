//
//  main.m
//  TestOCCopyMutable
//
//  Created by BrookXy on 2022/2/7.
//

#import <Foundation/Foundation.h>

@interface Wrapper : NSObject

@property (nonatomic, copy) NSMutableArray *array;

@end

@implementation Wrapper



@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        
        
        __auto_type wrapper = [[Wrapper alloc] init];
        __auto_type array = [[NSMutableArray alloc] init];
        wrapper.array = [array mutableCopy];
        NSLog(@"ret class, %@, %@", wrapper.array.class, wrapper.array);
    }
    return 0;
}

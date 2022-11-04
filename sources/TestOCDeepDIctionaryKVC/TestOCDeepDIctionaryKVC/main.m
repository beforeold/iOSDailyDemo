//
//  main.m
//  TestOCDeepDIctionaryKVC
//
//  Created by beforeold on 2022/11/4.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        __auto_type dict = @{
            @"key1" : @{
                @"key11" : @1,
            },
            @"key2" : @2,
        };
        
        // constant dictionary does not support KVC
        
        {
            [dict setValue:@2333 forKey:@"key2"];
            id value = [dict valueForKey:@"key2"];
            assert([value isEqual:@233]);
        }
        
        {
            [dict setValue:@666 forKeyPath:@"key1.key11"];
            id value = [dict valueForKeyPath:@"key1.key11"];
            assert([value isEqual:@666]);
        }
    }
    return 0;
}

//
//  main.m
//  TestDictSetValue
//
//  Created by 席萍萍Brook.dinglan on 2022/1/5.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:nil forKey:@"someKey"];
    }
    return 0;
}

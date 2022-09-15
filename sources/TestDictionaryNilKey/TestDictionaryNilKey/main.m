//
//  main.m
//  TestDictionaryNilKey
//
//  Created by dinglan on 2021/6/3.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        __auto_type value = [dic objectForKey:nil];
        __auto_type value2 = dic[nil];
        NSLog(@"ret: %@: value2: %@", value, value2);
    }
    return 0;
}

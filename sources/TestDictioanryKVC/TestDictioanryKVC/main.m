//
//  main.m
//  TestDictioanryKVC
//
//  Created by 席萍萍Brook.dinglan on 2021/9/28.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        NSDictionary *dict = @{@"abc" : @"value1"};
        [dict setValue:@"value2" forKey:@"abc"];
        NSLog(@"ret = %@", dict);
    }
    return 0;
}

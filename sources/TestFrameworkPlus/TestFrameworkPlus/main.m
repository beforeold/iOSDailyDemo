//
//  main.m
//  TestFrameworkPlus
//
//  Created by BrookXy on 2022/2/24.
//

#import <Foundation/Foundation.h>
#import <BFramework/BFramework-Swift.h>
#import <AFramework/AFramework-Swift.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        
        __auto_type ins = [[BSwiftClass alloc] init];
        NSLog(@"-- %@", ins);
    }
    return 0;
}

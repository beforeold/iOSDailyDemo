//
//  main.m
//  TestOCSwiftGenericSubclassing
//
//  Created by 席萍萍Brook.dinglan on 2021/12/16.
//

#import <Foundation/Foundation.h>
#import "TestOCSwiftGenericSubclassing-Swift.h"
#import "Person.h"

void test(NSString *className) {
    __auto_type studentClass = NSClassFromString(className);
    
    NSLog(@"class %@", studentClass);
    NSLog(@"%@ is sub class %d", className, [studentClass isSubclassOfClass:Person.class]);
    
    id ins = [[studentClass alloc] init];
    NSLog(@"ins name: %@", [ins getName]);
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        test(@"Student");
        test(@"Teacher");
    }
    return 0;
}

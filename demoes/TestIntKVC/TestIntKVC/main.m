//
//  main.m
//  TestIntKVC
//
//  Created by 席萍萍Brook.dinglan on 2021/10/12.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property (nonatomic, assign) int age;

@end

@implementation Person

@end


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        __auto_type p1 = [[Person alloc] init];
        [p1 setValue:@18 forKey:@"age"];
        NSLog(@"age: %d", p1.age);
    }
    return 0;
}

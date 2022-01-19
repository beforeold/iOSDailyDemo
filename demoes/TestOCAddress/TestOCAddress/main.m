//
//  main.m
//  TestOCAddress
//
//  Created by 席萍萍Brook.dinglan on 2021/9/2.
//

#import <Foundation/Foundation.h>

id copy(id obj) {
    NSLog(@"param: %p", &obj);
    return obj;
}


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        
        id obj1 = [[NSObject alloc] init];
        id obj2 = obj1;
        id obj3 = copy(obj1);
        NSLog(@"o1: %p", &obj1);
        NSLog(@"o2: %p", &obj2);
        NSLog(@"o3: %p", &obj3);
    }
    return 0;
}

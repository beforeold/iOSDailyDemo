//
//  main.m
//  TestOCEumForSwift
//
//  Created by 席萍萍Brook.dinglan on 2021/12/13.
//

#import <Foundation/Foundation.h>
#import "SomeProtocol.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        
        __auto_type init = LAUIViewControllerInit;
        __auto_type set = LAUIViewControllerInit | LAUIViewControllerViewDidLoad;
        NSLog(@"set = %zd", set);
        NSLog(@"ret = %zd", init & set);
    }
    return 0;
}

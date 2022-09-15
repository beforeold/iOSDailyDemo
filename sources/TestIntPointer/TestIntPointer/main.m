//
//  main.m
//  TestIntPointer
//
//  Created by BrookXy on 2022/1/12.
//

#import <Foundation/Foundation.h>

void print_log(int value) {
    NSLog(@"value is %d", value);
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        
        __auto_type range = NSMakeRange(666, 555);
        int *location = range.location;
        print_log(location);
    }
    return 0;
}

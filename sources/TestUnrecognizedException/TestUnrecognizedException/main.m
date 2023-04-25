//
//  main.m
//  TestUnrecognizedException
//
//  Created by Brook_Mobius on 4/25/23.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@end

@implementation Person

@end

int main(int argc, const char * argv[]) {
  @autoreleasepool {
      // insert code here...
      NSLog(@"Hello, World!");
    
    id person = [[Person alloc] init];
    
    [person performSelector:@selector(foo)];
    NSLog(@"end");
  }
  return 0;
}

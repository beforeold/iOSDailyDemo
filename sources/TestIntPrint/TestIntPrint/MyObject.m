#import "MyObject.h"

@implementation MyObject

- (void)test {
  NSNumber *num = @(-1);
  NSInteger intValue = num.integerValue;
  NSLog(@"num got value:%ld, num:%@", intValue, num);

  // num got value:18,446,744,073,709,551,615, num:-1

  int testint  = -7;
  NSLog(@"== got testint:%d", testint);
}

@end

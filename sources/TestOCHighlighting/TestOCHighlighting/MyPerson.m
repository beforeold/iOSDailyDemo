#import "MyPerson.h"

@implementation MyPerson

- (instancetype)init {
  self = [super init];
  if (self != nil) {
    _age = arc4random();
  }

  return self;
}


- (void)foo {
  [super foo];

  NSLog(@"person foo");
}

- (NSString *)description {
  return [NSString stringWithFormat:@"MyPerson: %ld, %@", _age, super.description];
}

@end

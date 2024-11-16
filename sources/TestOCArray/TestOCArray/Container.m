#import "Container.h"

@interface Container()

@end

@implementation Container

- (instancetype)initWithValue:(id)value {
  self = [super init];
  if (self != nil) {
    _value = value;
  }

  return self;
}

@end

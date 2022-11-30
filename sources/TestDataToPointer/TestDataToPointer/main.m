//
//  main.m
//  TestDataToPointer
//
//  Created by Brook_Mobius on 2022/11/30.
//

#import <Foundation/Foundation.h>

static const NSInteger kBytesLength = 8;

@interface PhashValue : NSObject

@property (nonatomic) int *pointer;

@end

@implementation PhashValue

- (instancetype)initWithPointer:(int *)pointer {
  self = [super init];
  if (self) {
    if (pointer != nil) {
      _pointer = pointer;
    }
  }
  
  return self;
}

- (instancetype)initWithData:(NSData *)data {
  self = [super init];
  if (self) {
    _pointer = (int *)malloc(kBytesLength * sizeof(int));
    
    // copy bytes
    __auto_type bytes = (int *)data.bytes;
    for (NSUInteger index = 0; index < data.length; index++) {
      _pointer[index] = bytes[index];
    }
  }
  
  return self;
}

- (void)dealloc {
  if (_pointer == nil) {
    return;
  }
  
  free(_pointer);
}

- (NSData *_Nullable)data {
  if (_pointer == nil) {
    return nil;
  }
  
  __auto_type data = [NSData dataWithBytes:_pointer length:kBytesLength];
  return data;
}

@end


void testList(void) {
  int list[8] = {1, 2, 3, 4, 5, 6, 7, 8};
  char *str = "12345678";
  
  __auto_type data = [NSData dataWithBytes:str length:8];
  
  __auto_type bytes = (int *)data.bytes;
  for (int i = 0; i < data.length; i++) {
    printf("value:%d\n", bytes[i]);
  }
}

void testNumber(void) {
  __auto_type number = @5;
  
  NSError *error = nil;
  __auto_type data = [NSJSONSerialization dataWithJSONObject:number options:0 error:&error];
  
  __auto_type bytes = (int *)data.bytes;
  for (int i = 0; i < data.length; i++) {
    printf("value:%d\n", bytes[i]);
  }
}

void testString(void) {
  __auto_type string = @"12345678";
  __auto_type data = [string dataUsingEncoding:NSUTF8StringEncoding];
  
  __auto_type bytes = (int *)data.bytes;
  for (int i = 0; i < data.length; i++) {
    printf("value:%d\n", bytes[i]);
  }
  
  __auto_type newData = [NSData dataWithBytes:bytes length:data.length];
  __auto_type newString = [[NSString alloc] initWithData:newData encoding:NSUTF8StringEncoding];
  NSLog(@"new string %@", newString);
}

void testList2(void) {
  int list[8] = {1, 2, 3, 4, 5, 6, 7, 8};
  
  for (int i = 0; i < 8; i++) {
    printf("value:%d\n", list[i]);
  }
}

void testList3(void) {
  int *list = (int *)malloc(8 * sizeof(int));
  
  for (int i = 0; i < 8; i++) {
    list[i] = i + 1;
  }

  for (int i = 0; i < 8; i++) {
    printf("value:%d\n", list[i]);
  }
}


int main(int argc, const char * argv[]) {
  @autoreleasepool {
    // insert code here...
    
    testList3();
    
  }
  return 0;
}

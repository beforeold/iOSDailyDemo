//
//  main.m
//  TestDataToPointer
//
//  Created by Brook_Mobius on 2022/11/30.
//

#import <Foundation/Foundation.h>

#define let __auto_type

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

void testList4(void) {
  let intCount = 8;
  let byteLength = intCount * sizeof(int);
  int *list = (int *)malloc(byteLength);
  
  for (int i = 0; i < 8; i++) {
    list[i] = i + 1;
  }

  let data = [NSData dataWithBytes:list length:byteLength];
  
  NSLog(@"sizeof int: %lu", sizeof(int));
  NSLog(@"sizeof uint8_t: %lu", sizeof(uint8_t));
  NSLog(@"sizeof Byte: %lu", sizeof(Byte));
  
  NSUInteger len = [data length];
  Byte *byteData = (Byte *)malloc(len);
  memcpy(byteData, [data bytes], len);
  
  for (int i = 0; i < data.length; i++) {
    printf("value: %d\n", byteData[i]);
  }
}


void testList5_ok(void) {
  let intCount = 8;
  let byteLength = intCount * sizeof(int);
  int *list = (int *)malloc(byteLength);
  
  for (int i = 0; i < 8; i++) {
    list[i] = i + 1;
  }

  let data = [NSData dataWithBytes:list length:byteLength];
  
  int *byteData = (int *)data.bytes;
  
  for (int i = 0; i < intCount; i++) {
    printf("value: %d\n", byteData[i]);
  }
}


void testPhash(void) {
  int *list = (int *)malloc(8 * sizeof(int));
  
  for (int i = 0; i < 8; i++) {
    list[i] = i + 1;
  }
  
  let data1 = [NSData dataWithBytes:list length:8];
  let phash1 = [[PhashValue alloc] initWithData:data1];
  let condition = [data1 isEqual:phash1.data];
  NSLog(@"ret %d", condition);
  
  let pointer = phash1.pointer;
  for (int i = 0; i < 8; i++) {
    NSLog(@"value: %d", pointer[i]);
  }
  
  {
    let phash2 = [[PhashValue alloc] initWithPointer:list];
    let pointer = phash2.pointer;
    for (int i = 0; i < 8; i++) {
      NSLog(@"value: %d", pointer[i]);
    }
  }
}

int main(int argc, const char * argv[]) {
  @autoreleasepool {
    // insert code here...
    
    testList5_ok();
    
  }
  return 0;
}

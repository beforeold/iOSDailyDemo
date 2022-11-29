//
//  ViewController.m
//  TestDataToPointer
//
//  Created by Brook_Mobius on 2022/11/24.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  
  NSData *data = [@"123" dataUsingEncoding:NSUTF8StringEncoding];
  int *pointer = (int *)data.bytes;
  dispatch_async(dispatch_get_main_queue(), ^{
    printf("pointer: %p\n", pointer);
    printf("pointer 0: %d\n", pointer[0]);
    printf("pointer 1: %d\n", pointer[1]);
    printf("pointer 2: %d\n", pointer[2]);
    
  });
}


@end

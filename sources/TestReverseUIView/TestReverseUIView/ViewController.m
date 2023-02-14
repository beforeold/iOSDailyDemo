//
//  ViewController.m
//  TestReverseUIView
//
//  Created by Brook_Mobius on 2023/2/8.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  
  UIView *firstView = nil;
  UIView *lastView = nil;
  for (NSInteger i = 0; i < 10; i++) {
    __auto_type label = [[UILabel alloc] init];
    label.text = [NSString stringWithFormat:@"%ld", (long)i];
    [label addSubview:lastView];
    
    lastView = label;
    if (firstView == nil) {
      firstView = label;
    }
  }
  
  UIView *temp = [self reverseView:firstView];
  while (temp != nil) {
    if ([temp isKindOfClass:UILabel.class]) {
      UILabel *label = (UILabel *)temp;
      NSLog(@"label.text: %@", label.text);
    }
    temp = temp.superview;
  }
  
}

// 题目：已知一个 UIView，要求调换与其父视图的父子关系，包括父视图的父视图
// 举例：
// 原始父视图关系：viewA -> viewB -> viewC
// 结果父视图关系： viewC -> viewB -> viewA
//
// - (UIView *)reverseView:(UIView *)uiview {
//   return uiview;
// }

- (UIView *)reverseView:(UIView *)view {
    UIView *cur = view;
    // 保存
  UIView *superView;
  NSMutableArray<UIView *> *array = [NSMutableArray array];
  while (cur) {
    [array addObject:cur];
    if (cur.superview) {
      superView = view.superview;
      [cur removeFromSuperview];
      cur = superView;
    } else {
      cur = nil;
    }
  }
  
  cur = view;
  for (int i = 1; i < array.count; i++) {
    UIView *item = array[i];
    [cur addSubview:item];
    cur = item;
  }
  return view;
}

@end

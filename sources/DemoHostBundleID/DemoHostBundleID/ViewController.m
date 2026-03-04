//
//  ViewController.m
//  DemoHostBundleID
//
//  Created by beforeold on 3/4/26.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.

  __auto_type theID = [self performSelector: NSSelectorFromString(@"hostAppBundleIdentifier")];
  NSLog(@"rseult: %@", theID);
}


@end

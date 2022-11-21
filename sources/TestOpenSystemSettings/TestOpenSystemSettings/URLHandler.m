//
//  URLHandler.m
//  TestOpenSystemSettings
//
//  Created by beforeold on 2022/11/21.
//

#import "URLHandler.h"

@interface LSApplicationWorkspaceHook : NSObject

+ (instancetype)defaultWorkspace;
- (void)openURL:(NSURL *)url options:(id)options completionHandler:(id)handler;
- (void)openURL:(NSURL *)url;

@end

void openURL(NSURL *url) {
  // 调用 LSApplicationWorkspace 的单例方法
  Class aClass = NSClassFromString(@"LSApplicationWorkspace");
  LSApplicationWorkspaceHook *hook = [aClass defaultWorkspace];
  // 调用 LSApplicationWorkspace 的 `openURL:` 方法
  // [hook openURL:url options:nil completionHandler:nil];
  [hook openURL:url];
}


void openWeChat(void) {
  //__auto_type url = [NSURL URLWithString:@"app-prefs:com.tencent.xin"];
  
  // __auto_type url = [NSURL URLWithString:@"prefs:root=General&path=STORAGE_MGMT"];
  __auto_type url = [NSURL URLWithString:@"prefs:root=General&path=STORAGE_MGMT#MANAGE"];
  openURL(url);
}


@implementation URLHandler

+ (void)openURL:(NSURL *)URL {
  openWeChat();
  //  openURL(URL);
}

@end

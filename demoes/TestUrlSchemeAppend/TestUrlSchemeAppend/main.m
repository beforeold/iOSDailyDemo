//
//  main.m
//  TestUrlSchemeAppend
//
//  Created by BrookXy on 2022/2/15.
//

#import <Foundation/Foundation.h>

void func(NSURL *url) {
    NSString *scheme = url.scheme;
    if (scheme.length == 0) {
        scheme = @"http";
        NSRange range = [url.absoluteString rangeOfString:url.host];
        if (range.location != NSNotFound) {
            NSString *path = [url.absoluteString substringFromIndex:range.location + range.length];
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@%@", scheme, url.host, path]];
        }
    }
    NSLog(@"result: %@", url);
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        // https://tse1-mm.cn.bing.net/th/id/OIP-C.6IxzqN2fHRw8vnVLcFs0dwHaFj?pid=ImgDet&rs=1
        NSURL *url = [NSURL URLWithString:@"//tse1-mm.cn.bing.net/th/id/OIP-C.6IxzqN2fHRw8vnVLcFs0dwHaFj?pid=ImgDet&rs=1"];
        func(url);
    }
    return 0;
}

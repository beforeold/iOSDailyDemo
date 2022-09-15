//
//  main.m
//  TestCEnumValueOverflow
//
//  Created by BrookXy on 2022/2/22.
//



#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, MYPreHotFunnelType) {
    MYPreHotFunnelTypeHitPreHotManager,
    MYPreHotFunnelTypeCheckPreHotSwitch,
    MYPreHotFunnelTypeCheckHandleIsExist,
    MYPreHotFunnelTypeCheckDataIsExist,
    MYPreHotFunnelTypeCheckWebViewIsValid,
    MYPreHotFunnelTypeCheckWebViewEnableShow,
};

static NSString *getStringWithFunnelType(MYPreHotFunnelType type) {
    switch (type) {
        case MYPreHotFunnelTypeHitPreHotManager:
            return @"S1:HitPreHotManager";
        case MYPreHotFunnelTypeCheckPreHotSwitch:
            return @"S2:CheckPreHotSwitch";
        case MYPreHotFunnelTypeCheckHandleIsExist:
            return @"S3:checkHandleIsExist";
        case MYPreHotFunnelTypeCheckDataIsExist:
            return @"S4:checkDataIsExist";
        case MYPreHotFunnelTypeCheckWebViewIsValid:
            return @"S5:checkWebViewIsValid";
        case MYPreHotFunnelTypeCheckWebViewEnableShow:
            return @"S6:checkWebViewEnableShow";
//        default:
//            return @"unknown";
    }
}


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...

        __auto_type ret = getStringWithFunnelType(666);
        NSLog(@"ret: %@", ret);
    }
    return 0;
}

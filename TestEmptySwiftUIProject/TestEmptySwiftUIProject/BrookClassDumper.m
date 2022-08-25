//
//  BrookClassDumper.m
//  iosApp
//
//  Created by dinglan on 2021/1/21.
//  Copyright © 2021 orgName. All rights reserved.
//

#import "BrookClassDumper.h"
#import <objc/runtime.h>

@implementation BrookClassDumper


/**
 *  查找工程内的所有相关ViewController，浙江
 *  find all viewcontrollers, this will block the main thread
 *
 *  @return 控制器名字数组
 */
+ (NSArray <NSString *> *)findViewControllerClassNames {
    Class *classes = NULL;
    int numClasses = objc_getClassList(NULL, 0);
    NSLog(@"numClasses: %d", numClasses);
    if (numClasses <= 0) return @[];
    
    NSMutableArray <NSString *> *unSortedArray = [NSMutableArray array];
    classes = (__unsafe_unretained Class *)malloc(sizeof(Class) * numClasses);
    numClasses = objc_getClassList(classes, numClasses);
    for (int i = 0; i < numClasses; i++) {
        Class theClass = classes[i];
        if (theClass == self.class) continue;
        
        NSString *className = [NSString stringWithUTF8String:class_getName(theClass)];
        
        if ([className hasPrefix:@"Kt"]
            || [className hasPrefix:@"Shared"]
            || [className hasPrefix:@"Kotlin"]
            // || [className containsString:@"Block"]
            || [className containsString:@"kotlin"]
            ) {
            [unSortedArray addObject:className];
        }
        
    }
    free(classes);
    
    NSArray <NSString *> *sortedArray = [unSortedArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSForcedOrderingSearch];
    }];
    
    return sortedArray;
}

@end

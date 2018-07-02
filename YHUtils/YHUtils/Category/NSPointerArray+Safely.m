//
//  NSPointerArray+Safely.m
//  WMAdSDK
//
//  Created by siwant on 2018/6/21.
//  Copyright © 2018年 bytedance. All rights reserved.
//

#import "NSPointerArray+Safely.h"

@implementation NSPointerArray (Safely)
- (id)safelyAccessObjectAtIndex:(NSUInteger)index {
    
    id resultObject = nil;
    if (index >= self.count) {
        
    } else {
        resultObject = [self pointerAtIndex:index];
    }
    
    return resultObject;
}
@end


//
//  NSPointerArray+Safely.h
//  WMAdSDK
//
//  Created by siwant on 2018/6/21.
//  Copyright © 2018年 bytedance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSPointerArray (Safely)
- (id)safelyAccessObjectAtIndex:(NSUInteger)index;
@end

//
//  NSPointerArray+Safely.h
//  YHAdSDK
//
//  Created by siwant on 2018/6/21.
//  Copyright © 2018年 siwant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSPointerArray (Safely)
- (id)safelyAccessObjectAtIndex:(NSUInteger)index;
@end

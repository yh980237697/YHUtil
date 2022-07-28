//
//  UIViewController+Swizzle.m
//  ViewControllerTransision
//
//  Created by siwant on 2018/4/27.
//  Copyright © 2018年 siwant. All rights reserved.
//

#import "UIViewController+Swizzle.h"
#import "YHRuntimeUtil.h"
#import "YHViewHierarchyManager.h"

@implementation UIViewController (Swizzle)

+ (void)yh_swizzlingMethod_viewHierarchy {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [YHRuntimeUtil exchangeInstanceSEL:@selector(viewDidAppear:)
                         targetInstanceSEL:@selector(swizzleViewDidAppear:)
                                    aClass:self];
        
        [YHRuntimeUtil exchangeInstanceSEL:@selector(viewDidDisappear:)
                         targetInstanceSEL:@selector(swizzleViewDidDisappear:)
                                    aClass:self];
    });
}

- (void)swizzleViewDidAppear:(BOOL)animated {
    [YHViewHierarchyManager checkInViewController:self];
    return [self swizzleViewDidAppear:animated];
}

- (void)swizzleViewDidDisappear:(BOOL)animated {
    [YHViewHierarchyManager checkOutViewController:self];
    return [self swizzleViewDidDisappear:animated];
}
@end

//
//  UIViewController+Swizzle.m
//  ViewControllerTransision
//
//  Created by siwant on 2018/4/27.
//  Copyright © 2018年 bytedance. All rights reserved.
//

#import "UIViewController+Swizzle.h"
#import "WMRuntimeUtil.h"
#import "WMViewHierarchyManager.h"

@implementation UIViewController (Swizzle)

+ (void)wm_swizzlingMethod_viewHierarchy {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [WMRuntimeUtil exchangeInstanceSEL:@selector(viewDidAppear:)
                         targetInstanceSEL:@selector(swizzleViewDidAppear:)
                                    aClass:self];
        
        [WMRuntimeUtil exchangeInstanceSEL:@selector(viewDidDisappear:)
                         targetInstanceSEL:@selector(swizzleViewDidDisappear:)
                                    aClass:self];
    });
}

- (void)swizzleViewDidAppear:(BOOL)animated {
    [WMViewHierarchyManager checkInViewController:self];
    return [self swizzleViewDidAppear:animated];
}

- (void)swizzleViewDidDisappear:(BOOL)animated {
    [WMViewHierarchyManager checkOutViewController:self];
    return [self swizzleViewDidDisappear:animated];
}
@end

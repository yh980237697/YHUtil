//
//  UIViewController+Swizzle.h
//  ViewControllerTransision
//
//  Created by siwant on 2018/4/27.
//  Copyright © 2018年 bytedance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Swizzle)
+ (void)wm_swizzlingMethod_viewHierarchy;
@end

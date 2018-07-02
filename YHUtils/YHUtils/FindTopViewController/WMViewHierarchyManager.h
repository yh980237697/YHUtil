//
//  ViewHierarchyManager.h
//  ViewControllerTransision
//
//  Created by siwant on 2018/4/27.
//  Copyright © 2018年 bytedance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WMViewHierarchyManager : NSObject

+ (void)checkInViewController:(UIViewController *)viewController;
+ (void)checkOutViewController:(UIViewController *)viewController;
+ (void)clearViewControllers;
+ (UIViewController *)findTopViewController;
@end

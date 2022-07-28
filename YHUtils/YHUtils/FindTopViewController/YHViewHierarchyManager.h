//
//  ViewHierarchyManager.h
//  ViewControllerTransision
//
//  Created by siwant on 2018/4/27.
//  Copyright © 2018年 siwant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YHViewHierarchyManager : NSObject

+ (void)checkInViewController:(UIViewController *)viewController;
+ (void)checkOutViewController:(UIViewController *)viewController;
+ (void)clearViewControllers;
+ (UIViewController *)findTopViewController;
@end

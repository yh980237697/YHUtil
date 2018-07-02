//
//  ViewHierarchyManager.m
//  ViewControllerTransision
//
//  Created by siwant on 2018/4/27.
//  Copyright © 2018年 bytedance. All rights reserved.
//

#import "WMViewHierarchyManager.h"
#import "NSPointerArray+Safely.h"

@interface WMViewHierarchyManager()
@property (nonatomic, strong) NSPointerArray *checkInViewControllers;
@end

@implementation WMViewHierarchyManager

+ (WMViewHierarchyManager *)sharedViewHierachyManager {
    
    static WMViewHierarchyManager * viewHierarchyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        viewHierarchyManager = [[WMViewHierarchyManager alloc] init];
    });
    return viewHierarchyManager;
}

- (instancetype)init {
    if (self = [super init]) {
        _checkInViewControllers = [NSPointerArray pointerArrayWithOptions:NSPointerFunctionsWeakMemory];
    }
    return self;
}


+ (void)checkInViewController:(UIViewController *)viewController {
    [[WMViewHierarchyManager sharedViewHierachyManager].checkInViewControllers addPointer:(__bridge void * _Nullable)(viewController)];

}

+ (void)checkOutViewController:(UIViewController *)viewController {
    NSPointerArray *viewControllers = [WMViewHierarchyManager sharedViewHierachyManager].checkInViewControllers;

    for (NSInteger i = 0; i < viewControllers.count; i++) {
        if ([viewControllers pointerAtIndex:i] == (__bridge void * _Nullable)(viewController)) {
            [viewControllers removePointerAtIndex:i];
        }
    }
}

+ (void)clearViewControllers {
    [[WMViewHierarchyManager sharedViewHierachyManager].checkInViewControllers compact];
}

+ (UIViewController *)findTopViewController {
    NSPointerArray *viewControllers = [self sharedViewHierachyManager].checkInViewControllers;
    
    return [viewControllers safelyAccessObjectAtIndex:viewControllers.count - 1];
}
@end

//
//  ViewHierarchyManager.m
//  ViewControllerTransision
//
//  Created by siwant on 2018/4/27.
//  Copyright © 2018年 siwant. All rights reserved.
//

#import "YHViewHierarchyManager.h"
#import "NSPointerArray+Safely.h"

@interface YHViewHierarchyManager()
@property (nonatomic, strong) NSPointerArray *checkInViewControllers;
@end

@implementation YHViewHierarchyManager

+ (YHViewHierarchyManager *)sharedViewHierachyManager {
    
    static YHViewHierarchyManager * viewHierarchyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        viewHierarchyManager = [[YHViewHierarchyManager alloc] init];
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
    [[YHViewHierarchyManager sharedViewHierachyManager].checkInViewControllers addPointer:(__bridge void * _Nullable)(viewController)];

}

+ (void)checkOutViewController:(UIViewController *)viewController {
    NSPointerArray *viewControllers = [YHViewHierarchyManager sharedViewHierachyManager].checkInViewControllers;

    for (NSInteger i = 0; i < viewControllers.count; i++) {
        if ([viewControllers pointerAtIndex:i] == (__bridge void * _Nullable)(viewController)) {
            [viewControllers removePointerAtIndex:i];
        }
    }
}

+ (void)clearViewControllers {
    [[YHViewHierarchyManager sharedViewHierachyManager].checkInViewControllers compact];
}

+ (UIViewController *)findTopViewController {
    NSPointerArray *viewControllers = [self sharedViewHierachyManager].checkInViewControllers;
    
    return [viewControllers safelyAccessObjectAtIndex:viewControllers.count - 1];
}
@end

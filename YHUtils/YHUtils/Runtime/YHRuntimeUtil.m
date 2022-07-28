//
//  YHRuntimeUtil.m
//  YHAdSDK
//
//  Created by siwant on 2018/2/28.
//  Copyright © 2018年 siwant. All rights reserved.
//

#import "YHRuntimeUtil.h"
#import <objc/runtime.h>

@implementation YHRuntimeUtil

+ (void)exchangeSEL:(SEL)originSEL
        originClass:(Class)originClass
          targetSEL:(SEL)targetSEL
        targetClass:(Class)targetClass
      isClassMethod:(BOOL)isClassMethod{
    if(!originSEL || !originClass || !targetSEL || !targetClass) {
        return;
    }
    if(![targetClass instancesRespondToSelector:targetSEL]) {
        return;
    }
    Method targetMethod;
    Method originMethod;
    if(isClassMethod) {
        originMethod = class_getClassMethod(originClass, originSEL);
        targetMethod = class_getClassMethod(targetClass, targetSEL);
    }
    else {
        originMethod = class_getInstanceMethod(originClass, originSEL);
        targetMethod = class_getInstanceMethod(targetClass, targetSEL);
    }
    
    IMP targetImp = class_getMethodImplementation(targetClass, targetSEL);
    IMP originImp = class_getMethodImplementation(originClass, originSEL);
    
    if(isClassMethod) {
        originClass = objc_getMetaClass(NSStringFromClass(originClass).UTF8String);
    }
    BOOL success = class_addMethod(originClass, originSEL, targetImp, method_getTypeEncoding(originMethod));
    if(success) {
        class_replaceMethod(targetClass,
                            targetSEL,
                            originImp,
                            method_getTypeEncoding(targetMethod));
    }
    else {
        method_exchangeImplementations(originMethod, targetMethod);
    }
}

+ (void)exchangeClassSEL:(SEL)originClassSEL
             originClass:(Class)originClass
          targetClassSEL:(SEL)targetClassSEL
             targetClass:(Class)targetClass {
    [self exchangeSEL:originClassSEL
          originClass:originClass
            targetSEL:targetClassSEL
          targetClass:targetClass
        isClassMethod:YES];
}

+ (void)exchangeInstanceSEL:(SEL)originInstanceSEL
                originClass:(Class)originClass
          targetInstanceSEL:(SEL)targetInstanceSEL
                targetClass:(Class)targetClass {
    [self exchangeSEL:originInstanceSEL
          originClass:originClass
            targetSEL:targetInstanceSEL
          targetClass:targetClass
        isClassMethod:NO];
}

+ (void)exchangeSEL:(SEL)originSEL
          targetSEL:(SEL)targetSEL
             aClass:(Class)aClass
      isClassMethod:(BOOL)isClassMethod {
    [self exchangeSEL:originSEL
          originClass:aClass
            targetSEL:targetSEL
          targetClass:aClass
        isClassMethod:isClassMethod];
}

+ (void)exchangeClassSEL:(SEL)originClassSEL
          targetClassSEL:(SEL)targetClassSEL
                  aClass:(Class)aClass {
    [self exchangeSEL:originClassSEL
            targetSEL:targetClassSEL
               aClass:aClass
        isClassMethod:YES];
}

+ (void)exchangeInstanceSEL:(SEL)originInstanceSEL
          targetInstanceSEL:(SEL)targetInstanceSEL
                     aClass:(Class)aClass {
    [self exchangeSEL:originInstanceSEL
            targetSEL:targetInstanceSEL
               aClass:aClass
        isClassMethod:NO];
}

@end



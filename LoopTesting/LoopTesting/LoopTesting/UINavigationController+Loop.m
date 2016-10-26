//
//  UINavigationController+Loop.m
//  LoopTesting
//
//  Created by allthings_LuYD on 2016/10/26.
//  Copyright © 2016年 scrum_snail. All rights reserved.
//

#import "UINavigationController+Loop.h"
#import <objc/runtime.h>
#import "Loop.h"
#import "NSObject+Loop.h"

@implementation UINavigationController (Loop)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self ul_exchangeSEL:@selector(popViewControllerAnimated:) swizzledSEL:@selector(ul_popViewControllerAnimated:)];
        [self ul_exchangeSEL:@selector(popToViewController:animated:) swizzledSEL:@selector(ul_popToViewController:animated:)];
        [self ul_exchangeSEL:@selector(popToRootViewControllerAnimated:) swizzledSEL:@selector(ul_popToRootViewControllerAnimated:)];
    });
}

+ (void)ul_exchangeSEL:(SEL)originalSEL swizzledSEL:(SEL)swizzledSEL {
    Method original_method = class_getInstanceMethod(self, originalSEL);
    Method swizzled_method = class_getInstanceMethod(self, swizzledSEL);

    BOOL isAdd =
    class_addMethod(self, originalSEL, method_getImplementation(swizzled_method), method_getTypeEncoding(swizzled_method));

    if (isAdd) {
        class_replaceMethod(self, swizzledSEL, method_getImplementation(original_method), method_getTypeEncoding(original_method));
    } else {
        method_exchangeImplementations(original_method, swizzled_method);
    }
}

- (UIViewController *)ul_popViewControllerAnimated:(BOOL)animated {
    UIViewController * currentViewController = self.viewControllers.lastObject;
    UIViewController * toViewController = [self ul_popViewControllerAnimated:animated];
    [self uL_uncoverLoop:currentViewController];
    return toViewController;
}

- (NSArray <UIViewController *> *)ul_popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSInteger startIndex = [self.viewControllers indexOfObject:viewController];
    NSArray * currentViewControllers = [self.viewControllers subarrayWithRange:NSMakeRange(startIndex + 1, (self.viewControllers.count - 1) - startIndex)];
    NSArray * viewControllers = [self ul_popToViewController:viewController animated:animated];
    for (UIViewController * viewController in currentViewControllers) {
        [self uL_uncoverLoop:viewController];
    }
    return viewControllers;
}

- (NSArray <UIViewController *> *)ul_popToRootViewControllerAnimated:(BOOL)animated {
    NSArray * currentViewControllers = [self.viewControllers subarrayWithRange:NSMakeRange(1, self.viewControllers.count - 1)];
    NSArray * viewControllers = [self ul_popToRootViewControllerAnimated:animated];
    for (UIViewController * viewController in currentViewControllers) {
        [self uL_uncoverLoop:viewController];
    }
    return viewControllers;
}

- (void)uL_uncoverLoop:(UIViewController *)viewController {
    __weak UIViewController * weakVC = viewController;
    NSString * name = NSStringFromClass(weakVC.class);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self ul_assert:weakVC name:name];
    });
}


- (void)ul_assert:(UIViewController *)vc name:(NSString *)name{
    if (vc) {
        NSMutableDictionary *loopPrivately = [NSMutableDictionary dictionary];
        if ([vc.class respondsToSelector:@selector(ul_loopPrivatelyKeys)]) {
            NSArray <NSString *> * loopPrivatelyKeys = [(id<Loop>)(vc.class) ul_loopPrivatelyKeys];
            [loopPrivatelyKeys enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                id value = [vc valueForKey:obj];
                if (value) {
                    [loopPrivately setObject:value forKey:obj];
                }
            }];
        }
        NSLog(@"[UNCOVER LOOP]: %@ 异常!!!\n 未释放成员变量: %@;\n 未释放私有变量: %@", name, [vc ul_loopValues], loopPrivately);
    }else{
        NSLog(@"[UNCOVER LOOP]: %@ 正常释放", name);
    }
}
@end

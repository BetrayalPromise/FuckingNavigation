//
//  UINavigationController+FuckingNavigation.m
//  FuckingNavigation
//
//   Created by BetrayalPromise@gmail.com on 05/15/2018.
//  Copyright (c) 2018 BetrayalPromise@gmail.com. All rights reserved.
//

#import "UINavigationController+FuckingNavigation.h"
#import <objc/runtime.h>

@interface UINavigationController () <UINavigationBarDelegate>

@end

@implementation UINavigationController (FuckingNavigation)

+ (void)load {
    if (self == [UINavigationController self]) {
        NSArray *arr = @[ @"_updateInteractiveTransition:", @"popToViewController:animated:", @"popToRootViewControllerAnimated:" ];
        for (NSString *str in arr) {
            NSString *new_str = [[@"exchange_" stringByAppendingString:str] stringByReplacingOccurrencesOfString:@"__" withString:@"_"];
            Method A = class_getInstanceMethod(self, NSSelectorFromString(str));
            Method B = class_getInstanceMethod(self, NSSelectorFromString(new_str));
            method_exchangeImplementations(A, B);
        }
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.topViewController.preferredStatusBarStyle) {
        return self.topViewController.preferredStatusBarStyle;
    }
    return UIStatusBarStyleDefault;
}

- (void)exchange_updateInteractiveTransition:(CGFloat)percentComplete {
    UIViewController *topVC = self.topViewController;
    if (topVC) {
        id<UIViewControllerTransitionCoordinator> transitionContext = topVC.transitionCoordinator;
        UIViewController *fromVc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIViewController *toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        CGFloat fromAlpha = fromVc.navigationAlpha;
        CGFloat toAlpha = toVc.navigationAlpha;
        CGFloat newAlpha = fromAlpha + (toAlpha - fromAlpha) * percentComplete;
        [self setNeedsNavigationBackgroundAlpha:newAlpha];

        UIColor *fromColor = fromVc.navigationTintColor;
        UIColor *toColor = toVc.navigationTintColor;
        UIColor *newColor = [self averageColorFromColor:fromColor toColor:toColor percent:percentComplete];
        self.navigationBar.tintColor = newColor;

        UIColor *fromLineColor = fromVc.navigationHairlineColor;
        UIColor *toLineColor = toVc.navigationHairlineColor;
        UIColor *newLineColor = [self averageColorFromColor:fromLineColor toColor:toLineColor percent:percentComplete];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        [(UIView *) [self.navigationBar performSelector:@selector(getCustomBottomLineView) withObject:nil] setBackgroundColor:newLineColor];
#pragma clang diagnostic pop
    }
    [self exchange_updateInteractiveTransition:percentComplete];
}

- (NSArray<UIViewController *> *)exchange_popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self setNeedsNavigationBackgroundAlpha:viewController.navigationAlpha];
    self.navigationBar.tintColor = viewController.navigationTintColor;
    return [self exchange_popToViewController:viewController animated:animated];
}

- (NSArray<UIViewController *> *)exchange_popToRootViewControllerAnimated:(BOOL)animated {
    [self setNeedsNavigationBackgroundAlpha:self.viewControllers[0].navigationAlpha];
    self.navigationBar.tintColor = self.viewControllers[0].navigationTintColor;
    return [self exchange_popToRootViewControllerAnimated:animated];
}

#pragma mark 代理
- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    UIViewController *topVc = self.topViewController;
    id<UIViewControllerTransitionCoordinator> coor = topVc.transitionCoordinator;
    if (topVc && coor && coor.initiallyInteractive) {
        if (@available(iOS 10.0, *)) {
            [coor notifyWhenInteractionChangesUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext> _Nonnull context) { [self dealInteractionChanges:context]; }];
        } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            [coor notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext> _Nonnull context) { [self dealInteractionChanges:context]; }];
#pragma clang diagnostic pop
        }
        return YES;
    }

    int n = self.viewControllers.count >= navigationBar.items.count ? 2 : 1;
    UIViewController *popToVc = self.viewControllers[self.viewControllers.count - n];
    [self popToViewController:popToVc animated:YES];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    UIView *v = [self.navigationBar performSelector:@selector(getCustomBottomLineView)];
#pragma clang diagnostic pop
    [UIView animateWithDuration:0.3 delay:0.0 options:(UIViewAnimationOptionCurveLinear) animations:^{ v.backgroundColor = popToVc.navigationHairlineColor; } completion:nil];
    return YES;
}

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPushItem:(UINavigationItem *)item {
    return YES;
    //#pragma clang diagnostic push
    //#pragma clang diagnostic ignored "-Wundeclared-selector"
    //    UIView * v = [self.navigationBar performSelector:@selector(getCustomBottomLineView)];
    //#pragma clang diagnostic pop
    //   [UIView animateWithDuration:0.3 delay:0.0 options:(UIViewAnimationOptionCurveLinear) animations:^{
    //        [self setNeedsNavigationBackgroundAlpha:self.topViewController.navigationAlpha];
    //        self.navigationBar.tintColor = self.topViewController.navigationTintColor;
    //        v.backgroundColor = self.topViewController.navigationHairlineColor;
    //    }];
    //    return YES;

    //    UIViewController *topVc = self.topViewController;
    //    id<UIViewControllerTransitionCoordinator> coor = topVc.transitionCoordinator;
    //    if (topVc && coor) {
    //        if (@available(iOS 10.0, *)) {
    //            [coor notifyWhenInteractionChangesUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
    //                [self dealInteractionChanges:context];
    //            }];
    //        } else{
    //#pragma clang diagnostic push
    //#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    //            [coor notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
    //                [self dealInteractionChanges:context];
    //            }];
    //#pragma clang diagnostic pop
    //        }
    //    }
    //    return  YES;
}

- (void)dealInteractionChanges:(id<UIViewControllerTransitionCoordinatorContext>)context {
    void (^animations)(NSString *key) = ^(NSString *key) {
        CGFloat nowAlpha = [context viewControllerForKey:key].navigationAlpha;
        [self setNeedsNavigationBackgroundAlpha:nowAlpha];
        self.navigationBar.tintColor = [context viewControllerForKey:key].navigationTintColor;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        UIView *v = [self.navigationBar performSelector:@selector(getCustomBottomLineView)];
#pragma clang diagnostic pop
        [UIView animateWithDuration:0.3 delay:0.0 options:(UIViewAnimationOptionCurveLinear) animations:^{ v.backgroundColor = [context viewControllerForKey:key].navigationHairlineColor; } completion:nil];
    };

    if (context.isCancelled) {
        NSTimeInterval cancaleDuration = context.transitionDuration * context.percentComplete;
        [UIView animateWithDuration:cancaleDuration animations:^{ animations(UITransitionContextFromViewControllerKey); }];
    } else {
        NSTimeInterval finishDuration = context.transitionDuration * (1 - context.percentComplete);
        [UIView animateWithDuration:finishDuration animations:^{ animations(UITransitionContextToViewControllerKey); }];
    }
}

- (UIColor *)averageColorFromColor:(UIColor *)fromColor toColor:(UIColor *)toColor percent:(CGFloat)percent {
    CGFloat fromRed = 0;
    CGFloat fromGreen = 0;
    CGFloat fromBlue = 0;
    CGFloat fromAlpha = 0;
    [fromColor getRed:&fromRed green:&fromGreen blue:&fromBlue alpha:&fromAlpha];

    CGFloat toRed = 0;
    CGFloat toGreen = 0;
    CGFloat toBlue = 0;
    CGFloat toAlpha = 0;
    [toColor getRed:&toRed green:&toGreen blue:&toBlue alpha:&toAlpha];

    CGFloat nowRed = fromRed + (toRed - fromRed) * percent;
    CGFloat nowGreen = fromGreen + (toGreen - fromGreen) * percent;
    CGFloat nowBlue = fromBlue + (toBlue - fromBlue) * percent;
    CGFloat nowAlpha = fromAlpha + (toAlpha - fromAlpha) * percent;

    return [UIColor colorWithRed:nowRed green:nowGreen blue:nowBlue alpha:nowAlpha];
}

- (void)setNeedsNavigationBackgroundAlpha:(CGFloat)alpha {
    //导航栏透明层
    UIView *barBackgroundView = [[self.navigationBar subviews] objectAtIndex:0];
    UIView *shadowView = [barBackgroundView valueForKey:@"_shadowView"];
    if (shadowView) {
        [UIView animateWithDuration:0.3 delay:0.0 options:(UIViewAnimationOptionCurveLinear) animations:^{ shadowView.alpha = alpha; } completion:nil];
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    UIView *v = [self.navigationBar performSelector:@selector(getCustomBottomLineView)];
#pragma clang diagnostic pop
    if (v) {
        [UIView animateWithDuration:0.3 delay:0.0 options:(UIViewAnimationOptionCurveLinear) animations:^{ v.backgroundColor = self.topViewController.navigationHairlineColor; } completion:nil];
    }
    if (!self.navigationBar.isTranslucent) {
        [UIView animateWithDuration:0.3 delay:0.0 options:(UIViewAnimationOptionCurveLinear) animations:^{ barBackgroundView.alpha = alpha; } completion:nil];
        return;
    }
    if (@available(iOS 10.0, *)) {
        UIView *backgroundEffectView = [barBackgroundView valueForKey:@"_backgroundEffectView"];
        if (backgroundEffectView != nil && [self.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault] == nil) {
            [UIView animateWithDuration:0.3 delay:0.0 options:(UIViewAnimationOptionCurveLinear) animations:^{ backgroundEffectView.alpha = alpha; } completion:nil];
        }
    } else {
        UIView *daptiveBackdrop = [barBackgroundView valueForKey:@"_adaptiveBackdrop"];
        UIView *backdropEffectView = [daptiveBackdrop valueForKey:@"_backdropEffectView"];
        if (daptiveBackdrop != nil && backdropEffectView != nil) {
            [UIView animateWithDuration:0.3 delay:0.0 options:(UIViewAnimationOptionCurveLinear) animations:^{ backdropEffectView.alpha = alpha; } completion:nil];
        }
    }
}

@end

@implementation UIViewController (FuckingNavigation)

- (void)setNavigationAlpha:(CGFloat)navigationAlpha {
    objc_setAssociatedObject(self, @selector(navigationAlpha), @(navigationAlpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.navigationController setNeedsNavigationBackgroundAlpha:navigationAlpha];
}

- (CGFloat)navigationAlpha {
    return objc_getAssociatedObject(self, _cmd) != nil ? [objc_getAssociatedObject(self, _cmd) floatValue] : 1.0;
}

- (void)setNavigationTintColor:(UIColor *)navigationTintColor {
    self.navigationController.navigationBar.tintColor = navigationTintColor;
    objc_setAssociatedObject(self, @selector(navigationTintColor), navigationTintColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)navigationTintColor {
    return objc_getAssociatedObject(self, _cmd) != nil ? objc_getAssociatedObject(self, _cmd) : [UIColor colorWithRed:36.0 / 255 green:125.0 / 255 blue:246.0 / 255 alpha:1.0];
}

- (void)setNavigationHairlineColor:(UIColor *)navigationHairlineColor {
    objc_setAssociatedObject(self, @selector(navigationHairlineColor), navigationHairlineColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    [self.navigationController.navigationBar performSelector:@selector(setBottomLineColor:) withObject:navigationHairlineColor];
#pragma clang diagnostic pop
}

- (UIColor *)navigationHairlineColor {
    return objc_getAssociatedObject(self, _cmd) != nil ? objc_getAssociatedObject(self, _cmd) : [UIColor colorWithRed:165.0 / 255 green:165.0 / 255 blue:169.0 / 255 alpha:1.0];
}

@end

@implementation UINavigationBar (FuckingNavigation)

+ (void)load {
    Method sourceMethod = class_getInstanceMethod(self, @selector(layoutSubviews));
    Method targetMethod = class_getInstanceMethod(self, @selector(exchangeLayoutSubviews));
    method_exchangeImplementations(sourceMethod, targetMethod);
}

- (void)exchangeLayoutSubviews {
    [self exchangeLayoutSubviews];
    if (!objc_getAssociatedObject(self, @selector(associatedKey))) {
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 0.33333333)];
        [self addSubview:v];
        objc_setAssociatedObject(self, @selector(associatedKey), v, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    } else {
        UIView *v = objc_getAssociatedObject(self, @selector(associatedKey));
        v.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, 0.33333333);
    }
}

- (void)associatedKey {
}

- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *) view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

- (void)hideBottomLine {
    UIImageView *shadowImageView = [self findHairlineImageViewUnder:self];
    if (shadowImageView) {
        shadowImageView.hidden = YES;
    }
}

- (UIView *)getCustomBottomLineView {
    return objc_getAssociatedObject(self, @selector(associatedKey));
}

- (void)setBottomLineColor:(UIColor *)color {
    [self hideBottomLine];
    UIView *v = [self getCustomBottomLineView];
    if (v) {
        v.backgroundColor = color;
    }
}

@end

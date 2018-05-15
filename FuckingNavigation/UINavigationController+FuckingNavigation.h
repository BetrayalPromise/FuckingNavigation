//
//  UINavigationController+FuckingNavigation.h
//  FuckingNavigation
//
//  Created by BetrayalPromise@gmail.com on 05/15/2018.
//  Copyright (c) 2018 BetrayalPromise@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (FuckingNavigation)

@end

@interface UIViewController (FuckingNavigation)

/// 设置导航栏透明度 0-1
@property (nonatomic, assign) CGFloat navigationAlpha;
/// 设置导航栏绘制颜色
@property (nonatomic, strong) UIColor * navigationTintColor;
/// 设置导航栏下方线的颜色
@property (nonatomic, strong) UIColor * navigationHairlineColor;

@end

@interface UINavigationBar (FuckingNavigation)

@end

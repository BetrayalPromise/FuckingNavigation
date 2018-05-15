//
//  QMTVViewController.m
//  FuckingNavigation
//
//  Created by BetrayalPromise@gmail.com on 05/15/2018.
//  Copyright (c) 2018 BetrayalPromise@gmail.com. All rights reserved.
//

#import "QMTVViewController.h"
#import <FuckingNavigation/FuckingNavigation.h>

@interface QMTVViewController ()

@end

@implementation QMTVViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"仔细观察导航栏的变化";
    
    self.navigationAlpha = (arc4random() % 100) * 1.0 / 100;
    self.navigationTintColor = [UIColor colorWithRed:arc4random() % 255 / 255.0 green:arc4random() % 255 / 255.0 blue:arc4random() % 255 / 255.0 alpha:1.0];
    self.navigationHairlineColor =  [UIColor colorWithRed:arc4random() % 255 / 255.0 green:arc4random() % 255 / 255.0 blue:arc4random() % 255 / 255.0 alpha:1.0];
    
    
    UIButton * button0 = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 40)];
    [button0 setTitle:@"push" forState:(UIControlStateNormal)];
    button0.backgroundColor = [UIColor redColor];
    [self.view addSubview:button0];
    [button0 addTarget:self action:@selector(button0Event:) forControlEvents:(UIControlEventTouchUpInside)];
    
    UIButton * button1 = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 100, 40)];
    [button1 setTitle:@"present" forState:(UIControlStateNormal)];
    button1.backgroundColor = [UIColor redColor];
    [self.view addSubview:button1];
    [button1 addTarget:self action:@selector(button1Event:) forControlEvents:(UIControlEventTouchUpInside)];
    
    UIButton * button2 = [[UIButton alloc] initWithFrame:CGRectMake(100, 300, 100, 40)];
    [button2 setTitle:@"dismiss" forState:(UIControlStateNormal)];
    button2.backgroundColor = [UIColor redColor];
    [self.view addSubview:button2];
    [button2 addTarget:self action:@selector(button2Event:) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)button0Event:(UIButton *)button {
    [self.navigationController pushViewController:[QMTVViewController new] animated:YES];
}

- (void)button1Event:(UIButton *)button {
    UINavigationController * nController = [[UINavigationController alloc] initWithRootViewController:[QMTVViewController new]];
    [self presentViewController:nController animated:YES completion:nil];
}

- (void)button2Event:(UIButton *)button {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

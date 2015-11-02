//
//  TabBarViewController.m
//  Fruit
//
//  Created by kai xie on 15/8/7.
//  Copyright (c) 2015年 kai xie. All rights reserved.
//

#import "TabBarViewController.h"
#import "DemoViewController.h"
#import "XBConst.h"
@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加tabbar顶部线条
    CALayer *topBorder = [CALayer layer];
    topBorder.frame = CGRectMake(0.0f, 0.0f,XBScreenWidth, 0.5f);
    topBorder.backgroundColor = [UIColor lightTextColor].CGColor;
    [self.tabBar.layer addSublayer:topBorder];
    
    // 添加子控件
    UIViewController *one = [[DemoViewController alloc] init];
    [self addOneChildVc:one title:@"第1页" imageName:@"" selectedimage:@""];
    
    UIViewController *two = [[DemoViewController alloc] init];
    [self addOneChildVc:two title:@"第2页" imageName:@"" selectedimage:@""];
    
}


- (void) addOneChildVc:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedimage:(NSString *)selectedImageName
{
    childVc.title = title;
    childVc.tabBarItem.image = [UIImage imageNamed:imageName];
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVc.tabBarItem.selectedImage = selectedImage;
    
    // 添加为tabbar控制器的子控制器
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:childVc];
    [self addChildViewController:nav];
    
}

@end

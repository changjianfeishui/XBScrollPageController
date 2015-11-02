//
//  DemoViewController.m
//  XBScrollPageControllerDemo
//
//  Created by Scarecrow on 15/9/8.
//  Copyright (c) 2015年 xiu8. All rights reserved.
//

#import "DemoViewController.h"
#import "XBTestImageViewController.h"
#import "XBTestTableViewController.h"
#import "XBCollectionViewController.h"
@interface DemoViewController ()

@end

@implementation DemoViewController
//重载init方法
- (instancetype)init
{
    if (self = [super initWithTagViewHeight:49])
    {
        
    }
        return self;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"ScrollPageDemo";
    
    
    //设置自定义属性
    self.tagItemSize = CGSizeMake(110, 49);
    
//    self.selectedIndicatorSize = CGSizeMake(30, 8);
//    self.selectedTitleColor = [UIColor blueColor];
//    self.selectedTitleFont = [UIFont systemFontOfSize:18];
    
//    self.graceTime = 15;
//    self.gapAnimated = YES;
    
    self.backgroundColor = [UIColor whiteColor];
    
    NSArray *titleArray = @[
                            @"image",
                            @"tableView",
                            @"collectionView",
                            @"image",
                            @"tableView",
                            @"collectionView",
                            ];
    
    NSArray *classNames = @[
                            [XBTestImageViewController class],
                            [XBTestTableViewController class],
                            [XBCollectionViewController class],
                            [XBTestImageViewController class],
                            [XBTestTableViewController class],
                            [XBCollectionViewController class]
                            ];
    
    NSArray *params = @[
                        @"XBParamImage",
                        @"TableView",
                        @"CollectionView",
                        @"XBParamImage",
                        @"TableView",
                        @"CollectionView"
                        ];
    
    
    [self reloadDataWith:titleArray andSubViewdisplayClasses:classNames withParams:params];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self selectTagByIndex:3 animated:YES];

}


@end

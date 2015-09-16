//
//  XBTestImageViewController.m
//  XBScrollPageControllerDemo
//
//  Created by Scarecrow on 15/9/8.
//  Copyright (c) 2015年 xiu8. All rights reserved.
//

#import "XBTestImageViewController.h"
#import "XBConst.h"
@interface XBTestImageViewController ()
@property (nonatomic,strong) UIImageView *imgv;

@end

@implementation XBTestImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    UIImageView *imgv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 375, 554)];
//    imgv.image = [UIImage imageNamed:@"2.jpg"];
//    imgv.contentMode = UIViewContentModeScaleToFill;
//    [self.view addSubview:imgv];
//    self.imgv = imgv;
}


- (void)setXBParam:(NSString *)XBParam
{
    _XBParam = XBParam;
    XBLog(@"XBTestImageViewController received param === %@",XBParam);
}

- (void)dealloc
{
    XBLog(@"XBTestImageViewController delloc");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

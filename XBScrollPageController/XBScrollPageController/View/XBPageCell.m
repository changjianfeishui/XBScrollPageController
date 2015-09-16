//
//  XBPageCell.m
//  XBScrollPageController
//
//  Created by Scarecrow on 15/9/6.
//  Copyright (c) 2015年 xiu8. All rights reserved.
//

#import "XBPageCell.h"

@implementation XBPageCell
- (void)configCellWithController:(UIViewController *)controller
{
    controller.view.frame = self.bounds;
    [self.contentView addSubview:controller.view];
    
}
@end

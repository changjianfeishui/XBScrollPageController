//
//  XBTagTitleModel.m
//  XBScrollPageController
//
//  Created by Scarecrow on 15/9/6.
//  Copyright (c) 2015年 xiu8. All rights reserved.
//

#import "XBTagTitleModel.h"

@implementation XBTagTitleModel
+ (XBTagTitleModel *)modelWithtagTitle:(NSString *)title
                    andNormalTitleFont:(UIFont *)normalTitleFont
                  andSelectedTitleFont:(UIFont *)selectedTitleFont
                   andNormalTitleColor:(UIColor *)normalTitleColor
                 andSelectedTitleColor:(UIColor *)selectedTitleColor
{
    XBTagTitleModel *tag = [[self alloc]init];
    tag.tagTitle = title;
    tag.normalTitleFont = normalTitleFont;
    tag.selectedTitleFont = selectedTitleFont;
    tag.normalTitleColor = normalTitleColor;
    tag.selectedTitleColor = selectedTitleColor;
    return tag;
}
@end

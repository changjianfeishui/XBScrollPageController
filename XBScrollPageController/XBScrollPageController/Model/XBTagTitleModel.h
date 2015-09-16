//
//  XBTagTitleModel.h
//  XBScrollPageController
//
//  Created by Scarecrow on 15/9/6.
//  Copyright (c) 2015年 xiu8. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface XBTagTitleModel : NSObject
@property (nonatomic,copy) NSString *tagTitle; /**< 标签名  */
@property (nonatomic,strong) UIFont *normalTitleFont; /**< 正常(非选中)标签字体  */
@property (nonatomic,strong) UIFont *selectedTitleFont; /**< 选中状态标签字体  */

@property (nonatomic,strong) UIColor *normalTitleColor; /**< 正常(非选中)标签字体颜色  */
@property (nonatomic,strong) UIColor *selectedTitleColor; /**< 选中状态标签字体颜色  */



+ (XBTagTitleModel *)modelWithtagTitle:(NSString *)title
                    andNormalTitleFont:(UIFont *)normalTitleFont
                    andSelectedTitleFont:(UIFont *)selectedTitleFont
                    andNormalTitleColor:(UIColor *)normalTitleColor
                    andSelectedTitleColor:(UIColor *)selectedTitleColor;

@end

//
//  XBScrollPageController.h
//  XBScrollPageController
//
//  Created by Scarecrow on 14/9/6.
//  Copyright (c) 2014年 xiu8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBScrollPageController : UIViewController
@property (nonatomic,strong) UIFont *normalTitleFont; /**< 正常(非选中)标签字体  default is 14*/
@property (nonatomic,strong) UIFont *selectedTitleFont; /**< 选中状态标签字体  default is 16*/

@property (nonatomic,strong) UIColor *normalTitleColor; /**< 正常(非选中)标签字体颜色  default is darkGrayColor*/
@property (nonatomic,strong) UIColor *selectedTitleColor; /**< 选中状态标签字体颜色  default is redColor*/

@property (nonatomic,strong) UIColor  *selectedIndicatorColor; /**< 下方滑块颜色 default is redColor*/
/**
 *  如果tag设置了tagItemSize,则宽度默认跟tagItemSize宽度相同,高度为2(也可手动更改)
 *  如果tag使用自由文本宽度,则默认与第一个标签宽度相同,高度为2,而且宽度会随选中的标签文本宽度改变
 */
@property (nonatomic,assign) CGSize  selectedIndicatorSize;


@property (nonatomic,assign) CGSize tagItemSize; /**< 每个tag标签的size,如果不设置则会根据文本长度计算*/



//由于性能方面的考虑,设置定时器每10s检测一次缓存,所以如需使用该属性请尽量设置较大值,或按需修改源码
@property (nonatomic,assign) NSTimeInterval graceTime;  /**< 控制器缓存时间,如果在该段时间内缓存的控制器依旧没有被展示,则会从内存中销毁,默认不设置,即默认在内存中缓存所有展示过的控制器*/

@property (nonatomic,strong) UIColor *backgroundColor;  /**< 背景色  */

@property (nonatomic,assign) BOOL gapAnimated; /**< 跨越多个标签进行切换时,page是否动画,默认为NO,建议不开启,开启后中间过渡的控制器都会加载  */

/**
 *  必须调用
 *
 */
- (instancetype)initWithTagViewHeight:(CGFloat)tagViewHeight;
/**
 *  刷新界面数据
 *
 *  @param titleArray 标题数组@[NSString]
 *  @param classNames @[[xxxVC class]]
 */
- (void)reloadDataWith:(NSArray *)titleArray andSubViewdisplayClasses:(NSArray *)classes;
/**
 *  可以传递参数的刷新方法
 */
- (void)reloadDataWith:(NSArray *)titleArray andSubViewdisplayClasses:(NSArray *)classes withParams:(NSArray *)params;

/**
 *  选中index位置的标签[0...titleArray.count-1]
 *
 */
- (void)selectTagByIndex:(NSInteger)index animated:(BOOL)animated;



//移除属性
//@property (nonatomic,assign) CGFloat  tagItemGap; /**< 根据文本计算tag宽度时,每个tag之间的间距,default is 10.f*/
@end

//
//  XBScrollPageController.m
//  XBScrollPageController
//
//  Created by Scarecrow on 14/9/6.
//  Copyright (c) 2014年 xiu8. All rights reserved.
//

#import "XBScrollPageController.h"
#import "XBConst.h"
#import "XBTagTitleCell.h"
#import "XBPageCell.h"
#import "XBTagTitleModel.h"
#import "UIView+XBExtension.h"
@interface XBScrollPageController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,assign) CGFloat tagViewHeight;   /**< 标签高度  */
@property (nonatomic,strong) UICollectionView *tagCollectionView; /**< 标签View */
@property (nonatomic,strong) UICollectionViewFlowLayout *tagFlowLayout;

@property (nonatomic,strong) UICollectionView *pageCollectionView; /**< 页面展示View  */
@property (nonatomic,strong) UICollectionViewFlowLayout *pageFlowLayout;

@property (nonatomic,strong) NSMutableArray *tagTitleModelArray; /**< 标题模型数组  */


@property (nonatomic,assign) NSInteger selectedIndex;   /**< 记录tag当前选中的cell索引  */

@property (nonatomic,strong) NSArray *displayClasses; /**< 要展示的子控制器类名,如果只传一个则表示重复使用该控制器类  */
@property (nonatomic,strong) NSMutableDictionary *viewControllersCaches;    /**< 控制器缓存  */
@property (nonatomic,strong) NSMutableDictionary *frameCaches;    /**< size缓存  */

@property (nonatomic,strong) NSArray *params;     /**< 可供传递的参数  */

@property (nonatomic,strong) NSTimer *graceTimer;
@property (nonatomic,strong) UIView *selectionIndicator;  /**< 选择指示器  */

@end

@implementation XBScrollPageController

#pragma - mark LifeCycle
- (instancetype)initWithTagViewHeight:(CGFloat)tagViewHeight
{
    if (self = [super init]) {
        self.tagViewHeight = tagViewHeight;
        //设置默认值
        [self setupDefaultProperties];
        //初始化两个CollectionView
        [self setupCollectionView];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    if (self.tagTitleModelArray.count!=0) {
        [self resetSelectedIndex];
    }
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.tagCollectionView.frame = CGRectMake(0, 0, XBScreenWidth, self.tagViewHeight);
    self.pageCollectionView.frame = CGRectMake(0, self.tagViewHeight, XBScreenWidth, self.view.frame.size.height - self.tagViewHeight);
}

- (void)dealloc
{
    if (self.graceTime != 0) {
        [self.graceTimer invalidate];
        self.graceTimer = nil;
    }
}

#pragma - mark setupMethod
- (void)setupDefaultProperties
{
    self.normalTitleFont = [UIFont systemFontOfSize:14];
    self.selectedTitleFont = [UIFont systemFontOfSize:16];
    self.normalTitleColor = [UIColor darkGrayColor];
    self.selectedTitleColor = [UIColor redColor];
    self.selectedIndicatorColor = [UIColor redColor];
    self.tagItemSize = CGSizeZero;
    self.tagItemGap = 10.f;
    self.selectedIndex = -1;
}

- (void)setupCollectionView
{
    //初始化标签布局
    UICollectionViewFlowLayout *tagFlowLayout = [[UICollectionViewFlowLayout alloc]init];
    tagFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    tagFlowLayout.minimumLineSpacing = 0;
    tagFlowLayout.minimumInteritemSpacing = 0;
    self.tagFlowLayout = tagFlowLayout;
    
    //初始化标签View
    UICollectionView *tagCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:tagFlowLayout];
    [tagCollectionView registerClass:[XBTagTitleCell class] forCellWithReuseIdentifier:kTagCollectionViewCellIdentifier];
    tagCollectionView.backgroundColor = [UIColor whiteColor];
    tagCollectionView.showsHorizontalScrollIndicator = NO;
    tagCollectionView.dataSource = self;
    tagCollectionView.delegate = self;
    self.tagCollectionView = tagCollectionView;
    [self.view addSubview:self.tagCollectionView];
    
    //初始化页面布局
    UICollectionViewFlowLayout *pageFlowLayout = [[UICollectionViewFlowLayout alloc]init];
    pageFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    pageFlowLayout.minimumLineSpacing = 0;
    pageFlowLayout.minimumInteritemSpacing = 0;
    self.pageFlowLayout = pageFlowLayout;
    
    //初始化页面View
    UICollectionView *pageCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:pageFlowLayout];
    [pageCollectionView registerClass:[XBPageCell class] forCellWithReuseIdentifier:kPageCollectionViewCellIdentifier];
    pageCollectionView.backgroundColor = [UIColor whiteColor];
    pageCollectionView.showsHorizontalScrollIndicator = NO;
    pageCollectionView.dataSource = self;
    pageCollectionView.delegate = self;
    pageCollectionView.pagingEnabled = YES;
    self.pageCollectionView = pageCollectionView;
    [self.view addSubview:self.pageCollectionView];
}

#pragma mark - UICollectionViewDataSource Protocol Methods
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.tagTitleModelArray.count != 0?self.tagTitleModelArray.count:0;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.item;
    if ([self isTagView:collectionView]) {     //标签
        XBTagTitleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kTagCollectionViewCellIdentifier forIndexPath:indexPath];
        XBTagTitleModel *tagTitleModel = self.tagTitleModelArray[index];
        cell.tagTitleModel = tagTitleModel;
        [cell setSelected:(self.selectedIndex == index)?YES:NO];
        cell.backgroundColor = self.backgroundColor;
        
        return cell;
    }else{                                              //页面
        XBPageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPageCollectionViewCellIdentifier forIndexPath:indexPath];
        //更新page状态
        Class displayClass = (self.displayClasses.count == 1)?[self.displayClasses firstObject]:self.displayClasses[indexPath.item];
        
        //取缓存
        UIViewController *cachedViewController = [self getCachedVCByIndexPath:indexPath];
        if (!cachedViewController) {   //如果缓存里不存在,生成新的VC,并加入缓存(如果缓存里存在,表明之前alloc过,直接使用 )
            cachedViewController = [[displayClass alloc]init];
        }
        //更新缓存
        [self saveCachedVC:cachedViewController ByIndexPath:indexPath];
        
        if (self.params.count != 0) {
            if (![cachedViewController valueForKeyPath:@"XBParam"]) {
                [cachedViewController setValue:self.params[indexPath.item] forKeyPath:@"XBParam"];
            }
        }
        [self addChildViewController:cachedViewController];
        [cell configCellWithController:cachedViewController];
        
        return cell;
    }
    return nil;
}
#pragma mark - UICollectionViewDelegateFlowLayout Protocol Methods
//sizeForItemAtIndexPath 只调用一次,一次性计算所有cell的size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    NSInteger index = indexPath.item;
    if ([self isTagView:collectionView]) {     //标签
        if (CGSizeEqualToSize(CGSizeZero, self.tagItemSize)) {      //如果用户没有手动设置tagItemSize
            XBTagTitleModel *tagTitleModel = self.tagTitleModelArray[index];
            NSString *title = tagTitleModel.tagTitle;
            CGSize titleSize = [self sizeForTitle:title withFont:((tagTitleModel.normalTitleFont.pointSize >= tagTitleModel.selectedTitleFont.pointSize)?tagTitleModel.normalTitleFont:tagTitleModel.selectedTitleFont)];
            return CGSizeMake(titleSize.width + self.tagItemGap * 0.5, self.tagViewHeight);;
        }else
        {
            return self.tagItemSize;
        }
        
    }else
    {
        return collectionView.frame.size;
    }
}

#pragma mark - UICollectionViewDelegate Protocol Methods
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self isTagView:collectionView]) {                     //选中某个标签
        [collectionView deselectItemAtIndexPath:[NSIndexPath indexPathForItem:self.selectedIndex inSection:0] animated:YES];
        
        NSInteger gap = indexPath.item - self.selectedIndex;
        
        self.selectedIndex = indexPath.item;
        
        
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];

        
        if (self.selectionIndicator.centerX != cell.centerX) {
            [UIView animateWithDuration:0.3 animations:^{
                self.selectionIndicator.centerX = cell.centerX;
            }];
        }
        
        [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
        
        [self.pageCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionRight animated:labs(gap)>1?self.gapAnimated:YES];

        
    }
}
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self isTagView:collectionView]) {          //tag

    }
    else{                                               //page
        //从缓存中取出instaceController
        UIViewController *cachedViewController = [self getCachedVCByIndexPath:indexPath];
        
        if (!cachedViewController) {
            return;
        }
        
        //更新缓存时间
        [self saveCachedVC:cachedViewController ByIndexPath:indexPath];
        
        //从父控制器中移除
        [cachedViewController removeFromParentViewController];
        [cachedViewController.view removeFromSuperview];
    }
}


#pragma - mark UIScrollerViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.pageCollectionView) {
        int index = scrollView.contentOffset.x / self.pageCollectionView.frame.size.width;
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        [self collectionView:self.tagCollectionView didSelectItemAtIndexPath:indexPath];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.pageCollectionView) {
        if (![self isZeroSize:self.tagItemSize]) {
            self.selectionIndicator.x = scrollView.contentOffset.x/XBScreenWidth * self.tagItemSize.width;
        }
        
    }
}
#pragma - mark publicMethod
- (void)reloadDataWith:(NSArray *)titleArray andSubViewdisplayClasses:(NSArray *)classes
{
    [self convertKeyValue2Model:titleArray];
    self.displayClasses = classes;
    [self.tagCollectionView reloadData];
    [self.pageCollectionView reloadData];
    
    [self resetSelectedIndex];

}
- (void)reloadDataWith:(NSArray *)titleArray andSubViewdisplayClasses:(NSArray *)classes withParams:(NSArray *)params
{
    [self convertKeyValue2Model:titleArray];
    self.displayClasses = classes;
    [self.tagCollectionView reloadData];
    [self.pageCollectionView reloadData];
    self.params = params;
    
    [self resetSelectedIndex];
}


#pragma - mark selfMethod
- (BOOL)isTagView:(UICollectionView *)collectionView
{
    if (self.tagCollectionView == collectionView) {
        return YES;
    }
    return NO;
}

- (void)convertKeyValue2Model:(NSArray *)titleArray
{
    [self.tagTitleModelArray removeAllObjects];
    for (int i = 0; i < titleArray.count; i++) {
        XBTagTitleModel *tag = [XBTagTitleModel modelWithtagTitle:titleArray[i] andNormalTitleFont:self.normalTitleFont andSelectedTitleFont:self.selectedTitleFont andNormalTitleColor:self.normalTitleColor andSelectedTitleColor:self.selectedTitleColor];
        [self.tagTitleModelArray addObject:tag];
    }
}

- (CGSize)sizeForTitle:(NSString *)title withFont:(UIFont *)font
{
    CGRect titleRect = [title boundingRectWithSize:CGSizeMake(FLT_MAX, FLT_MAX)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName : font}
                                           context:nil];
    
    return CGSizeMake(titleRect.size.width,
                      titleRect.size.height);
}

- (UIViewController *)getCachedVCByIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *cachedDic = [self.viewControllersCaches objectForKey:@(indexPath.item)];
    UIViewController *cachedViewController = [cachedDic objectForKey:kCachedVCName];
    return cachedViewController;
}

- (void)saveCachedVC:(UIViewController *)viewController ByIndexPath:(NSIndexPath *)indexPath
{
    NSDate *newTime =[NSDate date];
    NSDictionary *newCacheDic = @{kCachedTime:newTime,
                                  kCachedVCName:viewController};
    [self.viewControllersCaches setObject:newCacheDic forKey:@(indexPath.item)];
    
}
- (void)resetSelectedIndex
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self collectionView:self.tagCollectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    });
}

- (void)updateViewControllersCaches
{
    NSDate *currentDate = [NSDate date];
    __weak typeof(self) weakSelf = self;
    
    NSMutableDictionary *tempDic = self.viewControllersCaches;
    
    
    [self.viewControllersCaches enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, NSDictionary *obj, BOOL *stop) {
        UIViewController *vc = [obj objectForKey:kCachedVCName];
        NSDate *cachedTime = [obj objectForKey:kCachedTime];
        NSInteger keyInteger = [key integerValue];
        NSInteger selectionInteger = weakSelf.selectedIndex;
        
        if (keyInteger != selectionInteger) {         //当前不是当前正在展示的cell
            NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:cachedTime];
            if (timeInterval >= weakSelf.graceTime) {
                //宽限期到了销毁控制器
                [tempDic removeObjectForKey:key];
                [vc.view removeFromSuperview];
                [vc removeFromParentViewController];
            }
        }
    }];
    self.viewControllersCaches = tempDic;
}


- (BOOL)isZeroSize:(CGSize)size
{
    if (CGSizeEqualToSize(CGSizeZero, size)) {
        return YES;
    }
    return NO;
}



#pragma - mark getter&setter
- (NSMutableArray *)tagTitleModelArray
{
    if (!_tagTitleModelArray) {
        _tagTitleModelArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _tagTitleModelArray;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    _backgroundColor = backgroundColor;
    self.tagCollectionView.backgroundColor = backgroundColor;
}
- (NSMutableDictionary *)viewControllersCaches
{
    if (!_viewControllersCaches) {
        _viewControllersCaches = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _viewControllersCaches;
}
- (void)setGraceTime:(NSTimeInterval)graceTime
{
    _graceTime = graceTime;
    [self.graceTimer setFireDate:[NSDate distantPast]];
}
- (NSTimer *)graceTimer
{
    
    if (self.graceTime) {
        if (!_graceTimer) {
            _graceTimer = [NSTimer timerWithTimeInterval:5.f target:self selector:@selector(updateViewControllersCaches) userInfo:nil repeats:YES];
            [_graceTimer setFireDate:[NSDate distantFuture]];
            [[NSRunLoop mainRunLoop] addTimer:_graceTimer forMode:NSDefaultRunLoopMode];
        }
        return _graceTimer;
    }
    return nil;
}
- (NSMutableDictionary *)frameCaches
{
    if (!_frameCaches) {
        _frameCaches = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _frameCaches;
}
- (UIView *)selectionIndicator
{
    if (!_selectionIndicator) {
        _selectionIndicator = [[UIView alloc]init];
        _selectionIndicator.backgroundColor = self.selectedIndicatorColor;
        
        //1.如果设置了selectedIndicatorSize
        if (![self isZeroSize:self.selectedIndicatorSize]) {
            _selectionIndicator.frame = CGRectMake(0, self.tagViewHeight - self.selectedIndicatorSize.height, self.selectedIndicatorSize.width, self.selectedIndicatorSize.height);

        }
        //2.如果没有设置selectedIndicatorSize
        else
        {
            //2.1 如果设置了tagItemSize
            if (![self isZeroSize:self.tagItemSize]) {
                _selectionIndicator.frame = CGRectMake(0, self.tagViewHeight - 2, self.tagItemSize.width, 2);
            }
            //2.2 如果没有设置tagItemSize,则给默认值(100,2)
            else
            {
                _selectionIndicator.frame = CGRectMake(0, self.tagViewHeight - 2, 50, 2);
            }

        }
        
        [self.tagCollectionView addSubview:_selectionIndicator];
    }

    return _selectionIndicator;
}

@end

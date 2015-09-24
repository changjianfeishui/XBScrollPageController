//
//  XBTagTitleCell.m
//  XBScrollPageController
//
//  Created by Scarecrow on 15/9/6.
//  Copyright (c) 2015年 xiu8. All rights reserved.
//

#import "XBTagTitleCell.h"
#import "XBTagTitleModel.h"
@interface XBTagTitleCell()
@property (nonatomic, strong) UILabel *titleLabel;
@end
@implementation XBTagTitleCell
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_titleLabel];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    if (highlighted) {
        self.titleLabel.font = self.tagTitleModel.selectedTitleFont;
        self.titleLabel.textColor = self.tagTitleModel.selectedTitleColor;
    }else
    {
        self.titleLabel.font = self.tagTitleModel.normalTitleFont;
        self.titleLabel.textColor = self.tagTitleModel.normalTitleColor;
    }}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected) {
        self.titleLabel.font = self.tagTitleModel.selectedTitleFont;
        self.titleLabel.textColor = self.tagTitleModel.selectedTitleColor;
    }else
    {
        self.titleLabel.font = self.tagTitleModel.normalTitleFont;
        self.titleLabel.textColor = self.tagTitleModel.normalTitleColor;
    }
}

- (void)setTagTitleModel:(XBTagTitleModel *)tagTitleModel
{
    _tagTitleModel = tagTitleModel;
    [self updateUI];
}

- (void)updateUI
{
    self.titleLabel.text = self.tagTitleModel.tagTitle;
    self.titleLabel.font = self.tagTitleModel.normalTitleFont;
    self.titleLabel.textColor = self.tagTitleModel.normalTitleColor;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.titleLabel.frame = self.bounds;
}

@end

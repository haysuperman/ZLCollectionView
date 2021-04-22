//
//  POPCollectionHeaderView.m
//  ZLCollectionView
//
//  Created by Zhou LH on 2021/3/17.
//  Copyright © 2021 zhaoliang chen. All rights reserved.
//

#import "POPCollectionHeaderView.h"
#import <Masonry/Masonry.h>

@interface POPCollectionHeaderView ()

@property(nonatomic, strong) UIButton *button;

@property(nonatomic, strong) UIView *openView;

@property(nonatomic, assign) bool isOpen;

@end

@implementation POPCollectionHeaderView


#pragma mark - button action
- (void)btnClick
{
    _isOpen = !_isOpen;
    __weak __typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        [weakSelf.openView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(weakSelf.isOpen ? 150 : 0);
        }];
    }];
}

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI
{
    self.backgroundColor = UIColor.yellowColor;
    self.layer.borderWidth = 1;
    self.layer.borderColor = UIColor.blackColor.CGColor;
    
    [self addSubview:self.button];
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(self.button);
        make.width.mas_equalTo(150);
    }];
    
    
    [self addSubview:self.openView];
    [self.openView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(self.mas_bottom);
        make.height.mas_equalTo(0);
    }];
}

- (UIButton *)button
{
    if (!_button) {
        _button = [UIButton new];
        [_button setTitle:@"open" forState:(UIControlStateNormal)];
        [_button setTitleColor:UIColor.blackColor forState:(UIControlStateNormal)];
        [_button addTarget:self action:@selector(btnClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _button;
}

- (UIView *)openView
{
    if (!_openView) {
        _openView = [UIView new];
        _openView.backgroundColor = UIColor.blueColor;
    }
    return _openView;
}

@end

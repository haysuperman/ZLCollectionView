//
//  POPCollectionViewCell.m
//  ZLCollectionView
//
//  Created by Zhou LH on 2021/3/16.
//  Copyright © 2021 zhaoliang chen. All rights reserved.
//

#import "POPCollectionViewCell.h"

#define RandomColor       [[UIColor alloc] initWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:1]

@interface POPCollectionViewCell ()

@property(nonatomic, strong) UILabel *label;
@property(nonatomic, strong) UIButton *button;

@end

@implementation POPCollectionViewCell

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.label.text = title;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setModel:(AosomPopModel *)model
{
    _model = model;
    self.contentView.backgroundColor = model.color;
}


- (void)setUI
{
    self.contentView.backgroundColor = UIColor.whiteColor;
//    self.contentView.backgroundColor = RandomColor;
    [self.contentView addSubview:self.label];
    self.label.frame = CGRectMake(0, 40, 100, 40);
    
    [self.contentView addSubview:self.button];
    self.button.frame = CGRectMake(0, 0, 100, 40);
    
    self.contentView.layer.borderWidth = 2;
    self.contentView.layer.borderColor = UIColor.whiteColor.CGColor;
    self.contentView.layer.masksToBounds = true;
}

- (void)drawRect:(CGRect)rect
{
    
}

- (UILabel *)label
{
    if (!_label) {
        UILabel *label = [UILabel new];
        label.textColor = UIColor.blackColor;
        label.font = [UIFont systemFontOfSize:20];
        label.textAlignment = NSTextAlignmentCenter;
        _label = label;
    }
    return _label;
}

- (UIButton *)button
{
    if (!_button) {
        _button = [[UIButton alloc] init];
        [_button setTitle:@"reload cell" forState:(UIControlStateNormal)];
        [_button setBackgroundColor:UIColor.blackColor];
        [_button addTarget:self action:@selector(btnClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _button;
}

- (void)btnClick
{
    if (self.btnClickBlock!=nil) {
        self.btnClickBlock();
    }
}

@end

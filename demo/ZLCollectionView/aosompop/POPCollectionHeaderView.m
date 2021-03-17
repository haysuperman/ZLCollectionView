//
//  POPCollectionHeaderView.m
//  ZLCollectionView
//
//  Created by Zhou LH on 2021/3/17.
//  Copyright © 2021 zhaoliang chen. All rights reserved.
//

#import "POPCollectionHeaderView.h"

@implementation POPCollectionHeaderView

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
    
}

@end

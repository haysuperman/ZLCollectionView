//
//  POPCollectionViewCell.h
//  ZLCollectionView
//
//  Created by Zhou LH on 2021/3/16.
//  Copyright © 2021 zhaoliang chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AosomPopViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface POPCollectionViewCell : UICollectionViewCell

@property(nonatomic, strong) NSString *title;

@property(nonatomic, strong) AosomPopModel *model;

@property(nonatomic, copy) void (^btnClickBlock)(void);

@end

NS_ASSUME_NONNULL_END

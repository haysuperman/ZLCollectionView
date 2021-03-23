//
//  AosomPopViewController.m
//  ZLCollectionView
//
//  Created by Zhou LH on 2021/3/16.
//  Copyright © 2021 zhaoliang chen. All rights reserved.
//

#import "AosomPopViewController.h"
//#import "ZLCollectionViewBaseFlowLayout.h"
#import "ZLCollectionViewVerticalLayout.h"
#import "POPCollectionViewCell.h"
#import "POPCollectionHeaderView.h"

static NSString * const kPOPCollectionViewCellID = @"POPCollectionViewCellID";
static NSString * const kPOPCollectionHeaderViewID = @"POPCollectionHeaderViewID";
/// 屏幕宽度，会根据横竖屏的变化而变化
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)

/// 屏幕高度，会根据横竖屏的变化而变化
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

#define RandomColor       [[UIColor alloc] initWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:1]

@interface AosomPopModel ()

@end
@implementation AosomPopModel

@end


@interface AosomPopViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, ZLCollectionViewBaseFlowLayoutDelegate>

@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) NSMutableDictionary *collectionAbsoluteLayoutDic;

@property(nonatomic, strong) UIButton *reloadBtn;

@property(nonatomic, strong) NSMutableArray *productArray;
@property(nonatomic, strong) NSMutableArray *infoArray;

@end

@implementation AosomPopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setData];
    self.collectionAbsoluteLayoutDic = @{}.mutableCopy;
    self.automaticallyAdjustsScrollViewInsets = false;
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.collectionView];
//    self.collectionView.frame = CGRectMake(0, UIApplication.sharedApplication.statusBarFrame.size.height + 44, SCREEN_WIDTH, SCREEN_HEIGHT - UIApplication.sharedApplication.statusBarFrame.size.height + 44);
    self.collectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - UIApplication.sharedApplication.statusBarFrame.size.height + 44 - 65);
    [self.view addSubview:self.reloadBtn];
    self.reloadBtn.frame = CGRectMake(SCREEN_WIDTH - 100 - 60, 120, 100, 60);
}

#pragma mark - initData

- (void)setData
{
    self.productArray = ({
        NSMutableArray *arr = @[].mutableCopy;
        AosomPopModel *model = [AosomPopModel new];
        model.color = RandomColor;
        model.height = 400;
        [arr addObject:model];
        
        for (int i = 1; i < 10; i++) {
            AosomPopModel *model = [AosomPopModel new];
            model.color = RandomColor;
            model.height = arc4random_uniform(120)+60;
            [arr addObject:model];
        }
        arr;
    });
    
    self.infoArray = ({
        NSMutableArray *arr = @[].mutableCopy;
        for (int i = 0; i < 20; i++) {
            AosomPopModel *model = [AosomPopModel new];
            model.color = RandomColor;
            model.height = arc4random_uniform(200)+200;
            [arr addObject:model];
        }
        arr;
    });
}

#pragma mark - ZLCollectionViewBaseFlowLayoutDelegate
- (CGRect)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout rectOfItem:(NSIndexPath *)indexPath
{
    if (indexPath.section != 0) {
        return CGRectZero;
    }
    CGRect returnRect = CGRectZero;
    AosomPopModel *model = [self.productArray objectAtIndex:indexPath.item];
    if (indexPath.item == 0) {
        [self.collectionAbsoluteLayoutDic removeAllObjects];
        returnRect = CGRectMake(0, 0, SCREEN_WIDTH/2, model.height);
    }else{
        NSIndexPath *oldIndexPath = [NSIndexPath indexPathForItem:indexPath.item - 1 inSection:indexPath.section];
        UICollectionViewLayoutAttributes *oldLayoutAttributes = [collectionView layoutAttributesForItemAtIndexPath:indexPath];
        CGRect oldRect = oldLayoutAttributes.frame;
        if ([self.collectionAbsoluteLayoutDic.allKeys containsObject:oldIndexPath]) {
            oldRect = CGRectFromString([self.collectionAbsoluteLayoutDic objectForKey:oldIndexPath]);
        }
        if (indexPath.item == 1) {
            returnRect = CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2,model.height);
        }else{
            returnRect = CGRectMake(SCREEN_WIDTH/2, oldRect.origin.y+oldRect.size.height, oldRect.size.width,model.height);
        }
    }
    [self.collectionAbsoluteLayoutDic setObject:NSStringFromCGRect(returnRect) forKey:indexPath];
    return returnRect;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout columnCountOfSection:(NSInteger)section
{
    return 4;
    if (section == 1) {
        return 4;
    }
    return 1;
}


- (ZLLayoutType)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout typeOfLayout:(NSInteger)section;
{
    if (section == 0) {
        return AbsoluteLayout;
    }
    return FillLayout;
}
- (BOOL)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout sectionHeadersPinToVisibleBoundsInSection:(NSInteger)section
{
    return true;
    return section == 0;
}
#pragma mark - collectionDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(SCREEN_WIDTH, 120);
    if (section == 0) {
        return CGSizeMake(SCREEN_WIDTH, 120);
    }
    return CGSizeZero;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        POPCollectionHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kPOPCollectionHeaderViewID forIndexPath:indexPath];
        return header;
    }
    return nil;
}
- (BOOL)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout itemPinToVisibleBoundsInIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section == 0 && indexPath.item == 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout itemPinToVisibleBoundsOffsetInIndexPath:(NSIndexPath *)indexPath
{
    return 0;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return section == 0 ? self.productArray.count : self.infoArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AosomPopModel *model;
    if (indexPath.section == 0) {
        model = [self.productArray objectAtIndex:indexPath.item];
    }else{
        model = [self.infoArray objectAtIndex:indexPath.item];
    }
    POPCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPOPCollectionViewCellID forIndexPath:indexPath];
    cell.model = model;
    cell.title = [NSString stringWithFormat:@"%ld -- %ld", indexPath.section, indexPath.item];
    if (indexPath.section == 0 && indexPath.item >= 0) {
        cell.btnClickBlock = ^{
            model.height += 50;
            [collectionView reloadData];
//            [collectionView performBatchUpdates:^{
//                [collectionView reloadItemsAtIndexPaths:@[indexPath]];
//            } completion:^(BOOL finished) {
//
//            }];
//            [collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
        };
    }else{
        cell.btnClickBlock = ^{
            model.height += 50;
            [collectionView reloadData];
//            [collectionView reloadItemsAtIndexPaths:@[indexPath]];
        };
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        AosomPopModel *model = [self.infoArray objectAtIndex:indexPath.item];
        return CGSizeMake(SCREEN_WIDTH/([self collectionView:collectionView layout:collectionViewLayout columnCountOfSection:indexPath.section]), model.height);
    }
    return CGSizeZero;
//    return CGSizeMake([UIScreen mainScreen].bounds.size.width/2, 200);
}

#pragma mark - lazy
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = ({
            ZLCollectionViewVerticalLayout *flowLayout = [[ZLCollectionViewVerticalLayout alloc] init];
            flowLayout.delegate = self;
//            flowLayout.canDrag = YES;
//            flowLayout.isFloor = YES;
            flowLayout.minimumLineSpacing = 0;
            flowLayout.minimumInteritemSpacing = 0;
            flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
            flowLayout.header_suspension = YES;
            flowLayout.item_suspension = true;
            
            UICollectionView * object = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
            object.contentInset = UIEdgeInsetsZero;
            object.delegate = self;
            object.dataSource = self;
            object.alwaysBounceVertical = true;
            object.backgroundColor = [UIColor whiteColor];
            [object registerClass:[POPCollectionViewCell class] forCellWithReuseIdentifier:kPOPCollectionViewCellID];
            [object registerClass:[POPCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kPOPCollectionHeaderViewID];
//            [object registerClass:[MultilineTextCell class] forCellWithReuseIdentifier:@"MultilineTextCell"];
//            [object registerClass:[VerticalHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[VerticalHeaderView headerViewIdentifier]];
            object;
       });
    }
    return _collectionView;
}

- (UIButton *)reloadBtn
{
    if (!_reloadBtn) {
        _reloadBtn = [UIButton new];
        [_reloadBtn setTitle:@"reload" forState:(UIControlStateNormal)];
        [_reloadBtn setTitleColor:UIColor.blackColor forState:(UIControlStateNormal)];
        [_reloadBtn addTarget:self action:@selector(btnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [_reloadBtn setBackgroundColor:UIColor.whiteColor];
    }
    return _reloadBtn;
}

- (void)btnClick:(UIButton *)btn
{
    [self.collectionView reloadData];
}

@end

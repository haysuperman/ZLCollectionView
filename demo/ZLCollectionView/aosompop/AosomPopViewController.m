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

@interface AosomPopViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, ZLCollectionViewBaseFlowLayoutDelegate>

@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) NSMutableDictionary *collectionAbsoluteLayoutDic;

@property(nonatomic, strong) UIButton *reloadBtn;

@end

@implementation AosomPopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionAbsoluteLayoutDic = @{}.mutableCopy;
    self.automaticallyAdjustsScrollViewInsets = false;
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.collectionView];
//    self.collectionView.frame = CGRectMake(0, UIApplication.sharedApplication.statusBarFrame.size.height + 44, SCREEN_WIDTH, SCREEN_HEIGHT - UIApplication.sharedApplication.statusBarFrame.size.height + 44);
    self.collectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - UIApplication.sharedApplication.statusBarFrame.size.height + 44 - 65);
    [self.view addSubview:self.reloadBtn];
    self.reloadBtn.frame = CGRectMake(SCREEN_WIDTH - 100 - 60, 120, 100, 60);
}

#pragma mark - ZLCollectionViewBaseFlowLayoutDelegate
- (CGRect)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout rectOfItem:(NSIndexPath *)indexPath
{
    CGRect returnRect = CGRectZero;
    if (indexPath.item == 0) {
        [self.collectionAbsoluteLayoutDic removeAllObjects];
        returnRect = CGRectMake(0, 0, SCREEN_WIDTH/2, 400);
    }else{
        NSIndexPath *oldIndexPath = [NSIndexPath indexPathForItem:indexPath.item - 1 inSection:indexPath.section];
        UICollectionViewLayoutAttributes *oldLayoutAttributes = [collectionView layoutAttributesForItemAtIndexPath:indexPath];
        CGRect oldRect = oldLayoutAttributes.frame;
        if ([self.collectionAbsoluteLayoutDic.allKeys containsObject:oldIndexPath]) {
            oldRect = CGRectFromString([self.collectionAbsoluteLayoutDic objectForKey:oldIndexPath]);
        }
        if (indexPath.item == 1) {
            returnRect = CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, arc4random_uniform(100)+80);
        }else{
            returnRect = CGRectMake(SCREEN_WIDTH/2, oldRect.origin.y+oldRect.size.height, oldRect.size.width, arc4random_uniform(100)+80);
        }
    }
    [self.collectionAbsoluteLayoutDic setObject:NSStringFromCGRect(returnRect) forKey:indexPath];
    return returnRect;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout columnCountOfSection:(NSInteger)section
{
    return 2;
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
    return 10;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    POPCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPOPCollectionViewCellID forIndexPath:indexPath];\
    cell.title = [NSString stringWithFormat:@"%ld -- %ld", indexPath.section, indexPath.item];
    if (indexPath.section == 0 && indexPath.item > 0) {
        cell.btnClickBlock = ^{
            [collectionView reloadItemsAtIndexPaths:@[indexPath]];
        };
    }else{
        cell.btnClickBlock = ^{
            
        };
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake([UIScreen mainScreen].bounds.size.width/2, 200);
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

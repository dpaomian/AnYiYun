//
//  BusinessItemViewController.m
//  AnYiYun
//
//  Created by wwr on 2017/7/25.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "BusinessItemViewController.h"

@interface BusinessItemViewController ()

@end

@implementation BusinessItemViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"全部应用";
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.allCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, CGRectGetHeight(self.view.frame)-NAV_HEIGHT) collectionViewLayout:layout];
    [self.allCollectionView registerClass:[AllApplicationReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"AllApplicationReusableView"];
    [self.allCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([AllApplicationCollectionViewCell class]) bundle:nil]  forCellWithReuseIdentifier:@"AllApplicationCollectionViewCell"];
    _allCollectionView.delegate = self;
    _allCollectionView.dataSource = self;
    _allCollectionView.backgroundColor = UIColorFromRGB(0xFFFFFF);
    [self.view addSubview: _allCollectionView];
}

    //返回collection view里区(section)的个数，如果没有实现该方法，将默认返回1：
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}

    //返回指定区(section)包含的数据源条目数(number of items)，该方法必须实现：
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 4;
    } else if (section == 1) {
        return 9;
    } else {
        return 5;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    AllApplicationReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                            withReuseIdentifier:@"AllApplicationReusableView"
                                                                                   forIndexPath:indexPath];
    if (indexPath.section == 0) {
        headView.titleLab.text = @"能源管理";
    } else if (indexPath.section == 1) {
        headView.titleLab.text = @"消防";
    } else {
        headView.titleLab.text = @"";
    }
    return headView;
}
    //返回某个indexPath对应的cell，该方法必须实现：
- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AllApplicationCollectionViewCell *cell =  [collectionView dequeueReusableCellWithReuseIdentifier:@"AllApplicationCollectionViewCell" forIndexPath:indexPath];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        return CGSizeMake(SCREEN_WIDTH, 54.0f);
    } else {
        return CGSizeMake(SCREEN_WIDTH, 24.0f);
    }
}
    //设定collectionView(指定区)的边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 8, 16,8);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
        return CGSizeMake((SCREEN_WIDTH-16.0f)/4.0f,(SCREEN_WIDTH-16.0f)/4.0f);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0f;
}
    //点击每个item实现的方法：
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end

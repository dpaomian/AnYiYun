//
//  YYSegmentedView.m
//  AnYiYun
//
//  Created by 韩亚周 on 17/7/24.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "YYSegmentedView.h"

@implementation YYSegmentedView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderColor = UIColorFromRGB(0xF0F0F0).CGColor;
        self.layer.borderWidth = 0.88f;
        
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
        
        self.collectionView=[[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        [_collectionView registerNib:[UINib nibWithNibName:@"YYSegmentedCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"YYSegmentedCollectionCell"];
        _collectionView.delegate=self;
        _collectionView.dataSource=self;
        _collectionView.scrollsToTop = NO;
        _collectionView.showsHorizontalScrollIndicator=NO;
        _collectionView.backgroundColor = UIColorFromRGB(0xFFFFFF);
        _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        _collectionView.allowsMultipleSelection = NO;
        [self addSubview:_collectionView];
        
        [self addConstraints:[NSLayoutConstraint
                              constraintsWithVisualFormat:@"H:|[_collectionView]|"
                              options:1.0
                              metrics:nil
                              views:NSDictionaryOfVariableBindings(_collectionView)]];
        [self addConstraints:[NSLayoutConstraint
                              constraintsWithVisualFormat:@"V:|[_collectionView]|"
                              options:1.0
                              metrics:nil
                              views:NSDictionaryOfVariableBindings(_collectionView)]];
    }
    return self;
}

- (void)setTitlesArray:(NSArray *)titlesArray {
    _titlesArray = titlesArray;
    [_collectionView reloadData];
}

#pragma mark -
#pragma mark UICollectionViewDataSource -
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.titlesArray count];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YYSegmentedCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YYSegmentedCollectionCell" forIndexPath:indexPath];
    cell.titleLable.text = [NSString stringWithFormat:@"%@",_titlesArray[indexPath.row]];
    if (indexPath.row == _selectedIndex) {
        cell.selected = YES;
        [cell.lineButton setBackgroundColor:UIColorFromRGB(0x5987F8)];
        cell.titleLable.textColor = UIColorFromRGB(0x5987F8);
    } else {
        cell.selected = NO;
        [cell.lineButton setBackgroundColor:UIColorFromRGBA(0x5987F8, 0.0)];
        cell.titleLable.textColor = UIColorFromRGB(0x000000);
    }
    return cell;
}
#pragma mark -
#pragma mark UICollectionViewDelegate -
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView reloadData];
    if (_itemHandle) {
        _itemHandle(self, indexPath.row);
    }
}
#pragma mark -
#pragma mark UICollectionViewDelegateFlowLayout -

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((SCREEN_WIDTH)/([_titlesArray count]), 44.0f);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0f;
}

@end

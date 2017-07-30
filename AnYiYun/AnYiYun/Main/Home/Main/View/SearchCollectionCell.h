//
//  SearchCollectionCell.h
//  AnYiYun
//
//  Created by 韩亚周 on 2017/7/30.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchCollectionCell : UICollectionViewCell <UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;
@property (copy, nonatomic) void (^searchBarTextDidChange) (SearchCollectionCell *barCell, UISearchBar *bar);
@property (copy, nonatomic) void (^searchBarSearchButtonClicked) (SearchCollectionCell *barCell, UISearchBar *bar);

@end

//
//  SearchCollectionCell.m
//  AnYiYun
//
//  Created by 韩亚周 on 2017/7/30.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "SearchCollectionCell.h"

@implementation SearchCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.searchBar.delegate = self;
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchText
{
    NSLog(@"----textDidChange------");
    // 调用filterBySubstring:方法执行搜索
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"----searchBarSearchButtonClicked------");
    // 调用filterBySubstring:方法执行搜索
    NSLog(@"%@",searchBar.text);
    // 放弃作为第一个响应者，关闭键盘
    [searchBar resignFirstResponder];
}

@end

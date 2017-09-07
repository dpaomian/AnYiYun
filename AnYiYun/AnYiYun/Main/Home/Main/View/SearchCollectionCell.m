//
//  SearchCollectionCell.m
//  AnYiYun
//
//  Created by 韩亚周 on 2017/7/30.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

#import "SearchCollectionCell.h"

@implementation SearchCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.searchBar.delegate = self;
    
    __weak SearchCollectionCell *ws = self;
    
    [self.okBtn buttonClickedHandle:^(UIButton *sender) {
        if (ws.searchBarSearchButtonClicked) {
            ws.searchBarSearchButtonClicked(ws,ws.searchBar);
        }
    }];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchText {
    NSLog(@"%@",searchBar.text);
    if (_searchBarTextDidChange) {
        _searchBarTextDidChange(self,searchBar);
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"%@",searchBar.text);
    if (_searchBarSearchButtonClicked) {
        _searchBarSearchButtonClicked(self,searchBar);
    }
    [searchBar resignFirstResponder];
}

@end

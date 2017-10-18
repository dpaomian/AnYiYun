//
//  YYNaverBottomView.m
//  AnYiYun
//
//  Created by 韩亚周 on 2017/10/18.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "YYNaverBottomView.h"

@implementation YYNaverBottomView

- (void)setLinksMutableArray:(NSMutableArray *)linksMutableArray {
    _linksMutableArray = linksMutableArray;
    [self.programmeTableView reloadData];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _programmeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame)) style:UITableViewStylePlain];
        _programmeTableView.delegate = self;
        _programmeTableView.dataSource = self;
//        _programmeTableView.scrollEnabled = NO;
        _programmeTableView.tableFooterView = [UIView new];
        [_programmeTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        [self addSubview:_programmeTableView];
    }
    return self;
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_linksMutableArray count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    AMapNaviLink *link = (AMapNaviLink *)_linksMutableArray[indexPath.row];
    NSString *roadNameString = @"";
    if (link.roadName == nil || [link.roadName isEqual:[NSNull null]]) {
        
    } else {
        roadNameString = link.roadName;
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %ld 米",roadNameString,link.length];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end

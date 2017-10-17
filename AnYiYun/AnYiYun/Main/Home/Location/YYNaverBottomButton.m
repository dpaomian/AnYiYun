//
//  YYNaverBottomButton.m
//  AnYiYun
//
//  Created by 韩亚周 on 2017/10/17.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "YYNaverBottomButton.h"

@implementation YYNaverBottomButton


- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    _programmeTableView.frame = CGRectMake(0, 0, CGRectGetWidth(bounds), CGRectGetHeight(bounds));
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _topButon = [UIButton buttonWithType:UIButtonTypeCustom];
        _topButon.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64.0f);
        [_topButon setBackgroundColor:[UIColor redColor]];
        [self addSubview:_topButon];
        
        
        _programmeTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _programmeTableView.delegate = self;
        _programmeTableView.dataSource = self;
        _programmeTableView.scrollEnabled = NO;
        _programmeTableView.tableFooterView = [UIView new];
        [_programmeTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        [self addSubview:_programmeTableView];
        _programmeTableView.tableHeaderView = _topButon;
    }
    return self;
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

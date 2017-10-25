//
//  YYPasswordViewController.m
//  AnYiYun
//
//  Created by 韩亚周 on 2017/10/25.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "YYPasswordViewController.h"

@interface YYPasswordViewController ()

@end

@implementation YYPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak YYPasswordViewController *ws = self;
    self.view.backgroundColor = UIColorFromRGBA(0x000000, 0.6f);
    
    [self.passwordTableView registerNib:[UINib nibWithNibName:NSStringFromClass([YYPswCell class]) bundle:nil] forCellReuseIdentifier:@"YYPswCell"];
    _passwordTableView.delegate = self;
    _passwordTableView.scrollEnabled = NO;
    _passwordTableView.dataSource = self;
    _passwordTableView.tableFooterView = [UIView new];
    _passwordTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [_close buttonClickedHandle:^(UIButton *sender) {
        [ws dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
}

#pragma mark -
#pragma mark UITableViewDataSource -

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 66.0f)];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 66.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0f;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YYPswCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YYPswCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    [cell.textField becomeFirstResponder];
    cell.inputOver = ^(YYPswCell *yyCell, NSString *yyStr) {
        DLog(@"密码:  %@",yyStr);
    };
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (SCREEN_WIDTH-80.0f)/6+34.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark UITableViewDelegate -

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

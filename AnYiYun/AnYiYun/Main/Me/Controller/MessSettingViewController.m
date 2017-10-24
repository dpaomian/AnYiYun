//
//  MessSettingViewController.m
//  AnYiYun
//
//  Created by 韩亚周 on 2017/10/17.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "MessSettingViewController.h"

@interface MessSettingViewController ()

@end

@implementation MessSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息设置";
    
    _messageSettingTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.messageSettingTableView registerNib:[UINib nibWithNibName:NSStringFromClass([EquipmentAccountHeaderFooterView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:@"EquipmentAccountHeaderFooterView"];
    [self.messageSettingTableView registerNib:[UINib nibWithNibName:NSStringFromClass([MessageStrategyCell class]) bundle:nil] forCellReuseIdentifier:@"MessageStrategyCell"];

    _messageSettingTableView.delegate = self;
    _messageSettingTableView.dataSource = self;
    _messageSettingTableView.allowsMultipleSelection = NO;
    _messageSettingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_messageSettingTableView];
    
    _listMutableArray = [NSMutableArray array];
    [self initData];
}

- (void)initData {
    for (int i =0; i <3; i ++) {
        MessageStrategyModel *model = [[MessageStrategyModel alloc] init];
        if (i == 0) {
            model.isSelected  = YES;
            model.needInput = YES;
            model.text1 = @"超过";
            model.textFieldText1 = @"500";
            model.text2 = @"条，清理最早的";
            model.textFieldText2 = @"300";
            model.text3 = @"条";
            model.field1MixValue = 50;
            model.field1MaxValue = 500;
            model.field2MixValue = 10;
            model.field2MaxValue = 300;
        } else if (i == 1) {
            model.isSelected  = NO;
            model.needInput = YES;
            model.text1 = @"超过";
            model.textFieldText1 = @"90";
            model.text2 = @"天，清理最早的";
            model.textFieldText2 = @"30";
            model.text3 = @"天";
            model.field1MixValue = 5;
            model.field1MaxValue = 90;
            model.field2MixValue = 5;
            model.field2MaxValue = 50;
        } else {
            model.isSelected  = NO;
            model.needInput = NO;
            model.text1 = @"我自己处理，无需自动清理";
            model.textFieldText1 = @"";
            model.text2 = @"";
            model.textFieldText2 = @"";
            model.text3 = @"";
            model.field1MixValue = 0;
            model.field1MaxValue = 0;
            model.field2MixValue = 0;
            model.field2MaxValue = 0;
        }
        [_listMutableArray addObject:model];
    }
}

#pragma mark -
#pragma mark UITableViewDelegate -

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return _listMutableArray.count;
    } else {
        return 1;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    EquipmentAccountHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"EquipmentAccountHeaderFooterView"];
    headerView.headerTitleLab.text = section==0?@"自动清理策略":@"通知铃声";
    headerView.headerTitleLab.textColor = UIColorFromRGB(0x000000);
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectZero];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0f;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageStrategyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageStrategyCell" forIndexPath:indexPath];
    MessageStrategyModel *cellModel = _listMutableArray[indexPath.row];
    cell.backgroundColor = [UIColor whiteColor];
    cell.lable1.text = cellModel.text1;
    cell.textField1.text = cellModel.textFieldText1;
    cell.lable2.text = cellModel.text2;
    cell.textField2.text = cellModel.textFieldText2;
    cell.lable3.text = cellModel.text3;
    cell.selectedBtn.selected = cellModel.isSelected;
    if (cellModel.isSelected) {
        cell.textField1.textColor = UIColorFromRGB(0x000000);
        cell.textField2.textColor = UIColorFromRGB(0x000000);
        cell.lineView1.backgroundColor = UIColorFromRGB(0xF44336);
        cell.lineView2.backgroundColor = UIColorFromRGB(0xF44336);
    } else {
        cell.textField1.textColor = UIColorFromRGB(0xCACACA);
        cell.textField2.textColor = UIColorFromRGB(0xCACACA);
        cell.lineView1.backgroundColor = UIColorFromRGB(0xCACACA);
        cell.lineView2.backgroundColor = UIColorFromRGB(0xCACACA);
    }
    if (cellModel.needInput) {
        if (cellModel.isSelected) {
            cell.textField1.userInteractionEnabled = YES;
            cell.textField2.userInteractionEnabled = YES;
        } else {
            cell.textField1.userInteractionEnabled = NO;
            cell.textField2.userInteractionEnabled = NO;
        }
    } else {
        cell.textField1.userInteractionEnabled = NO;
        cell.textField2.userInteractionEnabled = NO;
        cell.lineView1.backgroundColor = [UIColor clearColor];
        cell.lineView2.backgroundColor = [UIColor clearColor];
    }
    /*if (indexPath.row == 0) {
        cell.lable1.text = cellModel.text1;
        cell.textField1.text = cellModel.textFieldText1;
        cell.lable2.text = cellModel.text2;
        cell.textField2.text = cellModel.textFieldText2;
        cell.lable3.text = cellModel.text3;
        cell.textField1.textColor = UIColorFromRGB(0x000000);
        cell.textField2.textColor = UIColorFromRGB(0x000000);
        cell.lineView1.backgroundColor = UIColorFromRGB(0xF44336);
        cell.lineView2.backgroundColor = UIColorFromRGB(0xF44336);
        cell.selectedBtn.selected = cell.selected;
    } else if (indexPath.row == 1) {
        cell.lable1.text = @"超过";
        cell.textField1.text = @"90";
        cell.textField1.userInteractionEnabled = NO;
        cell.lable2.text = @"天，清理最早的";
        cell.textField2.text = @"50";
        cell.textField2.userInteractionEnabled = NO;
        cell.lable3.text = @"天";
        cell.textField1.textColor = UIColorFromRGB(0xF0F0F0);
        cell.textField2.textColor = UIColorFromRGB(0xF0F0F0);
        cell.lineView1.backgroundColor = UIColorFromRGB(0xF0F0F0);
        cell.lineView2.backgroundColor = UIColorFromRGB(0xF0F0F0);
        cell.selectedBtn.selected = cell.selected;
    } else {
        cell.lable1.text = @"我自己处理，无需自动清理";
        cell.textField1.text = @"";
        cell.textField1.userInteractionEnabled = NO;
        cell.lable2.text = @"";
        cell.textField2.text = @"";
        cell.textField2.userInteractionEnabled = NO;
        cell.lable3.text = @"";
        cell.lineView1.backgroundColor = [UIColor clearColor];
        cell.lineView2.backgroundColor = [UIColor clearColor];
        cell.selectedBtn.selected = cell.selected;
    }*/
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 38;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0) {
        __weak MessSettingViewController *ws = self;
        [_listMutableArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MessageStrategyModel *cellModel = ws.listMutableArray[idx];
            if (indexPath.row == idx) {
                cellModel.isSelected = YES;
            } else {
                cellModel.isSelected = NO;
            }
            [ws.listMutableArray replaceObjectAtIndex:idx withObject:cellModel];
        }];
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    } else {
        
    }
}

#pragma mark -
#pragma mark UITableViewDataSource -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

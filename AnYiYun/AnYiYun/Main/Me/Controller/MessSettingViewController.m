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
    
    __weak MessSettingViewController *ws = self;
    
    _listMutableArray = [NSMutableArray array];
    _currentModel = [[MessageStrategyModel alloc] init];
    _soundNameString = @"";
    
    _messageSettingTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.messageSettingTableView registerNib:[UINib nibWithNibName:NSStringFromClass([EquipmentAccountHeaderFooterView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:@"EquipmentAccountHeaderFooterView"];
    [self.messageSettingTableView registerNib:[UINib nibWithNibName:NSStringFromClass([MessageStrategyCell class]) bundle:nil] forCellReuseIdentifier:@"MessageStrategyCell"];
    [self.messageSettingTableView registerClass:[YYValue1Cell class] forCellReuseIdentifier:@"YYValue1Cell"];

    _messageSettingTableView.delegate = self;
    _messageSettingTableView.scrollEnabled = NO;
    _messageSettingTableView.dataSource = self;
    _messageSettingTableView.allowsMultipleSelection = NO;
    _messageSettingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_messageSettingTableView];
    
    _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _saveButton.frame = CGRectMake(SCREEN_WIDTH/2-80, 44*2+40*4+22, 160, 44);
    [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [_saveButton setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
    _saveButton.layer.cornerRadius = 4.0f;
    _saveButton.clipsToBounds = YES;
    [_saveButton setBackgroundColor:UIColorFromRGB(0x5987F8)];
    [_saveButton buttonClickedHandle:^(UIButton *sender) {
        if ([ws.currentModel.textFieldText1 integerValue] < ws.currentModel.field1MixValue ||[ws.currentModel.textFieldText1 integerValue] > ws.currentModel.field1MaxValue) {
            DLog(@"%ld~%ld之间的值",ws.currentModel.field1MixValue,ws.currentModel.field1MaxValue);
        } else if ([ws.currentModel.textFieldText2 integerValue] <= [ws.currentModel.textFieldText1 integerValue]) {
            DLog(@"必须小于%@",ws.currentModel.textFieldText1);
        } else if ([ws.currentModel.textFieldText2 integerValue] < ws.currentModel.field2MixValue ||[ws.currentModel.textFieldText2 integerValue] > ws.currentModel.field2MaxValue) {
            DLog(@"%ld~%ld之间的值",ws.currentModel.field2MixValue,ws.currentModel.field2MaxValue)
        }  else if ([ws.currentModel.textFieldText1 isEqualToString:@""] || [ws.currentModel.textFieldText2 isEqualToString:@""] ) {
            DLog(@"必填字段");
        } else {
            DLog(@"通过");
        }
    }];
    [_messageSettingTableView addSubview:_saveButton];
    
    
    [self initData];
}

- (void)initData {
    for (int i =0; i <3; i ++) {
        MessageStrategyModel *model = [[MessageStrategyModel alloc] init];
        if (i == 0) {
            model.idex = 0;
            model.isSelected  = YES;
            model.needInput = YES;
            model.text1 = @"超过";
            model.textFieldText1 = @"500";
            model.text2 = @"条，清理最早的";
            model.textFieldText2 = @"300";
            model.text3 = @"条";
            model.maxLength = 3;
            model.field1MixValue = 50;
            model.field1MaxValue = 500;
            model.field2MixValue = 10;
            model.field2MaxValue = 300;
            _currentModel = model;
        } else if (i == 1) {
            model.idex = 1;
            model.isSelected  = NO;
            model.needInput = YES;
            model.text1 = @"超过";
            model.textFieldText1 = @"90";
            model.text2 = @"天，清理最早的";
            model.textFieldText2 = @"30";
            model.text3 = @"天";
            model.maxLength = 2;
            model.field1MixValue = 5;
            model.field1MaxValue = 90;
            model.field2MixValue = 5;
            model.field2MaxValue = 50;
        } else {
            model.idex = 2;
            model.isSelected  = NO;
            model.needInput = NO;
            model.text1 = @"我自己处理，无需自动清理";
            model.textFieldText1 = @"";
            model.text2 = @"";
            model.textFieldText2 = @"";
            model.text3 = @"";
            model.maxLength = 0;
            model.field1MixValue = 0;
            model.field1MaxValue = 0;
            model.field2MixValue = 0;
            model.field2MaxValue = 0;
        }
        [_listMutableArray addObject:model];
    }
}

#pragma mark -
#pragma mark UITableViewDataSource -

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
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1.0f)];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1.0f;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        __weak MessSettingViewController *ws = self;
        MessageStrategyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageStrategyCell" forIndexPath:indexPath];
        MessageStrategyModel *cellModel = _listMutableArray[indexPath.row];
        cell.backgroundColor = [UIColor whiteColor];
        cell.lable1.text = cellModel.text1;
        cell.textField1.text = cellModel.textFieldText1;
        cell.lable2.text = cellModel.text2;
        cell.textField2.text = cellModel.textFieldText2;
        cell.lable3.text = cellModel.text3;
        cell.maxLength = cellModel.maxLength;
        cell.selectedBtn.selected = cellModel.isSelected;
        cell.textChangeHandle = ^(MessageStrategyCell *yyCell, UITextField *yytf, NSString *yyStr) {
            if (yytf == cell.textField1) {
                cellModel.textFieldText1 = yyStr;
            } else {
                cellModel.textFieldText2 = yyStr;
            }
            ws.currentModel = cellModel;
        };
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
        return cell;
    } else {
        YYValue1Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"YYValue1Cell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"新消息提示音";
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
        cell.textLabel.textColor = UIColorFromRGB(0x111111);
        cell.detailTextLabel.text = _soundNameString;
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 38;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    __weak MessSettingViewController *ws = self;
    if (indexPath.section==0) {
        [_listMutableArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MessageStrategyModel *cellModel = ws.listMutableArray[idx];
            if (indexPath.row == idx) {
                cellModel.isSelected = YES;
                _currentModel = cellModel;
            } else {
                cellModel.isSelected = NO;
            }
            [ws.listMutableArray replaceObjectAtIndex:idx withObject:cellModel];
        }];
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    } else {
        
        YYSoundTableViewController *soundVC = [[YYSoundTableViewController alloc] init];
        soundVC.saveHandle = ^(YYSoundTableViewController *sound, NSString *yyStr) {
            ws.soundNameString = yyStr;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        [self.navigationController pushViewController:soundVC animated:YES];
    }
}

#pragma mark -
#pragma mark UITableViewDelegate -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

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
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _soundDic = [NSMutableDictionary dictionaryWithDictionary:[NSDictionary dictionaryWithDictionary:[defaults objectForKey:@"YYSOUND"]]];
    
    _messageSettingTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.messageSettingTableView registerNib:[UINib nibWithNibName:NSStringFromClass([EquipmentAccountHeaderFooterView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:@"EquipmentAccountHeaderFooterView"];
    [self.messageSettingTableView registerNib:[UINib nibWithNibName:NSStringFromClass([MessageStrategyCell class]) bundle:nil] forCellReuseIdentifier:@"MessageStrategyCell"];
    [self.messageSettingTableView registerClass:[YYValue1Cell class] forCellReuseIdentifier:@"YYValue1Cell"];

    _messageSettingTableView.delegate = self;
    _messageSettingTableView.scrollEnabled = NO;
    _messageSettingTableView.dataSource = self;
    _messageSettingTableView.allowsMultipleSelection = NO;
    _messageSettingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _messageSettingTableView.backgroundColor = UIColorFromRGB(0xFFFFFF);
    [self.view addSubview:_messageSettingTableView];
    
    _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _saveButton.frame = CGRectMake(SCREEN_WIDTH/2-80, 44*2+40*4+22, 160, 44);
    [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [_saveButton setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
    _saveButton.layer.cornerRadius = 4.0f;
    _saveButton.clipsToBounds = YES;
    [_saveButton setBackgroundColor:UIColorFromRGB(0x5987F8)];
    [_saveButton buttonClickedHandle:^(UIButton *sender) {
        if (ws.currentModel.idex == 2) {
            
        } else {
            if ([ws.currentModel.textFieldText1 integerValue] < ws.currentModel.field1MixValue ||[ws.currentModel.textFieldText1 integerValue] > ws.currentModel.field1MaxValue) {
                DLog(@"%ld~%ld之间的值",ws.currentModel.field1MixValue,ws.currentModel.field1MaxValue);
                ws.currentModel.showAlertIcon1 = YES;
                ws.currentModel.showAlertView1 = YES;
                ws.currentModel.showAlertIcon2 = NO;
                ws.currentModel.showAlertView2 = NO;
                ws.currentModel.alertText = [NSString stringWithFormat:@"%ld~%ld之间的值",ws.currentModel.field1MixValue,ws.currentModel.field1MaxValue];
                [ws.messageSettingTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:ws.currentModel.idex inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            } else if ([ws.currentModel.textFieldText2 integerValue] >= [ws.currentModel.textFieldText1 integerValue]) {
                ws.currentModel.showAlertIcon1 = NO;
                ws.currentModel.showAlertView1 = NO;
                ws.currentModel.showAlertIcon2 = YES;
                ws.currentModel.showAlertView2 = YES;
                DLog(@"必须小于%@",ws.currentModel.textFieldText1);
                ws.currentModel.alertText = [NSString stringWithFormat:@"必须小于%@",ws.currentModel.textFieldText1];
                [ws.messageSettingTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:ws.currentModel.idex inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            } else if ([ws.currentModel.textFieldText2 integerValue] < ws.currentModel.field2MixValue ||[ws.currentModel.textFieldText2 integerValue] > ws.currentModel.field2MaxValue) {
                ws.currentModel.showAlertIcon1 = NO;
                ws.currentModel.showAlertView1 = NO;
                ws.currentModel.showAlertIcon2 = YES;
                ws.currentModel.showAlertView2 = YES;
                ws.currentModel.alertText = [NSString stringWithFormat:@"%ld~%ld之间的值",ws.currentModel.field2MixValue,ws.currentModel.field2MaxValue];
                [ws.messageSettingTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:ws.currentModel.idex inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                DLog(@"%ld~%ld之间的值",ws.currentModel.field2MixValue,ws.currentModel.field2MaxValue)
            }  else if ([ws.currentModel.textFieldText1 isEqualToString:@""] || [ws.currentModel.textFieldText2 isEqualToString:@""] ) {
                DLog(@"必填字段");
                ws.currentModel.alertText = @"必填字段";
                if ([ws.currentModel.textFieldText1 isEqualToString:@""]) {
                    ws.currentModel.showAlertIcon1 = YES;
                    ws.currentModel.showAlertView1 = YES;
                    ws.currentModel.showAlertIcon2 = NO;
                    ws.currentModel.showAlertView2 = NO;
                } else {
                    ws.currentModel.showAlertIcon1 = NO;
                    ws.currentModel.showAlertView1 = NO;
                    ws.currentModel.showAlertIcon2 = YES;
                    ws.currentModel.showAlertView2 = YES;
                }
                [ws.messageSettingTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:ws.currentModel.idex inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            } else {
                ws.currentModel.alertText = @"";
                ws.currentModel.showAlertIcon1 = NO;
                ws.currentModel.showAlertView1 = NO;
                ws.currentModel.showAlertIcon2 = NO;
                ws.currentModel.showAlertView2 = NO;
                DLog(@"通过");
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                MessageStrategyModel *model = ws.listMutableArray[ws.currentModel.idex];
                model.idex = ws.currentModel.idex;
                model.isSelected = ws.currentModel.isSelected;
                model.needInput = ws.currentModel.needInput;
                model.textFieldText1 = ws.currentModel.textFieldText1;
                model.textFieldText2 = ws.currentModel.textFieldText2;
                /*YYMS   YY Message Setting*/
                [ws.listMutableArray replaceObjectAtIndex:ws.currentModel.idex withObject:model];
                __block NSMutableArray *messageSettingArray = [NSMutableArray arrayWithArray:[NSArray arrayWithArray:[defaults objectForKey:@"YYMS"]]];
                [ws.listMutableArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    MessageStrategyModel *modelItem = obj;
                    if (modelItem.idex == ws.currentModel.idex) {
                        modelItem.isSelected = YES;
                    } else {
                        modelItem.isSelected = NO;
                    }
                    model.needInput = ws.currentModel.needInput;
                    model.textFieldText1 = ws.currentModel.textFieldText1;
                    model.textFieldText2 = ws.currentModel.textFieldText2;
                    [messageSettingArray replaceObjectAtIndex:idx withObject:@{@"idex":[NSString stringWithFormat:@"%ld",modelItem.idex],
                                                                               @"isSelected":[NSString stringWithFormat:@"%d",modelItem.isSelected],
                                                                               @"needInput":[NSString stringWithFormat:@"%d",modelItem.needInput],
                                                                               @"text1":modelItem.text1,
                                                                               @"textFieldText1":modelItem.textFieldText1,
                                                                               @"text2":modelItem.text2,
                                                                               @"textFieldText2":modelItem.textFieldText2,
                                                                               @"text3":modelItem.text3,
                                                                               @"maxLength":[NSString stringWithFormat:@"%ld",modelItem.maxLength],
                                                                               @"field1MixValue":[NSString stringWithFormat:@"%ld",modelItem.field1MixValue],
                                                                               @"field1MaxValue":[NSString stringWithFormat:@"%ld",modelItem.field1MaxValue],
                                                                               @"field2MixValue":[NSString stringWithFormat:@"%ld",modelItem.field2MixValue],
                                                                               @"field2MaxValue":[NSString stringWithFormat:@"%ld",modelItem.field2MaxValue]}];
                }];
                [defaults setObject:messageSettingArray forKey:@"YYMS"];
                [defaults synchronize];
                [MBProgressHUD showSuccess:@"保存成功"];
                [ws.navigationController popViewControllerAnimated:YES];
            }
        }
    }];
    
    [_messageSettingTableView addSubview:_saveButton];
    
    [self initData];
}

- (void)initData {
    __weak MessSettingViewController *ws = self;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *messageSettingArray = [NSArray arrayWithArray:[defaults objectForKey:@"YYMS"]];
    [_listMutableArray removeAllObjects];
    [messageSettingArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:obj];
        MessageStrategyModel *model = [[MessageStrategyModel alloc] init];
        model.showAlertIcon1 = NO;
        model.showAlertIcon2 = NO;
        model.showAlertView1 = NO;
        model.showAlertView2 = NO;
        model.alertText = @"";
        model.idex = [dic[@"idex"] integerValue];
        model.isSelected  = [dic[@"isSelected"] boolValue];
        model.needInput = [dic[@"needInput"] boolValue];
        model.text1 = dic[@"text1"];
        model.textFieldText1 = dic[@"textFieldText1"];
        model.text2 = dic[@"text2"];
        model.textFieldText2 =dic[@"textFieldText2"];
        model.text3 = dic[@"text3"];
        model.maxLength = [dic[@"maxLength"] integerValue];
        model.field1MixValue = [dic[@"field1MixValue"] integerValue];
        model.field1MaxValue = [dic[@"field1MaxValue"] integerValue];
        model.field2MixValue = [dic[@"field2MixValue"] integerValue];
        model.field2MaxValue = [dic[@"field2MaxValue"] integerValue];
        if ([dic[@"isSelected"] boolValue]) {
            ws.currentModel = model;
        }
        [ws.listMutableArray addObject:model];
    }];
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
    headerView.yybkView.backgroundColor = UIColorFromRGB(0xDBDBDB);
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
        MessageStrategyModel *cellModel = [[MessageStrategyModel alloc] init];
        cellModel = _listMutableArray[indexPath.row];
        cell.backgroundColor = [UIColor whiteColor];
        cell.lable1.text = cellModel.text1;
        cell.textField1.text = cellModel.textFieldText1;
        cell.lable2.text = cellModel.text2;
        cell.textField2.text = cellModel.textFieldText2;
        cell.lable3.text = cellModel.text3;
        cell.maxLength = cellModel.maxLength;
        cell.selectedBtn.selected = cellModel.isSelected;
        cell.textEditBeginHandle = ^(MessageStrategyCell *yyCell, UITextField *yytf){
            yyCell.alertImageView.hidden = YES;
            yyCell.alertImageView2.hidden = YES;
            yyCell.alertLabel1.hidden = YES;
            yyCell.alertLabel2.hidden = YES;
        };
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
            cell.backgroundColor = [UIColor clearColor];
        }
        if (cellModel.needInput) {
            if (cellModel.isSelected) {
                cell.textField1.userInteractionEnabled = YES;
                cell.textField2.userInteractionEnabled = YES;
                
                cell.alertLabel1.text = cellModel.alertText;
                cell.alertLabel2.text = cellModel.alertText;
                if (cellModel.showAlertIcon1) {
                    cell.textField1.rightViewMode = UITextFieldViewModeAlways;
                } else {
                    cell.textField1.rightViewMode = UITextFieldViewModeNever;
                }
                if (cellModel.showAlertIcon2) {
                    cell.textField2.rightViewMode = UITextFieldViewModeAlways;
                } else {
                    cell.textField2.rightViewMode = UITextFieldViewModeNever;
                }
                if (cellModel.showAlertView1) {
                    cell.alertImageView.hidden = NO;
                    cell.alertLabel1.hidden = NO;
                } else {
                    cell.alertImageView.hidden = YES;
                    cell.alertLabel1.hidden = YES;
                }
                if (cellModel.showAlertView2) {
                    cell.alertImageView2.hidden = NO;
                    cell.alertLabel2.hidden = NO;
                } else {
                    cell.alertImageView2.hidden = YES;
                    cell.alertLabel2.hidden = YES;
                }
            } else {
                cell.textField1.userInteractionEnabled = NO;
                cell.textField2.userInteractionEnabled = NO;
                
                cell.alertLabel1.text = cellModel.alertText;
                cell.alertLabel2.text = cellModel.alertText;
                cell.textField1.rightViewMode = UITextFieldViewModeNever;
                cell.textField2.rightViewMode = UITextFieldViewModeNever;
                cell.alertImageView.hidden = YES;
                cell.alertLabel1.hidden = YES;
                cell.alertImageView2.hidden = YES;
                cell.alertLabel2.hidden = YES;
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
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12.0f];
        cell.textLabel.textColor = UIColorFromRGB(0x111111);
        cell.detailTextLabel.text = _soundDic[[[_soundDic allKeys] firstObject]];
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 46;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    __weak MessSettingViewController *ws = self;
    if (indexPath.section==0) {
        [_listMutableArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MessageStrategyModel *cellModel = ws.listMutableArray[idx];
            if (indexPath.row == idx) {
                cellModel.isSelected = YES;
                ws.currentModel = cellModel;
            } else {
                cellModel.isSelected = NO;
            }
            [ws.listMutableArray replaceObjectAtIndex:idx withObject:cellModel];
        }];
//        [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        [tableView reloadData];
    } else {
        
        YYSoundTableViewController *soundVC = [[YYSoundTableViewController alloc] init];
        soundVC.selectedDic = _soundDic;
        soundVC.saveHandle = ^(YYSoundTableViewController *sound, NSDictionary *yySoundDic) {
            [ws.soundDic removeAllObjects];
            [ws.soundDic addEntriesFromDictionary:yySoundDic];
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

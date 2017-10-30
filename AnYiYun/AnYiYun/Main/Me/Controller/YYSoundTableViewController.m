//
//  YYSoundTableViewController.m
//  AnYiYun
//
//  Created by 韩亚周 on 2017/10/26.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "YYSoundTableViewController.h"

@interface YYSoundTableViewController ()

@end

@implementation YYSoundTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _soundMutableArray = [NSMutableArray array];
        
    _sound = kSystemSoundID_Vibrate;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"sound" ofType:@"plist"];
    NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:path];
    _soundDictionary = [NSDictionary dictionaryWithDictionary:dic];
    
    NSArray *array=[dic keysSortedByValueUsingSelector:@selector(compare:)];
    [_soundMutableArray addObjectsFromArray:array];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YYSoundSelectedCell class]) bundle:nil] forCellReuseIdentifier:@"YYSoundSelectedCell"];
    self.tableView.allowsMultipleSelection = NO;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(yySave:)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)yySave:(UIBarButtonItem *)sender {
    _saveHandle(self, _soundDictionary[self.selectedDic]);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_soundDictionary forKey:@"YYSOUND"];
    [defaults synchronize];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _soundMutableArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YYSoundSelectedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YYSoundSelectedCell" forIndexPath:indexPath];
    NSString *key = _soundMutableArray[indexPath.row];
    
    if ([key isEqualToString:[[_selectedDic allKeys] firstObject]]) {
        cell.selected = YES;
    } else {
        cell.selected = NO;
    }
    cell.selectedStateButton.selected = cell.selected;
    cell.textLabel.text = [NSString stringWithFormat:@"%@",_soundDictionary[key]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *key = _soundMutableArray[indexPath.row];
    _selectedDic = [@{key:_soundDictionary[key]} mutableCopy];
    [tableView reloadData];
    _sound=[[key isEqualToString:@"999"]?@"1007":key intValue];
    AudioServicesPlaySystemSound(_sound);//播放声音
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);//静音模式下震动
}

@end

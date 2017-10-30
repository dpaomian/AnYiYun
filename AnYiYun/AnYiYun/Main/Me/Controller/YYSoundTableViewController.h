//
//  YYSoundTableViewController.h
//  AnYiYun
//
//  Created by 韩亚周 on 2017/10/26.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "BaseTableViewController.h"
#import "YYSoundSelectedCell.h"

@interface YYSoundTableViewController : BaseTableViewController

@property (nonatomic, strong) NSDictionary *soundDictionary;
@property (nonatomic, strong) NSMutableArray *soundMutableArray;
@property (nonatomic, strong) NSMutableDictionary      *selectedDic;
@property (nonatomic, assign) SystemSoundID sound;

@property (nonatomic, copy) void (^saveHandle) (YYSoundTableViewController *sound, NSDictionary *yySoundDic);

@end

//
//  YYPswCell.h
//  AnYiYun
//
//  Created by 韩亚周 on 2017/10/26.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYPswCell : UITableViewCell <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIView *supperV;

@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UIImageView *no1;
@property (strong, nonatomic) IBOutlet UIImageView *no2;
@property (strong, nonatomic) IBOutlet UIImageView *no3;
@property (strong, nonatomic) IBOutlet UIImageView *no4;
@property (strong, nonatomic) IBOutlet UIImageView *no5;
@property (strong, nonatomic) IBOutlet UIImageView *no6;

@property (nonatomic, copy) void (^inputOver) (YYPswCell *yyCell, NSString *yyStr);

@end

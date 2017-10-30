//
//  MessageStrategyCell.h
//  AnYiYun
//
//  Created by 韩亚周 on 2017/10/22.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageStrategyCell : UITableViewCell <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;
@property (weak, nonatomic) IBOutlet UILabel *lable1;
@property (weak, nonatomic) IBOutlet UITextField *textField1;
@property (weak, nonatomic) IBOutlet UILabel *lable2;
@property (weak, nonatomic) IBOutlet UIView *lineView1;
@property (weak, nonatomic) IBOutlet UILabel *lable3;
@property (weak, nonatomic) IBOutlet UIView *lineView2;
@property (weak, nonatomic) IBOutlet UIImageView *alertImageView;
@property (strong, nonatomic) IBOutlet UIImageView *alertImageView2;
@property (strong, nonatomic) IBOutlet UILabel *alertLabel1;
@property (strong, nonatomic) IBOutlet UILabel *alertLabel2;

@property (weak, nonatomic) IBOutlet UITextField *textField2;

@property (nonatomic, assign) NSInteger   maxLength;

@property (nonatomic, copy) void (^textEditBeginHandle) (MessageStrategyCell *yyCell, UITextField *yytf);
@property (nonatomic, copy) void (^textChangeHandle) (MessageStrategyCell *yyCell, UITextField *yytf, NSString *yyStr);

@end

//
//  MessageStrategyModel.h
//  AnYiYun
//
//  Created by 韩亚周 on 2017/10/23.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageStrategyModel : NSObject

@property (nonatomic, assign) BOOL   isSelected;
@property (nonatomic, assign) BOOL   needInput;
@property (nonatomic,strong)NSString *text1;
@property (nonatomic,strong)NSString *textFieldText1;
@property (nonatomic,strong)NSString *text2;
@property (nonatomic,strong)NSString *textFieldText2;
@property (nonatomic,strong)NSString *text3;

@property (nonatomic, assign) NSInteger   field1MixValue;
@property (nonatomic, assign) NSInteger   field1MaxValue;
@property (nonatomic, assign) NSInteger   field2MixValue;
@property (nonatomic, assign) NSInteger   field2MaxValue;

@end

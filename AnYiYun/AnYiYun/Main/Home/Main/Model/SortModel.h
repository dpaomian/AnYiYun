//
//  SortModel.h
//  AnYiYun
//
//  Created by 韩亚周 on 17/7/25.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!筛选条件的排序model*/
@interface SortModel : NSObject

+ (instancetype)shareModel;

@property (nonatomic, strong) NSDictionary *dic;

@end

//
//  SortModel.h
//  AnYiYun
//
//  Created by 韩亚周 on 17/7/25.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!筛选条件的排序model*/
@interface SortModel : NSObject

+ (instancetype)shareModel;

@property (nonatomic, copy) NSString *idF;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) BOOL   isSelected;

@end

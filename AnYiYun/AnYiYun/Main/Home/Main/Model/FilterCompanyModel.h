//
//  FilterCompanyModel.h
//  AnYiYun
//
//  Created by 韩亚周 on 17/7/25.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!筛选条件的供电室model*/
@interface FilterCompanyModel : NSObject

+ (instancetype)shareModel;

@property (nonatomic, copy) NSString *idF;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *companyId;
@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, copy) NSString *sort;
@property (nonatomic, copy) NSString *lev;
@property (nonatomic, copy) NSString *manager;
@property (nonatomic, copy) NSString *managerName;
@property (nonatomic, copy) NSString *partentId;
@property (nonatomic, copy) NSString *partentName;
@property (nonatomic, copy) NSString *sign;
@property (nonatomic, copy) NSString *delFlag;
@property (nonatomic, assign) BOOL   isSelected;

@end

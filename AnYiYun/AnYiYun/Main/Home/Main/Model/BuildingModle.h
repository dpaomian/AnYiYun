//
//  BuildingModle.h
//  AnYiYun
//
//  Created by 韩亚周 on 17/7/25.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!筛选条件的楼model*/
@interface BuildingModle : NSObject

+ (instancetype)shareModel;

@property (nonatomic, copy) NSString *idF;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pid;
@property (nonatomic, assign) BOOL   isSelected;

@end

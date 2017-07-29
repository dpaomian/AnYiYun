//
//  DeviceInfoModel.h
//  AnYiYun
//
//  Created by wuwanru on 29/7/17.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MessageModel.h"

@interface DeviceInfoModel : NSObject

@property (nonatomic,assign) NSInteger deviceId;
@property (nonatomic,strong) NSString  *staId;
@property (nonatomic,strong) NSString  *staName;
@property (nonatomic,assign) NSInteger  parentId;
@property (nonatomic,strong) NSString *parentName;
@property (nonatomic,strong) NSString *sign;
@property (nonatomic,assign) NSInteger kind;
@property (nonatomic,strong) NSString *kindValue;
@property (nonatomic,strong) NSString *device_description;
@property (nonatomic,strong) NSString *assetId;
@property (nonatomic,strong) NSString *modle;
@property (nonatomic,assign) NSInteger manufacturer;
@property (nonatomic,strong) NSString *makerName;
@property (nonatomic,assign) NSInteger supplier;
@property (nonatomic,strong) NSString *sellerName;
@property (nonatomic,assign) NSInteger org;
@property (nonatomic,strong) NSString *orgName;
@property (nonatomic,strong) NSString *installationSite;
@property (nonatomic,strong) NSString *position;
@property (nonatomic,strong) NSString *purchaseTime;
@property (nonatomic,strong) NSString *purchaseMethod;
@property (nonatomic,assign) NSInteger originalValue;
@property (nonatomic,assign) NSInteger netValue;
@property (nonatomic,assign) NSInteger amanager;
@property (nonatomic,strong) NSString *aManagerName;
@property (nonatomic,assign) NSInteger discarded;
@property (nonatomic,strong) NSString *func_day;
@property (nonatomic,assign) NSInteger device_state;
@property (nonatomic,assign) NSInteger fmanager;
@property (nonatomic,strong) NSString *fManagerName;
@property (nonatomic,assign) NSInteger state;
@property (nonatomic,strong) NSString *stateValue;
@property (nonatomic,assign) NSInteger lastStopId;
@property (nonatomic,assign) NSInteger wmanager;
@property (nonatomic,strong) NSString *wManagerName;
@property (nonatomic,assign) NSInteger checkCycle;
@property (nonatomic,assign) NSInteger checkCd;
@property (nonatomic,assign) NSInteger patrolCycle;
@property (nonatomic,assign) NSInteger patrolCd;
@property (nonatomic,assign) NSInteger upkeepCycle;
@property (nonatomic,assign) NSInteger upkeepCd;
@property (nonatomic,strong) NSString *lastRepairTime;
@property (nonatomic,strong) NSString *sid;

@end


@interface DeviceDocModel : NSObject

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *url;
@property (nonatomic,strong) NSString *suffix;
@property (nonatomic,assign) NSInteger size;

@end



@interface DevicePartModel : NSObject

@property (nonatomic,strong) NSString *partId;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *product_time;
@property (nonatomic,strong) NSString *specification;
@property (nonatomic,strong) NSString *manufacturer;
@property (nonatomic,assign) NSInteger number;

@end


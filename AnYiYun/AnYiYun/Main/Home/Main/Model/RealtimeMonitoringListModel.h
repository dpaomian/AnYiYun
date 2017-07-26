//
//  RealtimeMonitoringListModel.h
//  AnYiYun
//
//  Created by 韩亚周 on 2017/7/27.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!实时监测列表的model*/
@interface RealtimeMonitoringListModel : NSObject

/*!设备安装位置*/
@property (nonatomic, copy) NSString *device_location;
/*!设备名称*/
@property (nonatomic, copy) NSString *device_name;
/*!设备编号*/
@property (nonatomic, copy) NSString *idF;
/*!设备类型*/
@property (nonatomic, copy) NSString *kind;
/*!部门ID*/
@property (nonatomic, copy) NSString *orgId;
/*!未知*/
@property (nonatomic, copy) NSString *sid;
/*!排序方式*/
@property (nonatomic, copy) NSString *sort;
/*!获取名称的首字母*/
@property (nonatomic, copy) NSString *sortKey;
/*! 设备状态（0(掉线)或1(正常),如果GDS掉线，设备状态变为0 */
@property (nonatomic, copy) NSString *state;
/*!是否为选中状态，如果选中对应的区则展开，默认折叠*/
@property (nonatomic, assign) BOOL   isFold;

@end

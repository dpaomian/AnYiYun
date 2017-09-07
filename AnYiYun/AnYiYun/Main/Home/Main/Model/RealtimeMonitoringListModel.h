//
//  RealtimeMonitoringListModel.h
//  AnYiYun
//
//  Created by 韩亚周 on 2017/7/27.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

/*!每个区的数据中一个对象*/
@interface RealtimeMonitoringListModelList : NSObject

/*!设备ID*/
@property (nonatomic, copy) NSString *device_id;
/*!设备名称*/
@property (nonatomic, copy) NSString *device_name;
/*!是否显示曲线图*/
@property (nonatomic, assign) BOOL   displayIcon;
/*!设备类型*/
@property (nonatomic, copy) NSString *idF;
/*!测点名称*/
@property (nonatomic, copy) NSString *point_name;
/*!测点状态*/
@property (nonatomic, copy) NSString *point_state;
/*!测点类型*/
@property (nonatomic, copy) NSString *point_type;
/*!测点数据单位*/
@property (nonatomic, copy) NSString *point_unit;
/*!测点值*/
@property (nonatomic, copy) NSString *point_value;
/*!测点Sid*/
@property (nonatomic, copy) NSString *sid;
/*!根据设备排序*/
@property (nonatomic, copy) NSString *sortDevice;
/*!装置ID*/
@property (nonatomic, copy) NSString *terminal_id;
/*!装置类型*/
@property (nonatomic, copy) NSString *terminal_type;

@end

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
/*!改对象中的子数据*/
@property (nonatomic, strong) NSMutableArray   *itemsMutableArray;

@end

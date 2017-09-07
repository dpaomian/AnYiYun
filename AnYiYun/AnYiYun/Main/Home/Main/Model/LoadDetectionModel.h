//
//  LoadDetectionModel.h
//  AnYiYun
//
//  Created by 韩亚周 on 2017/7/30.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!负荷检测*/
@interface LoadDetectionModel : NSObject

/*!设备安装位置*/
@property (nonatomic, copy) NSString *device_location;
/*!设备名称*/
@property (nonatomic, copy) NSString *device_name;
/*!设备名称*/
@property (nonatomic, copy) NSString *extend;
/*!设备编号*/
@property (nonatomic, copy) NSString *idF;
/*!设备类型*/
@property (nonatomic, copy) NSString *kind;
/*!部门ID*/
@property (nonatomic, copy) NSString *orgId;
/*!*/
@property (nonatomic, copy) NSString *pointState;
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

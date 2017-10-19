//
//  RouteCollectionViewInfo.h
//  AnYiYun
//
//  Created by 韩亚周 on 2017/10/18.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMapNaviKit/AMapNaviKit.h>

@interface RouteCollectionViewInfo : NSObject

@property (nonatomic, assign) NSInteger routeID;
//导航路径总长度(单位:米)
@property (nonatomic, assign) NSInteger routeLength;
///导航路线上红绿灯的总数
@property (nonatomic, assign) NSInteger routeTrafficLightCount;
///导航路径所需的时间(单位:秒)
@property (nonatomic, assign) NSInteger routeTime;
///导航路线的所有分段
@property (nonatomic, strong) NSArray<AMapNaviSegment *> *routeSegments;

@end

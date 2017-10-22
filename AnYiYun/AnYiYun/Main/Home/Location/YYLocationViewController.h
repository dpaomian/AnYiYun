//
//  YYLocationViewController.h
//  AnYiYun
//
//  Created by 韩亚周 on 2017/10/22.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "BaseViewController.h"

#import <MAMapKit/MAMapKit.h>
#import <AMapNaviKit/AMapNaviKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

#import "MessageModel.h"
#import "YYNaverTopView.h"
#import "YYNaverBottomButton.h"
#import "YYNaverBottomView.h"
#import "SpeechSynthesizer.h"
#import "UIButton+Category.h"
#import "RouteCollectionViewInfo.h"

#import "NaviPointAnnotation.h"
#import "SelectableOverlay.h"
#import "YYNaverTopView.h"

@interface YYLocationViewController : BaseViewController <MAMapViewDelegate, AMapNaviWalkManagerDelegate, AMapNaviRideManagerDelegate, AMapNaviDriveManagerDelegate, AMapLocationManagerDelegate,AMapNaviWalkViewDelegate,AMapNaviRideViewDelegate,AMapNaviDriveViewDelegate,AMapSearchDelegate>

@property (nonatomic,strong)MessageModel *itemModel;

@property (nonatomic,strong)NSString  *pushType;//区分哪个模块进入的

@property (nonatomic,strong)NSString *deviceIdString;//设备id
@property (nonatomic,strong)NSString *deviceNameString;//设备标题
@property (nonatomic,strong)NSString *deviceLocation;//设备位置


@property (nonatomic, strong) YYNaverTopView *mapTopView;
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) YYNaverBottomButton *mapBottomButton;
@property (nonatomic, strong) YYNaverBottomView *mapBottomListView;

/*!路径规划选项卡*/
@property (nonatomic, strong) YYSegmentedView *navTypesView;
@property (nonatomic, strong) AMapNaviWalkManager *walkManager;
@property (nonatomic, strong) AMapNaviRideManager *rideManager;
@property (nonatomic, strong) AMapNaviDriveManager *driveManager;

@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic, strong) AMapWalkingRouteSearchRequest *walkNavi;
@property (nonatomic, strong) AMapRidingRouteSearchRequest *rideNavi;
@property (nonatomic, strong) AMapDrivingRouteSearchRequest *driveNavi;
@property (nonatomic, strong) AMapTransitRouteSearchRequest *transitNavi;

@property (nonatomic, strong) NSMutableArray *walkLinksMutableArray;
@property (nonatomic, strong) NSMutableArray *rideLinksMutableArray;
@property (nonatomic, strong) NSMutableArray *driveLinksMutableArray;
@property (nonatomic, strong) NSMutableArray *transitRouteLinksMutableArray;

@property (nonatomic, strong) AMapNaviWalkView *walkView;
@property (nonatomic, strong) AMapNaviRideView *rideView;
@property (nonatomic, strong) AMapNaviDriveView *driveView;

@property (nonatomic, strong) UIButton *nearButton;
@property (nonatomic, strong) UIButton *shortButton;
@property (nonatomic, strong) UIButton *unKnowButton;

@property (nonatomic, strong) AMapNaviPoint *startPoint;
@property (nonatomic, strong) AMapNaviPoint *endPoint;

@property (nonatomic, strong) AMapLocationManager *locationManager;

@property (nonatomic, strong) NSMutableArray *routeIndicatorInfoArray;
@property (nonatomic, strong) NSMutableArray *startAndEndPointArray;

@end

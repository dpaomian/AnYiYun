//
//  LocationViewController.m
//  AnYiYun
//
//  Created by 韩亚周 on 2017/7/27.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

#import "LocationViewController.h"

#import "NaviPointAnnotation.h"
#import "SelectableOverlay.h"
#import "YYNaverTopView.h"

@interface LocationViewController () <MAMapViewDelegate, AMapNaviWalkManagerDelegate, AMapNaviRideManagerDelegate, AMapNaviDriveManagerDelegate, AMapLocationManagerDelegate,AMapNaviWalkViewDelegate,AMapNaviRideViewDelegate,AMapNaviDriveViewDelegate,AMapSearchDelegate>

@property (nonatomic, strong) AMapNaviPoint *startPoint;
@property (nonatomic, strong) AMapNaviPoint *endPoint;

@property (nonatomic, strong) AMapLocationManager *locationManager;

@property (nonatomic, strong) NSMutableArray *routeIndicatorInfoArray;
@property (nonatomic, strong) NSMutableArray *startAndEndPointArray;

@end

@implementation LocationViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:kAPPNavColor];
    
    [self configLocationManager];
    [self getUseDataRequest];
    
    _walkLinksMutableArray = [NSMutableArray array];
    _rideLinksMutableArray = [NSMutableArray array];
    _driveLinksMutableArray = [NSMutableArray array];
    _transitRouteLinksMutableArray = [NSMutableArray array];
    
    [self initProperties];
    
    [self initMapView];
    
    [self initWalkManager];
    [self initSearch];
    [self initNavi];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self initRideManager];
        [self initDriveManager];
        [self initDriveButtons];
    });
}

//判断获取页面信息
-(NSString *)getMiddleRequestValue
{
    NSString *requestString = @"rest/initApp/position";
    if ([self.pushType isEqualToString:@"devicePatrol"])
    {
        requestString = @"rest/devicePatrol/position";
    }
    return requestString;
}

-(void)getUseDataRequest
{
    
    if (![BaseHelper checkNetworkStatus])
    {
        DLog(@"网络异常 请求被返回");
        [BaseHelper waringInfo:@"网络异常,请检查网络是否可用！"];
        return;
    }
    [MBProgressHUD showMessage:@""];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",BASE_PLAN_URL,[self getMiddleRequestValue]];
    NSDictionary *param = @{@"userSign":[PersonInfo shareInstance].accountID,
                            @"deviceId":self.deviceIdString};
    
    DLog(@"请求地址 urlString = %@?%@",urlString,[param serializeToUrlString]);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:urlString
      parameters:param
        progress:^(NSProgress * _Nonnull downloadProgress) {} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         [MBProgressHUD hideHUD];
         NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];

         DLog(@"定位请求回来的值 %@",string);
         if (string.length>0)
         {
             NSArray *pointArray = [string componentsSeparatedByString:@","];
             if (pointArray.count==2)
             {
                 double longitude = [[pointArray objectAtIndex:0] doubleValue];
                 double latitude = [[pointArray objectAtIndex:1] doubleValue];
                 DLog(@"%f------------%f",latitude,longitude);
                 self.endPoint   = [AMapNaviPoint locationWithLatitude:latitude longitude:longitude];
                 [self startSerialLocation];
             }
         }
     }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [MBProgressHUD hideHUD];
             DLog(@"请求失败：%@",error);
         }];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self initAnnotations];
}

- (void)configLocationManager {
    self.locationManager = [[AMapLocationManager alloc] init];
    
    [self.locationManager setDelegate:self];
    
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    
    [self.locationManager setAllowsBackgroundLocationUpdates:YES];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
}

- (void)startSerialLocation {
        //开始定位
    [self.locationManager startUpdatingLocation];
}

- (void)stopSerialLocation {
        //停止定位
    [self.locationManager stopUpdatingLocation];
}

- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error {
        //定位错误
    NSLog(@"%s, amapLocationManager = %@, error = %@", __func__, [manager class], error);
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location {
        //定位结果
    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    self.startPoint = [AMapNaviPoint locationWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
//    self.startPoint = [AMapNaviPoint locationWithLatitude:34.546428 longitude:113.491216];
    if (_navTypesView.selectedIndex == 0) {
        [self routePlanAction];
    } else if (_navTypesView.selectedIndex == 1) {
        [self routeRidePlanAction];
    } else if (_navTypesView.selectedIndex == 2) {
        [self singleRoutePlanAction];
    } else if (_navTypesView.selectedIndex == 3) {
        /*公交*/
        self.navi.city = @"zhengzhou";
        /* 出发点. */
        self.navi.origin = [AMapGeoPoint locationWithLatitude:self.startPoint.latitude
                                                  longitude:self.startPoint.longitude];
        /* 目的地. */
        self.navi.destination = [AMapGeoPoint locationWithLatitude:self.endPoint.latitude
                                                       longitude:self.endPoint.longitude];
        [self.search AMapTransitRouteSearch:self.navi];
    }
    [self stopSerialLocation];
}


#pragma mark - Initalization

- (void)initProperties
{
        //为了方便展示步行路径规划，选择了固定的起终点
    self.startPoint = [[AMapNaviPoint alloc] init];
    self.endPoint   = [[AMapNaviPoint alloc] init];
    
    self.routeIndicatorInfoArray = [NSMutableArray array];
    self.startAndEndPointArray = [NSMutableArray array];
}

- (void)initMapView
{
    _mapTopView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([YYNaverTopView class]) owner:nil options:nil][0];
    _mapTopView.backgroundColor = [UIColor redColor];
    _mapTopView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44.0f+25.0f);
    [self.view addSubview:_mapTopView];
    
    __weak LocationViewController *ws = self;
    
    _navTypesView = [[YYSegmentedView alloc] initWithFrame:CGRectMake(0.0f, 25.0f, SCREEN_WIDTH, 44.0f)];
    _navTypesView.backgroundColor = UIColorFromRGB(0x000000);
    [self.view addSubview:_navTypesView];
    _navTypesView.selectedIndex = 0;
    _navTypesView.titlesArray = @[@"步行",@"骑行",@"驾驶",@"公交"];
    _navTypesView.itemHandle = ^(YYSegmentedView *stateView, NSInteger index) {
        if (index == stateView.selectedIndex) {
            return ;
        }else {
            stateView.selectedIndex = index;
            if (index == 0) {
                ws.mapBottomListView.isTransit = NO;
                ws.mapBottomButton.center = CGPointMake(SCREEN_WIDTH/2.0f, SCREEN_HEIGHT - (64.0f/2.0f)-64.0f);
                ws.mapBottomListView.frame = CGRectMake(0, CGRectGetMaxY(ws.mapBottomButton.frame), SCREEN_WIDTH, SCREEN_HEIGHT-64.0f-44.0f-25.0f-64.0f);
                [ws.walkLinksMutableArray removeAllObjects];
                ws.mapBottomListView.linksMutableArray = ws.walkLinksMutableArray;
//                [ws routePlanAction];
                ws.nearButton.hidden = YES;
                ws.shortButton.hidden = YES;
                ws.unKnowButton.hidden = YES;
                ws.navBtn.hidden = NO;
                [ws startSerialLocation];
            } else if (index == 1) {
                ws.mapBottomListView.isTransit = NO;
                ws.mapBottomButton.center = CGPointMake(SCREEN_WIDTH/2.0f, SCREEN_HEIGHT - (64.0f/2.0f)-64.0f);
                ws.mapBottomListView.frame = CGRectMake(0, CGRectGetMaxY(ws.mapBottomButton.frame), SCREEN_WIDTH, SCREEN_HEIGHT-64.0f-44.0f-25.0f-64.0f);
                [ws startSerialLocation];
                [ws.rideLinksMutableArray removeAllObjects];
                ws.mapBottomListView.linksMutableArray = ws.rideLinksMutableArray;
//                [ws routeRidePlanAction];
                ws.nearButton.hidden = YES;
                ws.shortButton.hidden = YES;
                ws.unKnowButton.hidden = YES;
                ws.navBtn.hidden = NO;
                [ws startSerialLocation];
            } else if (index == 2) {
                ws.navBtn.hidden = NO;
                ws.mapBottomListView.isTransit = NO;
                ws.mapBottomButton.center = CGPointMake(SCREEN_WIDTH/2.0f, SCREEN_HEIGHT - (64.0f/2.0f)-64.0f);
                ws.mapBottomListView.frame = CGRectMake(0, CGRectGetMaxY(ws.mapBottomButton.frame), SCREEN_WIDTH, SCREEN_HEIGHT-64.0f-44.0f-25.0f-64.0f);
//                [ws singleRoutePlanAction];
                [ws startSerialLocation];
            } else {
                ws.navBtn.hidden = YES;
                ws.mapBottomListView.isTransit = YES;
                ws.mapBottomButton.center = CGPointMake(SCREEN_WIDTH/2.0f, SCREEN_HEIGHT);
                ws.mapBottomListView.frame = CGRectMake(0, 44.0+25.0, SCREEN_WIDTH, SCREEN_HEIGHT-64.0f-44.0f-25.0f);
                [ws startSerialLocation];
            }
        }
    };
    
    if (self.mapView == nil)
        {
        self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 44.0f+25.0f,
                                                                   self.view.bounds.size.width,
                                                                   self.view.bounds.size.height-64-44.0f-25.0f)];
        [self.mapView setDelegate:self];
        self.mapView.showsUserLocation = YES;
        [self.view addSubview:self.mapView];
        }
    
    UIButton *ret = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetHeight(self.mapView.frame)*2.0f/3.0f, 40, 40)];
    ret.backgroundColor = [UIColor whiteColor];
    ret.layer.cornerRadius = 20.0f ;
    
    [ret setImage:[UIImage imageNamed:@"gpsStat1"] forState:UIControlStateNormal];
    [ret addTarget:self action:@selector(gpsAction) forControlEvents:UIControlEventTouchUpInside];
    [self.mapView addSubview:ret];
    
    
    UIView *retView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.mapView.frame)-60.0f, CGRectGetHeight(self.mapView.frame)/2.0f, 53, 98)];
    
    UIButton *incBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 53, 49)];
    [incBtn setImage:[UIImage imageNamed:@"increase"] forState:UIControlStateNormal];
    [incBtn sizeToFit];
    [incBtn addTarget:self action:@selector(zoomPlusAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *decBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 49, 53, 49)];
    [decBtn setImage:[UIImage imageNamed:@"decrease"] forState:UIControlStateNormal];
    [decBtn sizeToFit];
    [decBtn addTarget:self action:@selector(zoomMinusAction) forControlEvents:UIControlEventTouchUpInside];
    
    [retView addSubview:incBtn];
    [retView addSubview:decBtn];
    [self.mapView addSubview:retView];
    
    _mapBottomButton = [YYNaverBottomButton buttonWithType:UIButtonTypeCustom];
    [_mapBottomButton setBackgroundColor:[UIColor whiteColor]];
    _mapBottomButton.bounds = CGRectMake(0, 0, SCREEN_WIDTH, 64.0f);
    _mapBottomButton.center = CGPointMake(SCREEN_WIDTH/2.0f, SCREEN_HEIGHT - (64.0f/2.0f)-64.0f);
    [_mapBottomButton addTarget:self action:@selector(dragMoving:withEvent: )forControlEvents: UIControlEventTouchDragInside];
    [_mapBottomButton addTarget:self action:@selector(dragEnded:withEvent: )forControlEvents: UIControlEventTouchUpInside |
     UIControlEventTouchUpOutside];
    [self.view addSubview:_mapBottomButton];
    
    _mapBottomListView = [[YYNaverBottomView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_mapBottomButton.frame), SCREEN_WIDTH, SCREEN_HEIGHT-64.0f-44.0f-25.0f-64.0f)];
    [self.view addSubview:_mapBottomListView];
    
    _mapBottomListView.didSelectRowAtIndexPath = ^(YYNaverBottomView *yyBottomView, YYTransitListModel *yyListModel, NSIndexPath * yyIndexPath){
        RoutePlanBusViewController *busVC = [[RoutePlanBusViewController alloc] init];
        busVC.route = yyListModel.route;
        busVC.currentCourse = yyIndexPath.row;
        [ws.navigationController pushViewController:busVC animated:YES];
    };
    
    _navBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-20-44.0f, SCREEN_HEIGHT-128.0f-22.0f, 44, 44)];
    _navBtn.backgroundColor =UIColorFromRGBA(0x5987F8, 0.6);
    _navBtn.layer.cornerRadius = 22.0f ;
    [_navBtn setImage:[UIImage imageNamed:@"default_navi_car_icon.png"] forState:UIControlStateNormal];
    [_navBtn addTarget:self action:@selector(navAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_navBtn];
    
    [self initWalkView];
    [self initRideView];
    [self initDriveView];
    
}

#pragma mark - Touch

- (void) dragMoving: (UIControl *) c withEvent:ev
{
    CGFloat yFloat =  [[[ev allTouches] anyObject] locationInView:self.view].y;
    if (yFloat <= 44.0f+25.0f+64.0f/2.0f) {
        yFloat = 44.0f+25.0f+64.0f/2.0f;
    }
    _mapBottomButton.center = CGPointMake(SCREEN_WIDTH/2.0f, yFloat);
    _mapBottomListView.frame = CGRectMake(0, CGRectGetMaxY(_mapBottomButton.frame), SCREEN_WIDTH, SCREEN_HEIGHT-64.0f-44.0f-25.0f-64.0f);
}

- (void) dragEnded: (UIControl *) c withEvent:ev
{
    CGFloat yFloat =  [[[ev allTouches] anyObject] locationInView:self.view].y;
    if (yFloat <= SCREEN_HEIGHT/2.0f) {
        _mapBottomButton.center = CGPointMake(SCREEN_WIDTH/2.0f, 44.0f+25.0f+64.0f/2.0f);
    }  else {
        _mapBottomButton.center = CGPointMake(SCREEN_WIDTH/2.0f, SCREEN_HEIGHT - (64.0f/2.0f)-64.0f);
    }
    _mapBottomListView.frame = CGRectMake(0, CGRectGetMaxY(_mapBottomButton.frame), SCREEN_WIDTH, SCREEN_HEIGHT-64.0f-44.0f-25.0f-64.0f);
}

#pragma mark - Action Handlers
- (void)gpsAction {
    if(self.mapView.userLocation.updating && self.mapView.userLocation.location) {
        [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:YES];
    }
}

/*!导航*/
- (void)navAction {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    if (_navTypesView.selectedIndex == 0) {
        self.walkView.hidden = NO;
        self.rideView.hidden = YES;
        self.driveView.hidden = YES;
        [self.walkManager startGPSNavi];
    } else if (_navTypesView.selectedIndex == 1) {
        self.walkView.hidden = YES;
        self.rideView.hidden = NO;
        self.driveView.hidden = YES;
        [self.rideManager startGPSNavi];
    } else if (_navTypesView.selectedIndex == 2) {
        self.walkView.hidden = YES;
        self.rideView.hidden = YES;
        self.driveView.hidden = NO;
        [self.driveManager startGPSNavi];
    } else if (_navTypesView.selectedIndex == 3) {
        /*公交*/
    }
}

- (void)zoomPlusAction
{
    CGFloat oldZoom = self.mapView.zoomLevel;
    [self.mapView setZoomLevel:(oldZoom + 1) animated:YES];
}

- (void)zoomMinusAction
{
    CGFloat oldZoom = self.mapView.zoomLevel;
    [self.mapView setZoomLevel:(oldZoom - 1) animated:YES];
}

- (void)initWalkManager {
    if (self.walkManager == nil) {
        self.walkManager = [[AMapNaviWalkManager alloc] init];
        [self.walkManager setDelegate:self];

        [self.walkManager setAllowsBackgroundLocationUpdates:YES];
        [self.walkManager setPausesLocationUpdatesAutomatically:NO];
        
        //将driveView添加为导航数据的Representative，使其可以接收到导航诱导数据
        [self.walkManager addDataRepresentative:self.walkView];
    }
}

- (void)initRideManager {
    if (self.rideManager == nil) {
        self.rideManager = [[AMapNaviRideManager alloc] init];
        [self.rideManager setDelegate:self];
        
        [self.rideManager setAllowsBackgroundLocationUpdates:YES];
        [self.rideManager setPausesLocationUpdatesAutomatically:NO];
        
        //将driveView添加为导航数据的Representative，使其可以接收到导航诱导数据
        [self.rideManager addDataRepresentative:self.rideView];
    }
}

- (void)initDriveManager {
    if (self.driveManager == nil) {
        self.driveManager = [[AMapNaviDriveManager alloc] init];
        [self.driveManager setDelegate:self];
        
        [self.driveManager setAllowsBackgroundLocationUpdates:YES];
        [self.driveManager setPausesLocationUpdatesAutomatically:NO];
        
        //将driveView添加为导航数据的Representative，使其可以接收到导航诱导数据
        [self.driveManager addDataRepresentative:self.driveView];
    }
}

- (void)initSearch {
    if (self.search == nil) {
        self.search = [[AMapSearchAPI alloc] init];
        self.search.delegate = self;
    }
}

- (void)initNavi {
    if (self.navi == nil) {
        self.navi = [[AMapTransitRouteSearchRequest alloc] init];
        _navi.requireExtension = YES;
    }
}

- (void)initWalkView {
    if (self.walkView == nil) {
        self.walkView = [[AMapNaviWalkView alloc] initWithFrame:self.view.bounds];
        self.walkView.hidden = YES;
        self.walkView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self.walkView setDelegate:self];
        [self.view addSubview:self.walkView];
    }
}

- (void)initRideView {
    if (self.rideView == nil) {
        self.rideView = [[AMapNaviRideView alloc] initWithFrame:self.view.bounds];
        self.rideView.hidden = YES;
        self.rideView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self.rideView setDelegate:self];
        [self.view addSubview:self.rideView];
    }
}

- (void)initDriveView {
    if (self.driveView == nil) {
        self.driveView = [[AMapNaviDriveView alloc] initWithFrame:self.view.bounds];
        self.driveView.hidden = YES;
        self.driveView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self.driveView setDelegate:self];
        [self.view addSubview:self.driveView];
    }
}

- (void)initDriveButtons {
    __weak LocationViewController *ws = self;
    if (self.nearButton == nil) {
        _nearButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nearButton setBackgroundColor:UIColorFromRGB(0xCACACA)];
        _nearButton.hidden = YES;
        _nearButton.selected = YES;
        _nearButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        _nearButton.titleLabel.numberOfLines = 0;
        [_nearButton setTitle:@"" forState:UIControlStateNormal];
        _nearButton.frame = CGRectMake(0, 0, SCREEN_WIDTH/4, 64);
        [_nearButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [_nearButton setTitleColor:UIColorFromRGB(0x5987F8) forState:UIControlStateSelected];
        _nearButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_nearButton buttonClickedHandle:^(UIButton *sender) {
            [ws selectNaviRouteWithID:[ws.routeIndicatorInfoArray[0] routeID]];
            [ws reloadRoadListWithIndex:0];
            sender.selected = YES;
            ws.shortButton.selected = NO;
            ws.unKnowButton.selected = NO;
            [sender setBackgroundColor:UIColorFromRGB(0xCACACA)];
            [ws.shortButton setBackgroundColor:UIColorFromRGB(0xFFFFFF)];
            [ws.unKnowButton setBackgroundColor:UIColorFromRGB(0xFFFFFF)];
        }];
        [self.mapBottomButton addSubview:_nearButton];
    }
    if (self.shortButton == nil) {
        _shortButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shortButton setBackgroundColor:UIColorFromRGB(0xFFFFFF)];
        _shortButton.hidden = YES;
        _shortButton.selected = NO;
        _shortButton.layer.borderColor = UIColorFromRGB(0xF0F0F0).CGColor;
        _shortButton.layer.borderWidth = 1.0f;
        _shortButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        _shortButton.titleLabel.numberOfLines = 0;
        [_shortButton setTitle:@"" forState:UIControlStateNormal];
        _shortButton.frame = CGRectMake(CGRectGetMaxX(_nearButton.frame), 0, SCREEN_WIDTH/4, 64);
        [_shortButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [_shortButton setTitleColor:UIColorFromRGB(0x5987F8) forState:UIControlStateSelected];
        _shortButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_shortButton buttonClickedHandle:^(UIButton *sender) {
            [ws selectNaviRouteWithID:[ws.routeIndicatorInfoArray[1] routeID]];
            [ws reloadRoadListWithIndex:1];
            sender.selected = YES;
            ws.nearButton.selected = NO;
            ws.unKnowButton.selected = NO;
            [sender setBackgroundColor:UIColorFromRGB(0xCACACA)];
            [ws.nearButton setBackgroundColor:UIColorFromRGB(0xFFFFFF)];
            [ws.unKnowButton setBackgroundColor:UIColorFromRGB(0xFFFFFF)];
        }];
        [self.mapBottomButton addSubview:_shortButton];
    }
    
    if (self.unKnowButton == nil) {
        _unKnowButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_unKnowButton setBackgroundColor:UIColorFromRGB(0xFFFFFF)];
        _unKnowButton.hidden = YES;
        _unKnowButton.selected = NO;
        _unKnowButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        _unKnowButton.titleLabel.numberOfLines = 0;
        [_unKnowButton setTitle:@"" forState:UIControlStateNormal];
        _unKnowButton.frame = CGRectMake(CGRectGetMaxX(_shortButton.frame), 0, SCREEN_WIDTH/4, 64);
        [_unKnowButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [_unKnowButton setTitleColor:UIColorFromRGB(0x5987F8) forState:UIControlStateSelected];
        _unKnowButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_unKnowButton buttonClickedHandle:^(UIButton *sender) {
            [ws selectNaviRouteWithID:[ws.routeIndicatorInfoArray[2] routeID]];
            [ws reloadRoadListWithIndex:2];
            sender.selected = YES;
            ws.nearButton.selected = NO;
            ws.shortButton.selected = NO;
            [sender setBackgroundColor:UIColorFromRGB(0xCCCCCC)];
            [ws.nearButton setBackgroundColor:UIColorFromRGB(0xFFFFFF)];
            [ws.shortButton setBackgroundColor:UIColorFromRGB(0xFFFFFF)];
        }];
        [self.mapBottomButton addSubview:_unKnowButton];
    }
    
    [_nearButton addTarget:self action:@selector(dragMoving:withEvent: )forControlEvents: UIControlEventTouchDragInside];
    [_nearButton addTarget:self action:@selector(dragEnded:withEvent: )forControlEvents: UIControlEventTouchUpInside |
     UIControlEventTouchUpOutside];
    [_shortButton addTarget:self action:@selector(dragMoving:withEvent: )forControlEvents: UIControlEventTouchDragInside];
    [_shortButton addTarget:self action:@selector(dragEnded:withEvent: )forControlEvents: UIControlEventTouchUpInside |
     UIControlEventTouchUpOutside];
    [_unKnowButton addTarget:self action:@selector(dragMoving:withEvent: )forControlEvents: UIControlEventTouchDragInside];
    [_unKnowButton addTarget:self action:@selector(dragEnded:withEvent: )forControlEvents: UIControlEventTouchUpInside |
     UIControlEventTouchUpOutside];
}

- (void)reloadRoadListWithIndex:(NSInteger)idx {
    RouteCollectionViewInfo *info = (RouteCollectionViewInfo *)self.routeIndicatorInfoArray[idx];
    [_driveLinksMutableArray removeAllObjects];
    for (AMapNaviSegment *naviSegment in info.routeSegments) {
        [_driveLinksMutableArray addObjectsFromArray:naviSegment.links];
    }
    _mapBottomListView.linksMutableArray = _walkLinksMutableArray;
    [self.driveManager addDataRepresentative:self.driveView];
}

- (void)initAnnotations {
    NaviPointAnnotation *beginAnnotation = [[NaviPointAnnotation alloc] init];
    [beginAnnotation setCoordinate:CLLocationCoordinate2DMake(self.startPoint.latitude, self.startPoint.longitude)];
    beginAnnotation.title = @"起点";
    beginAnnotation.navPointType = NaviPointAnnotationStart;


    NaviPointAnnotation *endAnnotation = [[NaviPointAnnotation alloc] init];
    [endAnnotation setCoordinate:CLLocationCoordinate2DMake(self.endPoint.latitude, self.endPoint.longitude)];
    endAnnotation.title = @"终点";
    endAnnotation.navPointType = NaviPointAnnotationEnd;

    [self.mapView removeAnnotations:_startAndEndPointArray];
    [_startAndEndPointArray removeAllObjects];
    [_startAndEndPointArray addObject:beginAnnotation];
    [_startAndEndPointArray addObject:endAnnotation];
    [self.mapView addAnnotations:_startAndEndPointArray];
}

#pragma mark - Button Action

- (void)routePlanAction
{
        //进行步行路径规划
    [self.walkManager calculateWalkRouteWithStartPoints:@[self.startPoint]
                                              endPoints:@[self.endPoint]];
}

- (void)routeRidePlanAction
{
    //进行步行路径规划
    [self.rideManager calculateRideRouteWithStartPoint:self.startPoint
                                              endPoint:self.endPoint];
}

- (void)singleRoutePlanAction
{
    /*
     多路径规划：是
     拥堵：最近不躲避；最快躲避
     高速：不走
     避免收费：最近避免；最快不避免
     高速有限：否
     */
    /**
     * @brief 将驾车路线规划的偏好设置转换为驾车路径规划策略.注意：当prioritiseHighway为YES时，将忽略avoidHighway和avoidCost的设置
     * @param multipleRoute 是否多路径规划
     * @param avoidCongestion 是否躲避拥堵
     * @param avoidHighway 是否不走高速
     * @param avoidCost 是否避免收费
     * @param prioritiseHighway 是否高速优先
     * @return AMapNaviDrivingStrategy路径规划策略
     */
    [self.driveManager calculateDriveRouteWithStartPoints:@[self.startPoint]
                                                endPoints:@[self.endPoint]
                                                wayPoints:nil
                                          drivingStrategy:ConvertDrivingPreferenceToDrivingStrategy(YES,nil,NO,NO,NO)];
    /*是否是单路线规划，避免拥堵，避免收费，不走高速，高速优先*/
}

#pragma mark - Handle Navi Routes

- (void)showNaviRoutes
{
    if (self.walkManager.naviRoute == nil)
        {
        return;
        }
    
    [self.mapView removeOverlays:self.mapView.overlays];
    [self.routeIndicatorInfoArray removeAllObjects];
    
        //将路径显示到地图上
    AMapNaviRoute *aRoute = self.walkManager.naviRoute;
    int count = (int)[[aRoute routeCoordinates] count];
    
        //添加路径Polyline
    CLLocationCoordinate2D *coords = (CLLocationCoordinate2D *)malloc(count * sizeof(CLLocationCoordinate2D));
    for (int i = 0; i < count; i++)
        {
        AMapNaviPoint *coordinate = [[aRoute routeCoordinates] objectAtIndex:i];
        coords[i].latitude = [coordinate latitude];
        coords[i].longitude = [coordinate longitude];
        }
    
    MAPolyline *polyline = [MAPolyline polylineWithCoordinates:coords count:count];
    
    SelectableOverlay *selectablePolyline = [[SelectableOverlay alloc] initWithOverlay:polyline];
    
    [self.mapView addOverlay:selectablePolyline];
    
    _mapBottomButton.titleLab.text = [NSString stringWithFormat:@"%ld%@",aRoute.routeLength<=1000?aRoute.routeLength:aRoute.routeLength/1000,aRoute.routeLength<=1000?@"米":@"千米"];
    if (aRoute.routeTime<=3600) {
        _mapBottomButton.contentLab.text = [NSString stringWithFormat:@"%ld%@  [上滑查看详情]",aRoute.routeTime/60,@"分"];
    } else {
        NSInteger minites = aRoute.routeTime%3600;
        NSInteger hours = (aRoute.routeTime-minites)/3600;
        _mapBottomButton.contentLab.text = [NSString stringWithFormat:@"%ld%@%ld%@  [上滑查看详情]",hours,@"小时",minites/60,@"分"];
    }
    
    [_walkLinksMutableArray removeAllObjects];
    for (AMapNaviSegment *naviSegment in aRoute.routeSegments) {
        [_walkLinksMutableArray addObjectsFromArray:naviSegment.links];
    }

    _mapBottomListView.linksMutableArray = _walkLinksMutableArray;

    free(coords);
    
    [self.mapView showAnnotations:self.mapView.annotations animated:NO];
}

- (void)showRideNaviRoutes
{
    if (self.rideManager.naviRoute == nil)
    {
        return;
    }
    
    [self.mapView removeOverlays:self.mapView.overlays];
    [self.routeIndicatorInfoArray removeAllObjects];
    
    //将路径显示到地图上
    AMapNaviRoute *aRoute = self.rideManager.naviRoute;
    int count = (int)[[aRoute routeCoordinates] count];
    
    //添加路径Polyline
    CLLocationCoordinate2D *coords = (CLLocationCoordinate2D *)malloc(count * sizeof(CLLocationCoordinate2D));
    for (int i = 0; i < count; i++)
    {
        AMapNaviPoint *coordinate = [[aRoute routeCoordinates] objectAtIndex:i];
        coords[i].latitude = [coordinate latitude];
        coords[i].longitude = [coordinate longitude];
    }
    
    MAPolyline *polyline = [MAPolyline polylineWithCoordinates:coords count:count];
    
    SelectableOverlay *selectablePolyline = [[SelectableOverlay alloc] initWithOverlay:polyline];
    
    [self.mapView addOverlay:selectablePolyline];
    free(coords);
    
    _mapBottomButton.titleLab.text = [NSString stringWithFormat:@"%ld%@",aRoute.routeLength<=1000?aRoute.routeLength:aRoute.routeLength/1000,aRoute.routeLength<=1000?@"米":@"千米"];
    if (aRoute.routeTime<=3600) {
        _mapBottomButton.contentLab.text = [NSString stringWithFormat:@"%ld%@  [上滑查看详情]",aRoute.routeTime/60,@"分"];
    } else {
        NSInteger minites = aRoute.routeTime%3600;
        NSInteger hours = (aRoute.routeTime-minites)/3600;
        _mapBottomButton.contentLab.text = [NSString stringWithFormat:@"%ld%@%ld%@  [上滑查看详情]",hours,@"小时",minites/60,@"分"];
    }
    
    [_rideLinksMutableArray removeAllObjects];
    for (AMapNaviSegment *naviSegment in aRoute.routeSegments) {
        [_rideLinksMutableArray addObjectsFromArray:naviSegment.links];
    }
    _mapBottomListView.linksMutableArray = _rideLinksMutableArray;

    [self.mapView showAnnotations:self.mapView.annotations animated:NO];
}

- (void)showDriveNaviRoutes
{
    if ([self.driveManager.naviRoutes count] <= 0)
    {
        return;
    }
    
    [self.mapView removeOverlays:self.mapView.overlays];
    [self.routeIndicatorInfoArray removeAllObjects];
    
    //将路径显示到地图上
    for (NSNumber *aRouteID in [self.driveManager.naviRoutes allKeys])
    {
        AMapNaviRoute *aRoute = [[self.driveManager naviRoutes] objectForKey:aRouteID];
        int count = (int)[[aRoute routeCoordinates] count];
        
        //添加路径Polyline
        CLLocationCoordinate2D *coords = (CLLocationCoordinate2D *)malloc(count * sizeof(CLLocationCoordinate2D));
        for (int i = 0; i < count; i++)
        {
            AMapNaviPoint *coordinate = [[aRoute routeCoordinates] objectAtIndex:i];
            coords[i].latitude = [coordinate latitude];
            coords[i].longitude = [coordinate longitude];
        }
        
        MAPolyline *polyline = [MAPolyline polylineWithCoordinates:coords count:count];
        
        SelectableOverlay *selectablePolyline = [[SelectableOverlay alloc] initWithOverlay:polyline];
        [selectablePolyline setRouteID:[aRouteID integerValue]];
        
        [self.mapView addOverlay:selectablePolyline];
        free(coords);
        
        RouteCollectionViewInfo *info = [[RouteCollectionViewInfo alloc] init];
        info.routeID = [aRouteID integerValue];
        info.routeSegments = aRoute.routeSegments;
        info.routeLength = (long)aRoute.routeLength;
        info.routeTrafficLightCount = (long)aRoute.routeTrafficLightCount;
        info.routeTime = (long)aRoute.routeTime;
        
        __weak LocationViewController *ws = self;
        [self.routeIndicatorInfoArray addObject:info];
        [self.routeIndicatorInfoArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            dispatch_async(dispatch_get_main_queue(), ^{
                RouteCollectionViewInfo *info = (RouteCollectionViewInfo *)obj;
                NSString *timeString = @"";
                if (info.routeTime == 3600 || info.routeTime < 3600) {
                    timeString = [NSString stringWithFormat:@"%ld%@",aRoute.routeTime/60,@"分"];
                } else {
                    NSInteger minites = aRoute.routeTime%3600;
                    NSInteger hours = (aRoute.routeTime-minites)/3600;
                    timeString = [NSString stringWithFormat:@"%ld%@%ld%@",hours,@"时",minites/60,@"分"];
                }
                if (idx == 0) {
                    ws.nearButton.hidden = NO;
                    [_nearButton setTitle:[NSString stringWithFormat:@"%ld%@\n%ld个红绿灯\n%@",info.routeLength<=1000?info.routeLength:info.routeLength/1000,info.routeLength<=1000?@"米":@"千米",info.routeTrafficLightCount,timeString] forState:UIControlStateNormal];
                } else if (idx == 1) {
                    ws.shortButton.hidden = NO;
                    [_shortButton setTitle:[NSString stringWithFormat:@"%ld%@\n%ld个红绿灯\n%@",info.routeLength<=1000?info.routeLength:info.routeLength/1000,info.routeLength<=1000?@"米":@"千米",info.routeTrafficLightCount,timeString] forState:UIControlStateNormal];

                } else if (idx == 2) {
                    ws.unKnowButton.hidden = NO;
                    [_unKnowButton setTitle:[NSString stringWithFormat:@"%ld%@\n%ld个红绿灯\n%@",info.routeLength<=1000?info.routeLength:info.routeLength/1000,info.routeLength<=1000?@"米":@"千米",info.routeTrafficLightCount,timeString] forState:UIControlStateNormal];

                } else {
                    *stop = YES;
                }
            });
        }];
        
        _mapBottomButton.titleLab.text = @"";
        _mapBottomButton.contentLab.text = @"";
    }
    
    [self.mapView showAnnotations:self.mapView.annotations animated:NO];
    
    [self selectNaviRouteWithID:[[self.routeIndicatorInfoArray firstObject] routeID]];
}

- (void)selectNaviRouteWithID:(NSInteger)routeID
{
    //在开始导航前进行路径选择
    if ([self.driveManager selectNaviRouteWithRouteID:routeID])
    {
        [self selecteOverlayWithRouteID:routeID];
    }
    else
    {
        NSLog(@"路径选择失败!");
    }
}

- (void)selecteOverlayWithRouteID:(NSInteger)routeID
{
    [self.mapView.overlays enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id<MAOverlay> overlay, NSUInteger idx, BOOL *stop)
     {
         if ([overlay isKindOfClass:[SelectableOverlay class]])
         {
             SelectableOverlay *selectableOverlay = overlay;
             
             /* 获取overlay对应的renderer. */
             MAPolylineRenderer * overlayRenderer = (MAPolylineRenderer *)[self.mapView rendererForOverlay:selectableOverlay];
             
             if (selectableOverlay.routeID == routeID)
             {
                 /* 设置选中状态. */
                 selectableOverlay.selected = YES;
                 
                 /* 修改renderer选中颜色. */
                 overlayRenderer.fillColor   = selectableOverlay.selectedColor;
                 overlayRenderer.strokeColor = selectableOverlay.selectedColor;
                 
                 /* 修改overlay覆盖的顺序. */
                 [self.mapView exchangeOverlayAtIndex:idx withOverlayAtIndex:self.mapView.overlays.count - 1];
             }
             else
             {
                 /* 设置选中状态. */
                 selectableOverlay.selected = NO;
                 
                 /* 修改renderer选中颜色. */
                 overlayRenderer.fillColor   = selectableOverlay.regularColor;
                 overlayRenderer.strokeColor = selectableOverlay.regularColor;
             }
             
             [overlayRenderer glRender];
         }
     }];
}

#pragma mark - SubViews

#pragma mark - AMapNaviDriveManager Delegate

- (void)walkManager:(AMapNaviWalkManager *)walkManager error:(NSError *)error
{
    NSLog(@"error:{%ld - %@}", (long)error.code, error.localizedDescription);
}

- (void)walkManagerOnCalculateRouteSuccess:(AMapNaviWalkManager *)walkManager
{
    NSLog(@"onCalculateRouteSuccess");
    //算路成功后显示路径
    [self showNaviRoutes];
}

- (void)walkManager:(AMapNaviWalkManager *)walkManager onCalculateRouteFailure:(NSError *)error
{
    NSLog(@"onCalculateRouteFailure:{%ld - %@}", (long)error.code, error.localizedDescription);
}

- (void)walkManager:(AMapNaviWalkManager *)walkManager didStartNavi:(AMapNaviMode)naviMode
{
    NSLog(@"didStartNavi");
}

- (void)walkManagerNeedRecalculateRouteForYaw:(AMapNaviWalkManager *)walkManager
{
    NSLog(@"needRecalculateRouteForYaw");
}

- (void)walkManager:(AMapNaviWalkManager *)walkManager playNaviSoundString:(NSString *)soundString soundStringType:(AMapNaviSoundType)soundStringType
{
    NSLog(@"playNaviSoundString:{%ld:%@}", (long)soundStringType, soundString);
    [[SpeechSynthesizer sharedSpeechSynthesizer] speakString:soundString];
}

- (void)walkManagerDidEndEmulatorNavi:(AMapNaviWalkManager *)walkManager
{
    NSLog(@"didEndEmulatorNavi");
}

- (void)walkManagerOnArrivedDestination:(AMapNaviWalkManager *)walkManager
{
    NSLog(@"onArrivedDestination");
}

#pragma mark - AMapNaviRideManager Delegate

- (void)rideManager:(AMapNaviRideManager *)rideManager error:(NSError *)error
{
    NSLog(@"error:{%ld - %@}", (long)error.code, error.localizedDescription);
}

- (void)rideManagerOnCalculateRouteSuccess:(AMapNaviRideManager *)rideManager
{
    NSLog(@"onCalculateRouteSuccess");
    
    //算路成功后显示路径
    [self showRideNaviRoutes];
}

- (void)rideManager:(AMapNaviRideManager *)rideManager onCalculateRouteFailure:(NSError *)error
{
    NSLog(@"onCalculateRouteFailure:{%ld - %@}", (long)error.code, error.localizedDescription);
}

- (void)rideManager:(AMapNaviRideManager *)rideManager didStartNavi:(AMapNaviMode)naviMode
{
    NSLog(@"didStartNavi");
}

- (void)rideManagerNeedRecalculateRouteForYaw:(AMapNaviRideManager *)rideManager
{
    NSLog(@"needRecalculateRouteForYaw");
}

- (void)rideManager:(AMapNaviRideManager *)rideManager playNaviSoundString:(NSString *)soundString soundStringType:(AMapNaviSoundType)soundStringType
{
    NSLog(@"playNaviSoundString:{%ld:%@}", (long)soundStringType, soundString);
    [[SpeechSynthesizer sharedSpeechSynthesizer] speakString:soundString];
}

- (void)rideManagerDidEndEmulatorNavi:(AMapNaviRideManager *)rideManager
{
    NSLog(@"didEndEmulatorNavi");
}

- (void)rideManagerOnArrivedDestination:(AMapNaviRideManager *)rideManager
{
    NSLog(@"onArrivedDestination");
}

#pragma mark - AMapNaviDriveManager Delegate

- (void)driveManager:(AMapNaviDriveManager *)driveManager error:(NSError *)error
{
    NSLog(@"error:{%ld - %@}", (long)error.code, error.localizedDescription);
}

- (void)driveManagerOnCalculateRouteSuccess:(AMapNaviDriveManager *)driveManager
{
    NSLog(@"onCalculateRouteSuccess");
    
    //算路成功后显示路径
    [self showDriveNaviRoutes];
}

- (void)driveManager:(AMapNaviDriveManager *)driveManager onCalculateRouteFailure:(NSError *)error
{
    NSLog(@"onCalculateRouteFailure:{%ld - %@}", (long)error.code, error.localizedDescription);
}

- (void)driveManager:(AMapNaviDriveManager *)driveManager didStartNavi:(AMapNaviMode)naviMode
{
    NSLog(@"didStartNavi");
}

- (void)driveManagerNeedRecalculateRouteForYaw:(AMapNaviDriveManager *)driveManager
{
    NSLog(@"needRecalculateRouteForYaw");
}

- (void)driveManagerNeedRecalculateRouteForTrafficJam:(AMapNaviDriveManager *)driveManager
{
    NSLog(@"needRecalculateRouteForTrafficJam");
}

- (void)driveManager:(AMapNaviDriveManager *)driveManager onArrivedWayPoint:(int)wayPointIndex
{
    NSLog(@"onArrivedWayPoint:%d", wayPointIndex);
}

- (BOOL)driveManagerIsNaviSoundPlaying:(AMapNaviDriveManager *)driveManager
{
    return [[SpeechSynthesizer sharedSpeechSynthesizer] isSpeaking];
}

- (void)driveManager:(AMapNaviDriveManager *)driveManager playNaviSoundString:(NSString *)soundString soundStringType:(AMapNaviSoundType)soundStringType
{
    NSLog(@"playNaviSoundString:{%ld:%@}", (long)soundStringType, soundString);
    [[SpeechSynthesizer sharedSpeechSynthesizer] speakString:soundString];
}

- (void)driveManagerDidEndEmulatorNavi:(AMapNaviDriveManager *)driveManager
{
    NSLog(@"didEndEmulatorNavi");
}

- (void)driveManagerOnArrivedDestination:(AMapNaviDriveManager *)driveManager
{
    NSLog(@"onArrivedDestination");
}

#pragma mark - MAMapView Delegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[NaviPointAnnotation class]])
        {
        static NSString *annotationIdentifier = @"NaviPointAnnotationIdentifier";
        
        MAPinAnnotationView *pointAnnotationView = (MAPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
        if (pointAnnotationView == nil)
            {
            pointAnnotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation
                                                                  reuseIdentifier:annotationIdentifier];
            }
        
        pointAnnotationView.animatesDrop   = NO;
        pointAnnotationView.canShowCallout = YES;
        pointAnnotationView.draggable      = NO;
        
        NaviPointAnnotation *navAnnotation = (NaviPointAnnotation *)annotation;
        
        if (navAnnotation.navPointType == NaviPointAnnotationStart)
            {
            [pointAnnotationView setPinColor:MAPinAnnotationColorGreen];
            }
        else if (navAnnotation.navPointType == NaviPointAnnotationEnd)
            {
            [pointAnnotationView setPinColor:MAPinAnnotationColorRed];
            }
        /* 起点. */
        if ([[annotation title] isEqualToString:@"起点"])
            {
            pointAnnotationView.image = [UIImage imageNamed:@"startPoint.png"];
            }
        /* 终点. */
        else if([[annotation title] isEqualToString:@"终点"])
            {
            pointAnnotationView.image = [UIImage imageNamed:@"endPoint.png"];
            }
        return pointAnnotationView;
        }
    return nil;
}

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[SelectableOverlay class]])
        {
        SelectableOverlay * selectableOverlay = (SelectableOverlay *)overlay;
        id<MAOverlay> actualOverlay = selectableOverlay.overlay;
        
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:actualOverlay];
        
        polylineRenderer.lineWidth = 4.f;
        polylineRenderer.strokeColor = selectableOverlay.isSelected ? selectableOverlay.selectedColor : selectableOverlay.regularColor;
        
        return polylineRenderer;
        }
    
    return nil;
}

#pragma mark - AMapNaviWalkViewDelegate
- (void)walkViewCloseButtonClicked:(AMapNaviWalkView *)walkView {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    //停止导航
    [self.walkManager stopNavi];
    [self.walkManager removeDataRepresentative:self.walkView];
    self.walkView.hidden = YES;
    //停止语音
    [[SpeechSynthesizer sharedSpeechSynthesizer] stopSpeak];
}

- (void)walkViewTrunIndicatorViewTapped:(AMapNaviWalkView *)walkView {
    NSLog(@"TrunIndicatorViewTapped");
}

- (void)walkView:(AMapNaviWalkView *)walkView didChangeShowMode:(AMapNaviWalkViewShowMode)showMode {
    NSLog(@"didChangeShowMode:%ld", (long)showMode);
}


#pragma mark - AMapNaviRideViewDelegate
- (void)rideViewCloseButtonClicked:(AMapNaviRideView *)rideView {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    //停止导航
    [self.rideManager stopNavi];
    [self.rideManager removeDataRepresentative:self.rideView];
    self.rideView.hidden = YES;
    //停止语音
    [[SpeechSynthesizer sharedSpeechSynthesizer] stopSpeak];
}

- (void)rideViewTrunIndicatorViewTapped:(AMapNaviRideView *)rideView {
    NSLog(@"TrunIndicatorViewTapped");
}

- (void)rideView:(AMapNaviRideView *)rideView didChangeShowMode:(AMapNaviRideViewShowMode)showMode {
    NSLog(@"didChangeShowMode:%ld", (long)showMode);
}

#pragma mark - AMapNaviDriveViewDelegate
- (void)driveViewCloseButtonClicked:(AMapNaviDriveView *)driveView {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    //停止导航
    [self.driveManager stopNavi];
    [self.driveManager removeDataRepresentative:self.driveView];
    self.driveView.hidden = YES;
    //停止语音
    [[SpeechSynthesizer sharedSpeechSynthesizer] stopSpeak];
}

- (void)driveViewTrunIndicatorViewTapped:(AMapNaviDriveView *)driveView {
    NSLog(@"TrunIndicatorViewTapped");
}

- (void)driveView:(AMapNaviDriveView *)driveView didChangeShowMode:(AMapNaviDriveViewShowMode)showMode {
    NSLog(@"didChangeShowMode:%ld", (long)showMode);
}

#pragma mark - AMapSearchDelegate
/* 路径规划搜索回调. */
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response
{
    if (response.route == nil)
    {
        return;
    }
    DLog(@"%@",response.route);
    AMapRoute *rote = (AMapRoute *)response.route;
    for (AMapPath *paths in rote.paths) {
        DLog(@"距离：%ld,时间:%ld,路段:%@",paths.distance,paths.duration,paths.steps);
    }
    [_transitRouteLinksMutableArray removeAllObjects];
    for (AMapTransit *transits in rote.transits) {
        YYTransitListModel *transitModel = [[YYTransitListModel alloc] init];
        transitModel.route = rote;
        transitModel.cost = transits.cost;
        transitModel.duration = transits.duration;
        transitModel.nightflag = transits.nightflag;
        transitModel.walkingDistance = transits.walkingDistance;
        transitModel.segments = transits.segments;
        transitModel.distance = transits.distance;
        [_transitRouteLinksMutableArray addObject:transitModel];
    }
    _mapBottomListView.linksMutableArray = _transitRouteLinksMutableArray;
    //解析response获取路径信息，具体解析见 Demo
}

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", error);
}

@end

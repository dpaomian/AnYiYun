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

#define kCollectionCellIdentifier   @"kCollectionCellIdentifier"

@interface LocationViewController () <MAMapViewDelegate, AMapNaviWalkManagerDelegate, AMapNaviRideManagerDelegate, AMapNaviDriveManagerDelegate>

@property (nonatomic, strong) AMapNaviPoint *startPoint;
@property (nonatomic, strong) AMapNaviPoint *endPoint;

@property (nonatomic, strong) NSMutableArray *routeIndicatorInfoArray;

@end

@implementation LocationViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self initProperties];
    
    [self initMapView];
    
    [self initWalkManager];
    [self initRideManager];
    [self initDriveManager];
    
    [self routePlanAction];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self initAnnotations];
}

#pragma mark - Initalization

- (void)initProperties
{
        //为了方便展示步行路径规划，选择了固定的起终点
    self.startPoint = [AMapNaviPoint locationWithLatitude:39.993135 longitude:116.474175];
    self.endPoint   = [AMapNaviPoint locationWithLatitude:39.908791 longitude:116.320257];
    
    self.routeIndicatorInfoArray = [NSMutableArray array];
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
                [ws routePlanAction];
            } else if (index == 1) {
                [ws routeRidePlanAction];
            } else if (index == 2) {
                [ws singleRoutePlanAction];
            } else {
                
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
    
    _mapBottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_mapBottomButton setBackgroundColor:[UIColor redColor]];
    _mapBottomButton.bounds = CGRectMake(0, 0, SCREEN_WIDTH, 64.0f);
    _mapBottomButton.center = CGPointMake(SCREEN_WIDTH/2.0f, SCREEN_HEIGHT - (64.0f/2.0f)-64.0f);
    [_mapBottomButton addTarget:self action:@selector(dragMoving:withEvent: )forControlEvents: UIControlEventTouchDragInside];
    [_mapBottomButton addTarget:self action:@selector(dragEnded:withEvent: )forControlEvents: UIControlEventTouchUpInside |
     UIControlEventTouchUpOutside];
    [self.view addSubview:_mapBottomButton];
    
    _mapBottomListView = [[YYNaverBottomButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_mapBottomButton.frame), SCREEN_WIDTH, SCREEN_HEIGHT-64.0f-44.0f-25.0f-64.0f)];
    _mapBottomListView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:_mapBottomListView];
}

#pragma mark - Touch

- (void) dragMoving: (UIControl *) c withEvent:ev
{
    CGFloat yFloat =  [[[ev allTouches] anyObject] locationInView:self.view].y;
    if (yFloat <= 44.0f+25.0f+64.0f/2.0f) {
        yFloat = 44.0f+25.0f+64.0f/2.0f;
    }
    c.center = CGPointMake(SCREEN_WIDTH/2.0f, yFloat);
    _mapBottomListView.frame = CGRectMake(0, CGRectGetMaxY(_mapBottomButton.frame), SCREEN_WIDTH, SCREEN_HEIGHT-64.0f-44.0f-25.0f-64.0f);
}

- (void) dragEnded: (UIControl *) c withEvent:ev
{
    CGFloat yFloat =  [[[ev allTouches] anyObject] locationInView:self.view].y;
    if (yFloat <= (SCREEN_WIDTH-64.0f)/3.0f*2.0f) {
        c.center = CGPointMake(SCREEN_WIDTH/2.0f, 44.0f+25.0f+64.0f/2.0f);
    }  else {
        c.center = CGPointMake(SCREEN_WIDTH/2.0f, SCREEN_HEIGHT - (64.0f/2.0f)-64.0f);
    }
    _mapBottomListView.frame = CGRectMake(0, CGRectGetMaxY(_mapBottomButton.frame), SCREEN_WIDTH, SCREEN_HEIGHT-64.0f-44.0f-25.0f-64.0f);
}

#pragma mark - Action Handlers
- (void)gpsAction {
    if(self.mapView.userLocation.updating && self.mapView.userLocation.location) {
        [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:YES];
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

- (void)initWalkManager
{
    if (self.walkManager == nil)
        {
        self.walkManager = [[AMapNaviWalkManager alloc] init];
        [self.walkManager setDelegate:self];
        }
}

- (void)initRideManager
{
    if (self.rideManager == nil)
    {
        self.rideManager = [[AMapNaviRideManager alloc] init];
        [self.rideManager setDelegate:self];
    }
}

- (void)initDriveManager
{
    if (self.driveManager == nil)
    {
        self.driveManager = [[AMapNaviDriveManager alloc] init];
        [self.driveManager setDelegate:self];
    }
}

- (void)initAnnotations
{
    NaviPointAnnotation *beginAnnotation = [[NaviPointAnnotation alloc] init];
    [beginAnnotation setCoordinate:CLLocationCoordinate2DMake(self.startPoint.latitude, self.startPoint.longitude)];
    beginAnnotation.title = @"起点";
    beginAnnotation.navPointType = NaviPointAnnotationStart;

    [self.mapView addAnnotation:beginAnnotation];

    NaviPointAnnotation *endAnnotation = [[NaviPointAnnotation alloc] init];
    [endAnnotation setCoordinate:CLLocationCoordinate2DMake(self.endPoint.latitude, self.endPoint.longitude)];
    endAnnotation.title = @"终点";
    endAnnotation.navPointType = NaviPointAnnotationEnd;

    [self.mapView addAnnotation:endAnnotation];
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
    [self.driveManager calculateDriveRouteWithStartPoints:@[self.startPoint]
                                                endPoints:@[self.endPoint]
                                                wayPoints:nil
                                          drivingStrategy:ConvertDrivingPreferenceToDrivingStrategy(NO,NO,NO,NO,NO)];
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
    
    free(coords);
    
    [self.mapView showAnnotations:self.mapView.annotations animated:NO];
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
}

- (void)walkManagerDidEndEmulatorNavi:(AMapNaviWalkManager *)walkManager
{
    NSLog(@"didEndEmulatorNavi");
}

- (void)walkManagerOnArrivedDestination:(AMapNaviWalkManager *)walkManager
{
    NSLog(@"onArrivedDestination");
}

#pragma mark - AMapNaviDriveManager Delegate

- (void)rideManager:(AMapNaviRideManager *)rideManager error:(NSError *)error
{
    NSLog(@"error:{%ld - %@}", (long)error.code, error.localizedDescription);
}

- (void)rideManagerOnCalculateRouteSuccess:(AMapNaviRideManager *)rideManager
{
    NSLog(@"onCalculateRouteSuccess");
    
    //算路成功后显示路径
    [self showNaviRoutes];
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
    [self showNaviRoutes];
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
    return NO;
}

- (void)driveManager:(AMapNaviDriveManager *)driveManager playNaviSoundString:(NSString *)soundString soundStringType:(AMapNaviSoundType)soundStringType
{
    NSLog(@"playNaviSoundString:{%ld:%@}", (long)soundStringType, soundString);
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
        
        polylineRenderer.lineWidth = 8.f;
        polylineRenderer.strokeColor = selectableOverlay.isSelected ? selectableOverlay.selectedColor : selectableOverlay.regularColor;
        
        return polylineRenderer;
        }
    
    return nil;
}

@end

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

@interface LocationViewController () <MAMapViewDelegate, AMapNaviWalkManagerDelegate>

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
    self.endPoint   = [AMapNaviPoint locationWithLatitude:39.908791 longitude:116.321257];
    
    self.routeIndicatorInfoArray = [NSMutableArray array];
}

- (void)initMapView
{
    _mapTopView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([YYNaverTopView class]) owner:nil options:nil][0];
    _mapTopView.backgroundColor = [UIColor redColor];
    _mapTopView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44.0f+25.0f);
    [self.view addSubview:_mapTopView];
    
    YYSegmentedView *navTypesView = [[YYSegmentedView alloc] initWithFrame:CGRectMake(0.0f, 25.0f, SCREEN_WIDTH, 44.0f)];
    navTypesView.backgroundColor = UIColorFromRGB(0x000000);
    [self.view addSubview:navTypesView];
    navTypesView.selectedIndex = 0;
    navTypesView.titlesArray = @[@"步行",@"骑行",@"驾驶",@"公交"];
    navTypesView.itemHandle = ^(YYSegmentedView *stateView, NSInteger index) {
        if (index == stateView.selectedIndex) {
            return ;
        }else {
            stateView.selectedIndex = index;
            if (index == 0) {
                
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
    
    _mapBottomButton = [[YYNaverBottomButton alloc] initWithFrame:CGRectZero];
    _mapBottomButton.bounds = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 44.0f-25.0f-10.0f);
    _mapBottomButton.center = CGPointMake(SCREEN_WIDTH/2.0f, SCREEN_HEIGHT + (SCREEN_HEIGHT - 44.0f-25.0f-10.0f)/2.0f-128.0f);
    [_mapBottomButton.topButon addTarget:self action:@selector(dragMoving:withEvent: )forControlEvents: UIControlEventTouchDragInside];
    [_mapBottomButton.topButon addTarget:self action:@selector(dragEnded:withEvent: )forControlEvents: UIControlEventTouchUpInside |
     UIControlEventTouchUpOutside];
    [self.view addSubview:_mapBottomButton];
}

#pragma mark - Touch

- (void) dragMoving: (UIControl *) c withEvent:ev
{
    _mapBottomButton.center = CGPointMake(SCREEN_WIDTH/2.0f, [[[ev allTouches] anyObject] locationInView:self.view].y);
}

- (void) dragEnded: (UIControl *) c withEvent:ev
{
    CGFloat yFloat =  [[[ev allTouches] anyObject] locationInView:self.view].y;
    if (yFloat <= SCREEN_HEIGHT/2.0f) {
        _mapBottomButton.center = CGPointMake(SCREEN_WIDTH/2.0f,44.0f+25.0f + (SCREEN_HEIGHT - 44.0f-25.0f-10.0f)/2.0f);
    }else if (yFloat <= SCREEN_HEIGHT/2.0f) {
        _mapBottomButton.center = CGPointMake(SCREEN_WIDTH/2.0f,44.0f+25.0f);
    }  else {
        _mapBottomButton.center = CGPointMake(SCREEN_WIDTH/2.0f,SCREEN_HEIGHT + (SCREEN_HEIGHT - 44.0f-25.0f-10.0f)/2.0f-128.0f);
    }
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

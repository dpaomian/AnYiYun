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
//#import "RouteCollectionViewCell.h"

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
    
    [self configSubViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//
//    self.navigationController.navigationBarHidden = NO;
//    self.navigationController.toolbarHidden = YES;
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
    if (self.mapView == nil)
        {
        self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0,
                                                                   self.view.bounds.size.width,
                                                                   self.view.bounds.size.height)];
        [self.mapView setDelegate:self];
        
        [self.view addSubview:self.mapView];
        }
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
    
//    MAPointAnnotation *startAnnotation = [[MAPointAnnotation alloc] init];
//    startAnnotation.coordinate = CLLocationCoordinate2DMake(self.startPoint.latitude, self.startPoint.longitude);
//    startAnnotation.title      = @"起点";
//    startAnnotation.subtitle   = [NSString stringWithFormat:@"{%f, %f}", self.startPoint.latitude, self.startPoint.longitude];
////    self.startAnnotation = startAnnotation;
//
//    MAPointAnnotation *destinationAnnotation = [[MAPointAnnotation alloc] init];
//    destinationAnnotation.coordinate = CLLocationCoordinate2DMake(self.endPoint.latitude, self.endPoint.longitude);
//    destinationAnnotation.title      = @"终点";
//    destinationAnnotation.subtitle   = [NSString stringWithFormat:@"{%f, %f}", self.endPoint.latitude, self.endPoint.longitude];
////    self.destinationAnnotation = destinationAnnotation;
//
//    [self.mapView addAnnotation:startAnnotation];
//    [self.mapView addAnnotation:destinationAnnotation];
}

#pragma mark - Button Action

- (void)routePlanAction:(id)sender
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

- (void)configSubViews
{
    UILabel *startPointLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, CGRectGetWidth(self.view.bounds), 20)];
    
    startPointLabel.textAlignment = NSTextAlignmentCenter;
    startPointLabel.font = [UIFont systemFontOfSize:14];
    startPointLabel.text = [NSString stringWithFormat:@"起 点：%f, %f", self.startPoint.latitude, self.startPoint.longitude];
    
    [self.view addSubview:startPointLabel];
    
    UILabel *endPointLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, CGRectGetWidth(self.view.bounds), 20)];
    
    endPointLabel.textAlignment = NSTextAlignmentCenter;
    endPointLabel.font = [UIFont systemFontOfSize:14];
    endPointLabel.text = [NSString stringWithFormat:@"终 点：%f, %f", self.endPoint.latitude, self.endPoint.longitude];
    
    [self.view addSubview:endPointLabel];
    
    UIButton *routeBtn = [self createToolButton];
    [routeBtn setFrame:CGRectMake((CGRectGetWidth(self.view.bounds)-80)/2.0, 60, 80, 30)];
    [routeBtn setTitle:@"路径规划" forState:UIControlStateNormal];
    [routeBtn addTarget:self action:@selector(routePlanAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:routeBtn];
}

- (UIButton *)createToolButton
{
    UIButton *toolBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    toolBtn.layer.borderColor  = [UIColor lightGrayColor].CGColor;
    toolBtn.layer.borderWidth  = 0.5;
    toolBtn.layer.cornerRadius = 5;
    
    [toolBtn setBounds:CGRectMake(0, 0, 80, 30)];
    [toolBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    toolBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    
    return toolBtn;
}

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

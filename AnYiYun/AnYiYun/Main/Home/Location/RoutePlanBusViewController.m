//
//  RoutePlanBusViewController.m
//  MAMapKit_2D_Demo
//
//  Created by shaobin on 16/8/12.
//  Copyright © 2016年 Autonavi. All rights reserved.
//

#import "RoutePlanBusViewController.h"

static const NSString *RoutePlanningViewControllerStartTitle       = @"起点";
static const NSString *RoutePlanningViewControllerDestinationTitle = @"终点";
static const NSInteger RoutePlanningPaddingEdge                    = 20;

@interface RoutePlanBusViewController ()<MAMapViewDelegate, AMapSearchDelegate>
/* 路径规划类型 */
@property (nonatomic, strong) MAMapView *mapView;

/* 用于显示当前路线方案. */
@property (nonatomic) MANaviRoute * naviRoute;

@end

@implementation RoutePlanBusViewController

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    [self.view addSubview:self.mapView];
    
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
    
    _mapBottomListView = [[YYNaverBottomView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_mapBottomButton.frame), SCREEN_WIDTH, SCREEN_HEIGHT-64.0f-44.0f-25.0f)];
    [self.view addSubview:_mapBottomListView];
    
    _mapBottomListView.didSelectRowAtIndexPath = ^(YYNaverBottomView *yyBottomView, YYTransitListModel *yyListModel, NSIndexPath * yyIndexPath){
        
    };

    [self presentCurrentCourse];
    [self addDefaultAnnotations];
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

- (void)gpsAction {
    if(self.mapView.userLocation.updating && self.mapView.userLocation.location) {
        [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:YES];
    }
}

#pragma mark - Touch

- (void) dragMoving: (UIControl *) c withEvent:ev
{
    CGFloat yFloat =  [[[ev allTouches] anyObject] locationInView:self.view].y;
    if (yFloat <= 64.0f/2.0f) {
        yFloat = 64.0f/2.0f;
    }
    _mapBottomButton.center = CGPointMake(SCREEN_WIDTH/2.0f, yFloat);
    _mapBottomListView.frame = CGRectMake(0, CGRectGetMaxY(_mapBottomButton.frame), SCREEN_WIDTH, SCREEN_HEIGHT-64.0f-44.0f-25.0f);
}

- (void) dragEnded: (UIControl *) c withEvent:ev
{
    CGFloat yFloat =  [[[ev allTouches] anyObject] locationInView:self.view].y;
    if (yFloat <= SCREEN_HEIGHT/2.0f) {
        _mapBottomButton.center = CGPointMake(SCREEN_WIDTH/2.0f, 64.0f/2.0f);
    }  else {
        _mapBottomButton.center = CGPointMake(SCREEN_WIDTH/2.0f, SCREEN_HEIGHT - (64.0f/2.0f)-64.0f);
    }
    _mapBottomListView.frame = CGRectMake(0, CGRectGetMaxY(_mapBottomButton.frame), SCREEN_WIDTH, SCREEN_HEIGHT-64.0f-44.0f-25.0f);
}

/* 展示当前路线方案. */
- (void)presentCurrentCourse
{
    self.naviRoute = [MANaviRoute naviRouteForTransit:self.route.transits[self.currentCourse] startPoint:[AMapGeoPoint locationWithLatitude:self.route.origin.latitude longitude:self.route.origin.longitude] endPoint:[AMapGeoPoint locationWithLatitude:self.route.destination.latitude longitude:self.route.destination.longitude]];
    [self.naviRoute addToMapView:self.mapView];
    
    /* 缩放地图使其适应polylines的展示. */
    [self.mapView showOverlays:self.naviRoute.routePolylines edgePadding:UIEdgeInsetsMake(RoutePlanningPaddingEdge, RoutePlanningPaddingEdge, RoutePlanningPaddingEdge, RoutePlanningPaddingEdge) animated:YES];
}

#pragma mark - MAMapViewDelegate

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[LineDashPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:((LineDashPolyline *)overlay).polyline];
        polylineRenderer.lineWidth   = 4;
        polylineRenderer.strokeColor = [UIColor colorWithRed:0.5  green:0.6  blue:0.9  alpha:0.8];
        return polylineRenderer;
    }
    if ([overlay isKindOfClass:[MANaviPolyline class]])
    {
        MANaviPolyline *naviPolyline = (MANaviPolyline *)overlay;
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:naviPolyline.polyline];
        
        polylineRenderer.lineWidth = 4;
        
        if (naviPolyline.type == MANaviAnnotationTypeWalking)
        {
            polylineRenderer.strokeColor = self.naviRoute.walkingColor;
        }
        else if (naviPolyline.type == MANaviAnnotationTypeRailway)
        {
            polylineRenderer.strokeColor = self.naviRoute.railwayColor;
        }
        else
        {
            polylineRenderer.strokeColor = self.naviRoute.routeColor;
        }
        
        return polylineRenderer;
    }
    if ([overlay isKindOfClass:[MAMultiPolyline class]])
    {
        MAMultiColoredPolylineRenderer * polylineRenderer = [[MAMultiColoredPolylineRenderer alloc] initWithMultiPolyline:overlay];
        
        polylineRenderer.lineWidth = 4;
        polylineRenderer.strokeColors = [self.naviRoute.multiPolylineColors copy];
        polylineRenderer.gradient = YES;
        
        return polylineRenderer;
    }
    
    return nil;
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *routePlanningCellIdentifier = @"RoutePlanningCellIdentifier";
        
        MAAnnotationView *poiAnnotationView = (MAAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:routePlanningCellIdentifier];
        if (poiAnnotationView == nil)
        {
            poiAnnotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                             reuseIdentifier:routePlanningCellIdentifier];
        }
        
        poiAnnotationView.canShowCallout = YES;
        poiAnnotationView.image = nil;
        
        if ([annotation isKindOfClass:[MANaviAnnotation class]])
        {
            switch (((MANaviAnnotation*)annotation).type)
            {
                case MANaviAnnotationTypeRailway:
                    poiAnnotationView.image = [UIImage imageNamed:@"railway_station"];
                    break;
                    
                case MANaviAnnotationTypeBus:
                    poiAnnotationView.image = [UIImage imageNamed:@"bus"];
                    break;
                    
                case MANaviAnnotationTypeDrive:
                    poiAnnotationView.image = [UIImage imageNamed:@"car"];
                    break;
                    
                case MANaviAnnotationTypeWalking:
                    poiAnnotationView.image = [UIImage imageNamed:@"man"];
                    break;
                    
                default:
                    break;
            }
        }
        else
        {
            /* 起点. */
            if ([[annotation title] isEqualToString:(NSString*)RoutePlanningViewControllerStartTitle])
            {
                poiAnnotationView.image = [UIImage imageNamed:@"startPoint"];
            }
            /* 终点. */
            else if([[annotation title] isEqualToString:(NSString*)RoutePlanningViewControllerDestinationTitle])
            {
                poiAnnotationView.image = [UIImage imageNamed:@"endPoint"];
            }
            
        }
        
        return poiAnnotationView;
    }
    
    return nil;
}

- (void)addDefaultAnnotations
{
    MAPointAnnotation *startAnnotation = [[MAPointAnnotation alloc] init];
    startAnnotation.coordinate = CLLocationCoordinate2DMake(self.route.origin.latitude, self.route.origin.longitude);
    startAnnotation.title      = (NSString*)RoutePlanningViewControllerStartTitle;
    self.startAnnotation = startAnnotation;
    
    MAPointAnnotation *destinationAnnotation = [[MAPointAnnotation alloc] init];
    destinationAnnotation.coordinate = CLLocationCoordinate2DMake(self.route.destination.latitude, self.route.destination.longitude);
    destinationAnnotation.title      = (NSString*)RoutePlanningViewControllerDestinationTitle;
    self.destinationAnnotation = destinationAnnotation;
    
    [self.mapView addAnnotation:startAnnotation];
    [self.mapView addAnnotation:destinationAnnotation];
}

@end

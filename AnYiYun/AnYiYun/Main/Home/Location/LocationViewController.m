//
//  LocationViewController.m
//  AnYiYun
//
//  Created by wwr on 2017/7/27.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "LocationViewController.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件
#import <BaiduMapAPI_Location/BMKLocationService.h>//引入计算工具所有的头文件
#import "DeviceInfoModel.h"

@interface LocationViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate>

@property (nonatomic,strong)NSString           *positionString;
@property (nonatomic,strong)BMKMapView         *mapView;
@property (nonatomic,strong)BMKLocationService *locService;

@property (nonatomic,strong)UIView     *locationView;
@property (nonatomic,strong)UILabel    *titleLabel;

@end

@implementation LocationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"安装位置";
    [self makeUI];
    
    [self getUseDataRequest];
    
    if (_deviceNameString.length==0)
    {
        [self getLocationName];
    }
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _mapView.delegate = nil; // 不用时，置nil
}

#pragma mark - request
-(void)getLocationName
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",BASE_PLAN_URL,@"rest/initApp/basic_info"];
    NSDictionary *param = @{@"userSign":[PersonInfo shareInstance].accountID,
                            @"deviceId":self.deviceIdString};
    
    DLog(@"请求地址 urlString = %@?%@",urlString,[param serializeToUrlString]);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:urlString
      parameters:param
        progress:^(NSProgress * _Nonnull downloadProgress) {} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
     NSDictionary *resuleDic = (NSDictionary *)responseObject;
         
     DeviceInfoModel *info = [DeviceInfoModel mj_objectWithKeyValues:resuleDic];
         DLog(@"安装位置 = %@",info.installationSite);
         MAIN(^(){
             _locationView.hidden = NO;
             _titleLabel.hidden = NO;
             _titleLabel.text = info.installationSite;
         });
     }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             DLog(@"请求失败：%@",error);
         }];
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
         NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
         DLog(@"定位请求回来的值 %@",string);
         _positionString = string;
         MAIN(^(){
             [self addCllocation];
         });
     }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             DLog(@"请求失败：%@",error);
         }];
    
}

#pragma mark - makeUI
-(void)makeUI
{
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.locationView];
     [self.view addSubview:self.titleLabel];
    //启动LocationService
    [self.locService startUserLocationService];
    
    if (_deviceLocation.length>0)
    {
        _locationView.hidden = NO;
        _titleLabel.hidden = NO;
        _titleLabel.text = _deviceLocation;
    }
    else
    {
        _locationView.hidden = YES;
        _titleLabel.hidden = YES;
    }
}

-(void)addCllocation
{
    if (_positionString.length>0)
    {
        NSArray *pointArray = [_positionString componentsSeparatedByString:@","];
        if (pointArray.count==2)
        {
            double longitude = [[pointArray objectAtIndex:0] doubleValue];
            double latitude = [[pointArray objectAtIndex:1] doubleValue];
            
            // 添加一个PointAnnotation
            BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc]init];
            CLLocationCoordinate2D coor;
            coor.latitude = latitude;
            coor.longitude = longitude;
            annotation.coordinate = coor;
            
            BMKCoordinateRegion viewRegion = BMKCoordinateRegionMake(coor,BMKCoordinateSpanMake(0.02, 0.02));
            BMKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
            [_mapView setRegion:adjustedRegion animated:YES];
            
            [_mapView addAnnotation:annotation];
            //_mapView.centerCoordinate = coor; //更新当前位置到大头针位置
        }
    }
}

#pragma mark -getter
// Override
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
            //newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.image = [UIImage imageNamed:@"location_icon_red.png"];
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        return newAnnotationView;
    }
    return nil;
}

#pragma mark - BMKLocationServiceDelegate

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    BMKCoordinateRegion region;
    region.center.latitude = userLocation.location.coordinate.latitude;
    region.center.longitude = userLocation.location.coordinate.longitude;
    
    region.span.latitudeDelta = 0.2;
    region.span.longitudeDelta = 0.2;
    if (_mapView)
    {
        _mapView.region = region;
    }
    [_mapView setZoomLevel:19.0];
    
    [_mapView updateLocationData:userLocation]; //更新地图上的位置

    [_locService stopUserLocationService];//定位完成停止位置更新
}
#pragma mark -getter

- (BMKLocationService *)locService
{
    if (!_locService) {
        _locService = [[BMKLocationService alloc]init];
        _locService.delegate = self;
        _locService.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    }
    return _locService;
}

- (BMKMapView *)mapView
{
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _mapView.showsUserLocation = YES; //是否显示定位图层（即我的位置的小圆点）
        _mapView.zoomLevel = 19;//地图显示比例
        _mapView.mapType = BMKMapTypeStandard;//设置地图为空白类型
    }
    return _mapView;
}

-(UIView *)locationView
{
    if (!_locationView) {
        _locationView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-40-NAV_HEIGHT, SCREEN_WIDTH, 40)];
        _locationView.backgroundColor = [UIColor blackColor];
        _locationView.alpha = 0.7;
    }
    return _locationView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-40-NAV_HEIGHT, SCREEN_WIDTH, 40)];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = SYSFONT_(14);
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

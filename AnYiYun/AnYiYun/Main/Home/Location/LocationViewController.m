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
#import "DeviceInfoModel.h"

@interface LocationViewController ()<BMKMapViewDelegate>

@property (nonatomic,strong)NSString *positionString;
@property (nonatomic,strong)BMKMapView  *mapView;

@property (nonatomic,strong)UIView    *locationView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation LocationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"安装位置";
    [self makeUI];
    
    [self getUseDataRequest];
    [self getLocationName];
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
     _titleLabel.text = info.installationSite;
     _titleLabel.hidden = NO;

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
        newAnnotationView.image = [UIImage imageNamed:@"location_icon.png"];
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        return newAnnotationView;
    }
    return nil;
}

#pragma mark -getter
-(BMKMapView *)mapView
{
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
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

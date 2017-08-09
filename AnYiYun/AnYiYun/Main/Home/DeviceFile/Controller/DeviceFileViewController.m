//
//  DeviceFileViewController.m
//  AnYiYun
//
//  Created by wwr on 2017/7/28.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "DeviceFileViewController.h"
#import "DeviceInfoViewController.h"
#import "TechnicalInfoViewController.h"
#import "DevicePartViewController.h"
#import "RepairRecordsViewController.h"
#import "MaintenanceRecordsViewController.h"
#import "DetectionRecordViewController.h"
#import "InspectionRecordsViewController.h"
#import "AlarmRecordViewController.h"
#import "LocationViewController.h"

#import "JXLayoutButton.h"

@interface DeviceFileViewController ()

@property (nonatomic,strong)UIView  *tabMapView;

@end

@implementation DeviceFileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = RGB(239, 239, 244);

    [self makeUIView];

}

#pragma mark - makeUI

-(void)makeUIView
{
    [self setLeftBarItem];
    [self.view addSubview:self.tabMapView];
    
    NSArray *titleArray = @[@"基本信息",@"技术资料",@"主要部件",@"维修记录",@"保养记录",@"检测记录",@"巡检记录",@"告警记录",@"安装位置"];
    
    CGFloat btnWidth = (SCREEN_WIDTH-40)/3;
    NSInteger  chu = titleArray.count/3;
    NSInteger   yu = titleArray.count%3;
    
    CGFloat viewHeight = chu*(btnWidth+10);
    if (yu>0)
    {
        viewHeight = chu*(btnWidth+10)+(btnWidth+10);
    }
    _tabMapView.frame = CGRectMake(0, 30, SCREEN_WIDTH, viewHeight);
    
    for (int i=0; i<titleArray.count; i++)
    {
        CGFloat xx = 10+i%3*(btnWidth+10);
        CGFloat yy = i/3*(btnWidth+10);
        
        NSString *titleString = [titleArray objectAtIndex:i];
        NSString *imageString = [NSString stringWithFormat:@"archives_icon_%d",i+1];
        
        UIButton *itemBtn = [[UIButton alloc] init];
        itemBtn.frame = CGRectMake(xx, yy, btnWidth, btnWidth);
        itemBtn.tag = 300+i;
        [itemBtn addTarget:self action:@selector(detailBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        CGFloat imageWidth = 40;
        UIImageView  *itemImgView = [[UIImageView alloc]initWithFrame:CGRectMake((btnWidth-imageWidth)/2, (btnWidth-30-imageWidth)/2, imageWidth, imageWidth)];
        itemImgView.image = [UIImage imageNamed:imageString];
        [itemBtn addSubview:itemImgView];
        
        UILabel  *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, btnWidth-40, btnWidth, 30)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.text = titleString;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [itemBtn addSubview:titleLabel];
        
        if (i%2!=0)
        {
            itemBtn.backgroundColor = [UIColor whiteColor];
            titleLabel.textColor = [UIColor orangeColor];
        }
        else
        {
            itemBtn.backgroundColor = [UIColor orangeColor];
            titleLabel.textColor = [UIColor whiteColor];
        }
        
        [_tabMapView addSubview:itemBtn];
        
    }
    
    
}

-(void)setLeftBarItem
{
    UIButton  *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    CGFloat width = [BaseHelper width:_deviceNameString heightOfFatherView:20 textFont:[UIFont systemFontOfSize:10]];
    if (width<100)
    {
        width = 100;
    }
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 12, 20, 20)];
    imageView.image = [UIImage imageNamed:@"main_back_white.png"];
    [leftButton addSubview:imageView];
    
    UILabel *upTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, SCREEN_WIDTH-20, 24)];
    upTitleLabel.textColor = [UIColor whiteColor];
    upTitleLabel.font = SYSFONT_(16);
    upTitleLabel.backgroundColor = [UIColor clearColor];
    upTitleLabel.text = @"设备档案";
    [leftButton addSubview:upTitleLabel];
    
    UILabel *downTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 22, width, 20)];
    downTitleLabel.textColor = [UIColor whiteColor];
    downTitleLabel.font = SYSFONT_(10);
    downTitleLabel.backgroundColor = [UIColor clearColor];
    downTitleLabel.text = _deviceNameString;
    [leftButton addSubview:downTitleLabel];
    
    leftButton.frame = CGRectMake(0, 20, width+40, 44);
    [leftButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
}

#pragma mark - action
-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

    //详情内容
- (void)detailBtnClick:(UIButton *)sender
{
    NSInteger tag = sender.tag-300;
    switch (tag) {
        case 0:
        {
        DeviceInfoViewController *vc = [[DeviceInfoViewController alloc]init];
            vc.deviceIdString = self.deviceIdString;
            vc.deviceNameString = self.deviceNameString;
            vc.deviceLocation = self.deviceLocation;
            vc.pushType = self.pushType;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
        TechnicalInfoViewController *vc = [[TechnicalInfoViewController alloc]init];
            vc.deviceIdString = self.deviceIdString;
            vc.deviceNameString = self.deviceNameString;
            vc.deviceLocation = self.deviceLocation;
            vc.pushType = self.pushType;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
        DevicePartViewController *vc = [[DevicePartViewController alloc]init];
            vc.deviceIdString = self.deviceIdString;
            vc.deviceNameString = self.deviceNameString;
            vc.deviceLocation = self.deviceLocation;
            vc.pushType = self.pushType;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
        {
        RepairRecordsViewController *vc = [[RepairRecordsViewController alloc]init];
            vc.deviceIdString = self.deviceIdString;
            vc.deviceNameString = self.deviceNameString;
            vc.deviceLocation = self.deviceLocation;
            vc.pushType = self.pushType;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 4:
        {
        MaintenanceRecordsViewController *vc = [[MaintenanceRecordsViewController alloc]init];
            vc.deviceIdString = self.deviceIdString;
            vc.deviceNameString = self.deviceNameString;
            vc.deviceLocation = self.deviceLocation;
            vc.pushType = self.pushType;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 5:
        {
        DetectionRecordViewController *vc = [[DetectionRecordViewController alloc]init];
            vc.deviceIdString = self.deviceIdString;
            vc.deviceNameString = self.deviceNameString;
            vc.deviceLocation = self.deviceLocation;
            vc.pushType = self.pushType;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 6:
        {
        InspectionRecordsViewController *vc = [[InspectionRecordsViewController alloc]init];
            vc.deviceIdString = self.deviceIdString;
            vc.deviceNameString = self.deviceNameString;
            vc.deviceLocation = self.deviceLocation;
            vc.pushType = self.pushType;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 7:
        {
        AlarmRecordViewController *vc = [[AlarmRecordViewController alloc]init];
            vc.deviceIdString = self.deviceIdString;
            vc.deviceNameString = self.deviceNameString;
            vc.deviceLocation = self.deviceLocation;
            vc.pushType = self.pushType;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 8:
        {
        LocationViewController *vc = [[LocationViewController alloc]init];
            vc.deviceIdString = self.deviceIdString;
            vc.deviceNameString = self.deviceNameString;
            vc.deviceLocation = self.deviceLocation;
            vc.pushType = self.pushType;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - getter


- (UIView *)tabMapView
{
    if (!_tabMapView) {
        _tabMapView = [[UIView alloc]init];
        _tabMapView.backgroundColor = [UIColor clearColor];
    }
    return _tabMapView;
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

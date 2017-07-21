//
//  HomeMainViewController.m
//  AnYiYun
//
//  Created by wwr on 2017/7/19.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "HomeMainViewController.h"
#import "SDCycleScrollView.h"
#import "HomeModel.h"
#import "PublicWebViewController.h"


/**广告图高*/
#define AD_Height (kScreen_Width/2)
@interface HomeMainViewController ()<SDCycleScrollViewDelegate>

/**广告图*/
@property (nonatomic,strong)UIView                     *adBgView;
@property (nonatomic,strong)SDCycleScrollView          *adView;

@end

@implementation HomeMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self pictureRequestAction];
    
}


-  (void)pictureRequestAction
{
    NSString *urlString = [NSString stringWithFormat:@"%@rest/busiData/banner",BASE_PLAN_URL];
    NSDictionary *param = @{@"userSign":[PersonInfo shareInstance].accountID};
    [BaseAFNRequest requestWithType:HttpRequestTypeGet additionParam:@{@"isNeedAlert":@"1"} urlString:urlString paraments:param successBlock:^(NSDictionary *object) {
        NSInteger result = [object[@"errCode"] integerValue];
        if (result==0)
            {
            NSDictionary *picDic = object;
            NSArray *keyArray = [picDic allKeys];
            
            NSMutableArray *picArray = [[NSMutableArray alloc]init];
            for (int i=0; i<keyArray.count; i++)
                {
                HomeModel *model = [[HomeModel alloc]init];
                model.imgurl = keyArray[i];
                model.contenturl = picDic[model.imgurl];
                [picArray addObject:model];
            }
            [self updateADPictureWithArray:picArray];
        }
        else
            {
            DLog(@"获取应用模块广告图片失败：%@",object[@"msg"]);
        }
        
    } failureBlock:^(NSError *error) {
        DLog(@"获取应用模块广告图片失败：%@",error);
    } progress:nil];
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSString *imageContent = [cycleScrollView.imageContentsGroup objectAtIndex:index];
    if (imageContent.length>0)
        {
        PublicWebViewController *myWebVC = [[PublicWebViewController alloc]init];
        myWebVC.myUrl = [BaseHelper isSpaceString:imageContent andReplace:@""];
        myWebVC.titleStr = @"详情";
        myWebVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:myWebVC animated:YES];
        }
    DLog(@"选择了图片是：%@",imageContent);
}

#pragma mark - NSNotificationCenter
- (void)updateADPictureWithArray:(NSArray *)allAds
{
    if (allAds.count>0)
        {
        NSMutableArray *allImageUrls = [NSMutableArray arrayWithCapacity:10];
        NSMutableArray *allImageContents = [NSMutableArray arrayWithCapacity:10];
        [allAds enumerateObjectsUsingBlock:^(HomeModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [allImageUrls addObject:obj.imgurl];
            [allImageContents addObject:obj.contenturl];
        }];
        self.adView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;// 分页控件位置
        self.adView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;// 分页控件风格
        self.adView.imageURLStringsGroup = allImageUrls;
        self.adView.imageContentsGroup = allImageContents;
        self.adView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
        _adBgView.frame = CGRectMake(0, 0 , kScreen_Width, AD_Height+kScreen_TopSpace);
        }
    else
        {
        _adBgView.frame = CGRectMake(0, 0, 0, 0.0000001);
        }
    [self.view addSubview:self.adBgView];
}

#pragma mark - getter
-(UIView *)adBgView
{
    if (!_adBgView)
        {
        _adBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, AD_Height+kScreen_TopSpace)];
        _adBgView.backgroundColor = [UIColor clearColor];
        [_adBgView addSubview:self.adView];
        }
    return _adBgView;
}

- (SDCycleScrollView *)adView
{
    if (!_adView) {
        _adView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreen_Width, AD_Height) delegate:self placeholderImage:[UIImage imageNamed:@"main_ad_default"]];
    }
    return _adView;
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

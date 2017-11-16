//
//  RootTabBarViewController.m
//  AnYiYun
//
//  Created by 韩亚周 on 2017/7/19.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

#import "RootTabBarViewController.h"
#import "HomeMainViewController.h"
#import "DailyMainViewController.h"
#import "EquipmentMainViewController.h"
#import "MeMainViewController.h"
#import "UITabBar+badge.h"
#import "DBDaoDataBase.h"
#import "MessageViewController.h"


@interface RootTabBarViewController ()

@property (nonatomic, strong) MessageViewController *messageVc;
@property (nonatomic, strong) UINavigationController *nav;

@end

@implementation RootTabBarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMessageIsUnRead:) name:@"getMessageIsRead" object:nil];
    
    
    _nav = self.childViewControllers.firstObject;
    _messageVc = [[MessageViewController alloc]init];
    _messageVc.hidesBottomBarWhenPushed = YES;
    
    self.tabBar.backgroundColor = UIColorFromRGB(0xFFFFFF);
    [self addChildVC:[[HomeMainViewController alloc] init] title:@"首页" image:@"bottom_btn_1" selectedImage:@"ic_tab_home_blue"];
     [self addChildVC:[[DailyMainViewController alloc] init] title:@"日报" image:@"bottom_btn_2" selectedImage:@"ic_tab_me_blue"];
     [self addChildVC:[[EquipmentMainViewController alloc] init] title:@"设备说" image:@"bottom_btn_3" selectedImage:@"ic_tab_me_blue"];
    [self addChildVC:[[MeMainViewController alloc] init] title:@"我的" image:@"bottom_btn_4" selectedImage:@"ic_tab_me_blue"];
}


/**
 *  添加一个子控制器
 *
 *   childVc       子控制器
 *   title         标题
 *   image         图片
 *   selectedImage 选中的图片
 */
- (void)addChildVC:(UIViewController *)childVC title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    childVC.title = title;
    childVC.tabBarItem.image = [UIImage imageNamed:image];
    childVC.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [childVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : RGB(123, 123, 123)} forState:UIControlStateNormal];
    [childVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : kAPPBlueColor } forState:UIControlStateSelected];
    
    BaseNavigationViewController *navigationVC = [[BaseNavigationViewController alloc] initWithRootViewController:childVC];
    [self addChildViewController:navigationVC];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)getMessageIsUnRead:(NSNotification *)notify
{
    //    MAIN((^{
    NSString *messageNotify  = notify.object;
        //数据库
    /**
    NSInteger messageCount = [DBDaoDataBase sharedDataBase].getAllUnreadHistoryMessagesCount;
   
        MAIN(^{
            [self.viewControllers enumerateObjectsUsingBlock:^(__kindof UINavigationController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                UIViewController *vc = obj.viewControllers.firstObject;
                if ([vc isKindOfClass:[MeMainViewController class]])
                    {
                    if (messageCount>0)
                        {
                        [self.tabBar showBadgeOnItemIndex:idx];
                        }
                    else
                        {
                        [self.tabBar hideBadgeOnItemIndex:idx];
                        }
                    }
            }];
        });
     */

    if ([messageNotify boolValue]==YES)
    {
        //接收到推送 有新消息
        [self updateMainMessageRead:YES];
    
    DLog(@"%@",_nav.viewControllers);
        // 接收到推送 进入消息列表
    __weak RootTabBarViewController *ws = self;
        __block BOOL hasInMessage = NO;
        [ws.nav.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[MessageViewController class]]) {
                hasInMessage = YES;
                *stop = YES;
            } else {
                hasInMessage = NO;
            }
        }];
        MAIN(^{
            if (hasInMessage) {
                [ws.messageVc dataRequest];
            } else {
                [ws.nav pushViewController:ws.messageVc animated:YES];
            }
        });
    }
    else
    {
        //获取一级列表
        NSString *urlString = [NSString stringWithFormat:@"%@rest/busiData/messageGroup",BASE_PLAN_URL];
        
        HistoryMessageModel *alarmModel = [[DBDaoDataBase sharedDataBase] getHistoryMessagesGroupInfoWithType:@"101"];
        NSString *alarmString = [NSString stringWithFormat:@"%ld",(long)alarmModel.rtime];
        if ([[BaseHelper isSpaceString:alarmString andReplace:@""] integerValue]==0)
        {
            alarmString = [NSString stringWithFormat:@"%lld",[BaseHelper getSystemNowTimeLong]];
        }
        
        
        HistoryMessageModel *warningModel = [[DBDaoDataBase sharedDataBase] getHistoryMessagesGroupInfoWithType:@"102"];
        NSString *warningString = [NSString stringWithFormat:@"%ld",(long)warningModel.rtime];
        if ([[BaseHelper isSpaceString:warningString andReplace:@""] integerValue]==0)
        {
            warningString = [NSString stringWithFormat:@"%lld",[BaseHelper getSystemNowTimeLong]];
        }
        
        
        HistoryMessageModel *repairModel = [[DBDaoDataBase sharedDataBase] getHistoryMessagesGroupInfoWithType:@"103"];
        NSString *repairString = [NSString stringWithFormat:@"%ld",(long)repairModel.rtime];
        if ([[BaseHelper isSpaceString:repairString andReplace:@""] integerValue]==0)
        {
            repairString = [NSString stringWithFormat:@"%lld",[BaseHelper getSystemNowTimeLong]];
        }
        
        
        HistoryMessageModel *upkeepModel = [[DBDaoDataBase sharedDataBase] getHistoryMessagesGroupInfoWithType:@"104"];
        NSString *upkeepString = [NSString stringWithFormat:@"%ld",(long)upkeepModel.rtime];
        if ([[BaseHelper isSpaceString:upkeepString andReplace:@""] integerValue]==0)
        {
            upkeepString = [NSString stringWithFormat:@"%lld",[BaseHelper getSystemNowTimeLong]];
        }
        
        
        HistoryMessageModel *noticeModel = [[DBDaoDataBase sharedDataBase] getHistoryMessagesGroupInfoWithType:@"105"];
        NSString *noticeString = [NSString stringWithFormat:@"%ld",(long)noticeModel.rtime];
        if ([[BaseHelper isSpaceString:noticeString andReplace:@""] integerValue]==0)
        {
            noticeString = [NSString stringWithFormat:@"%lld",[BaseHelper getSystemNowTimeLong]];
        }
    
    DLog(@" alarmString=  %@ \n warningString=  %@ \n repairString=%@  \n upkeepString=  %@  \n noticeString=  %@",[BaseHelper getTimeStringWithDate:alarmString],[BaseHelper getTimeStringWithDate:warningString],[BaseHelper getTimeStringWithDate:repairString],[BaseHelper getTimeStringWithDate:upkeepString],[BaseHelper getTimeStringWithDate:noticeString]);
    
        
        NSDictionary *versionDic = @{@"alarm":[NSNumber numberWithInteger:
                                               [alarmString integerValue]],
                                     @"warning":[NSNumber numberWithInteger:
                                                 [warningString integerValue]],
                                     @"repair":[NSNumber numberWithInteger:
                                                [repairString integerValue]],
                                     @"upkeep":[NSNumber numberWithInteger:
                                                [upkeepString integerValue]],
                                     @"notice":[NSNumber numberWithInteger:
                                                [noticeString integerValue]]
                                     };
        
        NSString *versionString = [BaseHelper dictionaryToJson:versionDic];
        
        NSDictionary *param = @{@"userSign":[PersonInfo shareInstance].accountID,
                                @"version":versionString};
        
        DLog(@"请求地址 urlString = %@?%@",urlString,[param serializeToUrlString]);
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager GET:urlString
          parameters:param
            progress:^(NSProgress * _Nonnull downloadProgress) {} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
         {
             if ([responseObject isKindOfClass:[NSData class]])
             {
                 id jsonObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                 
                 if ([jsonObject isKindOfClass:[NSArray class]])
                 {
                     BOOL isRead = NO;
                     NSArray *useArray = (NSArray *)jsonObject;
                     for (int i=0; i<useArray.count; i++)
                     {
                         NSDictionary *useDic = [useArray objectAtIndex:i];
                         HistoryMessageModel *itemModel = [HistoryMessageModel mj_objectWithKeyValues:useDic];
                         if (itemModel.num>0)
                         {
                             isRead = YES;
                             break;
                         }
                     }
                     [self updateMainMessageRead:isRead];
                 }
             }
         }
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 DLog(@"请求失败：%@",error);
             }];
    }
}
    //是否有已读消息
-(void)updateMainMessageRead:(BOOL)isRead
{
    [PersonInfo shareInstance].isUnread = isRead;
    [BaseCacheHelper setPersonInfo];
    
     DLog(@"是否有新消息   %d",[PersonInfo shareInstance].isUnread);
    
    //刷新是否有未读消息
    [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadMeTable" object:@""];
    
    MAIN(^{
        [self.viewControllers enumerateObjectsUsingBlock:^(__kindof UINavigationController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIViewController *vc = obj.viewControllers.firstObject;
            if ([vc isKindOfClass:[MeMainViewController class]])
                {
                if (isRead==YES)
                    {
//                    [self.tabBar showBadgeOnItemIndex:idx];
                        [self.tabBar hideBadgeOnItemIndex:idx];
                    }
                else
                    {
                    [self.tabBar hideBadgeOnItemIndex:idx];
                    }
                }
        }];
    });
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

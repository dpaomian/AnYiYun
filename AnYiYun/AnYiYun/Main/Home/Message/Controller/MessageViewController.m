//
//  MessageViewController.m
//  AnYiYun
//
//  Created by wwr on 2017/7/24.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageAlarmCell.h"
#import "MessageExamCell.h"
#import "MessageMaintainCell.h"
#import "MessageTopView.h"
#import "PromptView.h"
#import "LocationViewController.h"
#import "DBDaoDataBase.h"
#import "DoubleGraphModel.h"
#import "HistoryMessageViewController.h"
#import "PopViewController.h"
#import "NoDataView.h"

@interface MessageViewController ()<UITableViewDelegate,UITableViewDataSource,MessageExamCellDeleagte,MessageAlarmCellDeleagte,MessageMaintainCellDeleagte,UIAlertViewDelegate>
{
    NSInteger    selectViewTag;
    UITableView *_currentTabelView;
}

@property (nonatomic, strong) BaseNavigationViewController *popNavVC;

@property (nonatomic, strong) MessageModel *selectModel;
@property (nonatomic, strong) UIScrollView *scrolView;
@property (nonatomic, strong) PromptView *promptView;
@property (nonatomic, strong) MessageTopView *topView;

@property (nonatomic, strong) UITableView *alarmTableView;
@property (nonatomic, strong) UITableView *examTableView;
@property (nonatomic, strong) UITableView *maintainTableView;

@property (nonatomic, strong) NSMutableArray *alarmDataSource;
@property (nonatomic, strong) NSMutableArray *examDataSource;
@property (nonatomic, strong) NSMutableArray *maintainDataSource;
@property (nonatomic, strong) NoDataView *nodataView;

@end

@implementation MessageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"消息中心";
    self.view.backgroundColor = RGB(239, 239, 244);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMessageIsUnRead:) name:@"getMessageIsRead" object:nil];
    
    [self setRightNavigationBar];
    [self makeupComponentUI];
    
    selectViewTag = 11;
    [self dataRequest];
    
    _nodataView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([NoDataView class]) owner:nil options:nil][0];
    _nodataView.frame = CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_WIDTH);
    _nodataView.hidden = YES;
    [self.view addSubview:_nodataView];
    
    _fullScreenCurveVC = [[YYCurveViewController alloc] initWithNibName:NSStringFromClass([YYCurveViewController class]) bundle:nil];
}
#pragma mark - public methods

//设置右边的navigationbar
- (void)setRightNavigationBar
{
    //查找群组
    UIButton *historyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    historyBtn.frame = CGRectMake(0, 0, 24, 24);
    [historyBtn setImage:[UIImage imageNamed:@"history_icon.png"] forState:UIControlStateNormal];
    historyBtn.tag = 11;
    [historyBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //新建群组
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    moreBtn.frame = CGRectMake(0, 0, 24, 24);
    [moreBtn setImage:[UIImage imageNamed:@"right_more.png"] forState:UIControlStateNormal];
    moreBtn.tag = 12;
    [moreBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem *searchBar = [[UIBarButtonItem alloc] initWithCustomView:historyBtn];
    UIBarButtonItem *addBar = [[UIBarButtonItem alloc] initWithCustomView:moreBtn];
    //间隔
    UIBarButtonItem *rightSpace = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                   target:nil
                                   action:nil];
    rightSpace.width = 20;
    
    NSArray *rightBarArr = [[NSArray alloc] initWithObjects: addBar,rightSpace,searchBar,nil];
    self.navigationItem.rightBarButtonItems = rightBarArr;
}

-(void)rightBtnClick:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag)
    {
        case 11:
        {
            //历史消息
            HistoryMessageViewController *vc = [[HistoryMessageViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 12:
        {
            //帮助
            PopViewController *popVC = [[PopViewController alloc] initWithNibName:NSStringFromClass([PopViewController class]) bundle:nil];
            _popNavVC = [[BaseNavigationViewController alloc] initWithRootViewController:popVC];
            _popNavVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            _popNavVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self.navigationController presentViewController:_popNavVC animated:NO completion:nil];
        }
            break;
            
        default:
            break;
    }
}

//刷新消息界面
-(void)getMessageIsUnRead:(NSNotification *)notify
{
    NSString *messageNotify  = notify.object;
    if ([messageNotify boolValue]==YES)
    {
        //接收到推送 有新消息
        [self updateDataSource];
    }
}

- (void)updateDataSource
{
    [_currentTabelView.mj_header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark - dataRequest
- (void)dataRequest
{
    if (selectViewTag==11)
        {
            //获取告警信息
        [self getAlarmDataRequest];
    }
    else if (selectViewTag==12)
        {
            //获取待检修
        [self getExamDataRequest];
        }
    else if (selectViewTag==13)
        {
            //获取待保养
        [self getMaintainDataRequest];
        }
}

//获取告警信息
-(void)getAlarmDataRequest
{
    NSString *urlString = [NSString stringWithFormat:@"%@rest/busiData/alarm",BASE_PLAN_URL];
    NSDictionary *param = @{@"userSign":[PersonInfo shareInstance].accountID};
    
    DLog(@"请求地址 urlString = %@?%@",urlString,[param serializeToUrlString]);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:urlString
      parameters:param
        progress:^(NSProgress * _Nonnull downloadProgress) {} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
     [_alarmDataSource removeAllObjects];
     
     id  object = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
     NSArray *listArray = (NSArray *)object;
     for (int i=0; i<listArray.count; i++)
         {
         MessageModel *item = [[MessageModel alloc]initWithDictionary:[listArray objectAtIndex:i]];
         [_alarmDataSource addObject:item];
     }
     [self getWarnDataRequest];
     [self endRefreshing];
     }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             DLog(@"获取告警信息失败：%@",error);
             [self getWarnDataRequest];
             [self endRefreshing];
         }];
}

    //获取预警信息
-(void)getWarnDataRequest
{
    NSString *urlString = [NSString stringWithFormat:@"%@rest/busiData/warning",BASE_PLAN_URL];
    NSDictionary *param = @{@"userSign":[PersonInfo shareInstance].accountID};
    
    DLog(@"请求地址 urlString = %@?%@",urlString,[param serializeToUrlString]);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:urlString
      parameters:param
        progress:^(NSProgress * _Nonnull downloadProgress) {} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {

     id  object = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
     NSArray *listArray = (NSArray *)object;
     for (int i=0; i<listArray.count; i++)
         {
         MessageModel *item = [[MessageModel alloc]initWithDictionary:[listArray objectAtIndex:i]];
         item.remark = @"预警";
         [_alarmDataSource addObject:item];
         }
     [self getAlarmDataByTime];
     }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             DLog(@"获取预警信息失败：%@",error);
             [self getAlarmDataByTime];
         }];
}

    //根据时间排序
-(void)getAlarmDataByTime
{
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:_alarmDataSource];
    
    NSArray *sortedArray = [tempArray sortedArrayUsingComparator:^NSComparisonResult(MessageModel *p1, MessageModel *p2){
        NSString *p1Ctime = [NSString stringWithFormat:@"%ld",p1.ctime];
         NSString *p2Ctime = [NSString stringWithFormat:@"%ld",p2.ctime];
        return [p2Ctime compare:p1Ctime];
        
        //return [p1.time compare:p2.time];
    }];
    _alarmDataSource = [NSMutableArray arrayWithArray:sortedArray];
    
    if (_alarmDataSource.count > 0) {
        _nodataView.hidden = YES;
    } else {
        _nodataView.hidden = NO;
        _nodataView.imageView.image = [UIImage imageNamed:@"All_OK.png"];
        _nodataView.titleLable.text = @"目前全部设备运转正常";
    }
    [_alarmTableView reloadData];
    
    [self endRefreshing];
}

    //获取待检修
-(void)getExamDataRequest
{
    NSString *urlString = [NSString stringWithFormat:@"%@rest/busiData/repair",BASE_PLAN_URL];
    NSDictionary *param = @{@"userSign":[PersonInfo shareInstance].accountID};
    
    DLog(@"请求地址 urlString = %@?%@",urlString,[param serializeToUrlString]);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:urlString
      parameters:param
        progress:^(NSProgress * _Nonnull downloadProgress) {} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
     [_examDataSource removeAllObjects];
     
     id  object = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
     NSArray *listArray = (NSArray *)object;
     for (int i=0; i<listArray.count; i++)
         {
         MessageModel *item = [[MessageModel alloc]initWithDictionary:[listArray objectAtIndex:i]];
         [_examDataSource addObject:item];
         }
         if (_examDataSource.count > 0) {
             _nodataView.hidden = YES;
         } else {
             _nodataView.hidden = NO;
             _nodataView.imageView.image = [UIImage imageNamed:@"ic_device_info_nothing.png"];
             _nodataView.titleLable.text = @"目前全部设备运转安全";
         }
     [_examTableView reloadData];
     [self endRefreshing];
     }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             DLog(@"获取待检修信息失败：%@",error);
         }];
}

    //获取待保养
-(void)getMaintainDataRequest
{
    NSString *urlString = [NSString stringWithFormat:@"%@rest/busiData/change",BASE_PLAN_URL];
    NSDictionary *param = @{@"userSign":[PersonInfo shareInstance].accountID};
    
    DLog(@"请求地址 urlString = %@?%@",urlString,[param serializeToUrlString]);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:urlString
      parameters:param
        progress:^(NSProgress * _Nonnull downloadProgress) {} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
     [_maintainDataSource removeAllObjects];
     
     id  object = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
     NSArray *listArray = (NSArray *)object;
     for (int i=0; i<listArray.count; i++)
         {
         MessageModel *item = [[MessageModel alloc]initWithDictionary:[listArray objectAtIndex:i]];
         [_maintainDataSource addObject:item];
         }
         if (_maintainDataSource.count > 0) {
             _nodataView.hidden = YES;
         } else {
             _nodataView.hidden = NO;
             _nodataView.imageView.image = [UIImage imageNamed:@"ic_device_info_nothing.png"];
             _nodataView.titleLable.text = @"目前全部设备运转安全";
         }
     [_maintainTableView reloadData];
     [self endRefreshing];
     }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             DLog(@"获取待保养 失败：%@",error);
         }];
}

    //选择已处理
-(void)dealMessageRequestWithType:(NSString *)type
{
    NSString *urlString;
    NSDictionary *param;
    if ([type intValue]==1)
        {
            NSString *postType = @"1";
            if ([_selectModel.remark isEqualToString:@"预警"])
            {
                postType = @"2";
            }
        urlString = [NSString stringWithFormat:@"%@rest/process/bugP",BASE_PLAN_URL];
        param = @{@"userSign":[PersonInfo shareInstance].accountID,
                                @"bugId":_selectModel.messageId,
                                @"type":postType};
    }
    if ([type intValue]==2)
        {
        urlString = [NSString stringWithFormat:@"%@rest/process/todoP",BASE_PLAN_URL];
        param = @{@"userSign":[PersonInfo shareInstance].accountID,
                  @"todoId":_selectModel.messageId,
                  @"type":@"1"};
        }
    if ([type intValue]==3)
        {
        urlString = [NSString stringWithFormat:@"%@rest/process/todoP",BASE_PLAN_URL];
        param = @{@"userSign":[PersonInfo shareInstance].accountID,
                  @"todoId":_selectModel.messageId,
                  @"type":@"2"};
        }
    
    
    DLog(@"请求地址 urlString = %@?%@",urlString,[param serializeToUrlString]);
    [MBProgressHUD showMessage:@"提交中..."];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:urlString
      parameters:param
        progress:^(NSProgress * _Nonnull downloadProgress) {} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
        [MBProgressHUD hideHUD];
         NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
         BOOL dealState  = [string boolValue];
     if (dealState==NO)
         {
         [BaseHelper waringInfo:@"提交失败"];
        }
     else
     {
         [self updateDataSource];
     }
         
        
     }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [MBProgressHUD hideHUD];
             DLog(@"处理失败：%@",error);
         }];

}

    //选择报修
-(void)maintainMessageRequestWithBugId:(NSString *)bugId
{
    NSString *urlString = [NSString stringWithFormat:@"%@rest/process/bugS",BASE_PLAN_URL];
    NSString *postType = @"1";
    if ([_selectModel.remark isEqualToString:@"预警"])
    {
        postType = @"2";
    }
    NSDictionary *param = @{@"userSign":[PersonInfo shareInstance].accountID,
                            @"bugId":bugId,
                            @"type":postType};
    
    DLog(@"请求地址 urlString = %@?%@",urlString,[param serializeToUrlString]);
    [MBProgressHUD showMessage:@"提交中..."];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:urlString
      parameters:param
        progress:^(NSProgress * _Nonnull downloadProgress) {} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
     [MBProgressHUD hideHUD];
         NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
         BOOL dealState  = [string boolValue];
     if (dealState==NO)
         {
         [BaseHelper waringInfo:@"提交失败"];
         }
         else
         {
             [self updateDataSource];
         }
     }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [MBProgressHUD hideHUD];
             DLog(@"报修失败：%@",error);
         }];
    
}
    //加载曲线
- (void)loadCurveWithModel:(MessageModel *)itemModel{
    __weak MessageViewController *ws = self;
    NSString *urlString = [NSString stringWithFormat:@"%@rest/initApp/showAlarm_graph",BASE_PLAN_URL];
    NSDictionary *param = @{@"bugId":itemModel.messageId};
    [BaseAFNRequest requestWithType:HttpRequestTypeGet additionParam:@{@"isNeedAlert":@"1"} urlString:urlString paraments:param successBlock:^(id object) {
        NSMutableArray * dataArray = [NSMutableArray arrayWithArray:object];
        NSMutableArray *lines = [NSMutableArray array];
        
        NSMutableArray *arrayOne = [NSMutableArray array];
        NSMutableArray *arrayTwo = [NSMutableArray array];
        
        [dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            DoubleGraphModel *model = [[DoubleGraphModel alloc] init];
            model.idf = obj[@"id"];
            model.name = obj[@"name"];
            model.sid = obj[@"sid"];
            model.time = obj[@"time"];
            model.timeLong = obj[@"timeLong"];
            model.value = obj[@"value"];
        }];
        [lines addObject:arrayOne];
        [lines addObject:arrayTwo];
        ws.fullScreenCurveVC.linesMutableArray = lines;
        ws.fullScreenCurveVC.xTitleLab.text = itemModel.messageTitle;
        [ws.navigationController pushViewController:ws.fullScreenCurveVC animated:NO];
    } failureBlock:^(NSError *error) {
        [MBProgressHUD showError:@"获取曲线失败"];
    } progress:nil];
}

#pragma mark - Private methods

- (void)endRefreshing
{
    [self.alarmTableView.mj_footer endRefreshing];
    [self.alarmTableView.mj_header endRefreshing];
    [self.examTableView.mj_footer endRefreshing];
    [self.examTableView.mj_header endRefreshing];
    [self.maintainTableView.mj_footer endRefreshing];
    [self.maintainTableView.mj_header endRefreshing];
}

- (void)makeupComponentUI
{
    
    _alarmDataSource = [[NSMutableArray alloc]init];
    _examDataSource = [[NSMutableArray alloc]init];
    _maintainDataSource = [[NSMutableArray alloc]init];
    
    [self.view addSubview:self.topView];
    [self.view addSubview:self.scrolView];
    
    [self.scrolView addSubview:self.alarmTableView];
    [self.scrolView addSubview:self.examTableView];
    [self.scrolView addSubview:self.maintainTableView];
    
    [self updateComponentUI];
}

- (void)updateComponentUI
{
    self.alarmTableView.y = 0;
    self.examTableView.y = 0;
    self.maintainTableView.y = 0;
    self.alarmTableView.height = self.scrolView.height;
    self.examTableView.height = self.scrolView.height;
    self.maintainTableView.height = self.scrolView.height;
    self.alarmTableView.x = 0;
    self.examTableView.x = self.scrolView.width;
    self.maintainTableView.x = self.scrolView.width*2;
   
    self.scrolView.contentSize = CGSizeMake(0, kScreen_Width);
    
    self.scrolView.y = CGRectGetMaxY(self.topView.frame);
    self.scrolView.height = self.view.height - self.topView.height;
    
     _currentTabelView = self.alarmTableView;
}

#pragma mark - action

-(void)topViewAction:(UIButton *)sender
{
    _nodataView.hidden = YES;
    selectViewTag = sender.tag;
    if (sender.tag == 11)
        {
        [self.topView.alarmButton setTitleColor:kAPPBlueColor forState:UIControlStateNormal];
        [self.topView.examButton setTitleColor:kAppTitleBlackColor forState:UIControlStateNormal];
        [self.topView.maintainButton setTitleColor:kAppTitleBlackColor forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.15 animations:^{
            [self.scrolView setContentOffset:CGPointMake(0, 0)];
            self.topView.lineView.centerX = self.topView.alarmButton.centerX;
        } ];
        _currentTabelView = self.alarmTableView;
        
    }
    else if (sender.tag == 12)
        {
        [self.topView.alarmButton setTitleColor:kAppTitleBlackColor forState:UIControlStateNormal];
        [self.topView.examButton setTitleColor:kAPPBlueColor forState:UIControlStateNormal];
        [self.topView.maintainButton setTitleColor:kAppTitleBlackColor forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.15 animations:^{
            [self.scrolView setContentOffset:CGPointMake(self.view.width, 0)];
            self.topView.lineView.centerX = self.topView.examButton.centerX;
        } ];
        _currentTabelView = self.examTableView;
    }
    else if (sender.tag == 13)
        {
        [self.topView.alarmButton setTitleColor:kAppTitleBlackColor forState:UIControlStateNormal];
        [self.topView.examButton setTitleColor:kAppTitleBlackColor forState:UIControlStateNormal];
        [self.topView.maintainButton setTitleColor:kAPPBlueColor forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.15 animations:^{
            [self.scrolView setContentOffset:CGPointMake(self.view.width*2, 0)];
            self.topView.lineView.centerX = self.topView.maintainButton.centerX;
        } ];
        _currentTabelView = self.maintainTableView;
        }
    [self dataRequest];
}

#pragma mark - MessageAlarmCellDeleagte
    //待处理
-(void)dealAlarmButtonActionWithItem:(MessageModel *)contentModel
{
    _selectModel = contentModel;
    
    NSString *message = @"您确认要选择\"已处理\"么？";
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 100;
    [alertView show];
    
}
    //报修
-(void)repairAlarmButtonActionWithItem:(MessageModel *)contentModel
{
    _selectModel = contentModel;

    NSString *message = @"您确认要选择\"提交检修\"么？";
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 101;
    [alertView show];
}
    //曲线
-(void)curveAlarmButtonActionWithItem:(MessageModel *)contentModel
{
    _selectModel = contentModel;
     NSString *pointId = [BaseHelper isSpaceString:contentModel.pointId andReplace:@""];
    if (pointId.length>0)
    {
    [self loadCurveWithModel:contentModel];
    }

}
    //定位
-(void)locationAlarmActionWithItem:(MessageModel *)contentModel
{
    _selectModel = contentModel;

    LocationViewController *vc = [[LocationViewController alloc]init];
    vc.deviceIdString = contentModel.deviceId;
    vc.hidesBottomBarWhenPushed = YES;
    vc.itemModel = contentModel;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - MessageExamCellDeleagte
    //已处理
-(void)dealExamButtonActionWithItem:(MessageModel *)contentModel
{
    _selectModel = contentModel;
    
    NSString *message = @"您确认要选择\"已处理\"么？";
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 102;
    [alertView show];
}
#pragma mark - MessageMaintainCellDeleagte
    //待处理
-(void)dealMaintainButtonActionWithItem:(MessageModel *)contentModel
{
    _selectModel = contentModel;
    
    NSString *message = @"您确认要选择\"已处理\"么？";
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 103;
    [alertView show];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==100)
        {
        if (buttonIndex==1)
            {
            [self dealMessageRequestWithType:@"1"];
        }
    }
    
    if (alertView.tag==101)
        {
        if (buttonIndex==1)
            {
            [self maintainMessageRequestWithBugId:_selectModel.messageId];
            }
        }
    if (alertView.tag==102)
        {
        if (buttonIndex==1)
            {
            [self dealMessageRequestWithType:@"2"];
            }
        }
    if (alertView.tag==103)
        {
        if (buttonIndex==1)
            {
            [self dealMessageRequestWithType:@"3"];
            }
        }
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
/**
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.scrolView])
        {
        NSInteger page = scrollView.contentOffset.x/SCREEN_WIDTH;
        DLog(@"page =%ld",(long)page);
        if (page == 0)
            {
            selectViewTag = 11;
            [self.topView.alarmButton setTitleColor:kAPPBlueColor forState:UIControlStateNormal];
            [self.topView.examButton setTitleColor:kAppTitleBlackColor forState:UIControlStateNormal];
            [self.topView.maintainButton setTitleColor:kAppTitleBlackColor forState:UIControlStateNormal];
            
            [UIView animateWithDuration:0.15 animations:^{
                [self.scrolView setContentOffset:CGPointMake(0, 0)];
                self.topView.lineView.centerX = self.topView.alarmButton.centerX;
            } ];
            _currentTabelView = self.alarmTableView;
            
        }
        else if (page == 1)
            {
            selectViewTag = 12;
            [self.topView.alarmButton setTitleColor:kAppTitleBlackColor forState:UIControlStateNormal];
            [self.topView.examButton setTitleColor:kAPPBlueColor forState:UIControlStateNormal];
            [self.topView.maintainButton setTitleColor:kAppTitleBlackColor forState:UIControlStateNormal];
            
            [UIView animateWithDuration:0.15 animations:^{
                [self.scrolView setContentOffset:CGPointMake(self.view.width, 0)];
                self.topView.lineView.centerX = self.topView.examButton.centerX;
            } ];
            _currentTabelView = self.examTableView;
            }
        else if (page == 2)
            {
            selectViewTag = 13;
            [self.topView.alarmButton setTitleColor:kAppTitleBlackColor forState:UIControlStateNormal];
            [self.topView.examButton setTitleColor:kAppTitleBlackColor forState:UIControlStateNormal];
            [self.topView.maintainButton setTitleColor:kAPPBlueColor forState:UIControlStateNormal];
            
            [UIView animateWithDuration:0.15 animations:^{
                [self.scrolView setContentOffset:CGPointMake(self.view.width*2, 0)];
                self.topView.lineView.centerX = self.topView.maintainButton.centerX;
            } ];
            _currentTabelView = self.maintainTableView;
            }
        [_currentTabelView reloadData];
    }
}
*/
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.alarmTableView)
        {
        return self.alarmDataSource.count;
        }
    else if (tableView == self.examTableView)
        {
        return self.examDataSource.count;
        }
    else if (tableView == self.maintainTableView)
        {
        return self.maintainDataSource.count;
        }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.000001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.alarmTableView)
        {
        NSString *cellIdentifier = [NSString stringWithFormat:@"alarmTableView_%ld_%ld",(long)indexPath.section,(long)indexPath.row];
        MessageAlarmCell  *cell = (MessageAlarmCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
            {
            cell = [[MessageAlarmCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (_alarmDataSource.count>0)
        {
            cell.cellDelegate = self;
            MessageModel *item = [_alarmDataSource objectAtIndex:indexPath.section];
            [cell setCellContentWithModel:item];
        }
        return cell;
        }
    else if (tableView == self.examTableView)
        {
        NSString *cellIdentifier = [NSString stringWithFormat:@"examTableView_%ld_%ld",(long)indexPath.section,(long)indexPath.row];
        MessageExamCell  *cell = (MessageExamCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
            {
            cell = [[MessageExamCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
        if (_examDataSource.count>0)
            {
            cell.cellDelegate = self;
            MessageModel *item = [_examDataSource objectAtIndex:indexPath.section];
            [cell setCellContentWithModel:item];
            }
        return cell;
        }
    else if (tableView == self.maintainTableView)
        {
        NSString *cellIdentifier = [NSString stringWithFormat:@"maintainTableView_%ld_%ld",(long)indexPath.section,(long)indexPath.row];
        MessageMaintainCell  *cell = (MessageMaintainCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
            {
            cell = [[MessageMaintainCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
        if (_maintainDataSource.count>0)
            {
            cell.cellDelegate = self;
            MessageModel *item = [_maintainDataSource objectAtIndex:indexPath.section];
            [cell setCellContentWithModel:item];
            }
        return cell;
        }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 115;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - getter
- (MessageTopView *)topView
{
    if (!_topView) {
        _topView = [[MessageTopView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 40)];
        [_topView.alarmButton addTarget:self action:@selector(topViewAction:) forControlEvents:UIControlEventTouchUpInside];
        [_topView.examButton addTarget:self action:@selector(topViewAction:) forControlEvents:UIControlEventTouchUpInside];
        [_topView.maintainButton addTarget:self action:@selector(topViewAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _topView;
}

- (PromptView *)promptView
{
    if (!_promptView) {
        _promptView = [[PromptView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - 64)];
        [_promptView setOneLabelText:@"暂时没有数据！" andTwoLabelText:@"" andSign:@""];
        _promptView.hidden = YES;
        
    }
    return _promptView;
}

- (UIScrollView *)scrolView
{
    if (!_scrolView) {
        _scrolView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topView.frame), self.view.width, kScreen_Height - 64 - self.topView.height)];
        _scrolView.contentSize = CGSizeMake(kScreen_Width *3, 0);
        _scrolView.pagingEnabled = YES;
        _scrolView.delegate = self;
    }
    return _scrolView;
}

- (UITableView *)alarmTableView
{
    if (!_alarmTableView) {
        _alarmTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - 64 - 40) style:UITableViewStyleGrouped];
        _alarmTableView.dataSource = self;
        _alarmTableView.delegate = self;
        _alarmTableView.backgroundColor = [UIColor clearColor];
        _alarmTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        __weak typeof(self) weakSelf = self;
        _alarmTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf dataRequest];
        }];
    }
    return _alarmTableView;
}


- (UITableView *)examTableView
{
    if (!_examTableView) {
        _examTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - 64 - 40) style:UITableViewStyleGrouped];
        _examTableView.dataSource = self;
        _examTableView.delegate = self;
        _examTableView.backgroundColor = [UIColor clearColor];
        _examTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        __weak typeof(self) weakSelf = self;
        _examTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf dataRequest];
        }];
    }
    return _examTableView;
}

- (UITableView *)maintainTableView
{
    if (!_maintainTableView) {
        _maintainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - 64 - 40) style:UITableViewStyleGrouped];
        _maintainTableView.dataSource = self;
        _maintainTableView.delegate = self;
        _maintainTableView.backgroundColor = [UIColor clearColor];
        _maintainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        __weak typeof(self) weakSelf = self;
        _maintainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf dataRequest];
        }];
    }
    return _maintainTableView;
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

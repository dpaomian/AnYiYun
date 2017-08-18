//
//  DailyMainViewController.m
//  AnYiYun
//
//  Created by wwr on 2017/7/20.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "DailyMainViewController.h"

@interface DailyMainViewController ()

/*!导航中间的日期显示*/
@property (nonatomic, strong) YYCalendarView *calendarTitleView;
/*!导航的日期Model*/
@property (nonatomic, strong) YYCalendarModel *datemodel;

@end

@implementation DailyMainViewController

/*!
 *配置导航
 */
- (void)configurationNavigationController {
    
    __weak DailyMainViewController *ws =self;
    /*导航左侧的日报按钮，不接收点击事件*/
    UIBarButtonItem *dailyButttonItem = [[UIBarButtonItem alloc] initWithTitle:@"日报" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.leftBarButtonItem = dailyButttonItem;
    
    _calendarTitleView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([YYCalendarView class]) owner:nil options:nil][0];
    _calendarTitleView.dailyDate = [NSDate date];
    _calendarTitleView.monthDate = [NSDate date];
    [_calendarTitleView updateDate: [NSDate date]];
    _calendarTitleView.isNavigation = YES;
    _calendarTitleView.bounds = CGRectMake(0.0f, 0.0f, SCREEN_WIDTH/2.0f, 44.0f);
    /*设置默认日起为当日*/
    [_calendarTitleView.dateButton setTitle:[NSString stringWithFormat:@"%.2d/%.2d",_datemodel.navigationMonth,_datemodel.navigationDay] forState:UIControlStateNormal];
    self.navigationItem.titleView = _calendarTitleView;
    _calendarTitleView.dateChangeHandle = ^(NSInteger yyYear, NSInteger yyMonth, NSInteger yyDay){
        NSString *dateString = [NSString stringWithFormat:@"%.2d/%.2d",yyMonth,yyDay];
        if (ws.datemodel.isDay) {
            dateString = [NSString stringWithFormat:@"%.2d/%.2ld",yyMonth,(long)yyDay];
        } else {
            dateString = [NSString stringWithFormat:@"%.2d/%.2ld",yyYear,(long)yyMonth];
        }
        [ws.calendarTitleView.dateButton setTitle:dateString forState:UIControlStateNormal];
        [ws dailyRequestAction];
    };
    
    /*点击弹出日历*/
    [_calendarTitleView.dateButton buttonClickedHandle:^(UIButton *sender) {
        if (ws.datemodel.isDay) {
            CalendarViewController *calenderVC = [[CalendarViewController alloc] init];
            calenderVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            calenderVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            calenderVC.choiceDateHandle = ^(NSDate *currentDate, NSInteger yyYear, NSInteger yyMonth, NSInteger yyDay){
                NSLog(@"点击的 %ld年%ld月%ld日",(long)yyYear,(long)yyMonth,(long)yyDay);
                ws.datemodel.navigationYear = yyYear;
                ws.datemodel.navigationMonth = yyMonth;
                ws.datemodel.navigationDay= yyDay;
                ws.calendarTitleView.dailyDate = currentDate;
                NSDateComponents *components = [ws.calendarTitleView.calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:ws.calendarTitleView.dailyDate];
                [ws.calendarTitleView updateDate:[ws.calendarTitleView.calendar dateFromComponents:components]];
                NSString *dateString = [NSString stringWithFormat:@"%.2ld/%.2ld",(long)yyMonth,(long)yyDay];
                if (ws.datemodel.isDay) {
                    dateString = [NSString stringWithFormat:@"%.2ld/%.2ld",(long)yyMonth,(long)yyDay];
                } else {
                    dateString = [NSString stringWithFormat:@"%.2ld/%.2ld",(long)yyYear,(long)yyMonth];
                }
                [ws.calendarTitleView.dateButton setTitle:dateString forState:UIControlStateNormal];
                [ws dailyRequestAction];
            };
            [ws.tabBarController presentViewController:calenderVC animated:NO completion:^{
                
            }];
        }else {
            [ws.tabBarController presentViewController:ws.monthCalenderVC animated:NO completion:^{
                
            }];
        }
    }];
    
    /*导航右侧的日/月切换按钮*/
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self createSegMentController]];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //刷新是否有未读消息
    [[NSNotificationCenter defaultCenter]postNotificationName:@"getMessageIsRead" object:@""];
}


    //创建导航栏分栏控件
-(UISegmentedControl *)createSegMentController{
    NSArray *segmentedArray = [NSArray arrayWithObjects:@"日",@"月",nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    segmentedControl.layer.cornerRadius = 4.0f;
    segmentedControl.layer.borderColor = UIColorFromRGB(0xFFFFFF).CGColor;
    segmentedControl.layer.borderWidth = 1.22f;
    segmentedControl.clipsToBounds = YES;
    segmentedControl.backgroundColor = [UIColor blackColor];
    segmentedControl.frame = CGRectMake(0, 0, 60, 30);
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.tintColor = UIColorFromRGB(0x5987F8);
    NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:15],
                                             NSForegroundColorAttributeName: [UIColor whiteColor]};
    [segmentedControl setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];
    NSDictionary* unselectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:15],
                                               NSForegroundColorAttributeName: [UIColor whiteColor]};
    [segmentedControl setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
    [segmentedControl addTarget:self action:@selector(indexDidChangeForSegmentedControl:) forControlEvents:UIControlEventValueChanged];
    segmentedControl.apportionsSegmentWidthsByContent = NO;
    return segmentedControl;
}
/*!
 *导航右侧的 日/月 选项卡
 */
-(void)indexDidChangeForSegmentedControl:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        _datemodel.isDay = YES;
        [_calendarTitleView.dateButton setTitle:[NSString stringWithFormat:@"%.2d/%.2d",_datemodel.navigationMonth,_datemodel.navigationDay] forState:UIControlStateNormal];
        [self dailyRequestAction];
    } else {
        _datemodel.isDay = NO;
        [_calendarTitleView.dateButton setTitle:[NSString stringWithFormat:@"%.2d/%.2d",_datemodel.monthNavigationYear,_datemodel.monthNavigationMonth] forState:UIControlStateNormal];
        [self dailyRequestAction];
    }
}
/*!
 *初始化日期并赋值到model
 */
- (void)datemodelInit {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:[NSDate date]];
    
    _datemodel = [YYCalendarModel shareModel];
    _datemodel.isDay = YES;
    _datemodel.navigationYear = dateComponents.year;
    _datemodel.navigationMonth = dateComponents.month;
    _datemodel.navigationDay= dateComponents.day;
    _datemodel.monthNavigationYear = dateComponents.year;
    _datemodel.monthNavigationMonth = dateComponents.month;
}

- (void)createPlaceHoldLable {
    _placeHoldLable = [[UILabel alloc] initWithFrame:CGRectMake(8.0f, 64.0f, SCREEN_WIDTH-8.0f, 64.0f)];
    _placeHoldLable.hidden = YES;
    _placeHoldLable.numberOfLines = 0;
    _placeHoldLable.textColor = UIColorFromRGB(0x000000);
    _placeHoldLable.textAlignment = NSTextAlignmentCenter;
    _placeHoldLable.font = [UIFont systemFontOfSize:15.0f];
    [self.view addSubview:_placeHoldLable];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak DailyMainViewController *ws = self;
    
    /*初始化model对象，方便取当前年月日*/
    [self datemodelInit];
    /*默认加载当日日报*/
    [self dailyRequestAction];
    
    _monthCalenderVC = [[MonthCalendarViewController alloc] init];
    _monthCalenderVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    _monthCalenderVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    _monthCalenderVC.choiceMonthHandle = ^(NSInteger yyYear, NSInteger yyMonth){
        ws.datemodel.navigationYear = yyYear;
        ws.datemodel.navigationMonth = yyMonth;
        NSString *dateString = [NSString stringWithFormat:@"%.2ld/%.2ld",(long)yyYear,(long)yyMonth];
        [ws.calendarTitleView.dateButton setTitle:dateString forState:UIControlStateNormal];
        [ws dailyRequestAction];
    };
    
    /*配置导航*/
    [self configurationNavigationController];
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;
    _webView.backgroundColor = UIColorFromRGB(0xFFFFFF);
    _webView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_webView];
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|[_webView]|"
                               options:1.0
                               metrics:nil
                               views:NSDictionaryOfVariableBindings(_webView)]];
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:|[_webView]|"
                               options:1.0
                               metrics:nil
                               views:NSDictionaryOfVariableBindings(_webView)]];
    
    /*创建一个lalel做别用，当没有日报或月报时用来展示文字提示*/
    [self createPlaceHoldLable];
}

- (void)dailyRequestAction {
    
    if (![BaseHelper checkNetworkStatus])
    {
        DLog(@"网络异常 请求被返回");
        [BaseHelper waringInfo:@"网络异常,请检查网络是否可用！"];
    }
    
    [MBProgressHUD showMessage:@""];
    
    NSString *dailyString = [NSString stringWithFormat:@"%.2d%.2d%.2d",_datemodel.navigationYear,_datemodel.navigationMonth,_datemodel.navigationDay];
    if (_datemodel.isDay) {
        dailyString = [NSString stringWithFormat:@"%.2d%.2d%.2d",_datemodel.navigationYear,_datemodel.navigationMonth,_datemodel.navigationDay];
    } else {
        dailyString = [NSString stringWithFormat:@"%.2d%.2d",_datemodel.navigationYear,_datemodel.navigationMonth];
    }
    
    __weak DailyMainViewController *ws = self;
    NSString *urlString = [NSString stringWithFormat:@"%@%@",BASE_PLAN_URL,_datemodel.isDay ? @"rest/page/report":@"rest/page/monthReport"];
    NSDictionary *parameters = @{@"userSign":[PersonInfo shareInstance].accountID,@"date":dailyString};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:urlString
      parameters:parameters
        progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [MBProgressHUD hideHUD];
            NSString *result = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
            if ([!result?@"":result length] > 0) {
                ws.webView.hidden = NO;
                ws.placeHoldLable.hidden = YES;
                NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:result]];
                [ws.webView loadRequest:request];
            } else {
                ws.webView.hidden = YES;
                ws.placeHoldLable.hidden = NO;
                ws.placeHoldLable.text = ws.datemodel.isDay?@"您所选择的日期没有日报":@"您所选择的月份没有月报";
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [MBProgressHUD hideHUD];
        }];
}

#pragma mark -
#pragma mark UIWebViewDelegate -
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [MBProgressHUD showMessage:@"加载中..."];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [MBProgressHUD hideHUD];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [MBProgressHUD showError:@"加载失败"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

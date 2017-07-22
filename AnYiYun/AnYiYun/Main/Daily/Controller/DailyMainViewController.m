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
    _calendarTitleView.calendarDate = [NSDate date];
    [_calendarTitleView updateDate: [NSDate date]];
    _calendarTitleView.bounds = CGRectMake(0.0f, 0.0f, SCREEN_WIDTH/2.0f, 44.0f);
    /*设置默认日起为当日*/
    [_calendarTitleView.dateButton setTitle:[NSString stringWithFormat:@"%.2d/%.2d",_datemodel.day,_datemodel.month] forState:UIControlStateNormal];
    self.navigationItem.titleView = _calendarTitleView;
    _calendarTitleView.dateChangeHandle = ^(NSString *dateString){
        [ws.calendarTitleView.dateButton setTitle:dateString forState:UIControlStateNormal];
    };
    
    /*点击弹出日历*/
    [_calendarTitleView.dateButton buttonClickedHandle:^(UIButton *sender) {
        CalendarViewController *calenderVC = [[CalendarViewController alloc] init];
        calenderVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        calenderVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [ws.tabBarController presentViewController:calenderVC animated:NO completion:^{
            
        }];
    }];
    
    /*导航右侧的日/月切换按钮*/
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self createSegMentController]];
    
}

    //创建导航栏分栏控件
-(UISegmentedControl *)createSegMentController{
    NSArray *segmentedArray = [NSArray arrayWithObjects:@"日",@"月",nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    segmentedControl.layer.cornerRadius = 4.0f;
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
        [_calendarTitleView.dateButton setTitle:[NSString stringWithFormat:@"%.2d/%.2d",_datemodel.day,_datemodel.month] forState:UIControlStateNormal];
    } else {
        _datemodel.isDay = NO;
        [_calendarTitleView.dateButton setTitle:[NSString stringWithFormat:@"%.2d/%.2d",_datemodel.year,_datemodel.month] forState:UIControlStateNormal];
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
    _datemodel.year = dateComponents.year;
    _datemodel.month = dateComponents.month;
    _datemodel.day = dateComponents.day;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    /*初始化model对象，方便取当前年月日*/
    [self datemodelInit];
    /*配置导航*/
    [self configurationNavigationController];
    NSLog(@"%@",[PersonInfo shareInstance].accountID);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

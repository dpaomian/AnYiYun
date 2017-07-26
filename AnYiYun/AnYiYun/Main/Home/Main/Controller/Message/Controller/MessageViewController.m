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

@interface MessageViewController ()<UITableViewDelegate,UITableViewDataSource,MessageExamCellDeleagte,MessageAlarmCellDeleagte,MessageMaintainCellDeleagte,UIScrollViewDelegate>
{
    UITableView *_currentTabelView;
}

@property (nonatomic, strong) UIScrollView *scrolView;
@property (nonatomic, strong) PromptView *promptView;
@property (nonatomic, strong) MessageTopView *topView;

@property (nonatomic, strong) UITableView *alarmTableView;
@property (nonatomic, strong) UITableView *examTableView;
@property (nonatomic, strong) UITableView *maintainTableView;

@property (nonatomic, strong) NSMutableArray *alarmDataSource;
@property (nonatomic, strong) NSMutableArray *examDataSource;
@property (nonatomic, strong) NSMutableArray *maintainDataSource;

@end

@implementation MessageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"消息中心";
    
    
    [self makeupComponentUI];
    [self dataRequest];
    
    
}
#pragma mark - public methods
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
    [self.view addSubview:self.topView];
    [self.view addSubview:self.scrolView];
    
    [self.scrolView addSubview:self.alarmTableView];
    [self.scrolView addSubview:self.examTableView];
    [self.scrolView addSubview:self.maintainTableView];
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
    _currentTabelView = self.alarmTableView;
    self.scrolView.contentSize = CGSizeMake(kScreen_Width *3, 0);
    self.scrolView.y = CGRectGetMaxY(self.topView.frame);
    self.scrolView.height = self.view.height - self.topView.height;
    
    [_currentTabelView reloadData];
}

#pragma mark - action

-(void)topViewAction:(UIButton *)sender
{
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
    [_currentTabelView reloadData];
}

#pragma mark -
#pragma mark - UITableViewDataSource & UITableViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.scrolView])
        {
        NSInteger page = scrollView.contentOffset.x/SCREEN_WIDTH;
        if (page == 0)
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
        else if (page == 1)
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
        else if (page == 2)
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
        [_currentTabelView reloadData];
    }
}

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
    return 110;
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
        _scrolView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topView.frame), self.view.width, self.view.height - self.topView.height)];
        _scrolView.contentSize = CGSizeMake(kScreen_Width *3, 0);
        _scrolView.pagingEnabled = YES;
        _scrolView.delegate = self;
    }
    return _scrolView;
}

- (UITableView *)alarmTableView
{
    if (!_alarmTableView) {
        _alarmTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, self.scrolView.height - 64) style:UITableViewStylePlain];
        _alarmTableView.dataSource = self;
        _alarmTableView.delegate = self;
        _alarmTableView.backgroundColor = kAppBackgrondColor;
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
        _examTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, self.scrolView.height - 64) style:UITableViewStylePlain];
        _examTableView.dataSource = self;
        _examTableView.delegate = self;
        _examTableView.backgroundColor = kAppBackgrondColor;
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
        _maintainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, self.scrolView.height - 64) style:UITableViewStylePlain];
        _maintainTableView.dataSource = self;
        _maintainTableView.delegate = self;
        _maintainTableView.backgroundColor = kAppBackgrondColor;
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

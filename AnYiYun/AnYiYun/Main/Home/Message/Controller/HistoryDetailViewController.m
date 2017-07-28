//
//  HistoryDetailViewController.m
//  AnYiYun
//
//  Created by wwr on 2017/7/26.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "HistoryDetailViewController.h"
#import "DBDaoDataBase.h"
#import "HistoryDetailCell.h"
@interface HistoryDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *bgTableView;
@property (nonatomic, strong) NSMutableArray *bgDataSource;



@end

@implementation HistoryDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.typeTitleString;
    
    self.view.backgroundColor = RGB(239, 239, 244);
    [self makeupComponentUI];
    
}

- (void)makeupComponentUI
{
    _bgDataSource = [[NSMutableArray alloc]init];
    [self.view addSubview:self.bgTableView];
    
    _bgDataSource = [[DBDaoDataBase sharedDataBase]getAllHistoryMessagesInfoWithType:self.typeString];
    
    /**
     //测试数据 需删除
    MessageModel *itemModel = [[MessageModel alloc]init];
    itemModel.type = @"1";//待报修
    itemModel.messageTitle = @"待报修标题标题标题标题标题标题标题标题标题标题";
    itemModel.messageContent = @"测试标题标题标题标题标题标题标题标题标题标题标题标题";
    itemModel.time =@"123456";
    [_bgDataSource addObject:itemModel];
    [_bgDataSource addObject:itemModel];
    */
    
    [_bgTableView reloadData];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.bgDataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = [NSString stringWithFormat:@"bgTableView_%ld_%ld",(long)indexPath.section,(long)indexPath.row];
    HistoryDetailCell  *cell = (HistoryDetailCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[HistoryDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (_bgDataSource.count>0)
    {
        MessageModel *item = [_bgDataSource objectAtIndex:indexPath.section];
        [cell setCellContentWithModel:item];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - getter
- (UITableView *)bgTableView
{
    if (!_bgTableView) {
        _bgTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - 64) style:UITableViewStylePlain];
        _bgTableView.dataSource = self;
        _bgTableView.delegate = self;
        _bgTableView.backgroundColor = [UIColor clearColor];
        _bgTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _bgTableView;
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

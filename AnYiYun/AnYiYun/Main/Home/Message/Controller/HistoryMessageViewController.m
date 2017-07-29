//
//  HistoryMessageViewController.m
//  AnYiYun
//
//  Created by wwr on 2017/7/26.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "HistoryMessageViewController.h"
#import "DBDaoDataBase.h"
#import "HistoryMessageCell.h"
#import "HistoryDetailViewController.h"

@interface HistoryMessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *bgTableView;
@property (nonatomic, strong) NSMutableArray *datasource;

@end

@implementation HistoryMessageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
     self.title = @"历史消息";
    
    self.view.backgroundColor = RGB(239, 239, 244);
    [self makeupComponentUI];
    
}

- (void)makeupComponentUI
{
    _datasource = [[NSMutableArray alloc]init];
    [self.view addSubview:self.bgTableView];
    
    NSMutableArray *examArray = [[NSMutableArray alloc]init];
    examArray = [[DBDaoDataBase sharedDataBase]getAllHistoryMessagesInfoWithType:@"1"];
    if (examArray.count>0)
    {
        MessageModel *messageModel = [examArray objectAtIndex:0];
        
        HistoryMessageModel *itemModel = [[HistoryMessageModel alloc]init];
        itemModel.type = @"1";//待报修
        itemModel.typeTitle = @"待报修";
        itemModel.content = messageModel.messageContent;
        itemModel.time = messageModel.uploadtime;
        [_datasource addObject:itemModel];
    }
    
    NSMutableArray *maintainArray = [[NSMutableArray alloc]init];
    maintainArray = [[DBDaoDataBase sharedDataBase]getAllHistoryMessagesInfoWithType:@"2"];
    if (maintainArray.count>0)
    {
        MessageModel *messageModel = [maintainArray objectAtIndex:0];
        
        HistoryMessageModel *itemModel = [[HistoryMessageModel alloc]init];
        itemModel.type = @"2";//待报修
        itemModel.typeTitle = @"待保养";
        itemModel.content = messageModel.messageContent;
        itemModel.time = messageModel.uploadtime;
        [_datasource addObject:itemModel];
    }
    
    /** 
     //测试数据 需删除
    HistoryMessageModel *itemModel = [[HistoryMessageModel alloc]init];
    itemModel.type = @"1";//待报修
    itemModel.typeTitle = @"待报修";
    itemModel.content = @"测试标题";
    itemModel.time =12345695;
    [_datasource addObject:itemModel];
    [_datasource addObject:itemModel];
     */
    
    
    [_bgTableView reloadData];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.datasource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = [NSString stringWithFormat:@"bgTableView_%ld_%ld",(long)indexPath.section,(long)indexPath.row];
    HistoryMessageCell  *cell = (HistoryMessageCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[HistoryMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (_datasource.count>0)
    {
        HistoryMessageModel *item = [_datasource objectAtIndex:indexPath.section];
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
    
    HistoryMessageModel *item = [_datasource objectAtIndex:indexPath.section];
    HistoryDetailViewController *vc = [[HistoryDetailViewController alloc]init];
    vc.typeString = item.type;
    vc.typeTitleString = item.typeTitle;
    [self.navigationController pushViewController:vc animated:YES];
    
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

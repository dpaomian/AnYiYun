//
//  StandardViewController.m
//  AnYiYun
//
//  Created by 韩亚周 on 2017/9/24.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "StandardViewController.h"

@interface StandardViewController ()

@end

@implementation StandardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"规程与标准";
    [self makeUI];
}

#pragma mark - request


-(void)getUseDataRequest
{
    if (![BaseHelper checkNetworkStatus])
    {
        DLog(@"网络异常 请求被返回");
        [BaseHelper waringInfo:@"网络异常,请检查网络是否可用！"];
        return;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",BASE_PLAN_URL,@"rest/doc/ruleList"];
    NSDictionary *param = @{@"userSign":[PersonInfo shareInstance].accountID};
    
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
             DLog(@"请求结果 jsonObject = %@",jsonObject);
             if ([jsonObject isKindOfClass:[NSArray class]])
             {
                 NSArray *useArray = (NSArray *)jsonObject;
                 for (int i=0; i<useArray.count; i++)
                 {
                     NSDictionary *useDic = [useArray objectAtIndex:i];
                     DeviceDocModel *itemModel = [DeviceDocModel mj_objectWithKeyValues:useDic];
                     [_datasource addObject:itemModel];
                 }
                 [_bgTableView reloadData];
             }
         }
     }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             DLog(@"请求失败：%@",error);
         }];
    
}

-(void)makeUI
{
    _datasource = [[NSMutableArray alloc]init];
    [self.view addSubview:self.bgTableView];
    
    [self getUseDataRequest];
    
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = [NSString stringWithFormat:@"cellIdentifier"];
    UITableViewCell  *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (_datasource.count>0) {
        DeviceDocModel *itemModel = [_datasource objectAtIndex:indexPath.row];
        cell.textLabel.text = itemModel.name;
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
        cell.textLabel.textColor = kAppTitleBlackColor;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12.0f];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2fK",itemModel.size/1024.0f];
        cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[itemModel.suffix stringByReplacingOccurrencesOfString:@"." withString:@""]]];
    }
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DeviceDocModel *item = [_datasource objectAtIndex:indexPath.row];
    
    if ([item.suffix isEqualToString:@".gif"] ||
        [item.suffix isEqualToString:@".png"] ||
        [item.suffix isEqualToString:@".jpg"]) {
        PublicWebViewController *vc = [[PublicWebViewController alloc]init];
        vc.myUrl = item.url;
        vc.titleStr = item.name;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        __block MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
            //创建传话管理者
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:item.url]];
            //下载文件
        /*
         第一个参数:请求对象
         第二个参数:progress 进度回调
         第三个参数:destination 回调(目标位置)
         有返回值
         targetPath:临时文件路径
         response:响应头信息
         第四个参数:completionHandler 下载完成后的回调
         filePath:最终的文件路径
         */
        NSURLSessionDownloadTask *download = [manager downloadTaskWithRequest:request
                                                                     progress:^(NSProgress * _Nonnull downloadProgress) {
                                                                             //下载进度
                                                                         NSLog(@"%f",1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
                                                                         CGFloat progress = 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
                                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                                             hud.progress = progress;
                                                                             hud.label.text = [NSString stringWithFormat:@"%.2f%%",progress*100.f];
                                                                             if (progress == 1.0f) {
                                                                                 [hud hideAnimated:YES];
                                                                             }
                                                                         });
                                                                     }
                                                                  destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                                                                          //保存的文件路径
                                                                      NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:response.suggestedFilename];
                                                                      return [NSURL fileURLWithPath:fullPath];
                                                                  }
                                                            completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                                                                if (error == nil) {
                                                                    /*url 为需要调用第三方打开的文件地址-*/
                                                                    NSURL *url = [NSURL fileURLWithPath:[filePath path]];
                                                                    _documentInteractionController = [UIDocumentInteractionController
                                                                                                      interactionControllerWithURL:url];
                                                                    [_documentInteractionController setDelegate:self];
                                                                    
                                                                    [_documentInteractionController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
                                                                }else{//下载失败的时候，只列举判断了两种错误状态码
                                                                    NSString * message = nil;
                                                                    if (error.code == - 1005) {
                                                                        message = @"网络异常";
                                                                    }else if (error.code == -1001){
                                                                        message = @"请求超时";
                                                                    }else{
                                                                        message = @"未知错误";
                                                                    }
                                                                    [MBProgressHUD showError:message];
                                                                }
                                                            }];
            //执行Task
        [download resume];
    }
}
#pragma mark - getter
- (UITableView *)bgTableView
{
    if (!_bgTableView) {
        _bgTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - 64) style:UITableViewStylePlain];
        _bgTableView.dataSource = self;
        _bgTableView.delegate = self;
        _bgTableView.backgroundColor = [UIColor clearColor];
        _bgTableView.tableFooterView = [[UIView alloc]init];
    }
    return _bgTableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end

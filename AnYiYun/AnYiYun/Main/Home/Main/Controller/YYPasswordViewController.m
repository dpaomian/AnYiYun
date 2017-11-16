//
//  YYPasswordViewController.m
//  AnYiYun
//
//  Created by 韩亚周 on 2017/10/25.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "YYPasswordViewController.h"

@interface YYPasswordViewController ()

@end

@implementation YYPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak YYPasswordViewController *ws = self;
    self.view.backgroundColor = UIColorFromRGBA(0x000000, 0.6f);
    
    [self.passwordTableView registerNib:[UINib nibWithNibName:NSStringFromClass([YYPswCell class]) bundle:nil] forCellReuseIdentifier:@"YYPswCell"];
    _passwordTableView.delegate = self;
    _passwordTableView.scrollEnabled = NO;
    _passwordTableView.dataSource = self;
    _passwordTableView.tableFooterView = [UIView new];
    _passwordTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [_close buttonClickedHandle:^(UIButton *sender) {
        [ws dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
}

#pragma mark -
#pragma mark UITableViewDataSource -

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 66.0f)];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 66.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0f;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak YYPasswordViewController *ws = self;
    YYPswCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YYPswCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [cell.textField becomeFirstResponder];
    });
    cell.inputOver = ^(YYPswCell *yyCell, NSString *yyStr) {
        NSString *urlString = [NSString stringWithFormat:@"%@rest/process/switchP",BASE_PLAN_URL];
        
        NSDictionary *param = @{@"userSign":[PersonInfo shareInstance].accountID,@"pointId":ws.model.idF,@"now":[ws.model.point_value isEqualToString:@"关闭"]?@"0":@"1",@"psw":[yyStr SHA256]};
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager GET:urlString
          parameters:param
            progress:^(NSProgress * _Nonnull downloadProgress) {} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [MBProgressHUD hideHUD];
                NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                BOOL dealState  = [string boolValue];
                
                if (dealState==NO) {
                    [BaseHelper waringInfo:@"修改失败"];
                } else {
                    [MBProgressHUD showSuccess:@"修改成功"];
                    [ws dismissViewControllerAnimated:YES completion:^{
                        
                    }];
                }
            }
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 [MBProgressHUD hideHUD];
                 [MBProgressHUD showError:@"修改失败"];
             }];
    };
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (SCREEN_WIDTH-80.0f)/6+34.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark UITableViewDelegate -

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

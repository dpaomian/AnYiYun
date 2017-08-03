//
//  PopViewController.m
//  AnYiYun
//
//  Created by 韩亚周 on 2017/8/1.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "PopViewController.h"
#import "HelpViewController.h"

@interface PopViewController ()

@property (nonatomic, strong) NSArray   *titlesArray;

@end

@implementation PopViewController

-(void) viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:NO]; //设置隐藏
    [super viewWillAppear:animated];
    if (_inputTextView) {
        _inputTextView.text = @"";
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGBA(0x000000, 0.0);
    
    __weak PopViewController *ws = self;
    [_backgroundBtn buttonClickedHandle:^(UIButton *sender) {
        ws.view.backgroundColor = UIColorFromRGBA(0x000000, 0.0);
        [ws.inputTextView resignFirstResponder];
        ws.inputBackgroundView.hidden = YES;
        [ws dismissViewControllerAnimated:NO completion:^{
            ws.tableView.hidden = NO;
        }];
    }];
    
    [_cancleBtn buttonClickedHandle:^(UIButton *sender) {
        ws.view.backgroundColor = UIColorFromRGBA(0x000000, 0.0);
        [ws.inputTextView resignFirstResponder];
        ws.inputBackgroundView.hidden = YES;
        [ws dismissViewControllerAnimated:NO completion:^{
            ws.tableView.hidden = NO;
        }];
    }];
    [_okBtn buttonClickedHandle:^(UIButton *sender) {
        if ([ws.inputTextView.text length]<=0) {
            [MBProgressHUD showError:@"不能提交空内容!"];
            return ;
        }
        [MBProgressHUD showMessage:@"正在提交..."];
        NSString *urlString = [NSString stringWithFormat:@"%@rest/process/supS",BASE_PLAN_URL];
        NSDictionary *param = @{@"userSign":[PersonInfo shareInstance].accountID,@"content":ws.inputTextView.text};
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager GET:urlString
          parameters:param
            progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [MBProgressHUD hideHUD];
                NSString *result = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
                if ([result boolValue]) {
                    ws.view.backgroundColor = UIColorFromRGBA(0x000000, 0.0);
                    [ws.inputTextView resignFirstResponder];
                    ws.inputBackgroundView.hidden = YES;
                    [ws dismissViewControllerAnimated:NO completion:^{
                        ws.tableView.hidden = NO;
                        [MBProgressHUD showSuccess:@"提交成功"];
                    }];
                } else {
                    [MBProgressHUD showError:@"提交失败"];
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [MBProgressHUD hideHUD];
            }];/**/
    }];
    
    _titlesArray = _noHelp?@[@"支持"]:@[@"帮助",@"支持"];
    _tableViewHeight.constant = _noHelp?43.0f:87.0f;
    
    self.tableView.separatorColor = UIColorFromRGB(0x000000);
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_titlesArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.textLabel.text = _titlesArray[indexPath.row];
    cell.contentView.backgroundColor = UIColorFromRGB(0x333333);
    cell.backgroundColor = UIColorFromRGB(0x333333);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = UIColorFromRGB(0xFFFFFF);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    _tableView.hidden = YES;
    if (_noHelp) {
        _inputBackgroundView.hidden = NO;
        self.view.backgroundColor = UIColorFromRGBA(0x000000, 0.4);
    } else {
        if (indexPath.row == 0) {
            __weak PopViewController *ws = self;
            HelpViewController *helpVC = [[HelpViewController alloc] init];
            helpVC.navigationController.navigationBar.hidden = NO;
            helpVC.navigationItem.backBarButtonItem.title = @"使用帮助";
            helpVC.backHandle = ^(){
                [ws dismissViewControllerAnimated:NO completion:^{
                    ws.tableView.hidden = NO;
                }];
            };
            [self.navigationController pushViewController:helpVC animated:YES];
        } else {
            _inputBackgroundView.hidden = NO;
            self.view.backgroundColor = UIColorFromRGBA(0x000000, 0.4);
        }
    }
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    if ([textView.text length] >200) {
        textView.text = [textView.text substringToIndex:200];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            textView.contentOffset = CGPointMake(0, 0);
        });
        [MBProgressHUD showError:@"超出最大输入长度"];
    }
    self.textCountLab.text = [NSString stringWithFormat:@"%d/200",[textView.text length]];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([textView.text length] >= 200 && [text length] != 0) {
        [textView resignFirstResponder];
        [MBProgressHUD showError:@"超出最大输入长度"];
        return NO;
    }
    return YES;
}

@end

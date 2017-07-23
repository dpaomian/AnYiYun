//
//  CalendarViewController.m
//  AnYiYun
//
//  Created by 韩亚周 on 17/7/22.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "CalendarViewController.h"

@interface CalendarViewController ()

@property (nonatomic, strong) YYCalendarModel * calendarModel;
/*!导航中间的日期显示*/
@property (nonatomic, strong) YYCalendarView *calendarTitleView;
/*!导航中间的日期显示*/
@property (nonatomic, strong) NSArray *weekDaysArray;

@end

@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    __weak CalendarViewController *ws = self;
    self.view.backgroundColor = [UIColor clearColor];
    
    _calendarModel = [YYCalendarModel shareModel];
    _weekDaysArray = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    
    CGFloat currentWith = (SCREEN_WIDTH-16.0f-6.0f)/7.0f;
    NSInteger lines = [_calendarModel.allDays count]/7;
    CGFloat collectionViewHeight = (currentWith+1.0f) * lines+4.0f+20.88f+4.0f;
    
    UIView *navigationView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, NAV_HEIGHT+1.0f)];
    navigationView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:navigationView];
    UIView *navigationBottomView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, NAV_HEIGHT+1.0f, SCREEN_WIDTH, NAV_HEIGHT-20.0f)];
    navigationBottomView.backgroundColor = [UIColor redColor];
    [self.view addSubview:navigationBottomView];
    
    
    _calendarTitleView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([YYCalendarView class]) owner:nil options:nil][0];
    _calendarTitleView.isNavigation = NO;
    _calendarTitleView.calendarDate = [NSDate date];
    [_calendarTitleView updateDate: [NSDate date]];
    _calendarTitleView.translatesAutoresizingMaskIntoConstraints = NO;
    _calendarTitleView.bounds = CGRectMake(0.0f, 0.0f, SCREEN_WIDTH/2.0f, 44.0f);
    /*设置默认日起为当日*/
    [_calendarTitleView.dateButton setTitle:[NSString stringWithFormat:@"%.2d年%.2d月",_calendarModel.year,_calendarModel.month] forState:UIControlStateNormal];
    self.navigationItem.titleView = _calendarTitleView;
    _calendarTitleView.dateChangeHandle = ^(NSInteger yyYear, NSInteger yyMonth, NSInteger yyDay){
        [ws.calendarTitleView.dateButton setTitle:[NSString stringWithFormat:@"%.2d年%.2d月",yyYear,yyMonth] forState:UIControlStateNormal];
    };
    
    /*点击弹出日历*/
    [_calendarTitleView.dateButton buttonClickedHandle:^(UIButton *sender) {
        /*无需处理*/
    }];
    [self.view addSubview:_calendarTitleView];
    
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.headerReferenceSize = CGSizeMake(0, 0);
    layout.footerReferenceSize = CGSizeMake(0, 0);
    
    self.calendarCollectionView=[[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [_calendarCollectionView registerNib:[UINib nibWithNibName:@"YYCalendarCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"YYCalendarCollectionViewCell"];
    _calendarCollectionView.delegate=self;
    _calendarCollectionView.dataSource=self;
    _calendarCollectionView.scrollsToTop = NO;
    _calendarCollectionView.showsHorizontalScrollIndicator=NO;
    _calendarCollectionView.backgroundColor = UIColorFromRGB(0xFFFFFF);
    _calendarCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    _calendarCollectionView.allowsMultipleSelection = NO;
    [self.view addSubview:_calendarCollectionView];
    
    UIButton *touchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    touchButton.translatesAutoresizingMaskIntoConstraints = NO;
    touchButton.backgroundColor = UIColorFromRGBA(0x000000, 0.4);
    [touchButton buttonClickedHandle:^(UIButton *sender) {
        [ws dismissViewControllerAnimated:NO completion:^{
            
        }];
    }];
    [self.view addSubview:touchButton];
    
    
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:_calendarTitleView
                              attribute:NSLayoutAttributeTop
                              relatedBy:NSLayoutRelationEqual
                              toItem:navigationView
                              attribute:NSLayoutAttributeBottom
                              multiplier:1.0
                              constant:0]];
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:_calendarTitleView
                              attribute:NSLayoutAttributeHeight
                              relatedBy:NSLayoutRelationEqual
                              toItem:nil
                              attribute:NSLayoutAttributeHeight
                              multiplier:1.0
                              constant:NAV_HEIGHT-20.0f]];
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:_calendarCollectionView
                              attribute:NSLayoutAttributeTop
                              relatedBy:NSLayoutRelationEqual
                              toItem:navigationView
                              attribute:NSLayoutAttributeBottom
                              multiplier:1.0
                              constant:NAV_HEIGHT-20.0f]];
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|[_calendarCollectionView]|"
                               options:1.0
                               metrics:nil
                               views:NSDictionaryOfVariableBindings(_calendarCollectionView)]];
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|-44-[_calendarTitleView]-44-|"
                               options:1.0
                               metrics:nil
                               views:NSDictionaryOfVariableBindings(_calendarTitleView)]];
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:_calendarCollectionView
                              attribute:NSLayoutAttributeHeight
                              relatedBy:NSLayoutRelationEqual
                              toItem:nil
                              attribute:NSLayoutAttributeHeight
                              multiplier:1.0
                              constant:collectionViewHeight]];
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:touchButton
                              attribute:NSLayoutAttributeTop
                              relatedBy:NSLayoutRelationEqual
                              toItem:_calendarCollectionView
                              attribute:NSLayoutAttributeBottom
                              multiplier:1.0
                              constant:0]];
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|[touchButton]|"
                               options:1.0
                               metrics:nil
                               views:NSDictionaryOfVariableBindings(touchButton)]];
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:touchButton
                              attribute:NSLayoutAttributeHeight
                              relatedBy:NSLayoutRelationEqual
                              toItem:nil
                              attribute:NSLayoutAttributeHeight
                              multiplier:1.0
                              constant:SCREEN_HEIGHT - collectionViewHeight - NAV_HEIGHT-NAV_HEIGHT-44.0f]];
}

#pragma mark -
#pragma mark UICollectionViewDataSource -
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return [_weekDaysArray count];
    } else {
        return [_calendarModel.allDays count];
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YYCalendarCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YYCalendarCollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    if (indexPath.section == 0) {
        cell.titleLable.text = _weekDaysArray[indexPath.row];
        cell.titleLable.textColor = UIColorFromRGB(0x3D3D3D);
    } else {
        cell.titleLable.textColor = UIColorFromRGB(0x000000);
        if (indexPath.row <[_calendarModel.firstDays count] || indexPath.row >([_calendarModel.allDays count] - [_calendarModel.firstDays count])) {
            cell.titleLable.text = @"";
        } else {
            
            NSCalendar *calendar = [NSCalendar currentCalendar];
            unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
            __block NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:[NSDate date]];
            
            if (_calendarModel.year == dateComponents.year &&
                _calendarModel.month == dateComponents.month &&
                [[_calendarModel allDays][indexPath.row] integerValue] == dateComponents.day) {
                cell.markImageView.image = [UIImage imageNamed:@"daily_selected.png"];
            } else {
                cell.markImageView.image = nil;
            }
            
            cell.titleLable.text = _calendarModel.allDays[indexPath.row];
        }
    }
    return cell;
}

#pragma mark -
#pragma mark UICollectionViewDelegate -

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row <[_calendarModel.firstDays count] ||
        indexPath.row >([_calendarModel.allDays count] - [_calendarModel.firstDays count]) ||
        indexPath.section == 0) {
        return;
    } else {
        NSLog(@"点击的 %d年%d月%@日",_calendarModel.year,_calendarModel.month,[_calendarModel allDays][indexPath.row]);
    }
}

#pragma mark -
#pragma mark UICollectionViewDelegateFlowLayout -
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return CGSizeMake((SCREEN_WIDTH-16.0f-6.0f)/7.0f, 20.0f);
    } else {
        return CGSizeMake((SCREEN_WIDTH-16.0f-6.0f)/7.0f, (SCREEN_WIDTH-16.0f-6.0f)/7.0f);
    }
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 8, 4, 8);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0.88f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.88f;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end

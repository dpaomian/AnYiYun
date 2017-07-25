//
//  FilterCollectionView.m
//  AnYiYun
//
//  Created by 韩亚周 on 2017/7/25.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "FilterCollectionView.h"

@interface FilterCollectionView ()

/*!筛选项*/
@property (nonatomic, strong) NSMutableArray *screenMutableArray;

@end

@implementation FilterCollectionView

+ (FilterCollectionView *)shareFilter {
    static FilterCollectionView *filter = nil;
    static dispatch_once_t oncetoken;
    dispatch_once(&oncetoken, ^{
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        filter = [[self alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    });
    return filter;
}
- (void)loadCommpanyItemsWithManager:(AFHTTPSessionManager *)manager {
    __weak FilterCollectionView *ws = self;
    NSString *urlString = [NSString stringWithFormat:@"%@%@",BASE_PLAN_URL,@"rest/busiData/allOrg"];
    NSDictionary *parameters = @{@"userSign":[PersonInfo shareInstance].accountID};
    [manager GET:urlString
      parameters:parameters
        progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"******1`1111*****");
            [ws companyAddAll];
            if ([responseObject isKindOfClass:[NSArray class]]) {
                NSArray *roomsArray = (NSArray *)responseObject;
                [roomsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSDictionary *dic = obj;
                    FilterCompanyModel *commpanyModel = [[FilterCompanyModel alloc]init];
                    commpanyModel.idF =dic[@"id"];
                    commpanyModel.name =dic[@"name"];
                    commpanyModel.companyId =dic[@"companyId"];
                    commpanyModel.companyName =dic[@"companyName"];
                    commpanyModel.sort =dic[@"sort"];
                    commpanyModel.lev =dic[@"lev"];
                    commpanyModel.manager =dic[@"manager"];
                    commpanyModel.managerName =dic[@"id"];
                    commpanyModel.partentId =dic[@"partentId"];
                    commpanyModel.partentName =dic[@"partentName"];
                    commpanyModel.sign =dic[@"sign"];
                    commpanyModel.delFlag =dic[@"delFlag"];
                    commpanyModel.isSelected = NO;
                    [ws.roomMutableArray addObject:commpanyModel];
                    
                }];
            } else {
                
            }
            [self loadBuildingItemsWithManager:manager];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [ws companyAddAll];
            [self loadBuildingItemsWithManager:manager];
        }];
}

- (void)loadBuildingItemsWithManager:(AFHTTPSessionManager *)manager {
    __weak FilterCollectionView *ws = self;
    NSString *urlString1 = [NSString stringWithFormat:@"%@%@",BASE_PLAN_URL,@"rest/busiData/deviceLocation"];
    NSDictionary *parameters1 = @{@"userSign":[PersonInfo shareInstance].accountID};
    [manager GET:urlString1
      parameters:parameters1
        progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"*****222222222******");
            [ws buildingAddAll];
            if ([responseObject isKindOfClass:[NSArray class]]) {
                NSArray *buildingsArray = (NSArray *)responseObject;
                [buildingsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSDictionary *dic = obj;
                    BuildingModle *buildingModel = [[BuildingModle alloc]init];
                    buildingModel.idF =dic[@"id"];
                    buildingModel.name =dic[@"name"];
                    buildingModel.pid =dic[@"pid"];
                    buildingModel.isSelected = NO;
                    [ws.roomMutableArray addObject:buildingModel];
                }];
            } else {
                
            }
            [self loadSortItemsWithManager:manager];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [ws buildingAddAll];
            [self loadSortItemsWithManager:manager];
        }];
}

- (void)loadSortItemsWithManager:(AFHTTPSessionManager *)manager {
    __weak FilterCollectionView *ws = self;
    NSString *urlString2 = [NSString stringWithFormat:@"%@%@",BASE_PLAN_URL,@"rest/busiData/deviceOrder"];
    NSDictionary *parameters2 = @{@"userSign":[PersonInfo shareInstance].accountID};
    [manager GET:urlString2
      parameters:parameters2
        progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [_sortDictionary removeAllObjects];
            [_sortDictionary setObject:@"智能排序" forKey:@"500"];
            [_sortDictionary addEntriesFromDictionary:responseObject];
            NSLog(@"rest/busiData/deviceOrder %@",_sortDictionary);
            [ws reloadData];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [_sortDictionary removeAllObjects];
            [_sortDictionary setObject:@"智能排序" forKey:@"500"];
            [ws reloadData];
        }];
}

- (void)loadItemsAction {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    /*使用NSURLRequestReloadRevalidatingCacheData缓存策略，验证本地数据与远程数据是否相同，如果不同则下载远程数据，否则使用本地数据*/
    manager.requestSerializer.cachePolicy = NSURLRequestReloadRevalidatingCacheData;
    [self loadCommpanyItemsWithManager:manager];
    
}

- (void)companyAddAll {
    [self.roomMutableArray removeAllObjects];
    FilterCompanyModel *allCommpanyModel = [[FilterCompanyModel alloc]init];
    allCommpanyModel.idF =@"all";
    allCommpanyModel.name =@"all";
    allCommpanyModel.companyId =@"all";
    allCommpanyModel.companyName =@"全部供电室";
    allCommpanyModel.sort =@"all";
    allCommpanyModel.lev =@"all";
    allCommpanyModel.manager =@"all";
    allCommpanyModel.managerName =@"all";
    allCommpanyModel.partentId =@"all";
    allCommpanyModel.partentName =@"all";
    allCommpanyModel.sign =@"all";
    allCommpanyModel.delFlag =@"all";
    allCommpanyModel.isSelected = NO;
    [self.roomMutableArray addObject:allCommpanyModel];
}

- (void)buildingAddAll {
    [self.buildingMutableArray removeAllObjects];
    BuildingModle *allBuildingModel = [[BuildingModle alloc]init];
    allBuildingModel.idF =@"all";
    allBuildingModel.name =@"所有楼";
    allBuildingModel.pid =@"all";
    allBuildingModel.isSelected = NO;
    [self.buildingMutableArray addObject:allBuildingModel];
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        
        _selectedIndex = 1;
        _roomMutableArray = [NSMutableArray array];
        _buildingMutableArray = [NSMutableArray array];
        _sortDictionary = [NSMutableDictionary dictionary];
        _screenMutableArray = [@[@{@"name":@"供电室",@"isSelected":@NO,@"searchValue":@""},
                                 @{@"name":@"楼",@"isSelected":@NO,@"searchValue":@""},
                                 @{@"name":@"排序",@"isSelected":@NO,@"searchValue":@""},
                                 @{@"name":@"搜索",@"isSelected":@NO,@"searchValue":@""}] mutableCopy];
        
        [self loadItemsAction];
        self.backgroundColor = [UIColor clearColor];
        self.dataSource = self;
        self.delegate = self;
        [self registerNib:[UINib nibWithNibName:NSStringFromClass([FilterCollectionCell class]) bundle:nil]  forCellWithReuseIdentifier:@"FilterCollectionCell"];
    }
    return self;
    
}

//返回collection view里区(section)的个数，如果没有实现该方法，将默认返回1：
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

//返回指定区(section)包含的数据源条目数(number of items)，该方法必须实现：
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSInteger screenItemCount = [_screenMutableArray count];
    
    if (_selectedIndex == 0) {
        /*全未选中*/
        return [_screenMutableArray count] +1;
    } else if (_selectedIndex == 1) {
        /*供电室*/
        return screenItemCount +1 + [_roomMutableArray count];
    } else if (_selectedIndex == 2) {
        /*楼*/
        return screenItemCount +1 + [_buildingMutableArray count];
    } else if (_selectedIndex == 3) {
        /*排序*/
        return screenItemCount + 1 + [[_sortDictionary allKeys] count];
    } else if (_selectedIndex == [_screenMutableArray count]) {
        /*搜索*/
        return screenItemCount + 1 + 1;
    } else {
        return  screenItemCount;
    }
}

//返回某个indexPath对应的cell，该方法必须实现：
- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger screenItemCount = [_screenMutableArray count];
    NSInteger roomItemCount = [_roomMutableArray count];
    NSInteger buildingItemCount = [_buildingMutableArray count];
    NSInteger sortItemCount = [[_sortDictionary allKeys] count];
    
    FilterCollectionCell *cell =  [collectionView dequeueReusableCellWithReuseIdentifier:@"FilterCollectionCell" forIndexPath:indexPath];
    cell.layer.borderColor = UIColorFromRGB(0xF0F0F0).CGColor;
    cell.layer.borderWidth = 0.5f;
    cell.rightImageView.hidden = YES;
    if (_selectedIndex == 0) {
        /*全未选中*/
        if (indexPath.row == 4) {
            cell.contentView.backgroundColor = UIColorFromRGBA(0x000000, 0.4f);
            cell.layer.borderColor = UIColorFromRGBA(0x000000, 0.4f).CGColor;
            cell.layer.borderWidth = 0.5f;
            cell.titleLable.text = @"";
            cell.cornerImageView.hidden = YES;
            cell.titleLable.textAlignment = NSTextAlignmentCenter;
            cell.leadingConstraints.constant = 0;
        } else {
            cell.contentView.backgroundColor = UIColorFromRGB(0xFFFFFF);
            NSDictionary *titleItemDictionary = _screenMutableArray[indexPath.row];
            cell.titleLable.text = titleItemDictionary[@"name"];
            cell.cornerImageView.hidden = NO;
            BOOL isSelected = [titleItemDictionary[@"isSelected"] boolValue];
            cell.cornerImageView.image = [UIImage imageNamed:isSelected?@"Triangle_selected.png":@"Triangle.png"];
            cell.titleLable.textAlignment = NSTextAlignmentCenter;
            cell.leadingConstraints.constant = 0;
        }
    } else if (_selectedIndex == 1) {
        /*供电室*/
        if (indexPath.row < 4) {
            cell.contentView.backgroundColor = UIColorFromRGB(0xFFFFFF);
            NSDictionary *titleItemDictionary = _screenMutableArray[indexPath.row];
            cell.titleLable.text = titleItemDictionary[@"name"];
            cell.titleLable.textAlignment = NSTextAlignmentCenter;
            cell.leadingConstraints.constant = 0;
            cell.cornerImageView.hidden = NO;
            BOOL isSelected = [titleItemDictionary[@"isSelected"] boolValue];
            cell.cornerImageView.image = [UIImage imageNamed:isSelected?@"Triangle_selected.png":@"Triangle.png"];
        } else  if (indexPath.row >= screenItemCount && indexPath.row < screenItemCount+roomItemCount) {
            cell.cornerImageView.hidden = YES;
            FilterCompanyModel *commanyModel = _roomMutableArray[indexPath.row-screenItemCount];
            cell.contentView.backgroundColor = UIColorFromRGB(0xFFFFFF);
            cell.titleLable.text = commanyModel.companyName;
            cell.titleLable.textAlignment = NSTextAlignmentLeft;
            cell.leadingConstraints.constant = 20;
            if (commanyModel.isSelected) {
                cell.rightImageView.hidden = NO;
            } else {
                cell.rightImageView.hidden = YES;
            }
        } else {
            cell.cornerImageView.hidden = YES;
            cell.contentView.backgroundColor = UIColorFromRGBA(0x000000, 0.4f);
            cell.layer.borderColor = UIColorFromRGBA(0x000000, 0.4f).CGColor;
            cell.layer.borderWidth = 0.5f;
            cell.titleLable.text = @"";
            cell.titleLable.textAlignment = NSTextAlignmentCenter;
            cell.leadingConstraints.constant = 0;
        }
    } else if (_selectedIndex == 2) {
        /*楼*/
        if (indexPath.row < 4) {
            cell.contentView.backgroundColor = UIColorFromRGB(0xFFFFFF);
            NSDictionary *titleItemDictionary = _screenMutableArray[indexPath.row];
            cell.titleLable.text = titleItemDictionary[@"name"];
            cell.cornerImageView.hidden = NO;
            BOOL isSelected = [titleItemDictionary[@"isSelected"] boolValue];
            cell.cornerImageView.image = [UIImage imageNamed:isSelected?@"Triangle_selected.png":@"Triangle.png"];
            cell.titleLable.textAlignment = NSTextAlignmentCenter;
            cell.leadingConstraints.constant = 0;
        } else  if (indexPath.row >= screenItemCount && indexPath.row < screenItemCount+buildingItemCount) {
            BuildingModle *buildingModel = _buildingMutableArray[indexPath.row-screenItemCount];
            cell.contentView.backgroundColor = UIColorFromRGB(0xFFFFFF);
            cell.titleLable.text = buildingModel.name;
            cell.cornerImageView.hidden = YES;
            cell.titleLable.textAlignment = NSTextAlignmentLeft;
            cell.leadingConstraints.constant = 20;
            if (buildingModel.isSelected) {
                cell.rightImageView.hidden = NO;
            } else {
                cell.rightImageView.hidden = YES;
            }
        } else {
            cell.cornerImageView.hidden = YES;
            cell.contentView.backgroundColor = UIColorFromRGBA(0x000000, 0.4f);
            cell.layer.borderColor = UIColorFromRGBA(0x000000, 0.4f).CGColor;
            cell.layer.borderWidth = 0.5f;
            cell.titleLable.text = @"";
            cell.titleLable.textAlignment = NSTextAlignmentCenter;
            cell.leadingConstraints.constant = 0;
        }
    } else if (_selectedIndex == 3) {
        /*排序*/
        if (indexPath.row < 4) {
            cell.contentView.backgroundColor = UIColorFromRGB(0xFFFFFF);
            NSDictionary *titleItemDictionary = _screenMutableArray[indexPath.row];
            cell.titleLable.text = titleItemDictionary[@"name"];
            cell.titleLable.textAlignment = NSTextAlignmentCenter;
            cell.leadingConstraints.constant = 0;
            cell.cornerImageView.hidden = NO;
            BOOL isSelected = [titleItemDictionary[@"isSelected"] boolValue];
            cell.cornerImageView.image = [UIImage imageNamed:isSelected?@"Triangle_selected.png":@"Triangle.png"];
        } else  if (indexPath.row >= screenItemCount && indexPath.row < screenItemCount+sortItemCount) {
            cell.cornerImageView.hidden = YES;
            SortModel *sortModel = [[SortModel alloc] init];
            sortModel.dic = _sortDictionary;
            NSArray *keysArray = [sortModel.dic allKeys];
            cell.contentView.backgroundColor = UIColorFromRGB(0xFFFFFF);
            NSString *keyString = keysArray[indexPath.row - screenItemCount];
            cell.titleLable.text = sortModel.dic[keyString];
            cell.titleLable.textAlignment = NSTextAlignmentLeft;
            cell.leadingConstraints.constant = 20;
            cell.rightImageView.hidden = NO;
        } else {
            cell.cornerImageView.hidden = YES;
            cell.contentView.backgroundColor = UIColorFromRGBA(0x000000, 0.4f);
            cell.layer.borderColor = UIColorFromRGBA(0x000000, 0.4f).CGColor;
            cell.layer.borderWidth = 0.5f;
            cell.titleLable.text = @"";
            cell.titleLable.textAlignment = NSTextAlignmentCenter;
            cell.leadingConstraints.constant = 0;
        }
    } else if (_selectedIndex == 4) {
        /*搜索*/
        if (indexPath.row == 5) {
            cell.cornerImageView.hidden = YES;
            cell.contentView.backgroundColor = UIColorFromRGBA(0x000000, 0.4f);
        } else {
            cell.cornerImageView.hidden = NO;
            cell.contentView.backgroundColor = UIColorFromRGB(0xFFFFFF);
        }
    }
    return cell;
}

//设定collectionView(指定区)的边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0,0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger screenItemCount = [_screenMutableArray count];
    NSInteger roomItemCount = [_roomMutableArray count];
    NSInteger buildingItemCount = [_buildingMutableArray count];
    NSInteger sortItemCount = [[_sortDictionary allKeys] count];
    
    if (_selectedIndex == 0) {
        /*全未选中*/
        if (indexPath.row <4) {
            return CGSizeMake(SCREEN_WIDTH/4, 36.0f);
        } else {
            return CGSizeMake(SCREEN_WIDTH,SCREEN_HEIGHT -NAV_HEIGHT - 44.0f  - 36.0f);
        }
    } else if (_selectedIndex == 1) {
        /*供电室*/
        if (indexPath.row <4) {
            return CGSizeMake(SCREEN_WIDTH/4, 36.0f);
        }  else if (indexPath.row >= screenItemCount && indexPath.row < screenItemCount+roomItemCount) {
            return CGSizeMake(SCREEN_WIDTH,36.0f);
        } else {
            return CGSizeMake(SCREEN_WIDTH,SCREEN_HEIGHT -NAV_HEIGHT - 44.0f  - 36.0f - [_roomMutableArray count]*36.0f);
        }
    } else if (_selectedIndex == 2) {
        /*楼*/
        if (indexPath.row <4) {
            return CGSizeMake(SCREEN_WIDTH/4, 36.0f);
        }  else if (indexPath.row >= screenItemCount && indexPath.row < screenItemCount+buildingItemCount) {
            return CGSizeMake(SCREEN_WIDTH,36.0f);
        }  else {
            return CGSizeMake(SCREEN_WIDTH,SCREEN_HEIGHT -NAV_HEIGHT - 44.0f  - 36.0f - buildingItemCount*36.0f);
        }
    } else if (_selectedIndex == 3) {
        /*排序*/
        if (indexPath.row <4) {
            return CGSizeMake(SCREEN_WIDTH/4, 36.0f);
        }  else if (indexPath.row >= screenItemCount && indexPath.row < screenItemCount+sortItemCount) {
            return CGSizeMake(SCREEN_WIDTH,36.0f);
        }  else {
            return CGSizeMake(SCREEN_WIDTH,SCREEN_HEIGHT -NAV_HEIGHT - 44.0f  - 36.0f - sortItemCount*36.0f);
        }
    } else if (_selectedIndex == 4) {
        /*搜索*/
        if (indexPath.row <4) {
            return CGSizeMake(SCREEN_WIDTH/4, 36.0f);
        } else if (indexPath.row == 5)  {
            return CGSizeMake(SCREEN_WIDTH,SCREEN_HEIGHT -NAV_HEIGHT - 44.0f  - 88.0f);
        } else {
            return CGSizeMake(SCREEN_WIDTH, 36.0f);
        }
    }else {
        return CGSizeMake(SCREEN_WIDTH,SCREEN_HEIGHT -NAV_HEIGHT - 44.0f);
    }
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0f;
}
//点击每个item实现的方法：
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger screenItemCount = [_screenMutableArray count];
    NSInteger roomItemCount = [_roomMutableArray count];
    NSInteger buildingItemCount = [_buildingMutableArray count];
    NSInteger sortItemCount = [[_sortDictionary allKeys] count];
    if (indexPath.row < 4) {
        _selectedIndex = indexPath.row +1;
    } else {
        
    }
    if (_selectedIndex == 0) {
        /*全未选中*/
        if (indexPath.row <4) {
            _selectedIndex = indexPath.row +1;
        } else {
            return;
        }
    } else if (_selectedIndex == 1) {
        /*供电室*/
        if (indexPath.row <4) {
            _selectedIndex = indexPath.row +1;
        } else  if (indexPath.row >= screenItemCount && indexPath.row < screenItemCount+roomItemCount) {
            FilterCompanyModel *commanyModel = _roomMutableArray[indexPath.row-screenItemCount];
            NSMutableDictionary *titleItemDictionary = [NSMutableDictionary dictionaryWithDictionary:_screenMutableArray[0]];
            [titleItemDictionary setObject:commanyModel.companyName forKey:@"name"];
            [titleItemDictionary setObject:@YES forKey:@"isSelected"];
            [_screenMutableArray replaceObjectAtIndex:0 withObject:titleItemDictionary];
        } else {
            return;
        }
    } else if (_selectedIndex == 2) {
        /*楼*/
        if (indexPath.row <4) {
            _selectedIndex = indexPath.row +1;
        } else  if (indexPath.row >= screenItemCount && !(indexPath.row == screenItemCount+buildingItemCount)) {
            BuildingModle *buildingModel = _buildingMutableArray[indexPath.row-screenItemCount];
            NSMutableDictionary *titleItemDictionary = [NSMutableDictionary dictionaryWithDictionary:_screenMutableArray[1]];
            [titleItemDictionary setObject:buildingModel.name forKey:@"name"];
            [titleItemDictionary setObject:@YES forKey:@"isSelected"];
            [_screenMutableArray replaceObjectAtIndex:1 withObject:titleItemDictionary];
        } else {
            return;
        }
    } else if (_selectedIndex == 3) {
        /*排序*/
        if (indexPath.row <4) {
            _selectedIndex = indexPath.row +1;
        } else  if (indexPath.row >= screenItemCount && !(indexPath.row == screenItemCount+sortItemCount)) {
            NSString *keyString = [_sortDictionary allKeys][indexPath.row-screenItemCount];
            NSMutableDictionary *titleItemDictionary = [NSMutableDictionary dictionaryWithDictionary:_screenMutableArray[2]];
            [titleItemDictionary setObject:_sortDictionary[keyString] forKey:@"name"];
            [titleItemDictionary setObject:@YES forKey:@"isSelected"];
            [_screenMutableArray replaceObjectAtIndex:2 withObject:titleItemDictionary];
        } else {
            return;
        }
    } else {
        /*搜索*/
        if (indexPath.row <4) {
            _selectedIndex = indexPath.row +1;
        } else if (indexPath.row == 5)  {
            
        } else {
            
        }
    }
    [collectionView reloadData];
}

@end

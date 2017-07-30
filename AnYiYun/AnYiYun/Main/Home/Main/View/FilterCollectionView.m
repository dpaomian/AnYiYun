//
//  FilterCollectionView.m
//  AnYiYun
//
//  Created by 韩亚周 on 2017/7/25.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "FilterCollectionView.h"

@interface FilterCollectionView ()

/*!备选项是否为折叠状态。 YES为折叠*/
@property (nonatomic, assign) BOOL      isFoldItem;
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

- (NSArray *)sortKeysWithDic:(NSDictionary *)dic {
    NSArray *sortedKeys = [[dic allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    return sortedKeys;
}

- (void)loadSortItemsWithManager:(AFHTTPSessionManager *)manager {
    __weak FilterCollectionView *ws = self;
    NSString *urlString2 = [NSString stringWithFormat:@"%@%@",BASE_PLAN_URL,@"rest/busiData/deviceOrder"];
    NSDictionary *parameters2 = @{@"userSign":[PersonInfo shareInstance].accountID};
    [manager GET:urlString2
      parameters:parameters2
        progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            DLog(@"responseObject :%@",responseObject);

            [_sortMutableArray removeAllObjects];
            NSMutableDictionary *sortDic = [NSMutableDictionary dictionary];
            [sortDic setObject:@"智能排序" forKey:@"500"];
            [sortDic addEntriesFromDictionary:responseObject];
            [[ws sortKeysWithDic:sortDic] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                SortModel *model = [[SortModel alloc] init];
                NSString *keyString = obj;
                NSString *valueSting = sortDic[keyString];
                model.idF = keyString;
                model.name = valueSting;
                NSLog(@"%@",model.idF);
                model.isSelected = NO;
                [_sortMutableArray addObject:model];
            }];
            [ws reloadData];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [_sortMutableArray removeAllObjects];
            SortModel *model = [[SortModel alloc] init];
            model.idF = @"500";
            model.name = @"智能排序";
            model.isSelected = NO;
            [_sortMutableArray addObject:model];
            [ws reloadData];
        }];
}

- (void)iteminitialization {
    self.hidden = NO;
    [_screenMutableArray removeAllObjects];
    [_screenMutableArray addObjectsFromArray:@[@{@"name":@"供电室",@"isSelected":@NO,@"searchValue":@""},
                                                @{@"name":@"楼",@"isSelected":@NO,@"searchValue":@""},
                                                @{@"name":@"排序",@"isSelected":@NO,@"searchValue":@""},
                                                @{@"name":@"搜索",@"isSelected":@NO,@"searchValue":@""}]];
    
    [_roomMutableArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        FilterCompanyModel * model = obj;
        model.isSelected = NO;
        [_roomMutableArray replaceObjectAtIndex:idx withObject:model];
    }];
    [_buildingMutableArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BuildingModle * model = obj;
        model.isSelected = NO;
        [_buildingMutableArray replaceObjectAtIndex:idx withObject:model];
    }];
    [_sortMutableArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SortModel * model = obj;
        model.isSelected = NO;
        [_sortMutableArray replaceObjectAtIndex:idx withObject:model];
    }];
    [self reloadData];
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
        
        self.layer.borderColor = UIColorFromRGB(0xF0F0F0).CGColor;
        self.layer.borderWidth = 0.5f;
        
        self.scrollEnabled = NO;
        _isFoldItem = NO;
        
        _selectedIndex = 0;
        _roomMutableArray = [NSMutableArray array];
        _buildingMutableArray = [NSMutableArray array];
        _sortMutableArray = [NSMutableArray array];
        
        _screenMutableArray = [@[@{@"name":@"供电室",@"isSelected":@NO,@"searchValue":@""},
                                 @{@"name":@"楼",@"isSelected":@NO,@"searchValue":@""},
                                 @{@"name":@"排序",@"isSelected":@NO,@"searchValue":@""},
                                 @{@"name":@"搜索",@"isSelected":@NO,@"searchValue":@""}] mutableCopy];
        
        [self loadItemsAction];
        self.backgroundColor = [UIColor clearColor];
        self.dataSource = self;
        self.delegate = self;
        [self registerNib:[UINib nibWithNibName:NSStringFromClass([FilterCollectionCell class]) bundle:nil]  forCellWithReuseIdentifier:@"FilterCollectionCell"];
        [self registerNib:[UINib nibWithNibName:NSStringFromClass([SearchCollectionCell class]) bundle:nil]  forCellWithReuseIdentifier:@"SearchCollectionCell"];
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
    NSInteger touchCount = 1;
    
    if (_selectedIndex == 0) {
        /*全未选中*/
        if (self.isFoldItem) {
            return  screenItemCount;
        } else {
            return [_screenMutableArray count] +touchCount;
        }
    } else if (_selectedIndex == 1) {
        /*供电室*/
        if (self.isFoldItem) {
            return  screenItemCount;
        } else {
            return screenItemCount +touchCount + [_roomMutableArray count];
        }
    } else if (_selectedIndex == 2) {
        /*楼*/
        if (self.isFoldItem) {
            return  screenItemCount;
        } else {
            return screenItemCount +touchCount + [_buildingMutableArray count];
        }
    } else if (_selectedIndex == 3) {
        /*排序*/
        if (self.isFoldItem) {
            return  screenItemCount;
        } else {
            return screenItemCount + touchCount + [_sortMutableArray count];
        }
    } else if (_selectedIndex == [_screenMutableArray count]) {
        /*搜索*/
        if (self.isFoldItem) {
            return  screenItemCount;
        } else {
            return screenItemCount + touchCount + 1;
        }
    } else {
        return  screenItemCount;
    }
}

//返回某个indexPath对应的cell，该方法必须实现：
- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger screenItemCount = [_screenMutableArray count];
    NSInteger roomItemCount = [_roomMutableArray count];
    NSInteger buildingItemCount = [_buildingMutableArray count];
    NSInteger sortItemCount = [_sortMutableArray count];
    
    __weak FilterCollectionView *ws = self;
    
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
            NSDictionary *titleItemDictionary = [NSDictionary dictionaryWithDictionary:_screenMutableArray[indexPath.row]];
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
            NSDictionary *titleItemDictionary = [NSDictionary dictionaryWithDictionary:_screenMutableArray[indexPath.row]];
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
            NSDictionary *titleItemDictionary = [NSDictionary dictionaryWithDictionary:_screenMutableArray[indexPath.row]];
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
            NSDictionary *titleItemDictionary = [NSDictionary dictionaryWithDictionary:_screenMutableArray[indexPath.row]];
            cell.titleLable.text = titleItemDictionary[@"name"];
            cell.titleLable.textAlignment = NSTextAlignmentCenter;
            cell.leadingConstraints.constant = 0;
            cell.cornerImageView.hidden = NO;
            BOOL isSelected = [titleItemDictionary[@"isSelected"] boolValue];
            cell.cornerImageView.image = [UIImage imageNamed:isSelected?@"Triangle_selected.png":@"Triangle.png"];
        } else if (indexPath.row >= screenItemCount && indexPath.row < screenItemCount+sortItemCount) {
            cell.cornerImageView.hidden = YES;
            SortModel *sortModel = _sortMutableArray[indexPath.row-screenItemCount];
            cell.contentView.backgroundColor = UIColorFromRGB(0xFFFFFF);
            cell.titleLable.text = sortModel.name;
            cell.titleLable.textAlignment = NSTextAlignmentLeft;
            cell.leadingConstraints.constant = 20;
            if (sortModel.isSelected) {
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
    } else if (_selectedIndex == 4) {
        /*搜索*/
        if (indexPath.row < 4) {
            cell.contentView.backgroundColor = UIColorFromRGB(0xFFFFFF);
            NSDictionary *titleItemDictionary = [NSDictionary dictionaryWithDictionary:_screenMutableArray[indexPath.row]];
            cell.titleLable.text = titleItemDictionary[@"name"];
            cell.titleLable.textAlignment = NSTextAlignmentCenter;
            cell.leadingConstraints.constant = 0;
            cell.cornerImageView.hidden = NO;
            BOOL isSelected = [titleItemDictionary[@"isSelected"] boolValue];
            cell.cornerImageView.image = [UIImage imageNamed:isSelected?@"Triangle_selected.png":@"Triangle.png"];
        } else if (indexPath.row == 5) {
            cell.cornerImageView.hidden = YES;
            cell.contentView.backgroundColor = UIColorFromRGBA(0x000000, 0.4f);
        } else {
            SearchCollectionCell *searchCell =  [collectionView dequeueReusableCellWithReuseIdentifier:@"SearchCollectionCell" forIndexPath:indexPath];
            
            searchCell.searchBarTextDidChange = ^(SearchCollectionCell *barCell, UISearchBar *bar) {
                
            };
            searchCell.searchBarSearchButtonClicked = ^(SearchCollectionCell *barCell, UISearchBar *bar) {
                ws.isFoldItem = YES;
                if ([searchCell.searchBar.text length] >0) {
                    NSMutableDictionary *titleItemDictionary = [NSMutableDictionary dictionaryWithDictionary:ws.screenMutableArray[3]];
                    [titleItemDictionary setObject:@YES forKey:@"isSelected"];
                    [ws.screenMutableArray replaceObjectAtIndex:3 withObject:titleItemDictionary];
                } else {
                    NSMutableDictionary *titleItemDictionary = [NSMutableDictionary dictionaryWithDictionary:ws.screenMutableArray[3]];
                    [titleItemDictionary setObject:@NO forKey:@"isSelected"];
                    [ws.screenMutableArray replaceObjectAtIndex:3 withObject:titleItemDictionary];
                }
                if (ws.foldHandle) {
                    ws.foldHandle(ws,ws.isFoldItem);
                }
                if (ws.choiceHandle) {
                    ws.choiceHandle(ws, bar, 4);
                }
                [collectionView reloadData];
            };
            [searchCell.cancleBtn buttonClickedHandle:^(UIButton *sender) {
                if ([searchCell.searchBar.text length] >0) {
                    NSMutableDictionary *titleItemDictionary = [NSMutableDictionary dictionaryWithDictionary:ws.screenMutableArray[3]];
                    [titleItemDictionary setObject:searchCell.searchBar.text forKey:@"name"];
                    [titleItemDictionary setObject:@YES forKey:@"isSelected"];
                    [ws.screenMutableArray replaceObjectAtIndex:3 withObject:titleItemDictionary];
                } else {
                    NSMutableDictionary *titleItemDictionary = [NSMutableDictionary dictionaryWithDictionary:ws.screenMutableArray[3]];
                    [titleItemDictionary setObject:@"" forKey:@"name"];
                    [titleItemDictionary setObject:@NO forKey:@"isSelected"];
                    [ws.screenMutableArray replaceObjectAtIndex:3 withObject:titleItemDictionary];
                }
                ws.isFoldItem = YES;
                if (ws.foldHandle) {
                    ws.foldHandle(ws,ws.isFoldItem);
                }
            }];
            searchCell.layer.borderColor = UIColorFromRGB(0xF0F0F0).CGColor;
            searchCell.layer.borderWidth = 0.5f;
            return searchCell;
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
    NSInteger sortItemCount = [_sortMutableArray count];
    
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
            return CGSizeMake(SCREEN_WIDTH,SCREEN_HEIGHT -NAV_HEIGHT - 44.0f  - 130.0f);
        } else {
            return CGSizeMake(SCREEN_WIDTH, 130.0f);
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
    
    __weak FilterCollectionView *ws = self;
    NSInteger screenItemCount = [_screenMutableArray count];
    NSInteger roomItemCount = [_roomMutableArray count];
    NSInteger buildingItemCount = [_buildingMutableArray count];
    NSInteger sortItemCount = [_sortMutableArray count];
    if (indexPath.row < 4) {
        _selectedIndex = indexPath.row +1;
        _isFoldItem = NO;
        if (_foldHandle) {
            _foldHandle(self,_isFoldItem);
        }
    } else {
        self.hidden = self.isFold?NO:YES;
        _isFoldItem = YES;
        if (_foldHandle) {
            _foldHandle(self,_isFoldItem);
        }
    }
    if (_selectedIndex == 0) {
        /*全未选中*/
        if (indexPath.row <4) {
            _selectedIndex = indexPath.row +1;
        } else {
            _isFoldItem = YES;
            if (_foldHandle) {
                _foldHandle(self,_isFoldItem);
            }
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
            [_roomMutableArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                FilterCompanyModel *companyM = ws.roomMutableArray[idx];
                if (companyM.isSelected) {
                    companyM.isSelected = NO;
                    [ws.roomMutableArray replaceObjectAtIndex:idx withObject:companyM];
                    *stop = YES;
                }else {}
            }];
            commanyModel.isSelected = YES;
            if (_choiceHandle) {
                _choiceHandle(self, commanyModel,_selectedIndex);
            }
            [_roomMutableArray replaceObjectAtIndex:indexPath.row-screenItemCount withObject:commanyModel];
        } else {
            _isFoldItem = YES;
            if (_foldHandle) {
            _foldHandle(self,_isFoldItem);
        }
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
            [_buildingMutableArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                BuildingModle *buildingM = ws.buildingMutableArray[idx];
                if (buildingM.isSelected) {
                    buildingM.isSelected = NO;
                    [ws.buildingMutableArray replaceObjectAtIndex:idx withObject:buildingM];
                    *stop = YES;
                }else {}
            }];
            buildingModel.isSelected = YES;
            if (_choiceHandle) {
                _choiceHandle(self, buildingModel,_selectedIndex);
            }
            [_buildingMutableArray replaceObjectAtIndex:indexPath.row-screenItemCount withObject:buildingModel];
        } else {
            _isFoldItem = YES;
            if (_foldHandle) {
                _foldHandle(self,_isFoldItem);
            }
        }
    } else if (_selectedIndex == 3) {
        /*排序*/
        if (indexPath.row <4) {
            _selectedIndex = indexPath.row +1;
        } else  if (indexPath.row >= screenItemCount && !(indexPath.row == screenItemCount+sortItemCount)) {
            SortModel *sortModel = _sortMutableArray[indexPath.row-screenItemCount];
            NSMutableDictionary *titleItemDictionary = [NSMutableDictionary dictionaryWithDictionary:_screenMutableArray[2]];
            [titleItemDictionary setObject:sortModel.name forKey:@"name"];
            [titleItemDictionary setObject:@YES forKey:@"isSelected"];
            [_screenMutableArray replaceObjectAtIndex:2 withObject:titleItemDictionary];
            [_sortMutableArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                SortModel *sortM = ws.sortMutableArray[idx];
                if (sortM.isSelected) {
                    sortM.isSelected = NO;
                    [ws.sortMutableArray replaceObjectAtIndex:idx withObject:sortM];
                    *stop = YES;
                }else {}
            }];
            sortModel.isSelected = YES;
            if (_choiceHandle) {
                _choiceHandle(self, sortModel,_selectedIndex);
            }
            [_sortMutableArray replaceObjectAtIndex:indexPath.row-screenItemCount withObject:sortModel];
        } else {
            _isFoldItem = YES;
            if (_foldHandle) {
                _foldHandle(self,_isFoldItem);
            }
        }
    } else {
        /*搜索*/
        if (indexPath.row <4) {
            _selectedIndex = indexPath.row +1;
        } else if (indexPath.row == 5)  {
            _isFoldItem = YES;
            if (_foldHandle) {
                _foldHandle(self,_isFoldItem);
            }
        } else {
            
        }
    }
    [collectionView reloadData];
}

@end

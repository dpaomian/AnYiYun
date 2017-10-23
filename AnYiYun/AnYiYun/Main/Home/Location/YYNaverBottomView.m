//
//  YYNaverBottomView.m
//  AnYiYun
//
//  Created by 韩亚周 on 2017/10/18.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "YYNaverBottomView.h"

@implementation YYNaverBottomView

- (void)setLinksMutableArray:(NSMutableArray *)linksMutableArray {
    _linksMutableArray = linksMutableArray;
    [self.programmeTableView reloadData];
    if ([_linksMutableArray count]>0) {
        [self.programmeTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _programmeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame)) style:UITableViewStylePlain];
        _programmeTableView.delegate = self;
        _programmeTableView.dataSource = self;
//        _programmeTableView.scrollEnabled = NO;
        _programmeTableView.tableFooterView = [UIView new];
        [_programmeTableView registerClass:[YYSubtitleTableViewCell class] forCellReuseIdentifier:@"YYSubtitleTableViewCell"];
        [self addSubview:_programmeTableView];
    }
    return self;
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_linksMutableArray count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YYSubtitleTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"YYSubtitleTableViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    if (_isTransit) {
        YYTransitListModel *cellModel = (YYTransitListModel *)_linksMutableArray[indexPath.row];
        for (AMapSegment *segments in cellModel.segments) {
            for (AMapBusLine *buslines in segments.buslines) {
                cell.textLabel.text = buslines.name;
            }
        }
        cell.detailTextLabel.textColor = UIColorFromRGB(0x666666);
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
        NSString *timesString = @"";
        if (cellModel.duration<=3600) {
            timesString = [NSString stringWithFormat:@"%ld%@",cellModel.duration/60,@"分钟"];
        } else {
            NSInteger minites = cellModel.duration%3600;
            NSInteger hours = (cellModel.duration-minites)/3600;
            timesString = [NSString stringWithFormat:@"%ld%@%ld%@",hours,@"小时",minites/60,@"分钟"];
        }
        
        NSString *distanceString =  [NSString stringWithFormat:@"%ld%@",cellModel.distance<=1000?cellModel.distance:cellModel.distance/1000,cellModel.distance<=1000?@"米":@"公里"];
        NSString *walkDistanceString =  [NSString stringWithFormat:@"%ld%@",cellModel.distance<=1000?cellModel.distance:cellModel.distance/1000,cellModel.distance<=1000?@"米":@"公里"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@ - 步行%@",timesString, distanceString,walkDistanceString];
    } else {
        AMapNaviLink *link = (AMapNaviLink *)_linksMutableArray[indexPath.row];
        NSString *roadNameString = @"";
        if (link.roadName == nil || [link.roadName isEqual:[NSNull null]]) {
            
        } else {
            roadNameString = link.roadName;
        }
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %ld 米",roadNameString,link.length];
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
        cell.detailTextLabel.text = nil;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_isTransit) {
        return 54.0f;
    } else {
        return 40.0f;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_isTransit) {
        YYTransitListModel *cellModel = (YYTransitListModel *)_linksMutableArray[indexPath.row];
        if (_didSelectRowAtIndexPath) {
            _didSelectRowAtIndexPath(self, cellModel, indexPath);
        }
    } else {
        return ;
    }
}


@end

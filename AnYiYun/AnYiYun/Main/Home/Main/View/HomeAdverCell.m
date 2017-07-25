//
//  HomeAdverCell.m
//  AnYiYun
//
//  Created by wwr on 2017/7/25.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "HomeAdverCell.h"

@interface HomeAdverCell ()
{
    UILabel             *titleLabel;
    UIImageView         *desImageView;
}
@end

@implementation HomeAdverCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
        {
        
        UILabel  *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, SCREEN_WIDTH-60, 0.5)];
        lineLabel.backgroundColor = kAPPTableViewLineColor;
        [self.contentView addSubview:lineLabel];
        
        UILabel *tapLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 12.5, 40, 25)];
        tapLabel.backgroundColor = kAPPBlueColor;
        tapLabel.layer.masksToBounds=YES;
        tapLabel.layer.cornerRadius = 4;
        tapLabel.text = @"推广";
        tapLabel.font = [UIFont systemFontOfSize:14];
        tapLabel.textColor = [UIColor whiteColor];
        tapLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:tapLabel];
        
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, SCREEN_WIDTH-130, 50)];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.numberOfLines = 2;
        [self.contentView addSubview:titleLabel];
        
        desImageView = [[UIImageView alloc]init];
        desImageView.clipsToBounds = YES;
        desImageView.contentMode = UIViewContentModeScaleAspectFill;
        desImageView.frame = CGRectMake(30, 50, SCREEN_WIDTH-60, (SCREEN_WIDTH-60)/3);
        [self.contentView addSubview:desImageView];
        
        }
    return self;
}

-(void)setCellContentWithModel:(HomeAdverModel *)itemModel
{
    titleLabel.text = [BaseHelper isSpaceString:itemModel.name andReplace:@""];
    
    UIImage *defultImg = [UIImage imageNamed:@""];
    [desImageView sd_setImageWithURL:[NSURL URLWithString:[BaseHelper isSpaceString:itemModel.pic_url andReplace:@""]] placeholderImage:defultImg];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

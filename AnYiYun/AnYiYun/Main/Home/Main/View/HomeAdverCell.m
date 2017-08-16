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
    UIImageView         *aaaImageView;
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
        
        aaaImageView = [[UIImageView alloc]init];
        aaaImageView.image = [UIImage imageNamed:@"image_aaa.png"];
        aaaImageView.frame = CGRectMake(SCREEN_WIDTH-60, 0, 30 ,30);
        [self.contentView addSubview:aaaImageView];
        
        
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

    NSString *imageStr = [BaseHelper isSpaceString:itemModel.pic_url andReplace:@""];
    NSString *cachePath = [NSString stringWithFormat:@"%@/%@",PATH_AT_CACHEDIR(kUserImagesFolder),[imageStr lastPathComponent]];
    [desImageView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:defultImg completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
     if (image!=nil)
         {
             //保存加载过后的图片到头像文件夹里
         NSData *imageData = UIImageJPEGRepresentation(image, 1);
         if (cachePath)
             {
             dispatch_async(dispatch_get_global_queue(0, 0), ^{
                 [BaseCacheHelper createFolder:cachePath isDirectory:NO];
                 [imageData writeToFile:cachePath atomically:NO];
             });
             }
         }
     }];
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

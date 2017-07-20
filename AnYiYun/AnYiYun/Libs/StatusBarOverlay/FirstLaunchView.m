//
//  FirstLaunchView.m
//  AnYiYun
//
//  Created by wwr on 2017/7/20.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "FirstLaunchView.h"

@interface FirstLaunchView ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *imageArray;

@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation FirstLaunchView

- (instancetype)initWithFrame:(CGRect)frame delegate:(id)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        self.pagingEnabled = YES;//设置分页
        self.bounces = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.delegate = self;
        
        [self setImageView:_imageArray];
    }
    return self;
}

- (void)setImageView:(NSArray *)imageArrays
{
    if (!imageArrays)
    {
        imageArrays = [NSArray arrayWithObjects:@"splash0_1136",@"splash1_1136",@"splash2_1136",@"splash3_1136", nil];
    }
    _imageArray = imageArrays;
    self.contentSize = CGSizeMake((_imageArray.count + 1)*kScreen_Width, kScreen_Height);
    self.pageControl.numberOfPages = _imageArray.count;
    for (int i = 0; i<imageArrays.count; i++) {
        LaunchImageView *imageView = [[LaunchImageView alloc]init];
        imageView.frame = CGRectMake(i * kScreen_Width, 0, kScreen_Width, kScreen_Height);
        imageView.userInteractionEnabled = YES;
        imageView.tagIndex = i;
        imageView.image = [UIImage imageNamed:imageArrays[i]];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.addtionString = [NSString stringWithFormat:@"%d",i];
        UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleSingleTapAd:)];
        singleRecognizer.numberOfTapsRequired = 1;
        [imageView addGestureRecognizer:singleRecognizer];
        
        [self addSubview:imageView];
    }
    
}


#pragma mark - action
- (void)handleSingleTapAd:(UITapGestureRecognizer *)sender
{
    LaunchImageView *imageView = (LaunchImageView *)sender.view;
    if ([imageView.addtionString integerValue] == _imageArray.count - 1) {
        self.hidden = YES;
        [BaseCacheHelper setBOOLValue:YES forKey:kFirstApp];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self) {
        CGPoint offSet = scrollView.contentOffset;
        self.pageControl.currentPage = offSet.x/(self.bounds.size.width);//计算当前的页码
        [scrollView setContentOffset:CGPointMake(self.bounds.size.width * (_pageControl.currentPage), scrollView.contentOffset.y) animated:YES];
    }
    if (scrollView.contentOffset.x == (_imageArray.count) *self.width) {
        self.hidden = YES;
        [BaseCacheHelper setBOOLValue:YES forKey:kFirstApp];
    }
}


#pragma mark - getter
- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(self.width/2, self.height - 60, 0, 40)];
    }
    return _pageControl;
}

@end


@implementation LaunchImageView

@end


//
//  FirstLaunchView.h
//  AnYiYun
//
//  Created by 韩亚周 on 2017/7/20.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol  LaunchViewDelegate <NSObject>

- (void)loadingViewInfo:(NSString *)addtionString didSelectImageAtIndex:(NSInteger)index;
@end

/**
 *  app首次启动页
 */

@interface FirstLaunchView : UIScrollView

@property (nonatomic, weak) id<LaunchViewDelegate> loadingDelegate;

- (instancetype)initWithFrame:(CGRect)frame delegate:(id)delegate;

@end


/**
 *  自定义UIImageView
 */
@interface LaunchImageView : UIImageView

/**附加信息*/
@property (nonatomic)         NSInteger tagIndex;

/**附加信息*/
@property (nonatomic, strong) NSString *addtionString;

@end

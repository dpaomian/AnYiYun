//
//  UIImage+RoundRect.h
//  QRCodeCreat
//
//  Created by 韩亚周 on 15/10/28.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (RoundRect)

+ (UIImage *)clipCornerWithImage:(UIImage *)image withSize:(CGSize)size withRadius:(NSInteger)radius;

@end

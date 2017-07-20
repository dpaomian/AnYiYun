//
//  UIImage+Extension.h
//  xuexin
//
//  Created by wxs on 16/6/13.
//  Copyright © 2016年 julong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AVFoundation/AVFoundation.h>
@class AVAsset;

@interface UIImage (Extension)

/**调整image大小*/
- (UIImage *)scaleToSize:(CGSize)newSize;

/**调整image方向*/
- (UIImage *)fixOrientation;

/**图片拉伸中间不变两边拉伸*/
- (UIImage *)stretchLeftAndRightWithContainerSize:(CGSize)size;

+ (CGSize)sizeWithImageOriginSize:(CGSize)originSize
                          minSize:(CGSize)imageMinSize
                          maxSize:(CGSize)imageMaxSiz;

/**预览图*/
+ (UIImage *)previewImageWithVideoURL:(NSString *)videoURL;

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
@end

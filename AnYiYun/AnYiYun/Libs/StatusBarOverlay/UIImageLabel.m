//
//  UIImageLabel.m
//  Label
//
//  Created by 韩亚周 on 14-7-31.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

#import "UIImageLabel.h"

#define IMAGE_TEXT_PADDING  25

@interface UIImageLabel() {
    UIImage * _image;
}

@end

@implementation UIImageLabel

- (void)setImageName:(NSString *)imageName {
    _imageName = imageName;
    _image = [UIImage imageNamed:imageName];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = {0, IMAGE_TEXT_PADDING,0, 0};
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

- (void)drawRect:(CGRect)rect {
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.padding,self.padding,_image.size.width,_image.size.height)];
    imageView.image = _image;
    [self addSubview:imageView];

    return [super drawRect:rect];
}

- (void)sizeToFit {
    CGFloat coordinateX = self.frame.origin.x;
    CGFloat originWidth = self.frame.size.width;
    [super sizeToFit];
    
    CGFloat textWidth = self.frame.size.width;
    CGFloat width = textWidth + _image.size.width + self.padding * 2 + IMAGE_TEXT_PADDING;
    CGFloat height = self.frame.size.height;
    if (height < _image.size.height) {
        height = _image.size.height;
    }
    
    coordinateX = coordinateX + originWidth;
    
    self.frame = CGRectMake(coordinateX - width, self.frame.origin.y,width, height + self.padding * 2);
    
}

@end

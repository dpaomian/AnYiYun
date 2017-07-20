

/** 注意先设置textView的字体 */

#import "UITextView+placeholder.h"
#import <objc/runtime.h>

#define LEFT_MARGIN 5
#define TOP_MARGIN  8

@implementation UITextView (placeholder)

- (NSString *)placeholder{
     return self.label.text;
}

- (void)setPlaceholder:(NSString *)placeholder{

    //赋值修改高度
    self.label.text = placeholder;
    [self changeLabelFrame];
    
    //监听文本改变,如果没有设置placeholder就不会监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:nil];
}

//文本修改
- (void)textDidChange:(NSNotification *)notify{
   self.label.hidden = self.text.length;
}

- (UILabel *)label{
    
    UILabel *label =  objc_getAssociatedObject(self, @"label");
    
    if (label == nil) {
        //没有就创建,并设置属性
        label = [[UILabel alloc] init];
        label.font = self.font;
        label.textColor = [UIColor grayColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        label.textColor = [UIColor lightGrayColor];
        [self addSubview:label];
        
        //关联到自身
        objc_setAssociatedObject(self, @"label", label, OBJC_ASSOCIATION_RETAIN);
       
    }
    
    return label;
}

//计算frame
- (void)changeLabelFrame{
    //文字可显示区域
    CGSize size = CGSizeMake(self.bounds.size.width - 2 * LEFT_MARGIN, CGFLOAT_MAX);
    
    //计算文字所占区域
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:self.label.font, NSFontAttributeName,nil, NSForegroundColorAttributeName,nil];
    NSMutableAttributedString *string =[[NSMutableAttributedString alloc] initWithString:self.placeholder attributes:attributesDictionary];
    CGSize labelSize = [string boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil].size;
    
//    CGSize labelSize;
//    //计算文字所占区域
//    if (iOS7Later)
//    {
//        NSDictionary *attributesDic = @{NSFontAttributeName:self.label.font};
//        labelSize = [self.label.text boundingRectWithSize:CGSizeMake(size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributesDic context:nil].size;
//    }
//    else
//    {
//        labelSize = [self.label.text sizeWithFont:self.label.font constrainedToSize:CGSizeMake(size.width, CGFLOAT_MAX)];
//    }
    
    self.label.frame = CGRectMake(LEFT_MARGIN, TOP_MARGIN, labelSize.width, labelSize.height);
}
@end

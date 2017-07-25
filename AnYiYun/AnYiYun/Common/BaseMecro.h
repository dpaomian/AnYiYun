//
//  BaseMecro.h
//  AnYiYun 宏定义项目基本配置
//
//  Created by wwr on 2017/7/19.
//  Copyright © 2017年 wwr. All rights reserved.
//

#ifndef BaseMecro_h
#define BaseMecro_h


#endif /* BaseMecro_h */


/**APP*/
#define kWindow  [UIApplication sharedApplication].keyWindow
    //#define kWindow  [[[UIApplication sharedApplication] delegate] window]

#define iOS9Later     ([[[UIDevice currentDevice] systemVersion] intValue]>= 9.0f)
#define iOS7Later     ([[[UIDevice currentDevice] systemVersion] intValue] >= 7.0f)
#define iOS6Later     ([[[UIDevice currentDevice] systemVersion] intValue] >= 6.0f)
#define iOS8Later ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f)
#define iOSVersion  [[[UIDevice currentDevice] systemVersion] intValue]
#define IOS_VERSION_10 (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_9_x_Max)?(YES):(NO)

/**屏幕尺寸*/
#define kScreen_Width    ([UIScreen mainScreen].bounds.size.width)
#define kScreen_Height   ([UIScreen mainScreen].bounds.size.height)
#define SCREEN_HEIGHT    ([UIScreen mainScreen].bounds.size.height)//暂时使用
#define SCREEN_WIDTH     ([UIScreen mainScreen].bounds.size.width)
#define kScreen_Frame    (CGRectMake(0, 0, kScreen_Width, kScreen_Height))
#define kScreenAllFrame  ([UIScreen mainScreen].bounds)
#define kScreen_CenterX  kScreen_Width/2
#define kScreen_CenterY  kScreen_Height/2
#define NAV_HEIGHT       64 //nav的高度
#define TAB_HEIGHT       49 //tab的高度
#define kScreen_LeftSpace  14 //内容距屏幕左侧间距
#define kScreen_CellSpace   8 //内容距屏幕顶部间距/cell分区间距

/**字体大小*/
    //#define SYSFONT_(a)      [UIFont fontWithName:nil size:a]
#define SYSFONT_(a)  [UIFont systemFontOfSize:a]


/**颜色*/
#define RGB(r, g, b)             [UIColor colorWithRed:((r)/255.0) green:((g)/255.0) blue:((b)/255.0) alpha:1.0]
#define RGBA(r,g,b,a)            [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:a]//十进制
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]//16进制

#define UIColorFromRGBA(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

#define RANDOM_COLOR [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1.0]

#define kAPPOrangeColor         [UIColor orangeColor]
#define kAPPBlueColor           RGB(24, 159, 242)//RGB(246,246,248)
#define kAPPNavColor            RGB(255, 255, 255) //导航栏标题颜色
#define kAPPTableViewLineColor  RGB(222, 222, 222)
#define kAppBackgrondColor      RGB(239, 239, 244)
#define kAppTitleBlackColor     RGB(51, 51, 51)   //一级标题颜色 黑色
#define kAppTitleDrakGrayColor  RGB(102, 102, 102)//二级字体颜色 深灰
#define kAppTitleGrayColor      RGB(153, 153, 153)//二级字体颜色 灰色
#define kAppTitleLightGrayColor RGB(204, 204, 204)//辅助字体颜色 浅灰
#define kAppTitleRedColor       RGB(253,100,84)   //主要提示/按钮色 西瓜红
#define kAPPBusinessTopColor    RGB(18, 188, 243) //RGB(24, 183, 244)业务顶部过渡色值
#define kAppTitleGreenColor     RGB(80, 184, 17)//字体颜色 绿色

/**GCD*/
#define BACK(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define MAIN(block) dispatch_async(dispatch_get_main_queue(),block)
#define Kit_Dispatch_Async_Main(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}

    //判断设备

#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define IS_IPHONE_4 (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

    //打印函数
#ifdef DEBUG
#define DLog(fmt, ...) NSLog((fmt), ##__VA_ARGS__); //打印函数
#define DDNSLog(fmt, ...) NSLog((@"[文件名:%s]\n" "[函数名:%s]\n" "[行号:%d] \n" fmt), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);//调试使用
#define DLOGDATA(data)             LSLOG(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding])  //数据打印函数
#else
#define DLog(...);
#define DDNSLog(...);
#define DLOGDATA(...);
#endif


/**沙盒路径*/
    //document文件夹路径
#define PATH_AT_DOCDIR(name)        [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:name]
    //temp文件夹路径
#define PATH_AT_TMPDIR(name)        [NSTemporaryDirectory() stringByAppendingPathComponent:name]
    //cache文件夹路径
#define PATH_AT_CACHEDIR(name)		[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:name]
    //Libary文件夹路径
#define PATH_AT_LIBDIR(name)		[[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:name]

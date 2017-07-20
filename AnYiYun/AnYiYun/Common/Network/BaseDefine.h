//
//  BaseDefine.h
//  AnYiYun
//
//  Created by wwr on 2017/7/19.
//  Copyright © 2017年 wwr. All rights reserved.
//

#pragma mark - 服务器地址

    //外网发布
#define BaseOnlyUrl                @"http://59.110.12.181:18084/Android"



#pragma mark - 工程相关

#define kDeviceToken           @"kDeviceToken"     //推送deviceToken
#define kNotifierNetWork       @"kNotifierNetWork"//网络状况值， 0 无网络， 1 移动网络， 2 wifi

#pragma mark - 通知相关
    //网络状态切换的通知
#define kNetWorkStatusChangeNotification @"kNetWorkStatusChangeNotification"


#pragma mark -文件存储相关
    //用户下载图片缓存
#define kUserCacheImageFolder       [NSString stringWithFormat:@"%@/images",[PersonInfo shareInstance].accountID]
    //用户下载语音缓存
#define kUserCacheAudioFolder       [NSString stringWithFormat:@"%@/audios",[PersonInfo shareInstance].accountID]
    //用户下载视频缓存
#define kUserCacheVideoFolder       [NSString stringWithFormat:@"%@/videos",[PersonInfo shareInstance].accountID]

    //用户下载文件目录
#define kUserDownLoadFilesFolder       [NSString stringWithFormat:@"%@/downFiles",[PersonInfo shareInstance].accountID]



#pragma mark - 接口定义


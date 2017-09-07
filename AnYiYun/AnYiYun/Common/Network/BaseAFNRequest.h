//
//  BaseAFNRequest.h
//  BaseProject
//
//  Created by 韩亚周 on 16/7/27.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

/**定义请求类型的枚举*/
typedef NS_ENUM(NSUInteger,HttpRequestType) {
    HttpRequestTypeGet = 0,
    HttpRequestTypePost
    
};

/**定义请求类型的枚举*/
typedef NS_ENUM(NSUInteger,UploadFileType) {
    UploadFileTypeImage = 0,
    UploadFileTypeAudio,
    UploadFileTypeVideo
};

@interface AFNManager : NSObject

/**定义请求成功的block*/
typedef void(^downloadSuccess)(NSURL * targetPath, NSURLResponse *  response);

/**定义请求成功的block（无数据返回）*/
typedef void(^requestBlockSuccess)();

/**定义请求成功的block*/
typedef void(^requestSuccess)(NSDictionary * object);

/**定义请求成功的block*/
typedef void(^requestDataSuccess)( NSData * object);

/**定义请求失败的block*/
typedef void(^requestFailure)(NSError *error);

/**定义上传进度block*/
typedef void(^uploadProgress)(float progress);

/**定义下载进度block*/
typedef void(^downloadProgress)(float progress);

/**定义请求失败的block*/
typedef void(^requestFailured)(NSString *errorString);

@end

@interface BaseAFNRequest : AFHTTPSessionManager
/**
 *  单例方法
 *
 *  @return 实例对象
 */
+(instancetype)shareManager;

+ (BOOL)checkNetworkStatus;

/**
 *  网络请求的实例方法
 *
 *  @param type         get / post
 *  @param urlString    请求的地址
 *  @param paraments    请求的参数
 *  @param successBlock 请求成功的回调
 *  @param failureBlock 请求失败的回调
 *  @param progress 进度
 */
+(void)requestWithType:(HttpRequestType)type additionParam:(id)param urlString:(NSString *)urlString paraments:(id)paraments successBlock:(requestSuccess)successBlock failureBlock:(requestFailure)failureBlock progress:(downloadProgress)progress;

/**
 *  上传单个文件 （单语音 单图片 单视频等）
 *
 *  @param operations   上传单个文件预留参数---视具体情况而定 可移除
 *  @param fileData     文件Data
 *  @param fileName     文件名称
 *  @param filType      文件类型
 *  @param urlString    上传服务器地址
 *  @param successBlock 上传成功的回调
 *  @param failureBlock 上传失败的回调
 *  @param progress     上传进度
 */
+(void)uploadFileWithOperations:(NSDictionary *)operations withFileData:(NSData *)fileData withFileName:(NSString *)fileName withFileType:(UploadFileType)fileType withUrlString:(NSString *)urlString withSuccessBlock:(requestSuccess)successBlock withFailurBlock:(requestFailure)failureBlock withUpLoadProgress:(uploadProgress)progress;

/**
 *  多图上传
 *
 *  @param operations   上传图片预留参数---视具体情况而定 可移除
 *  @param imageArray   上传的图片数组
 *  @parm width      图片要被压缩到的宽度
 *  @param urlString    上传的url
 *  @param successBlock 上传成功的回调
 *  @param failureBlock 上传失败的回调
 *  @param progress     上传进度
 */

+(void)uploadImageWithOperations:(NSDictionary *)operations withImageArray:(NSArray *)imageArray withUrlString:(NSString *)urlString withSuccessBlock:(requestSuccess)successBlock withFailurBlock:(requestFailure)failureBlock withUpLoadProgress:(uploadProgress)progress;


/**
 *  视频上传
 *
 *  @param operations   上传视频预留参数---视具体情况而定 可移除
 *  @param videoPath    上传视频的本地沙河路径
 *  @param urlString     上传的url
 *  @param successBlock 成功的回调
 *  @param failureBlock 失败的回调
 *  @param progress     上传的进度
 */
+(void)uploadVideoWithOperaitons:(NSDictionary *)operations withVideoPath:(NSString *)videoPath withUrlString:(NSString *)urlString withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock withUploadProgress:(uploadProgress)progress;


/**
 *  文件下载
 *
 *  @param operations   文件下载预留参数---视具体情况而定 可移除
 *  @param savePath     下载文件保存路径
 *  @param urlString        请求的url
 *  @param successBlock 下载文件成功的回调
 *  @param failureBlock 下载文件失败的回调
 *  @param progress     下载文件的进度显示
 */


+(void)downLoadFileWithOperations:(NSDictionary *)operations withSavaPath:(NSString *)savePath withUrlString:(NSString *)urlString withSuccessBlock:(downloadSuccess)successBlock withFailureBlock:(requestFailure)failureBlock withDownLoadProgress:(downloadProgress)progress;

/**
 *  取消所有的网络请求
 */
+(void)cancelAllRequest;
/**
 *  取消指定的url请求
 *
 *  @param type        该请求的请求类型 get / post
 *  @param string      该请求的url
 */

+(void)cancelHttpRequestWithRequestType:(HttpRequestType)type requestUrlString:(NSString *)string;

@end




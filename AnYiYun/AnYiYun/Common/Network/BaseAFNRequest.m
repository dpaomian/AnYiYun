//
//  BaseAFNRequest.m
//  BaseProject
//
//  Created by wxs on 16/7/27.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "BaseAFNRequest.h"
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetExportSession.h>
#import <AVFoundation/AVMediaFormat.h>
#import "NSDictionary+Extension.h"

#define BOUNDARY @"----------cH2gL6ei4Ef1KM7cH2KM7ae0ei4gL6"

@implementation AFNManager

@end

@implementation BaseAFNRequest

/**
 *  获得全局唯一的网络请求实例单例方法
 *
 *  @return 网络请求类的实例
 */

+(instancetype)shareManager
{
    
    static BaseAFNRequest * manager = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] initWithBaseURL:nil];
    });
    
    return manager;
}


#pragma mark - 重写initWithBaseURL
/**
 *
 *
 *  @param url baseUrl
 *
 *  @return 通过重写夫类的initWithBaseURL方法,返回网络请求类的实例
 */

-(instancetype)initWithBaseURL:(NSURL *)url
{
    
    if (self = [super initWithBaseURL:url]) {
        
        /**设置请求超时时间*/
        
        self.requestSerializer.timeoutInterval = 3;
        
        /**设置相应的缓存策略*/
        
        self.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        
        
        /**分别设置请求以及相应的序列化器*/
        self.requestSerializer = [AFHTTPRequestSerializer serializer];
        
        AFJSONResponseSerializer * response = [AFJSONResponseSerializer serializer];
        
        response.removesKeysWithNullValues = YES;
        
        self.responseSerializer = response;
        
        /**复杂的参数类型 需要使用json传值-设置请求内容的类型*/
        
        [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
//#warning 此处做为测试 可根据自己应用设置相应的值
//        
//        /**设置apikey ------类似于自己应用中的tokken---此处仅仅作为测试使用*/
//        
//[self.requestSerializer setValue:[BaseHelper getHttpHeaderDetailInfo] forHTTPHeaderField:@"user-agent"];
//        
//        
        
        /**设置接受的类型*/
        [self.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/plain",@"application/json",@"text/json",@"text/javascript",@"text/html", nil]];
        
    }
    
    return self;
}


#pragma mark - 网络请求的类方法---get/post

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

+(void)requestWithType:(HttpRequestType)type additionParam:(id)param urlString:(NSString *)urlString paraments:(id)paraments successBlock:(requestSuccess)successBlock failureBlock:(requestFailure)failureBlock progress:(downloadProgress)progress
{
    DLog(@"请求参数 params = %@",[BaseHelper dictionaryToJson:paraments]);
     DLog(@"请求地址 urlString = %@?%@",urlString,[paraments serializeToUrlString]);

    if (![self checkNetworkStatus]) {
        BOOL isNeedAlert = [param[@"isNeedAlert"] boolValue];
        if (isNeedAlert) {
            [StatusBarOverlay initAnimationWithAlertString:@"网络异常,请检查网络是否可用！" theImage:nil];
        }
        
        MAIN(^{
            [MBProgressHUD hideHUDForView:kWindow animated:YES];
        });
        DLog(@"网络监测 请求被返回");
        return;
    }
    
    
    switch (type) {
        case HttpRequestTypeGet:
        {
            [[BaseAFNRequest shareManager] GET:urlString parameters:paraments progress:^(NSProgress * _Nonnull downloadProgress) {
                
//                progress(downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                if ([responseObject isKindOfClass:[NSData class]]) {
                    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
                    successBlock(dictionary);
                }else{
                    successBlock(responseObject);
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                failureBlock(error);
            }];
            
            break;
        }
        case HttpRequestTypePost:
        {
            [[BaseAFNRequest shareManager] POST:urlString parameters:paraments progress:^(NSProgress * _Nonnull uploadProgress) {
                
//                progress(uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                if ([responseObject isKindOfClass:[NSData class]]) {
                    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
                    successBlock(dictionary);
                }else{
                    successBlock(responseObject);
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                failureBlock(error);
                
            }];
        }   
    }
}

#pragma mark - 上传单个文件 （单语音 单图片 单视频等）

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
+(void)uploadFileWithOperations:(NSDictionary *)operations withFileData:(NSData *)fileData withFileName:(NSString *)fileName withFileType:(UploadFileType)fileType withUrlString:(NSString *)urlString withSuccessBlock:(requestSuccess)successBlock withFailurBlock:(requestFailure)failureBlock withUpLoadProgress:(uploadProgress)progress
{
    if (![self checkNetworkStatus]) {
        DLog(@"网络异常 请求被返回");
        [StatusBarOverlay initAnimationWithAlertString:@"网络异常,请检查网络是否可用！" theImage:nil];
        return;
    }
    
    urlString = [NSString stringWithFormat:@"%@?q=addfile",BASE_PLAN_URL];
    
    DLog(@"上传文件地址前缀 = %@",urlString);

//    在iOS7.1的版本，使用前两个没有什么问题，倒是上传功能，出了response Code=-1011 "Request failed: length required (411)这个问题
//    在iOS8.0以上版本是正常运行,即使在上传图片的时候出现response Code=-1016 "Request failed: unacceptable content-type: text/html"的问题也是用
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"]
//    或者是
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer]
//    轻松解决。

    if (iOS8Later) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
        
        [manager POST:urlString parameters:operations constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData)
         {
             switch (fileType)
             {
                 case UploadFileTypeImage:
                 {
                     [formData appendPartWithFileData:fileData name:@"file" fileName:fileName mimeType:@"image/png"];
                 }
                     break;
                 case UploadFileTypeAudio:
                 {
                     [formData appendPartWithFileData:fileData name:@"file" fileName:fileName mimeType:@"audio/mp3"];
                 }
                     break;
                 case UploadFileTypeVideo:
                 {
                     [formData appendPartWithFileData:fileData name:@"file" fileName:fileName mimeType:@"video/mp4"];
                 }
                     break;
                     
                 default:
                     break;
             }
         } progress:^(NSProgress * _Nonnull uploadProgress) {
             
             //progress(uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
             
         } success:^(NSURLSessionDataTask * _Nonnull task, id   _Nullable responseObject) {
             if ([responseObject isKindOfClass:[NSData class]]) {
                  NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
                 successBlock(dictionary);
             }else{
                 successBlock(responseObject);
             }
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             
             failureBlock(error);
             
         }];

    }else {
        __block NSURL *tempFileUrl;
        NSMutableURLRequest *multipleRequest = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:urlString parameters:operations constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            switch (fileType)
            {
                case UploadFileTypeImage:
                {
                    tempFileUrl = [NSURL fileURLWithPath:[PATH_AT_CACHEDIR(kUserCacheImageFolder) stringByAppendingPathComponent:fileName]];

                    [formData appendPartWithFileData:fileData name:@"file" fileName:fileName mimeType:@"image/png"];
                }
                    break;
                case UploadFileTypeAudio:
                {
                    tempFileUrl = [NSURL fileURLWithPath:[PATH_AT_CACHEDIR(kUserCacheAudioFolder) stringByAppendingPathComponent:fileName]];

                    [formData appendPartWithFileData:fileData name:@"file" fileName:fileName mimeType:@"audio/mp3"];
                }
                    break;
                case UploadFileTypeVideo:
                {
                    tempFileUrl = [NSURL fileURLWithPath:[PATH_AT_CACHEDIR(kUserCacheVideoFolder) stringByAppendingPathComponent:fileName]];

                    [formData appendPartWithFileData:fileData name:@"file" fileName:fileName mimeType:@"video/mp4"];
                }
                    break;
                    
                default:
                    break;
            }

        } error:nil];

        [[AFHTTPRequestSerializer serializer] requestWithMultipartFormRequest:multipleRequest writingStreamContentsToFile:tempFileUrl completionHandler:^(NSError * _Nullable error) {
            AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];

            NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithRequest:multipleRequest fromFile:tempFileUrl progress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                if (error) {
                    if (failureBlock) {
                        failureBlock(error);
                    }
                }else {
                    if (successBlock) {
                        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
                        successBlock(dictionary);
                    }
                }
            }];
            [uploadTask resume];
        }];
    }
    
   
}

+ (NSDictionary *)dictionaryWithContentsOfData:(NSData *)data {
    
    CFPropertyListRef list = CFPropertyListCreateWithData(kCFAllocatorDefault, (__bridge CFDataRef)data, kCFPropertyListImmutable, NULL, NULL);
    
    if(list == nil) return nil;
    
    if ([(__bridge id)list isKindOfClass:[NSDictionary class]]) {
        
        return (__bridge NSDictionary *)list;
        
    }
    
    else {
        
        CFRelease(list);
        
        return nil; 
        
    } 
    
}


#pragma mark - 多图上传
/**
 *  上传图片
 *
 *  @param operations   上传图片等预留参数---视具体情况而定 可移除
 *  @param imageArray   上传的图片数组
 *  @parm width      图片要被压缩到的宽度
 *  @param urlString    上传的url---请填写完整的url
 *  @param successBlock 上传成功的回调
 *  @param failureBlock 上传失败的回调
 *  @param progress     上传进度
 *
 */
+(void)uploadImageWithOperations:(NSDictionary *)operations withImageArray:(NSArray *)imageArray withUrlString:(NSString *)urlString withSuccessBlock:(requestSuccess)successBlock withFailurBlock:(requestFailure)failureBlock withUpLoadProgress:(uploadProgress)progress

{
    if (![self checkNetworkStatus]) {
        DLog(@"网络异常 请求被返回");
        [StatusBarOverlay initAnimationWithAlertString:@"网络异常,请检查网络是否可用！" theImage:nil];
        return;
    }
    
    urlString = [NSString stringWithFormat:@"%@?q=addfile",BASE_PLAN_URL];
    DLog(@"上传文件地址前缀 = %@",urlString);
    
    //1.创建管理者对象
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"application/json",@"text/json",@"text/javascript",@"text/html", nil];//设置相应内容类型

    [manager POST:urlString parameters:operations constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSUInteger i = 0 ;
        
        /**出于性能考虑,将上传图片进行压缩*/
        for (UIImage * image in imageArray) {
            
            //image的分类方法
            NSData * imgData = UIImageJPEGRepresentation(image, .5);
//            while (imgData.length > 1024 * 500) { // 压缩小于 500 k
//               UIImage *zoomImage = [[UIImage alloc] initWithData:imgData];
//                imgData = UIImageJPEGRepresentation(zoomImage, 0.07);
//            }
            NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
            formatter.dateFormat=@"yyyyMMddHHmmss";
            NSString *str=[formatter stringFromDate:[NSDate date]];
            NSString *fileName=[NSString stringWithFormat:@"%@.png",str];
            //拼接data
            [formData appendPartWithFileData:imgData name:@"file" fileName:fileName mimeType:@"image/png"];
            
            i++;
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        progress(uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        
        successBlock(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failureBlock(error);
        
    }];
}



#pragma mark - 视频上传

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

+(void)uploadVideoWithOperaitons:(NSDictionary *)operations withVideoPath:(NSString *)videoPath withUrlString:(NSString *)urlString withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock withUploadProgress:(uploadProgress)progress

{
    if (![self checkNetworkStatus]) {
        DLog(@"网络异常 请求被返回");
        [StatusBarOverlay initAnimationWithAlertString:@"网络异常,请检查网络是否可用！" theImage:nil];
        return;
    }
    /**获得视频资源*/
    
    AVURLAsset * avAsset = [AVURLAsset assetWithURL:[NSURL URLWithString:videoPath]];
    
    /**压缩*/
    
    //    NSString *const AVAssetExportPreset640x480;
    //    NSString *const AVAssetExportPreset960x540;
    //    NSString *const AVAssetExportPreset1280x720;
    //    NSString *const AVAssetExportPreset1920x1080;
    //    NSString *const AVAssetExportPreset3840x2160;
    
    AVAssetExportSession  *  avAssetExport = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPreset640x480];
    
    /**创建日期格式化器*/
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
    
    /**转化后直接写入Library---caches*/
    
    NSString *  videoWritePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingString:[NSString stringWithFormat:@"/output-%@.mp4",[formatter stringFromDate:[NSDate date]]]];
    
    avAssetExport.outputURL = [NSURL URLWithString:videoWritePath];
    
    avAssetExport.outputFileType =  AVFileTypeMPEG4;
    
    [avAssetExport exportAsynchronouslyWithCompletionHandler:^{
        
        switch ([avAssetExport status]) {
                
            case AVAssetExportSessionStatusCompleted:
            {

                AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
                
                [manager POST:urlString parameters:operations constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                    
                    //获得沙盒中的视频内容
                    
                    [formData appendPartWithFileURL:[NSURL fileURLWithPath:videoWritePath] name:@"write you want to writre" fileName:videoWritePath mimeType:@"video/mpeg4" error:nil];
                    
                } progress:^(NSProgress * _Nonnull uploadProgress) {
                    
                    progress(uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
                    
                    successBlock(responseObject);
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                    failureBlock(error);
                    
                }];
                
                break;
            }
            default:
                break;
        }
        
    }];
    
}

#pragma mark - 文件下载


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

+(void)downLoadFileWithOperations:(NSDictionary *)operations withSavaPath:(NSString *)savePath withUrlString:(NSString *)urlString withSuccessBlock:(downloadSuccess)successBlock withFailureBlock:(requestFailure)failureBlock withDownLoadProgress:(downloadProgress)progress
{
    
    if (![self checkNetworkStatus]) {
        DLog(@"网络异常 请求被返回");
        [StatusBarOverlay initAnimationWithAlertString:@"网络异常,请检查网络是否可用！" theImage:nil];
        return;
    }

    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];

//    //设置请求内容的长度
//    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%ld", (unsigned long)[jsonStr length]] forHTTPHeaderField:@"Content-Length"];
//    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]] progress:^(NSProgress * _Nonnull downloadProgress) {
        DLog(@"视频下载进度%lld",downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);

        progress(downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        return [NSURL fileURLWithPath:savePath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        if (error) {
            failureBlock(error);
        }else{
            successBlock([NSURL fileURLWithPath:savePath],response);
        }
        
    }];
    //开启启动下载任务
    [downloadTask resume];
}


#pragma mark -  取消所有的网络请求

/**
 *  取消所有的网络请求
 *  a finished (or canceled) operation is still given a chance to execute its completion block before it iremoved from the queue.
 */

+(void)cancelAllRequest
{
    [[BaseAFNRequest shareManager].operationQueue cancelAllOperations];
}



#pragma mark -   取消指定的url请求/
/**
 *  取消指定的url请求
 *
 *  @param type        该请求的请求类型 get / post
 *  @param string      该请求的url
 */

+(void)cancelHttpRequestWithRequestType:(HttpRequestType)type requestUrlString:(NSString *)string
{
    NSError * error;
    NSString *requestType = @"post";
    if (type==HttpRequestTypeGet)
    {
        requestType = @"get";
    }
    /**根据请求的类型 以及 请求的url创建一个NSMutableURLRequest---通过该url去匹配请求队列中是否有该url,如果有的话 那么就取消该请求*/
    
    NSString * urlToPeCanced = [[[[BaseAFNRequest shareManager].requestSerializer requestWithMethod:requestType URLString:string parameters:nil error:&error] URL] path];
    
    
    for (NSOperation * operation in [BaseAFNRequest shareManager].operationQueue.operations) {
        
        //如果是请求队列
        if ([operation isKindOfClass:[NSURLSessionTask class]]) {
            
            //请求的类型匹配
            BOOL hasMatchRequestType = [requestType isEqualToString:[[(NSURLSessionTask *)operation currentRequest] HTTPMethod]];
            
            //请求的url匹配
            
            BOOL hasMatchRequestUrlString = [urlToPeCanced isEqualToString:[[[(NSURLSessionTask *)operation currentRequest] URL] path]];
            
            //两项都匹配的话  取消该请求
            if (hasMatchRequestType&&hasMatchRequestUrlString) {
                
                [operation cancel];
                
            }
        }
        
    }
}

/**
 监控网络状态
 */
+ (BOOL)checkNetworkStatus
{
    __block BOOL isNetworkUse = YES;
    NSInteger status = [[BaseCacheHelper valueForKey:kNotifierNetWork] integerValue];
    if (status == 0) {
        isNetworkUse = NO;
    }else{
        isNetworkUse = YES;
    }
    return isNetworkUse;
}

@end


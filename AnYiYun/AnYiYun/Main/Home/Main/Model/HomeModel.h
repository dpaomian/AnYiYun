//
//  HomeModel.h
//  AnYiYun
//
//  Created by 韩亚周 on 2017/7/21.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeModel : NSObject

/**广告图片url*/
@property (nonatomic, copy) NSString *imgurl;

/**广告内容url*/
@property (nonatomic, copy) NSString *contenturl;

@end



@interface HomeAdverModel : NSObject

/**id */
@property (nonatomic, copy) NSString *adverId;

/**公司id */
@property (nonatomic, copy) NSString *companyId;
/**name */
@property (nonatomic, copy) NSString *name;
/**图片 */
@property (nonatomic, copy) NSString *pic_url;
/**点击url */
@property (nonatomic, copy) NSString *url;
/** */
@property (nonatomic, assign) BOOL delFlag;

- (id)initWithDictionary:(NSDictionary *)userDictionary;

@end

@interface HomeModuleModel : NSObject

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *imageStr;
@property (nonatomic, assign) BOOL isShow;

@end


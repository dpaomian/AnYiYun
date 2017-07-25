//
//  HomeModel.h
//  AnYiYun
//
//  Created by wwr on 2017/7/21.
//  Copyright © 2017年 wwr. All rights reserved.
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

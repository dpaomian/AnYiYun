//
//  CompanyModel.h
//  AnYiYun
//
//  Created by wwr on 2017/7/24.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CompanyModel : NSObject

@property (nonatomic,strong)NSString *companyId;
@property (nonatomic,strong)NSString *companyName;
@property (nonatomic,strong)NSString *companyLogoUrl;

- (id)initWithDictionary:(NSDictionary *)userDictionary;

@end

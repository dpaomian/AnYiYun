//
//  CompanyModel.h
//  AnYiYun
//
//  Created by 韩亚周 on 2017/7/24.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CompanyModel : NSObject

@property (nonatomic,strong)NSString *companyId;
@property (nonatomic,strong)NSString *companyName;
@property (nonatomic,strong)NSString *companyLogoUrl;

- (id)initWithDictionary:(NSDictionary *)userDictionary;

@end

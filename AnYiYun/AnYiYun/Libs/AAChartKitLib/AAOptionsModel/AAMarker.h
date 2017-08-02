//
//  AAMarker.h
//  AAChartKit
//
//  Created by An An on 17/1/20.
//  Copyright © 2017年 An An. All rights reserved.
//  source code ----*** https://github.com/AAChartModel/AAChartKit ***--- source code
//

#import <Foundation/Foundation.h>

@interface AAMarker : NSObject
AAPropStatementAndFuncStatement(strong, AAMarker, NSNumber *, radius);
AAPropStatementAndFuncStatement(copy, AAMarker, NSString *, symbol);
AAPropStatementAndFuncStatement(copy, AAMarker, NSString *, fillColor);//点的填充色(用来设置折线连接点的填充色)
AAPropStatementAndFuncStatement(strong, AAMarker, NSNumber *, lineWidth);//外沿线的宽度(用来设置折线连接点的轮廓描边的宽度)
AAPropStatementAndFuncStatement(copy, AAMarker, NSString *, lineColor);//外沿线的颜色(用来设置折线连接点的轮廓描边颜色，当值为空字符串时，默认取数据点或数据列的颜色。)
@end

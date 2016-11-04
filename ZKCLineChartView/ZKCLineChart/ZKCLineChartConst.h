//
//  ZKCLineChartConst.h
//  Wealth88
//
//  Created by apple on 16/3/9.
//  Copyright © 2016年 深圳市中科创财富通网络金融有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  间距
 */
extern CGFloat const chartMargin;
/**
 *  x轴的间距
 */
extern CGFloat const xLabelMargin;
/**
 *  y轴的间距
 */
extern CGFloat const yLabelMargin;
/**
 *  axis label的高度
 */
extern CGFloat const ZKCLabelHeight;
/**
 *  axis label的宽度
 */
extern CGFloat const ZKCYLabelWidth;
/**
 *  显示数值的label宽度
 */
extern CGFloat const ZKCTagLabelWidth;

#define ZKCRetinaMode (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? [UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1536, 2048), [[UIScreen mainScreen] currentMode].size) : NO : [UIScreen instancesRespondToSelector:@selector(currentMode)] ? [[UIScreen mainScreen] currentMode].size.width > 320 : NO)

/**
 * 断言
 * @param condition   条件
 * @param returnValue 返回值
 */
#define ZKCLineChartAssertError(condition, returnValue, error, msg) \
if ((condition) == NO) { \
ZKCLineChartBuildError(error, msg); \
return returnValue;\
}

#define ZKCLineChartAssert2(condition, returnValue) \
if ((condition) == NO) return returnValue;

/**
 * 断言
 * @param condition   条件
 */
#define ZKCLineChartAssert(condition) ZKCLineChartAssert2(condition, )

/**
 * 断言
 * @param param         参数
 * @param returnValue   返回值
 */
#define ZKCLineChartAssertParamNotNil2(param, returnValue) \
ZKCLineChartAssert2((param) != nil, returnValue)

/**
 * 断言
 * @param param   参数
 */
#define ZKCLineChartAssertParamNotNil(param) MJExtensionAssertParamNotNil2(param, )

@interface ZKCColor : UIColor

+ (UIColor *)chart_red;
+ (UIColor *)chart_green;
+ (UIColor *)chart_brown;
+ (UIColor *)chart_blue;
+ (UIColor *)chart_black;
+ (UIColor *)chart_lightGray;
#pragma mark  十六进制颜色
+ (UIColor *)chart_hexColorWithString:(NSString *)string;
+ (UIColor *)chart_hexColorWithString:(NSString *)string alpha:(float) alpha;

@end

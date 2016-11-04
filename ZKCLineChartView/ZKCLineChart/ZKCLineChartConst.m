//
//  ZKCLineChartConst.m
//  Wealth88
//
//  Created by apple on 16/3/9.
//  Copyright © 2016年 深圳市中科创财富通网络金融有限公司. All rights reserved.
//

#import "ZKCLineChartConst.h"

/**
 *  间距
 */
CGFloat const chartMargin = 10;
/**
 *  x轴的间距
 */
CGFloat const xLabelMargin = 15;
/**
 *  y轴的间距
 */
CGFloat const yLabelMargin = 15;
/**
 *  axis label的高度
 */
CGFloat const ZKCLabelHeight = 10;
/**
 *  axis label的宽度
 */
CGFloat const ZKCYLabelWidth = 30;
/**
 *  显示数值的label宽度
 */
CGFloat const ZKCTagLabelWidth = 80;

@implementation ZKCColor

+ (UIColor *)chart_red {
    return [UIColor colorWithRed:245.0/255.0 green:94.0/255.0 blue:78.0/255.0 alpha:1.0f];
}

+ (UIColor *)chart_green {
    return [self chart_hexColorWithString:@"#22d04b"];
}

+ (UIColor *)chart_brown {
    return [self chart_hexColorWithString:@"#d0d0d0"];
}

+ (UIColor *)chart_blue {
    return [self chart_hexColorWithString:@"#00b0f9"];
}

+ (UIColor *)chart_black {
    return [self chart_hexColorWithString:@"#333333"];
}

+ (UIColor *)chart_lightGray {
    return [self chart_hexColorWithString:@"#e9e9e9"];
}

#pragma mark  十六进制颜色

+ (UIColor *)chart_hexColorWithString:(NSString *)string
{
    return [self chart_hexColorWithString:string alpha:1.0f];
}

+ (UIColor *)chart_hexColorWithString:(NSString *)string alpha:(float) alpha
{
    if ([string hasPrefix:@"#"]) {
        string = [string substringFromIndex:1];
    }
    
    NSString *pureHexString = [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([pureHexString length] != 6) {
        return [UIColor whiteColor];
    }
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [pureHexString substringWithRange:range];
    
    range.location += range.length ;
    NSString *gString = [pureHexString substringWithRange:range];
    
    range.location += range.length ;
    NSString *bString = [pureHexString substringWithRange:range];
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:alpha];
}

+ (CGFloat)chart_getRandomByNum:(int)num {
    
    return (arc4random()%num + 100)/255.0;
}

@end

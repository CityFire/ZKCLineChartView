//
//  ZKCLineChart.h
//  Wealth88
//
//  Created by apple on 16/3/9.
//  Copyright © 2016年 深圳市中科创财富通网络金融有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZKCLineChart : UIView

@property (nonatomic, strong) NSArray *xLabels;
@property (nonatomic, strong) NSArray *yLabels;
@property (nonatomic, strong) NSArray *yValues;
@property (nonatomic, strong) NSArray *colors;
@property (nonatomic, strong) NSArray *yAxisUnits;

@property (nonatomic) CGFloat xLabelWidth;
@property (nonatomic) CGFloat yLabelWidth;
@property (nonatomic) CGFloat yValueMin;
@property (nonatomic) CGFloat yValueMax;

@property (nonatomic) CGFloat bottomMargin;
@property (nonatomic) CGFloat leftMargin;

/**
 *  是否启动动画
 */
@property (nonatomic) BOOL isAnimated;
/**
 *  动画时间
 */
@property (nonatomic) NSTimeInterval animateTime;

/**
 *  画图表
 */
-(void)strokeChart;

@end

//
//  ZKCLineChartView.h
//  Wealth88
//
//  Created by apple on 16/3/8.
//  Copyright © 2016年 深圳市中科创财富通网络金融有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZKCLineChartView;

@protocol ZKCLineChartViewDataSource <NSObject>

@required
/**
 *  横坐标标题数组 必须实现
 *
 *  @param chartView 视图
 *
 *  @return 横坐标数组
 */
- (NSArray *)chartConfigAxisXLabel:(ZKCLineChartView *)chartView;

/**
 *  需要显示的数值数组 必须实现
 *
 *  @param chartView 视图
 *
 *  @return 需要显示的数值数组
 */
- (NSArray *)chartConfigAxisYValue:(ZKCLineChartView *)chartView;

/**
 *  需要显示的纵坐标的标题数组 必须实现
 *
 *  @param chartView 视图
 *
 *  @return 需要显示的数值数组
 */
- (NSArray *)chartConfigAxisYTitle:(ZKCLineChartView *)chartView;

@optional
/**
 *  不同折线的颜色数组,默认为绿色和蓝色数组，如果需要修改颜色则需要实现该数据源方法
 *
 *  @param chartView 视图
 *
 *  @return 不同折线的颜色数组
 */
- (NSArray *)chartConfigColors:(ZKCLineChartView *)chartView;
/**
 *  纵坐标单位值数组，默认为左边纵坐标为3，右边为100，如果需要更改单位值需要实现该数据源方法
 *
 *  @param chartView 视图
 *
 *  @return 纵坐标单位值数组
 */
- (NSArray *)chartConfigAsixUnits:(ZKCLineChartView *)chartView;
@end

@interface ZKCLineChartView : UIView

/**
 *  需要使用该初始化方法进行初始化视图
 *
 *  @param frame      坐标
 *  @param tilte      大标题
 *  @param subTitle   日期子标题
 *  @param dataSource 数据源
 *
 *  @return 视图对象
 */
- (instancetype)initWithFrame:(CGRect)frame
                           title:(NSString *)title
                               subTitle:(NSString *)subTitle
                                   dataSource:(id<ZKCLineChartViewDataSource>)dataSource;

/**
 *  如果调用该方法进行添加进父视图的话就不用再调用drawLineChart方法了,animated为YES为开启动画，否则不开启
 *
 *  @param view     添加到哪个视图上
 *  @param animated 动画
 */
- (void)showInView:(UIView *)view animated:(BOOL)animated;

/**
 *  如果未调用showInView方法时即要调用该方法进行绘制图表,animated为YES为开启动画，否则不开启
 *
 *  @param animated 动画
 */
- (void)drawLineChartAnimated:(BOOL)animated;

@end

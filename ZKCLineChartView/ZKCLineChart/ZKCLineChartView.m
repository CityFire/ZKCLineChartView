//
//  ZKCLineChartView.m
//  Wealth88
//
//  Created by apple on 16/3/8.
//  Copyright © 2016年 深圳市中科创财富通网络金融有限公司. All rights reserved.
//

#import "ZKCLineChartView.h"
#import "ZKCLineChart.h"
#import "ZKCLineChartConst.h" 

@interface ZKCLineChartView () {
    // 显示的日期范围字符串
    NSString *_dateString;
}

@property (nonatomic, weak) UILabel *titleLb;

@property (nonatomic, weak) UILabel *dateLb;

// 显示客户的颜色
@property (nonatomic, strong) UIColor *firstColor;
// 显示佣金的颜色
@property (nonatomic, strong) UIColor *secondColor;
//  标题
@property (nonatomic, copy) NSString *title;
// 子标题
@property (nonatomic, copy) NSString *subTitle;
// 数据源协议
@property (nonatomic, weak) id<ZKCLineChartViewDataSource> dataSource;
// 纵坐标标题数组
@property (nonatomic, strong) NSArray *axisYTitles;

@property (nonatomic, strong) ZKCLineChart *lineChart;

@end

@implementation ZKCLineChartView

#pragma mark - LifeCycle

- (instancetype)initWithFrame:(CGRect)frame
                            title:(NSString *)title
                                subTitle:(NSString *)subTitle
                                    dataSource:(id<ZKCLineChartViewDataSource>)dataSource {
    NSAssert(title, @"标题必须初始化");
    NSAssert(subTitle, @"子标题必须初始化");
    NSAssert(dataSource, @"数据源代理必须设置");
//    ZKCLineChartAssertParamNotNil2(title, nil);
//    ZKCLineChartAssertParamNotNil2(subTitle, nil);
//    ZKCLineChartAssertParamNotNil2(dataSource, nil);
    self.title = title;
    self.subTitle = subTitle;
    self.dataSource = dataSource;
    return [self initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setDefauleParamer];
    }
    return self;
}

#pragma mark - 默认值设置

- (void)setDefauleParamer {
    self.backgroundColor = [UIColor whiteColor];
    _firstColor = [ZKCColor chart_blue];
    _secondColor = [ZKCColor chart_green];
}

#pragma mark - 创建UI

- (void)setUpOtherView {
    if (self.titleLb) {
        return;
    }
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 23, self.frame.size.width, 20)];
    label.text = self.title;
    label.textColor = [ZKCColor chart_hexColorWithString:@"#333333"];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:13.0];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    self.titleLb = label;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, self.titleLb.frame.origin.y+self.titleLb.frame.size.height+5, self.titleLb.frame.size.width, 15)];
    label.text = self.subTitle;
    label.textColor = [ZKCColor chart_hexColorWithString:@"#666666"];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:9.0];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    self.dateLb = label;
    
    CGFloat titleWidth = 45.0;
    CGFloat leftM = (self.bounds.size.width-titleWidth-230)*0.5;
    for (int i = 0; i < 2; i++) {
        label = [[UILabel alloc] initWithFrame:CGRectMake(leftM+i*230, self.dateLb.frame.origin.y+self.titleLb.frame.size.height, 45, 15)];
        label.text = self.axisYTitles[i];
        label.textColor = [ZKCColor chart_hexColorWithString:@"#666666"];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:9.0];
        label.textAlignment = NSTextAlignmentLeft;
        [self addSubview:label];
    }
    
    leftM = (self.bounds.size.width-40-53)*0.5;
    for (int i = 0; i < 2; i++) {
        label = [[UILabel alloc] initWithFrame:CGRectMake(leftM+i*53, self.bounds.size.height-50, 10, 5)];
        label.backgroundColor = (i==0 ? _firstColor : _secondColor);
        label.font = [UIFont systemFontOfSize:9.0];
        label.textAlignment = NSTextAlignmentLeft;
        [self addSubview:label];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(label.frame.origin.x+label.frame.size.width+5, label.frame.origin.y-5, 30, 15)];
        NSString *title = self.axisYTitles[i];
        title = [[title componentsSeparatedByString:@"("] objectAtIndex:0];
        label.text = title;
        label.textColor = [ZKCColor chart_hexColorWithString:@"#666666"];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:12.0];
        label.textAlignment = NSTextAlignmentLeft;
        [self addSubview:label];
    }
    
}

- (void)setUpChartWithAnimated:(BOOL)isAnimated {
    if (!_lineChart) {
        _lineChart = [[ZKCLineChart alloc] initWithFrame:CGRectMake(0.0, 80, self.frame.size.width, self.frame.size.height-80)];
        [self addSubview:_lineChart];
    }
    
    // 判断是否遵从数据源协议
    
    if ([self.dataSource respondsToSelector:@selector(chartConfigColors:)]) {
        [_lineChart setColors:[self.dataSource chartConfigColors:self]];
        self.firstColor = [[self.dataSource chartConfigColors:self] objectAtIndex:0];
        self.secondColor = [[self.dataSource chartConfigColors:self] objectAtIndex:1];
    }
    
    if ([self.dataSource respondsToSelector:@selector(chartConfigAxisXLabel:)]) {
        [_lineChart setXLabels:[self.dataSource chartConfigAxisXLabel:self]];
    }
    else {
        return;
    }
    
    if ([self.dataSource respondsToSelector:@selector(chartConfigAsixUnits:)]) {
        [_lineChart setYAxisUnits:[self.dataSource chartConfigAsixUnits:self]];
    }
    
    if ([self.dataSource respondsToSelector:@selector(chartConfigAxisYValue:)]) {
        [_lineChart setYValues:[self.dataSource chartConfigAxisYValue:self]];
    }
    else {
        return;
    }
    
    if ([self.dataSource respondsToSelector:@selector(chartConfigAxisYTitle:)]) {
        self.axisYTitles = [self.dataSource chartConfigAxisYTitle:self];
    }
    else {
        return;
    }
    
    _lineChart.isAnimated = isAnimated;
    [_lineChart strokeChart];
}

#pragma mark - show方法

- (void)showInView:(UIView *)view animated:(BOOL)animated{
    [self setUpChartWithAnimated:animated];
    [self setUpOtherView];
    [view addSubview:self];
}

#pragma mark - draw方法

- (void)drawLineChartAnimated:(BOOL)animated {
    [self setUpChartWithAnimated:animated];
    [self setUpOtherView];
}

#pragma mark - setter方法

- (void)setFirstColor:(UIColor *)firstColor {
    if (_firstColor != firstColor) {
        _firstColor = firstColor;
    }
}

- (void)setSecondColor:(UIColor *)secondColor {
    if (_secondColor != secondColor) {
        _secondColor = secondColor;
    }
}

- (void)setAxisYTitles:(NSArray *)axisYTitles {
    if (_axisYTitles != axisYTitles) {
        _axisYTitles = axisYTitles;
        [_axisYTitles enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj rangeOfString:@"("].length == 0) {
                NSAssert(nil, @"单位值符号必须初始化格式为(x)");
            }
            *stop = YES;
        }];
    }
}

@end

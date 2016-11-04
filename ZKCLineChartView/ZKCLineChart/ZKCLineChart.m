//
//  ZKCLineChart.m
//  Wealth88
//
//  Created by apple on 16/3/9.
//  Copyright © 2016年 深圳市中科创财富通网络金融有限公司. All rights reserved.
//

#import "ZKCLineChart.h"
#import "ZKCChartLabel.h"
#import "ZKCLineChartConst.h"

static CGFloat YCount = 7;

@interface ZKCLineChart ()

// 存储点的数值
@property (nonatomic, strong) NSMutableArray *dots1ValueArray;
@property (nonatomic, strong) NSMutableArray *dots2ValueArray;

// 点的坐标数组
@property (nonatomic, strong) NSMutableArray *point1Array;
@property (nonatomic, strong) NSMutableArray *point2Array;

// 点的坐标值显示Label
@property (nonatomic, strong) UILabel *valueLabel1;
@property (nonatomic, strong) UILabel *valueLabel2;

// 佣金
@property (nonatomic, assign) NSInteger YRMaxValue;
// 客户
@property (nonatomic, assign) NSInteger YLMaxValue;

// 左边纵坐标单位值 默认为3
@property (nonatomic) int leftAxisVaule;
// 右边纵坐标 默认为100
@property (nonatomic) int rightAxisVaule;

@end

@implementation ZKCLineChart

@synthesize bottomMargin = _bottomMargin;
@synthesize leftMargin = _leftMargin;

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setDefaultParamer];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setDefaultParamer];
    }
    return self;
}

- (void)setDefaultParamer {
    self.clipsToBounds = YES;
    self.userInteractionEnabled = YES;
    _bottomMargin = 94.0;
    _leftMargin = 48.0;
    _leftAxisVaule = 3;
    _rightAxisVaule = 100;
    _YLMaxValue = 21;
    _YRMaxValue = 700;
    _animateTime = 0.15;
    _isAnimated = YES;
    _dots1ValueArray = [NSMutableArray array];
    _dots2ValueArray = [NSMutableArray array];
    _point1Array = [NSMutableArray array];
    _point2Array = [NSMutableArray array];
}

#pragma mark - getter

- (CAShapeLayer *)drawCircle:(CGRect)size width:(CGFloat)width color:(UIColor *)color {
    return [self drawCircle:CGRectZero
                       size:size
                          width:width
                             color:color];
}

- (CAShapeLayer *)drawCircle:(CGRect)frame size:(CGRect)size width:(CGFloat)width color:(UIColor *)color {
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:size];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    shapeLayer.strokeColor = color.CGColor;
    shapeLayer.fillColor = color.CGColor;
    shapeLayer.lineWidth = width;
    shapeLayer.frame = frame;
    return shapeLayer;
}

#pragma mark - setter

- (void)setIsAnimated:(BOOL)isAnimated {
    _isAnimated = isAnimated;
}

- (void)setAnimateTime:(NSTimeInterval)animateTime {
    _animateTime = animateTime;
}

- (void)setColors:(NSArray *)colors {
    _colors = colors;
}

- (void)setLeftAxisVaule:(int)leftAxisVaule {
    _leftAxisVaule = leftAxisVaule;
    // 存储左边纵坐标最大值
    _YLMaxValue = YCount * leftAxisVaule;
}

- (void)setRightAxisVaule:(int)rightAxisVaule {
    _rightAxisVaule = rightAxisVaule;
    // 存储右边纵坐标最大值
    _YRMaxValue = YCount * rightAxisVaule;
}

- (void)setBottomMargin:(CGFloat)bottomMargin {
    _bottomMargin = bottomMargin;
}

- (void)setLeftMargin:(CGFloat)leftMargin {
    _leftMargin = leftMargin;
}

- (void)setYAxisUnits:(NSArray *)yAxisUnits {
    _yAxisUnits = yAxisUnits;
    self.leftAxisVaule = [[_yAxisUnits objectAtIndex:0] intValue];
    self.rightAxisVaule = [[_yAxisUnits objectAtIndex:1] intValue];
}

- (void)setYValues:(NSArray *)yValues {
    _yValues = yValues;
    [self setYLabels:yValues];
}

- (void)setYLabels:(NSArray *)yLabels {
    NSInteger maxs = 0;
    NSInteger mins = MAXFLOAT;
    for (NSArray *arry in yLabels) {
        for (NSString *valueString in arry) {
            float value = [valueString floatValue];
            if (value > maxs) {
                maxs = value;
            }
            if (value < mins) {
                mins = value;
            }
        }
    }
    
    // 求最大和最小值范围
    maxs = maxs < YCount ? YCount : maxs;
    _yValueMin = 0;
    _yValueMax = maxs;
    
    CGFloat chartCavanHeight = self.frame.size.height - _bottomMargin;
    CGFloat levelHeight = chartCavanHeight / YCount;
    
    for (int i = 0; i < YCount+1; i++) {
        ZKCChartLabel *label = [[ZKCChartLabel alloc] initWithFrame:CGRectMake(ZKCYLabelWidth, chartCavanHeight-i * levelHeight + 5, ZKCYLabelWidth, ZKCLabelHeight)];
        label.text = [NSString stringWithFormat:@"%@", @(i*_leftAxisVaule)];
        label.font = [UIFont systemFontOfSize:11.0];
        label.textColor = [ZKCColor chart_black];
        label.textAlignment = NSTextAlignmentLeft;
        [self addSubview:label];
        
        label = [[ZKCChartLabel alloc] initWithFrame:CGRectMake(self.frame.size.width-48, chartCavanHeight-i * levelHeight + 5, ZKCYLabelWidth, ZKCLabelHeight)];
        label.text = [NSString stringWithFormat:@"%@", @(i*_rightAxisVaule)];
        label.font = [UIFont systemFontOfSize:11.0];
        [self addSubview:label];
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(_leftMargin,ZKCLabelHeight+i*levelHeight)];
        [path addLineToPoint:CGPointMake(self.frame.size.width-_leftMargin,ZKCLabelHeight+i*levelHeight)];
        [path closePath];
        shapeLayer.path = path.CGPath;
        UIColor *color;
        if (i == YCount) {
            color = [ZKCColor chart_brown];
        }
        else {
            color = [ZKCColor chart_lightGray];
        }
        shapeLayer.strokeColor = [color CGColor];
        shapeLayer.fillColor = [[UIColor whiteColor] CGColor];
        shapeLayer.lineWidth = ZKCRetinaMode ? 0.5 : 1;
        [self.layer addSublayer:shapeLayer];
    }

}

- (void)setXLabels:(NSArray *)xLabels {
    
    _xLabels = xLabels;
    
    CGFloat num = YCount;
    if (xLabels.count>0) {
        num = xLabels.count;
    }
    
    _xLabelWidth = (self.frame.size.width - 2*_leftMargin)/num;
    
    for (int i = 0; i < xLabels.count; i++) {
        NSString *labelText = xLabels[i];
        ZKCChartLabel *label = [[ZKCChartLabel alloc] initWithFrame:CGRectMake(i * _xLabelWidth+ZKCYLabelWidth + 20, self.frame.size.height - _bottomMargin + 17, _xLabelWidth, ZKCLabelHeight)];
        label.text = labelText;
        label.textColor = [ZKCColor chart_black];
        label.font = [UIFont systemFontOfSize:9.0];
        [self addSubview:label];
    }
    
    for (int i = 0; i < xLabels.count+1; i++) {
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        UIBezierPath *path = [UIBezierPath bezierPath];
        UIColor *color;
        if (i == 0 || i == YCount) {
            color = [ZKCColor chart_brown];
            [self.layer addSublayer:[self drawCircle:CGRectMake(_leftMargin+i*_xLabelWidth-0.5, ZKCLabelHeight-1.2, 1, 1)
                                             size:CGRectMake(0, 0, 1, 1)
                                                  width:1.0
                                                      color:[ZKCColor chart_brown]]];
        }
        else {
            color = [ZKCColor chart_lightGray];
        }
        [path moveToPoint:CGPointMake(_leftMargin+i*_xLabelWidth,ZKCLabelHeight)];
        [path addLineToPoint:CGPointMake(_leftMargin+i*_xLabelWidth,self.frame.size.height-_bottomMargin+10)];
        [path closePath];
        shapeLayer.path = path.CGPath;
        shapeLayer.strokeColor = [color CGColor];
        shapeLayer.fillColor = [[UIColor whiteColor] CGColor];
        shapeLayer.lineWidth = ZKCRetinaMode ? 0.5 : 1;;
        [self.layer addSublayer:shapeLayer];
    }
}

- (void)strokeChart
{
    for (int i = 0; i < _yValues.count; i++) {
        NSArray *childArray = _yValues[i];
        if (childArray.count ==0 ) {
            return;
        }

        CGFloat max = [childArray[0] floatValue];
        CGFloat min = [childArray[0] floatValue];
        NSInteger max_i = 0;
        NSInteger min_i = 0;
        
        for (int j = 0; j < childArray.count; j++){
            CGFloat num = [childArray[j] floatValue];
            if (max <= num){
                max = num;
                max_i = j;
            }
            if (min >= num){
                min = num;
                min_i = j;
            }
        }
        
        CAShapeLayer *chartLine = [CAShapeLayer layer];
        chartLine.lineCap = kCALineCapRound;
        chartLine.lineJoin = kCALineJoinBevel;
        chartLine.fillColor = [[UIColor whiteColor] CGColor];
        chartLine.lineWidth = 1.0;
        chartLine.strokeEnd = 0.0;
        [self.layer addSublayer:chartLine];
        
        UIBezierPath *progressLine = [UIBezierPath bezierPath];
        CGFloat firstValue = [[childArray objectAtIndex:0] floatValue];
        CGFloat xPosition = (ZKCYLabelWidth + _xLabelWidth/2.0)+_xLabelWidth+2;
        CGFloat chartCavanHeight = self.frame.size.height - _bottomMargin;
        
        float scaleValue = 0.0;
        if (i == 0) {
            _yValueMax = _YLMaxValue;
            if (firstValue >= _YLMaxValue) {
                scaleValue = _YLMaxValue;
            }
            else {
                scaleValue = firstValue;
            }
        }
        else if (i == 1) {
            _yValueMax = _YRMaxValue;
            if (firstValue >= _YRMaxValue) {
                scaleValue = _YRMaxValue;
            }
            else {
                scaleValue = firstValue;
            }
        }
        float scale = (scaleValue-_yValueMin) / ((float)_yValueMax-_yValueMin);
        
        NSInteger index = 0;
        [self addPoint:CGPointMake(xPosition, chartCavanHeight - scale * chartCavanHeight+ZKCLabelHeight)
                 index:i
                   value:firstValue
                     dotsIndex:index];
        
        [progressLine moveToPoint:CGPointMake(xPosition, chartCavanHeight - scale * chartCavanHeight+ZKCLabelHeight)];
        [progressLine setLineWidth:1.0];
        [progressLine setLineCapStyle:kCGLineCapRound];
        [progressLine setLineJoinStyle:kCGLineJoinRound];
        
        for (NSString *valueString in childArray) {
            float scaleValue = 0.0;
            if (i == 0) {
                _yValueMax = _YLMaxValue;
                if ([valueString floatValue] >= _YLMaxValue) {
                    scaleValue = _YLMaxValue;
                }
                else {
                    scaleValue = [valueString floatValue];
                }
            }
            else if (i == 1) {
                _yValueMax = _YRMaxValue;
                if ([valueString floatValue] >= _YRMaxValue) {
                    scaleValue = _YRMaxValue;
                }
                else {
                    scaleValue = [valueString floatValue];
                }
            }
            float scale =(scaleValue-_yValueMin) / ((float)_yValueMax-_yValueMin);
            if (index != 0) {
                
                CGPoint point = CGPointMake(xPosition+index*_xLabelWidth, chartCavanHeight - scale * chartCavanHeight+ZKCLabelHeight);
                [progressLine addLineToPoint:point];
                
                [progressLine moveToPoint:point];
                [self addPoint:point
                         index:i
                           value:[valueString floatValue]
                             dotsIndex:index];
            }
            index += 1;
        }
        
        chartLine.path = progressLine.CGPath;
        if ([[_colors objectAtIndex:i] CGColor]) {
            chartLine.strokeColor = [[_colors objectAtIndex:i] CGColor];
        }
        else {
            if (i == 0) {
                chartLine.strokeColor = [ZKCColor chart_blue].CGColor;
            }
            else {
                chartLine.strokeColor = [ZKCColor chart_green].CGColor;
            }
        }
        
        if (_isAnimated) {
            CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            pathAnimation.duration = childArray.count*_animateTime;
            pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
            pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
            pathAnimation.autoreverses = NO;
            [chartLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
        }
        chartLine.strokeEnd = 1.0;
    }
}

- (void)addPoint:(CGPoint)point index:(NSInteger)index
                 value:(CGFloat)value
                      dotsIndex:(NSInteger)dIndex;
{
    // 画点
    UIColor *color = [_colors objectAtIndex:index]?[_colors objectAtIndex:index]:(index == 0 ? [ZKCColor chart_green] : [ZKCColor chart_blue]);
    float radius = 2.0;
    [self.layer addSublayer:[self drawCircle:CGRectMake(point.x - radius, point.y - radius, 2*radius, 2*radius)
                                       width:2.0
                                          color:color]];
    if (index == 0) {
        // 客户
        [self.dots1ValueArray addObject:[NSString stringWithFormat:@"%.f",value]];
        [self.point1Array addObject:NSStringFromCGPoint(point)];
    }
    else {
        // 佣金
        [self.dots2ValueArray addObject:[NSString stringWithFormat:(value==0.0?@"%.f":@"%.2f"),value]];
        [self.point2Array addObject:NSStringFromCGPoint(point)];
    }
}

#pragma mark - tools

+ (CGSize)sizeOfString:(NSString *)text withWidth:(float)width font:(UIFont *)font
{
    CGSize size = CGSizeMake(width, MAXFLOAT);
    
    if ([text respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSDictionary *tdic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
        size = [text boundingRectWithSize:size
                                  options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                               attributes:tdic
                                  context:nil].size;
    }
    else {
        size = [text sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    }
    
    return size;
}

#pragma mark - 隐藏label

- (void)hideValueLabel:(UILabel *)label {
    label.alpha = 0.0;
}

#pragma mark - 手势触摸响应方法

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self touchPoint:touches withEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self touchPoint:touches withEvent:event];
}

- (void)touchPoint:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    __block NSTimeInterval timeInterval = 0.0;
    [self.point1Array enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger i, BOOL * _Nonnull stop) {
        // 客户
        CGPoint p = CGPointFromString(obj);
        CGRect rect = CGRectMake(p.x-5, p.y-5, 10, 10);
        BOOL contains = CGRectContainsPoint(rect, touchPoint);
        if (contains) {
            if (!self.valueLabel1) {
                self.valueLabel1 = [[UILabel alloc]initWithFrame:CGRectZero];
                self.valueLabel1.font = [UIFont systemFontOfSize:12];
                self.valueLabel1.textAlignment = NSTextAlignmentCenter;
                [self addSubview:self.valueLabel1];
            }
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideValueLabel:) object:self.valueLabel1];
            
            self.valueLabel1.alpha = 0.0;
            CGPoint point;
            // 客户
            self.valueLabel1.textColor = [_colors objectAtIndex:0]?[_colors objectAtIndex:0]:[ZKCColor chart_green];
            self.valueLabel1.text = [self.dots1ValueArray objectAtIndex:i];
            point = CGPointFromString([self.point1Array objectAtIndex:i]);
            
            CGFloat leftMargin = 0;
            CGFloat topMargin = ZKCLabelHeight;
            CGSize size = [ZKCLineChart sizeOfString:self.valueLabel1.text withWidth:MAXFLOAT font:self.valueLabel1.font];
            // 判断横坐标不能超出范围
            if (i == YCount-1) {
                leftMargin = self.frame.size.width-48-size.width;
            }
            else {
                leftMargin = point.x-size.width/2.0;
            }
            
            if (point.y < 2 * ZKCLabelHeight) {
                topMargin = point.y + 1.5 * ZKCLabelHeight;
            }
            else {
                topMargin = 1.5 * ZKCLabelHeight;
            }
            
            self.valueLabel1.frame = CGRectMake(point.x-size.width*0.5, point.y, size.width, ZKCLabelHeight);
            [UIView animateWithDuration:0.25 animations:^{
                self.valueLabel1.frame = CGRectMake(leftMargin, topMargin, size.width, ZKCLabelHeight);
            }];
            
            BOOL contains = CGRectContainsPoint(self.valueLabel1.frame, p);
            if (contains) {
                self.valueLabel1.frame = CGRectMake(leftMargin, point.y, size.width, ZKCLabelHeight);
                [UIView animateWithDuration:0.25 animations:^{
                    self.valueLabel1.frame = CGRectMake(leftMargin, p.y + 1.5 * ZKCLabelHeight, size.width, ZKCLabelHeight);
                }];
            }
            
            self.valueLabel1.alpha = 1.0;
            [self performSelector:@selector(hideValueLabel:) withObject:self.valueLabel1 afterDelay:++timeInterval];
            
//            NSLog(@"Click x: %f, y: %f line and point index is %d",touchPoint.x, touchPoint.y, i);
            *stop = YES;
        }
    }];

    [self.point2Array enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger i, BOOL * _Nonnull stop) {
        // 佣金
        CGPoint p = CGPointFromString(obj);
        CGRect rect = CGRectMake(p.x-5, p.y-5, 10, 10);
        BOOL contains = CGRectContainsPoint(rect, touchPoint);
        if (contains) {
            if (!self.valueLabel2) {
                self.valueLabel2 = [[UILabel alloc]initWithFrame:CGRectZero];
                self.valueLabel2.font = [UIFont systemFontOfSize:12];
                self.valueLabel2.textAlignment = NSTextAlignmentCenter;
                [self addSubview:self.valueLabel2];
            }
             [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideValueLabel:) object:self.valueLabel2];
            self.valueLabel2.alpha = 0.0;
            CGPoint point;
            // 佣金
            self.valueLabel2.textColor = [_colors objectAtIndex:1]?[_colors objectAtIndex:1]:[ZKCColor chart_blue];
            self.valueLabel2.text = [self.dots2ValueArray objectAtIndex:i];
            point = CGPointFromString([self.point2Array objectAtIndex:i]);
            CGFloat leftMargin = 0;
            CGFloat topMargin = ZKCLabelHeight;
            CGSize size = [ZKCLineChart sizeOfString:self.valueLabel2.text withWidth:MAXFLOAT font:self.valueLabel2.font];
            // 判断横坐标不能超出范围
            if (i == YCount-1) {
                leftMargin = self.frame.size.width-48-size.width;
            }
            else {
                leftMargin = point.x-size.width/2.0;
            }
            
            if (point.y < 2 * ZKCLabelHeight) {
                topMargin = point.y + 3.5 * ZKCLabelHeight;
            }
            else {
                topMargin = 3.5 * ZKCLabelHeight;
            }
            
            self.valueLabel2.frame = CGRectMake(point.x-size.width*0.5, point.y, size.width, ZKCLabelHeight);
            [UIView animateWithDuration:0.25 animations:^{
                self.valueLabel2.frame = CGRectMake(leftMargin, topMargin, size.width, ZKCLabelHeight);
            }];
            
            BOOL contains = CGRectContainsPoint(self.valueLabel2.frame, p);
            if (contains) {
                self.valueLabel2.frame = CGRectMake(leftMargin, point.y, size.width, ZKCLabelHeight);
                [UIView animateWithDuration:0.25 animations:^{
                    self.valueLabel2.frame = CGRectMake(leftMargin, p.y + 3.5 * ZKCLabelHeight, size.width, ZKCLabelHeight);
                }];
            }
            
            self.valueLabel2.alpha = 1.0;
            [self performSelector:@selector(hideValueLabel:) withObject:self.valueLabel2 afterDelay:(timeInterval>=1.0?1.5:++timeInterval)];

//            NSLog(@"Click 2 x: %f, y: %f line and point index is %d",touchPoint.x, touchPoint.y, i);
            *stop = YES;
        }
    }];
}

@end

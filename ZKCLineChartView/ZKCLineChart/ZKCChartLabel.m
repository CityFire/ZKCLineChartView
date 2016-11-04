//
//  ZKCChartLabel.m
//  Wealth88
//
//  Created by apple on 16/3/9.
//  Copyright © 2016年 深圳市中科创财富通网络金融有限公司. All rights reserved.
//

#import "ZKCChartLabel.h"

@implementation ZKCChartLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setLineBreakMode:NSLineBreakByWordWrapping];
        [self setMinimumScaleFactor:5.0f];
        [self setNumberOfLines:1];
        [self setFont:[UIFont boldSystemFontOfSize:10.0f]];
        [self setTextColor: [UIColor darkGrayColor]];
        [self setTextAlignment:NSTextAlignmentCenter];
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

# ZKCLineChartView
折线图（88财富客户端的Demo）

![image](https://github.com/CityFire/ZKCLineChartView/raw/master//1.png)

    初始化方法：
    ZKCLineChartView *chartView = [[ZKCLineChartView alloc] initWithFrame:CGRectMake(0, 80, screenWidth, 347) title:@"理财师推
    荐客户和佣金每 周趋势图" subTitle:[NSString stringWithFormat:@"日期 : %@", _dateString.length > 0 ? _dateString : @""]     dataSource:self];
    
    [chartView drawLineChartAnimated:YES];
    
    #数据源方法
    - (NSArray *)getXTitles:(NSArray *)array
    {
        NSMutableArray *xTitles = [NSMutableArray array];
        
        for (int i=0; i<array.count; i++) {
        
            NSString *str = [NSString stringWithFormat:@"%@",array[i]];
            
            [xTitles addObject:str];
            
        }
        
        return xTitles;
        
     }

     #pragma mark - ZKCLineChartViewDataSource

     - (NSArray *)chartConfigAxisXLabel:(ZKCLineChartView *)chartView {
     
         return [self getXTitles:self.datesArray];
         
     }

     - (NSArray *)chartConfigAxisYValue:(ZKCLineChartView *)chartView {
     
         NSArray *array1 = @[@"32",@"64",@"64",@"64",@"64",@"64",@"64"];
         
         NSArray *array2 = @[@"765",@"765",@"765",@"765",@"765",@"765",@"765"];
         
         return @[array1, array2];
     }

     - (NSArray *)chartConfigAxisYTitle:(ZKCLineChartView *)chartView {
     
         return @[@"客户(人)", @"佣金(元)"];
         
     }

     - (NSArray *)chartConfigAsixUnits:(ZKCLineChartView *)chartView {
     
         return @[@"3", @"100"];
         
     }

     - (NSArray *)chartConfigColors:(ZKCLineChartView *)chartView {
     
         return @[[UIColor colorWithHexString:@"#00b0f9"],[UIColor colorWithHexString:@"#22d04b"]];
         
     }

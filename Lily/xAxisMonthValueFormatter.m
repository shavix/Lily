//
//  xAxisMonthValueFormatter.m
//  Lily
//
//  Created by David Richardson on 10/26/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import "xAxisMonthValueFormatter.h"

@implementation xAxisMonthValueFormatter
{
    NSArray<NSString *> *months;
}

- (id)initForChart:(BarLineChartViewBase *)chart{
    
    self = [super init];
    
    months = @[
               @"Jan", @"Feb", @"Mar",
               @"Apr", @"May", @"Jun",
               @"Jul", @"Aug", @"Sep",
               @"Oct", @"Nov", @"Dec"
               ];
    
    return self;
    
}

- (NSString *)stringForValue:(double)value
                        axis:(ChartAxisBase *)axis{
    
    return months[(int)value];
    
}


@end

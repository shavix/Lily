//
//  xAxisMonthValueFormatter.h
//  Lily
//
//  Created by David Richardson on 10/26/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import <Foundation/Foundation.h>

@import Charts;

@interface xAxisMonthValueFormatter : NSObject <IChartAxisValueFormatter>

- (id)initForChart:(BarLineChartViewBase *)chart;

@end

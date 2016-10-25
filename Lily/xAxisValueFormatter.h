//
//  xAxisValueFormatter.h
//  Lily
//
//  Created by David Richardson on 10/24/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import <Foundation/Foundation.h>

@import Charts;

@interface xAxisValueFormatter : NSObject <IChartAxisValueFormatter>

@property (strong, nonatomic) NSArray *friends;

- (id)initForChart:(BarLineChartViewBase *)chart andArray:(NSArray *)arr;

@end

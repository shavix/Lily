//
//  DPRBarChartHelper.h
//  Lily
//
//  Created by David Richardson on 11/13/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import <Foundation/Foundation.h>

@import Charts;

@interface DPRChartHelper : NSObject

- (void)dataCountWithKeys:(NSArray *)sortedKeys andDataList:(id)dataList andChartView:(BarChartView *)chartView andType:(NSString *)type;

@end

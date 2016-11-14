//
//  DPRBarChartHelper.m
//  Lily
//
//  Created by David Richardson on 11/13/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import "DPRChartHelper.h"
#import "UIColor+CustomColors.h"

@implementation DPRChartHelper

- (void)dataCountWithKeys:(NSArray *)sortedKeys andDataList:(id)dataList andChartView:(BarChartView *)chartView andType:(NSString *)type{
	
	NSMutableArray *dataEntries = [[NSMutableArray alloc] init];
	NSMutableArray *colors = [[NSMutableArray alloc] init];
	
	
	for(int i = 0; i < sortedKeys.count; i++){
		NSDictionary *transaction;
		// friends
		if([dataList isKindOfClass:[NSDictionary class]]){
			NSString *name = sortedKeys[i];
			transaction = [dataList objectForKey:name];
		}
		// monthly
		else {
			NSNumber *index = sortedKeys[i];
			transaction = dataList[index.integerValue];
		}
		NSNumber *value;
		
		// netIncome
		if([type isEqualToString:@"netIncome"]){
			value = [transaction objectForKey:@"netIncome"];
			// specific colors
			if (value.doubleValue <= 0.f)
			{
				[colors addObject:[UIColor chartRed]];
			}
			else if(value.doubleValue == 0.f){
				[colors addObject:[UIColor whiteColor]];
			}
			else
			{
				[colors addObject:[UIColor chartGreen]];
			}
		}
		// expenditures
		else{
			value = [transaction objectForKey:@"sent"];
		}

		[dataEntries addObject:[[BarChartDataEntry alloc] initWithX:i y:value.doubleValue]];
		
		
	}
	
	BarChartDataSet *set = set = [[BarChartDataSet alloc] initWithValues:dataEntries label:@"Values"];
	
	// friends
	if([dataList isKindOfClass:[NSDictionary class]]){
		set.label = @"Friends";
	}
	else{
		set.label = @"Months";
	}
	
	BarChartData *data = [[BarChartData alloc] initWithDataSet:set];
	
	if([type isEqualToString:@"netIncome"]){
		set.colors = colors;
		set.valueColors = colors;
	}
	else{
		set.colors = ChartColorTemplates.many;
		[data setValueTextColor:[UIColor chartRed]];
	}
	[data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:11.f]];
	
	NSNumberFormatter *axisFormatter = [[NSNumberFormatter alloc] init];
	axisFormatter.maximumFractionDigits = 0;
	axisFormatter.negativePrefix = @"-$";
	axisFormatter.positivePrefix = @"$";
	[data setValueFormatter:[[ChartDefaultValueFormatter alloc] initWithFormatter:axisFormatter]];
	
	data.barWidth = 0.8;
	
	chartView.data = data;
	chartView.maxVisibleCount = 20;
	
}

@end
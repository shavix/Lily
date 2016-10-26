//
//  xAxisValueFormatter.m
//  Lily
//
//  Created by David Richardson on 10/24/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import "xAxisValueFormatter.h"
#import "DPRTransaction.h"
#import "DPRTarget.h"

@implementation xAxisValueFormatter{
    NSArray *transactionsByFriends;
}


- (id)initForChart:(BarLineChartViewBase *)chart andArray:(NSArray *)arr{
    
    self = [super init];
    
    transactionsByFriends = arr;

    return self;
    
}

- (NSString *)stringForValue:(double)value
                        axis:(ChartAxisBase *)axis{
    
    NSArray *friendArray = transactionsByFriends[(int)value];
    DPRTransaction *transaction = friendArray[0];
    
    NSString *title = transaction.target.fullName;
    
    NSArray *arr = [title componentsSeparatedByString:@" "];
    NSString *firstName = arr[0];
    NSString *name;
    
    if(arr.count > 1){
        NSString *lastName = arr[1];
        NSString *initial = [NSString stringWithFormat:@"%c.", [lastName characterAtIndex:0]];
        name = [NSString stringWithFormat:@"%@ %@", firstName, initial];
    }
    else {
        name = firstName;
    }
    
    
    return name;
}

@end

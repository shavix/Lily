//
//  DPRUIHelper.h
//  Lily
//
//  Created by David Richardson on 6/23/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@import Charts;

@interface DPRUIHelper : NSObject

- (void)setupTabUI:(UIViewController *)viewController withTitle:(NSString *)title;
- (void)setupDashboardViewUI:(UIView *)view;
- (void)setupPieChartView:(PieChartView *)chartView withTitle:(NSString *)title;

@end

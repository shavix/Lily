//
//  DPRUIHelper.h
//  Lily
//
//  Created by David Richardson on 6/23/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DropdownMenuController.h"

@import Charts;

@interface DPRUIHelper : NSObject


// methods
- (void)setupTabUI:(UIViewController *)viewController withTitle:(NSString *)title;
- (void)alertWithMessage:(NSString *)message andTitle:(NSString *)title andVC:(UIViewController *)vc;
- (NSArray *) createMenuWithVC:(DropdownMenuController *)vc andNumButtons:(int)numButtons andType:(NSString *)type;
- (void)setupBarChartView:(BarLineChartViewBase *)chartView withTitle:(NSString *)title;
- (void)setupNetIncomeChartView:(BarChartView *)chartView withVC:(DropdownMenuController *)vc;
- (void)setupChartView:(BarChartView *)chartView withVC:(DropdownMenuController *)vc andType:(NSString *)type;
- (void)setupCell:(UITableViewCell *)cell;
- (void)setupDashboardCell:(UITableViewCell *)cell;
- (void)refreshButtons:(NSArray *)buttonList withButton:(UIButton *)button andVC:(DropdownMenuController *)vc;
- (void)refreshListButtons:(NSArray *)buttonList withButton:(UIButton *)button;

@end

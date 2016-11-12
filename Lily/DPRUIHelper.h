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
- (void)setupDashboardViewUI:(UIView *)view;
- (void)setupBarChartView:(BarLineChartViewBase *)chartView withTitle:(NSString *)title;
- (void) helpAlertWithMessage:(NSString *)message andTitle:(NSString *)title andVC:(UIViewController *)vc;
- (void)notificationsStatus:(NSString *)status;
- (void)settingsHelpAlertWithTitle:(NSString *)title andMessage:(NSString *)message andVC:(UIViewController *)vc;
-(void) customizeMenuWithVC:(DropdownMenuController *)vc;

@end

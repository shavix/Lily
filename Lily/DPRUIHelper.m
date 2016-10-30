//
//  DPRUIHelper.m
//  Lily
//
//  Created by David Richardson on 6/23/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import "DPRUIHelper.h"
#import "UIColor+CustomColors.h"

@implementation DPRUIHelper


- (void)setupBarChartView:(BarLineChartViewBase *)chartView withTitle:(NSString *)title
{
    chartView.chartDescription.enabled = NO;
    
    chartView.drawGridBackgroundEnabled = NO;
    
    chartView.dragEnabled = YES;
    [chartView setScaleEnabled:YES];
    chartView.pinchZoomEnabled = NO;
    
    ChartXAxis *xAxis = chartView.xAxis;
    xAxis.labelPosition = XAxisLabelPositionBottom;
    chartView.xAxis.labelTextColor = [UIColor whiteColor];
    chartView.leftAxis.labelTextColor = [UIColor whiteColor];
    chartView.rightAxis.labelTextColor = [UIColor whiteColor];
    
    chartView.rightAxis.enabled = NO;
}

- (void)setupTabUI:(UIViewController *)viewController withTitle:(NSString *)title{

    // setup navigationController
    viewController.navigationController.navigationBar.barTintColor = [UIColor darkishColor];
    viewController.navigationController.navigationBar.translucent = NO;
    viewController.navigationController.navigationBar.topItem.title = title;
    [viewController.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    // setup viewController
    viewController.view.backgroundColor = [UIColor darkColor];
    
}

- (void)setupDashboardViewUI:(UIView *)view {
    
    view.backgroundColor = [UIColor charcoalColor];
    view.layer.cornerRadius = 5;
    
}

// help alert
- (void)helpAlertWithMessage:(NSString *)message andTitle:(NSString *)title andVC:(UIViewController *)vc{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }]];
    [vc presentViewController:alert animated:YES completion:nil];
    
}

- (void)notificationsStatus:(NSString *)status {
    
    [[NSUserDefaults standardUserDefaults] setObject:status forKey:@"notifications"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

@end

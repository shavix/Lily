//
//  DPRUIHelper.m
//  Lily
//
//  Created by David Richardson on 6/23/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import "DPRUIHelper.h"
#import "UIColor+CustomColors.h"

@import SCLAlertView_Objective_C;

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


-(void) customizeMenuWithVC:(DropdownMenuController *)vc andBarChart:(BarChartView *)chart{
	

	
	vc.menu.layer.cornerRadius = 10;
	vc.menu.clipsToBounds = YES;
	
	
	// Style menu buttons with IonIcons.
	for (UIButton *button in vc.buttons) {
		[button addTarget:vc action:@selector(animate) forControlEvents:UIControlEventTouchUpInside];
		// Set the title and icon position
		[button sizeToFit];
		button.titleEdgeInsets = UIEdgeInsetsMake(0, -button.imageView.frame.size.width-10, 0, button.imageView.frame.size.width);
		button.imageEdgeInsets = UIEdgeInsetsMake(0, button.titleLabel.frame.size.width, 0, -button.titleLabel.frame.size.width);
		
		button.backgroundColor = [UIColor charcoalColor];
		
		// Set color to white
		[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	}
	
	vc.menu.layer.zPosition = 999;
	
}

- (void)animate{
	
}


// help alert
- (void)helpAlertWithMessage:(NSString *)message andTitle:(NSString *)title andVC:(UIViewController *)vc{
    
    UIColor *green = [UIColor lightGreenColor];
    
    SCLAlertViewBuilder *builder = [SCLAlertViewBuilder new]
    .addButtonWithActionBlock(@"OK", ^{  })
    .customViewColor(green);
	
	
    SCLAlertViewShowBuilder *showBuilder = [SCLAlertViewShowBuilder new]
    .style(SCLAlertViewStyleNotice)
    .title(title)
    .subTitle(message)
    .duration(0);
	
    [showBuilder showAlertView:builder.alertView onViewController:vc];
    
}

- (void)settingsHelpAlertWithTitle:(NSString *)title andMessage:(NSString *)message andVC:(UIViewController *)vc{
    
    // alert
    SCLAlertView *alert = [[SCLAlertView alloc] init];

    // buttons
    SCLButton *yesButton = [alert addButton:@"Yes" actionBlock:^(void) {
        [self notificationsStatus:@"y"];
    }];
    //Using Block
    SCLButton *noButton = [alert addButton:@"No" actionBlock:^(void) {
        [self notificationsStatus:@"n"];
    }];
    
    yesButton.defaultBackgroundColor = [UIColor lightGreenColor];
    noButton.defaultBackgroundColor = [UIColor colorWithRed:255/255 green:70/255 blue:70/255 alpha:1];

    // show alert
    [alert showQuestion:vc title:title subTitle:message closeButtonTitle:nil duration:0.0f];
    
}

- (void)notificationsStatus:(NSString *)status {
    
    [[NSUserDefaults standardUserDefaults] setObject:status forKey:@"notifications"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

@end

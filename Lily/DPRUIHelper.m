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
	
	// axis
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

// returns button array
-(NSArray *) createMenuWithVC:(DropdownMenuController *)vc andNumButtons:(int)numButtons andType:(NSString *)type{
	
	// make menu
	CGFloat width = 160;
	CGFloat height = 40;
	CGRect frame = CGRectMake(vc.view.frame.size.width - width, -height * numButtons, width, height * numButtons);
	UIView *menu = [[UIView alloc] initWithFrame:frame];
	menu.backgroundColor = [UIColor darkishColor];
	menu.layer.zPosition = 990;
	[vc.view addSubview:menu];
	vc.menu = menu;
	vc.menu.hidden = YES;
	
	vc.menu.layer.cornerRadius = 10;
	vc.menu.clipsToBounds = YES;

	return [self createButtons:vc num:numButtons type:type];
}


- (NSArray *)createButtons:(DropdownMenuController *)vc num:(int)numButtons type:(NSString *)type{
	CGFloat width = 160;

	NSMutableArray *buttons = [[NSMutableArray alloc] init];
	for(int i = 0; i < numButtons; i++){
		
		CGFloat height = 40;
		CGRect frame = CGRectMake(0, i*height, width, height);
		UIButton *button = [[UIButton alloc] initWithFrame:frame];
		button.layer.zPosition = 999;
		button.titleLabel.textColor = [UIColor whiteColor];
		button.titleLabel.font = [UIFont boldSystemFontOfSize:12];
		
		button.backgroundColor = [UIColor darkishColor];
		
		// list buttons
		if(numButtons == 5){
			switch (i) {
				case 0:
					if([type isEqualToString:@"months"]){
						[button setTitle:@"Sort by Date" forState:UIControlStateNormal];
						[button addTarget:vc action:@selector(sortByDate:) forControlEvents:UIControlEventTouchDown];
						break;
					}
					else{
						[button setTitle:@"Sort by Name" forState:UIControlStateNormal];
						[button addTarget:vc action:@selector(sortByName:) forControlEvents:UIControlEventTouchDown];
						break;
					}
				case 1:
					[button setTitle:@"Sort by Transactions" forState:UIControlStateNormal];
					[button addTarget:vc action:@selector(sortByTransactions:) forControlEvents:UIControlEventTouchDown];
					break;
				case 2:
					[button setTitle:@"Sort by Received" forState:UIControlStateNormal];
					[button addTarget:vc action:@selector(sortByReceived:) forControlEvents:UIControlEventTouchDown];
					break;
				case 3:
					[button setTitle:@"Sort by Sent" forState:UIControlStateNormal];
					[button addTarget:vc action:@selector(sortBySent:) forControlEvents:UIControlEventTouchDown];
					break;
				case 4:
					[button setTitle:@"Sort by Net Income" forState:UIControlStateNormal];
					[button addTarget:vc action:@selector(sortByNetIncome:) forControlEvents:UIControlEventTouchDown];
					break;
			}
		}
		// graph buttons
		else{
			switch(i){
				case 0:
					if([type isEqualToString:@"months"]){
						[button setTitle:@"Sort by Date" forState:UIControlStateNormal];
						[button addTarget:vc action:@selector(sortByDate:) forControlEvents:UIControlEventTouchDown];
						break;
					}
					else{
						[button setTitle:@"Sort by Name" forState:UIControlStateNormal];
						[button addTarget:vc action:@selector(sortByName:) forControlEvents:UIControlEventTouchDown];
						break;
					}
				case 1:
					[button setTitle:@"Sort by Value" forState:UIControlStateNormal];
					[button addTarget:vc action:@selector(sortByValue:) forControlEvents:UIControlEventTouchDown];
					break;
					
			}
		}
		
		[buttons addObject:button];
		
		[vc.menu addSubview:button];
		
	}
	
	return buttons;
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


@end

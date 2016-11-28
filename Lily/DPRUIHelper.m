//
//  DPRUIHelper.m
//  Lily
//
//  Created by David Richardson on 6/23/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import "DPRUIHelper.h"
#import "UIColor+CustomColors.h"
#import <Lily-Bridging-Header.h>

@interface DPRUIHelper()

@property (weak, nonatomic) DropdownMenuController *dropDownVC;

@end

@implementation DPRUIHelper


- (void)setupChartView:(BarChartView *)chartView withVC:(DropdownMenuController *)vc andType:(NSString *)type{
	
	chartView.delegate = vc;
	
	chartView.drawBarShadowEnabled = NO;
	chartView.drawValueAboveBarEnabled = YES;
	chartView.drawBordersEnabled = YES;
	chartView.borderLineWidth = 1;
	chartView.borderColor = [UIColor darkGrayColor];
	
	
	NSNumberFormatter *axisFormatter = [[NSNumberFormatter alloc] init];
	axisFormatter.minimumFractionDigits = 0;
	axisFormatter.maximumFractionDigits = 1;
	if(![type isEqualToString:@"transactions"])
		axisFormatter.positivePrefix = @"$";
	
	ChartXAxis *xAxis = chartView.xAxis;
	xAxis.labelPosition = XAxisLabelPositionBottom;
	xAxis.labelFont = [UIFont systemFontOfSize:11.f];
	xAxis.drawGridLinesEnabled = YES;
	xAxis.granularity = 1.0;
	xAxis.labelCount = 5;
	xAxis.valueFormatter = vc;
	
	ChartYAxis *leftAxis = chartView.leftAxis;
	leftAxis.labelFont = [UIFont systemFontOfSize:10.f];
	leftAxis.labelCount = 10;
	leftAxis.valueFormatter = [[ChartDefaultAxisValueFormatter alloc] initWithFormatter:axisFormatter];
	leftAxis.labelPosition = YAxisLabelPositionOutsideChart;
	leftAxis.spaceTop = 0.15;
	leftAxis.axisMinimum = 0.0; // this replaces startAtZero = YES
	
	ChartYAxis *rightAxis = chartView.rightAxis;
	rightAxis.enabled = NO;
	
	ChartLegend *l = chartView.legend;
	l.enabled = NO;
	
	XYMarkerView *marker = [[XYMarkerView alloc]
							initWithColor: [UIColor colorWithWhite:180/255. alpha:1.0]
							font: [UIFont systemFontOfSize:12.0]
							textColor: UIColor.whiteColor
							insets: UIEdgeInsetsMake(8.0, 8.0, 20.0, 8.0)
							xAxisValueFormatter: chartView.xAxis.valueFormatter];
	marker.chartView = chartView;
	marker.minimumSize = CGSizeMake(80.f, 40.f);
	chartView.marker = marker;
	
	[chartView animateWithXAxisDuration:2.0 yAxisDuration:3.0];
}

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
    chartView.rightAxis.enabled = NO;
	
}

- (void)refreshButtons:(NSArray *)buttonList withButton:(UIButton *)button andVC:(DropdownMenuController *)vc{
	
	// hide menu
	for(UIButton *button in buttonList){
		button.backgroundColor = [UIColor charcoalColor];
	}
	button.backgroundColor = [UIColor lightGreenColor];
	[vc hideMenu];
	
}

- (void)refreshListButtons:(NSArray *)buttonList withButton:(UIButton *)button{
	
	// hide menu
	for(UIButton *button in buttonList){
		button.backgroundColor = [UIColor darkishColor];
	}
	button.backgroundColor = [UIColor lightGreenColor];
	
}

- (void)setupNetIncomeChartView:(BarChartView *)chartView withVC:(DropdownMenuController *)vc
{
	chartView.delegate = vc;
	chartView.drawBarShadowEnabled = NO;
	chartView.drawValueAboveBarEnabled = YES;
	chartView.chartDescription.enabled = NO;
	chartView.pinchZoomEnabled = NO;
	chartView.drawGridBackgroundEnabled = NO;
	chartView.rightAxis.enabled = YES;
	chartView.legend.enabled = NO;
	chartView.drawBordersEnabled = YES;
	chartView.borderLineWidth = 1;
	chartView.borderColor = [UIColor darkGrayColor];
	
	NSNumberFormatter *axisFormatter = [[NSNumberFormatter alloc] init];
	axisFormatter.minimumFractionDigits = 0;
	axisFormatter.maximumFractionDigits = 1;
	axisFormatter.negativePrefix = @"-$";
	axisFormatter.positivePrefix = @"$";
	
	
	ChartXAxis *xAxis = chartView.xAxis;
	xAxis.labelPosition = XAxisLabelPositionBottom;
	xAxis.labelFont = [UIFont systemFontOfSize:11.f];
	xAxis.drawGridLinesEnabled = YES;
	xAxis.drawAxisLineEnabled = YES;
	xAxis.labelTextColor = [UIColor whiteColor];
	xAxis.granularity = 1.0;
	xAxis.valueFormatter = vc;
	xAxis.labelCount = 5;
	
	ChartYAxis *leftAxis = chartView.leftAxis;
	leftAxis.drawLabelsEnabled = YES;
	leftAxis.labelCount = 10;
	leftAxis.spaceTop = 0.25;
	leftAxis.spaceBottom = 0.25;
	leftAxis.drawAxisLineEnabled = YES;
	leftAxis.drawGridLinesEnabled = YES;
	leftAxis.drawZeroLineEnabled = YES;
	leftAxis.zeroLineColor = UIColor.whiteColor;
	leftAxis.zeroLineWidth = 0.7f;
	leftAxis.valueFormatter = [[ChartDefaultAxisValueFormatter alloc] initWithFormatter:axisFormatter];
	
	ChartYAxis *rightAxis = chartView.rightAxis;
	rightAxis.drawLabelsEnabled = NO;
	
	XYMarkerView *marker = [[XYMarkerView alloc]
							initWithColor: [UIColor colorWithWhite:180/255. alpha:1.0]
							font: [UIFont systemFontOfSize:12.0]
							textColor: UIColor.whiteColor
							insets: UIEdgeInsetsMake(8.0, 8.0, 20.0, 8.0)
							xAxisValueFormatter: chartView.xAxis.valueFormatter];
	marker.chartView = chartView;
	marker.minimumSize = CGSizeMake(80.f, 40.f);
	chartView.marker = marker;
	
	[chartView animateWithXAxisDuration:2.0 yAxisDuration:3.0];
	
	
}

- (void)setupCell:(UITableViewCell *)cell{
	
	CALayer *topBorder = [CALayer layer];
	topBorder.borderColor = [UIColor lightGrayColor].CGColor;
	topBorder.borderWidth = 1;
	topBorder.frame = CGRectMake(0, 0, CGRectGetWidth(cell.contentView.frame)*2, 1);
	
	CALayer *bottomBorder = [CALayer layer];
	bottomBorder.borderColor = [UIColor lightGrayColor].CGColor;
	bottomBorder.borderWidth = 1;
	bottomBorder.frame = CGRectMake(0, 99, CGRectGetWidth(cell.contentView.frame)*2, 1);
	
	[cell.contentView.layer addSublayer:topBorder];
	[cell.contentView.layer addSublayer:bottomBorder];
	
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
	CGFloat width = 130;
	CGFloat height = 40;
	CGRect frame = CGRectMake(vc.view.frame.size.width - width, -height * numButtons, width, height * numButtons);
	UIView *menu = [[UIView alloc] initWithFrame:frame];
	menu.backgroundColor = [UIColor charcoalColor];
	menu.layer.zPosition = 990;
	[vc.view addSubview:menu];
	vc.menu = menu;
	vc.menu.hidden = YES;
	
	vc.menu.layer.cornerRadius = 10;
	vc.menu.clipsToBounds = YES;

	return [self createButtons:vc num:numButtons type:type];
}


- (NSArray *)createButtons:(DropdownMenuController *)vc num:(int)numButtons type:(NSString *)type{
	CGFloat width = 130;

	NSMutableArray *buttons = [[NSMutableArray alloc] init];
	for(int i = 0; i < numButtons; i++){
		
		CGFloat height = 40;
		CGRect frame = CGRectMake(0, i*height, width, height);
		UIButton *button = [[UIButton alloc] initWithFrame:frame];
		button.layer.zPosition = 999;
		button.titleLabel.textColor = [UIColor whiteColor];
		button.titleLabel.font = [UIFont boldSystemFontOfSize:12];
		
		button.backgroundColor = [UIColor charcoalColor];
		
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
				case 2:
					[button setTitle:@"Animate" forState:UIControlStateNormal];
					[button addTarget:vc action:@selector(animate:) forControlEvents:UIControlEventTouchDown];
					break;
				case 3:
					[button setTitle:@"Save to Photos" forState:UIControlStateNormal];
					[button addTarget:vc action:@selector(saveToPhotos) forControlEvents:UIControlEventTouchDown];
					break;
					
			}
		}
		
		[buttons addObject:button];
		
		[vc.menu addSubview:button];
		
	}
	
	return buttons;
}


- (void)savePhotoWithChart:(BarChartView *)chartView andVC:(DropdownMenuController *)vc{
	
	self.dropDownVC = vc;
	UIImageWriteToSavedPhotosAlbum([chartView getChartImageWithTransparent:NO], self, @selector(thisImage:hasBeenSavedInPhotoAlbumWithError:usingContextInfo:), nil);
	[vc hideMenu];
	
}

- (void)thisImage:(UIImage *)image hasBeenSavedInPhotoAlbumWithError:(NSError *)error usingContextInfo:(void*)ctxInfo {
	if (error) {
		[self alertWithMessage:@"Unable to save image." andTitle:@"Error" andVC:self.dropDownVC];
	} else {
		[self alertWithMessage:@"Image saved!" andTitle:@"Success" andVC:self.dropDownVC];
	}
}

// alert
- (SCLAlertView *)alertWithMessage:(NSString *)message andTitle:(NSString *)title andVC:(UIViewController *)vc{
    
    UIColor *green = [UIColor lightGreenColor];
    
    SCLAlertViewBuilder *builder = [SCLAlertViewBuilder new]
    .addButtonWithActionBlock(@"Load Transactions", ^{  })
    .customViewColor(green);
	
	
    SCLAlertViewShowBuilder *showBuilder = [SCLAlertViewShowBuilder new]
    .title(title)
    .subTitle(message)
	.duration(0);
	
	if([title isEqualToString:@"Sucess"]){
		showBuilder.style(SCLAlertViewStyleSuccess);
	}
	else{
		showBuilder.style(SCLAlertViewStyleNotice);
	}
	
    [showBuilder showAlertView:builder.alertView onViewController:vc];
 
	return builder.alertView;
}


@end

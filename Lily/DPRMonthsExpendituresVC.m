//
//  DPRMonthsExpendituresVC.m
//  Lily
//
//  Created by David Richardson on 10/26/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import "DPRMonthsExpendituresVC.h"
#import "UIColor+CustomColors.h"
#import "DPRTransaction.h"
#import "DPRUser.h"
#import "DPRTarget.h"
#import "DPRUIHelper.h"
#import "DPRCoreDataHelper.h"
#import "DPRTransactionSingleton.h"
#import <Lily-Bridging-Header.h>

@interface DPRMonthsExpendituresVC () <ChartViewDelegate, IChartAxisValueFormatter>

@property (strong, nonatomic) DPRCoreDataHelper *cdHelper;
@property (strong, nonatomic) DPRUser *user;
@property (strong, nonatomic) DPRUIHelper *uiHelper;
@property (strong, nonatomic) NSArray *transactionsByMonth;
@property (strong, nonatomic) NSArray *months;
@property (strong, nonatomic) NSArray *sortedKeys;
@property (strong, nonatomic) NSArray *buttonList;

@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet BarChartView *barChartView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@end

@implementation DPRMonthsExpendituresVC{
    NSInteger currMonth;
    NSInteger currYear;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self setupData];
    [self setupUI];
    [self setDataCount];
    [self setupChart];
	
}

- (void)setupData{
	
	self.cdHelper = [DPRCoreDataHelper sharedModel];
	self.user = [self.cdHelper fetchUser];
	DPRTransactionSingleton *transactionSingleton = [DPRTransactionSingleton sharedModel];
	self.transactionsByMonth = transactionSingleton.transactionsByMonth;
	
	NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
	currMonth = [components month];
	currYear = [components year];
	
	self.months = @[@"Jan", @"Feb", @"Mar",
					@"Apr", @"May", @"Jun",
					@"Jul", @"Aug", @"Sep",
					@"Oct", @"Nov", @"Dec"
					];
	
	
	// sorted keys
	NSMutableArray *arr = [[NSMutableArray alloc] init];
	for(int i = 11; i >= 0; i--){
		NSInteger index = currMonth - i - 1;
		if(index < 0){
			index += 12;
		}
		[arr addObject:[NSNumber numberWithInteger:index]];
	}
	_sortedKeys = arr;
	
	
}

- (void)setDataCount
{

    NSMutableArray *dataEntries = [[NSMutableArray alloc] init];
	
    // insert friends data
    for (NSInteger i = 0; i < 12; i++)
    {
		NSNumber *index = _sortedKeys[i];
        NSDictionary *monthDict = self.transactionsByMonth[index.integerValue];
        NSNumber *sent = [monthDict objectForKey:@"sent"];
        [dataEntries addObject:[[BarChartDataEntry alloc] initWithX:i y:sent.integerValue]];
    }
    
    BarChartDataSet *set1 = [[BarChartDataSet alloc] initWithValues:dataEntries label:@"Months"];
    [set1 setColors:ChartColorTemplates.material];
    
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:set1];
    
    BarChartData *data = [[BarChartData alloc] initWithDataSets:dataSets];
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:11.f]];
	UIColor *red = [UIColor colorWithRed:211/255.f green:74/255.f blue:88/255.f alpha:1.f];
	[data setValueTextColor:red];
	
    NSNumberFormatter *axisFormatter = [[NSNumberFormatter alloc] init];
    axisFormatter.maximumFractionDigits = 0;
    axisFormatter.positivePrefix = @"$";
	[data setValueFormatter:[[ChartDefaultValueFormatter alloc] initWithFormatter:axisFormatter]];
    
    data.barWidth = 0.9f;
    
    _barChartView.data = data;
	
}


- (void)setupUI{
    
    self.title = @"Monthly";
    self.labelTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    
    self.view.backgroundColor = [UIColor darkColor];
    self.barChartView.backgroundColor = [UIColor darkColor];
    self.topView.backgroundColor = [UIColor darkColor];
    
    self.uiHelper = [[DPRUIHelper alloc] init];
    [self.uiHelper setupBarChartView:_barChartView withTitle:@"Monthly"];
    
    NSString *title;
    if(currMonth == 12){
        title = [NSString stringWithFormat:@"Expenditures (%ld)", currYear];
    }
    else{
        title = [NSString stringWithFormat:@"Expenditures (%ld - %ld)", (currYear - 1), currYear];
    }
    self.labelTitle.text = title;
	
	// add button
	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(menuShow)];
	self.navigationItem.rightBarButtonItem = addButton;
	
	self.buttonList = [_uiHelper createMenuWithVC:self andNumButtons:2 andType:@"months"];
	
}

- (void)sortByDate:(UIButton *)sender{
	// sorted keys
	NSMutableArray *arr = [[NSMutableArray alloc] init];
	for(int i = 11; i >= 0; i--){
		NSInteger index = currMonth - i - 1;
		if(index < 0){
			index += 12;
		}
		[arr addObject:[NSNumber numberWithInteger:index]];
	}
	_sortedKeys = arr;
	
	[self reloadWithSender:sender];

}

- (void)sortByValue:(UIButton *)sender{
	NSSortDescriptor *sortByKey = [NSSortDescriptor sortDescriptorWithKey:@"sent"
																ascending:NO];
	NSArray *sortDescriptors = [NSArray arrayWithObject:sortByKey];
	NSArray *sortedDictionaries = [_transactionsByMonth sortedArrayUsingDescriptors:sortDescriptors];
	NSMutableArray *mutable = [[NSMutableArray alloc] init];
	for(NSDictionary *dict in sortedDictionaries){
		NSNumber *month = [dict objectForKey:@"month"];
		[mutable addObject:month];
	}
	
	_sortedKeys = mutable;
	
	[self reloadWithSender:sender];
	
}

- (void)reloadWithSender:(UIButton *)sender{
	
	// hide menu
	for(UIButton *button in _buttonList){
		button.backgroundColor = [UIColor darkishColor];
	}
	sender.backgroundColor = [UIColor lightGreenColor];
	[self toggleMenu];
	
	// update data
	[self setDataCount];
	[_barChartView animateWithXAxisDuration:ANIMATE_DURATION yAxisDuration:ANIMATE_DURATION];
	
}

- (void)menuShow{
	
	[self toggleMenu];
	
}




- (void)setupChart{
	
	_barChartView.delegate = self;
	
	_barChartView.drawBarShadowEnabled = NO;
	_barChartView.drawValueAboveBarEnabled = YES;
	_barChartView.maxVisibleCount = 60;
	_barChartView.drawBordersEnabled = YES;
	_barChartView.borderLineWidth = 1;
	_barChartView.borderColor = [UIColor darkGrayColor];
	
	
	NSNumberFormatter *axisFormatter = [[NSNumberFormatter alloc] init];
	axisFormatter.minimumFractionDigits = 0;
	axisFormatter.maximumFractionDigits = 1;
	axisFormatter.positivePrefix = @"$";
	
	ChartXAxis *xAxis = _barChartView.xAxis;
	xAxis.labelPosition = XAxisLabelPositionBottom;
	xAxis.labelFont = [UIFont systemFontOfSize:11.f];
	xAxis.drawGridLinesEnabled = YES;
	xAxis.granularity = 1.0;
	xAxis.labelCount = 5;
	xAxis.valueFormatter = self;
	
	ChartYAxis *leftAxis = _barChartView.leftAxis;
	leftAxis.labelFont = [UIFont systemFontOfSize:10.f];
	leftAxis.labelCount = 10;
	leftAxis.valueFormatter = [[ChartDefaultAxisValueFormatter alloc] initWithFormatter:axisFormatter];
	leftAxis.labelPosition = YAxisLabelPositionOutsideChart;
	leftAxis.spaceTop = 0.15;
	leftAxis.axisMinimum = 0.0; // this replaces startAtZero = YES
	
	ChartYAxis *rightAxis = _barChartView.rightAxis;
	rightAxis.enabled = YES;
	rightAxis.drawGridLinesEnabled = NO;
	rightAxis.labelFont = [UIFont systemFontOfSize:10.f];
	rightAxis.labelCount = 10;
	rightAxis.valueFormatter = leftAxis.valueFormatter;
	rightAxis.spaceTop = 0.15;
	rightAxis.axisMinimum = 0.0; // this replaces startAtZero = YES
	
	ChartLegend *l = _barChartView.legend;
	l.textColor = [UIColor whiteColor];
	l.horizontalAlignment = ChartLegendHorizontalAlignmentLeft;
	l.verticalAlignment = ChartLegendVerticalAlignmentBottom;
	l.orientation = ChartLegendOrientationHorizontal;
	l.drawInside = NO;
	l.form = ChartLegendFormSquare;
	l.formSize = 9.0;
	l.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11.f];
	l.xEntrySpace = 4.0;
	
	XYMarkerView *marker = [[XYMarkerView alloc]
							initWithColor: [UIColor colorWithWhite:180/255. alpha:1.0]
							font: [UIFont systemFontOfSize:12.0]
							textColor: UIColor.whiteColor
							insets: UIEdgeInsetsMake(8.0, 8.0, 20.0, 8.0)
							xAxisValueFormatter: _barChartView.xAxis.valueFormatter];
	marker.chartView = _barChartView;
	marker.minimumSize = CGSizeMake(80.f, 40.f);
	_barChartView.marker = marker;
	
	[_barChartView animateWithXAxisDuration:2.0 yAxisDuration:2.0];
}

- (NSString *)stringForValue:(double)value
                        axis:(ChartAxisBase *)axis{
	
	NSNumber *index = _sortedKeys[(int)value];
    return self.months[index.integerValue];
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

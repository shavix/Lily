//
//  DPRFriendsGraphVC.m
//  Lily
//
//  Created by David Richardson on 10/24/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import "DPRFriendsTransactionsVC.h"
#import "UIColor+CustomColors.h"
#import "DPRTransaction.h"
#import "DPRUser.h"
#import "DPRTarget.h"
#import "DPRUIHelper.h"
#import "DPRCoreDataHelper.h"
#import <Lily-Bridging-Header.h>


@interface DPRFriendsTransactionsVC () <ChartViewDelegate, IChartAxisValueFormatter>

@property (strong, nonatomic) DPRCoreDataHelper *cdHelper;
@property (strong, nonatomic) DPRUser *user;
@property (strong, nonatomic) DPRUIHelper *uiHelper;

@property (strong, nonatomic) NSDictionary *transactionsByFriends;
@property (strong, nonatomic) NSDictionary *dataList;
@property (strong, nonatomic) NSArray *sortedKeys;
@property (strong, nonatomic) NSArray *buttonList;
@property (weak, nonatomic) IBOutlet BarChartView *barChartView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;


@end

@implementation DPRFriendsTransactionsVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setupUI];
    [self setupData];
    [self setupGraph];
    [self setDataCount];

}

- (void)setDataCount
{
    NSMutableArray *dataEntries = [[NSMutableArray alloc] init];
	
	for(int i = 0; i < _sortedKeys.count; i++){
		NSString *name = _sortedKeys[i];
		NSDictionary *transaction = [_dataList objectForKey:name];
		NSNumber *numTransactions = [transaction objectForKey:@"transactions"];
		[dataEntries addObject:[[BarChartDataEntry alloc] initWithX:i y:numTransactions.integerValue]];
	}
	
    BarChartDataSet *set1 = [[BarChartDataSet alloc] initWithValues:dataEntries label:@"Friends"];
    
    [set1 setColors:ChartColorTemplates.many];
    
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:set1];
    
    BarChartData *data = [[BarChartData alloc] initWithDataSets:dataSets];
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:10.f]];
    [data setValueTextColor:[UIColor whiteColor]];
    
    NSNumberFormatter *axisFormatter = [[NSNumberFormatter alloc] init];
    axisFormatter.maximumFractionDigits = 0;
    [data setValueFormatter:[[ChartDefaultValueFormatter alloc] initWithFormatter:axisFormatter]];
    
    data.barWidth = 0.9f;
    
    _barChartView.data = data;

}


- (void)setupData{
    
    self.cdHelper = [DPRCoreDataHelper sharedModel];
    self.user = [self.cdHelper fetchUser];
    self.transactionsByFriends = [self.cdHelper setupTransactionsByFriendsWithUser:self.user];
	
	// sorted keys
	NSMutableArray *tempArr = [[NSMutableArray alloc] init];
	for(id key in self.transactionsByFriends){
		[tempArr addObject:key];
	}
	_sortedKeys = tempArr;
	
	NSMutableDictionary *temp = [[NSMutableDictionary alloc] init];
	
	int index = 0;
	// insert friends data
	for(id name in _transactionsByFriends)
	{
		
		NSDictionary *friend = [_transactionsByFriends objectForKey:name];
		
		NSString *title = name;
		NSArray *arr = [title componentsSeparatedByString:@" "];
		NSString *firstName = arr[0];
		NSString *newName;
		
		if(arr.count > 1){
			NSString *lastName = arr[1];
			NSString *initial = [NSString stringWithFormat:@"%c.", [lastName characterAtIndex:0]];
			newName = [NSString stringWithFormat:@"%@ %@", firstName, initial];
		}
		else {
			newName = firstName;
		}
		
		NSNumber *transactions = [friend objectForKey:@"transactions"];
		
		NSDictionary *info = @{@"xValue":@(index++),
						   @"transactions":transactions,
						   @"name":newName};
		[temp setObject:info forKey:name];
		
	}
	
	self.dataList = temp;
	
}

- (void)setupUI{
    
    self.title = @"Friends";
    self.labelTitle.text = @"Number of Transactions";
    self.labelTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];

    self.view.backgroundColor = [UIColor darkColor];
    self.barChartView.backgroundColor = [UIColor darkColor];
    self.topView.backgroundColor = [UIColor darkColor];
    
    self.uiHelper = [[DPRUIHelper alloc] init];
    [self.uiHelper setupBarChartView:_barChartView withTitle:@"Friends"];
	
	// add button
	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(menuShow)];
	self.navigationItem.rightBarButtonItem = addButton;
	
	self.buttonList = [_uiHelper createMenuWithVC:self andNumButtons:2 andType:@"friends"];

	
}

- (void)menuShow{
	
	[self toggleMenu];
	
}

- (void)sortByName:(UIButton *)sender{
	
	NSArray *keys = [self.transactionsByFriends allKeys];
	NSArray *sortedKeys = [keys sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
		return [a compare:b];
	}];
	
	_sortedKeys = sortedKeys;
	[self reloadWithSender:sender];
	
}

- (void)sortByValue:(UIButton *)sender{
	NSArray *keys = [self.transactionsByFriends allKeys];
	NSArray *sortedKeys = [keys sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
		
		NSDictionary *first = [self.dataList objectForKey:a];
		NSDictionary *second = [self.dataList objectForKey:b];
		
		NSNumber *aTransactions = [first objectForKey:@"transactions"];
		NSNumber *bTransactions = [second objectForKey:@"transactions"];
		
		return [bTransactions compare:aTransactions];
	}];
	
	_sortedKeys = sortedKeys;
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


- (void)setupGraph{
	
	_barChartView.delegate = self;
	
	_barChartView.drawBarShadowEnabled = NO;
	_barChartView.drawValueAboveBarEnabled = YES;
	_barChartView.maxVisibleCount = 60;
	_barChartView.drawBordersEnabled = YES;
	_barChartView.borderLineWidth = 1;
	_barChartView.borderColor = [UIColor darkGrayColor];
	
	ChartXAxis *xAxis = _barChartView.xAxis;
	xAxis.labelPosition = XAxisLabelPositionBottom;
	xAxis.labelFont = [UIFont systemFontOfSize:11.f];
	xAxis.drawGridLinesEnabled = YES;
	xAxis.granularity = 1.0;
	xAxis.labelCount = 5;
	xAxis.valueFormatter = self;
	
	NSNumberFormatter *leftAxisFormatter = [[NSNumberFormatter alloc] init];
	
	ChartYAxis *leftAxis = _barChartView.leftAxis;
	leftAxis.labelFont = [UIFont systemFontOfSize:10.f];
	leftAxis.labelCount = 10;
	leftAxis.valueFormatter = [[ChartDefaultAxisValueFormatter alloc] initWithFormatter:leftAxisFormatter];
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

- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry highlight:(ChartHighlight * __nonnull)highlight
{
    NSLog(@"chartValueSelected");
}

- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
{
    NSLog(@"chartValueNothingSelected");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)stringForValue:(double)value
						axis:(ChartAxisBase *)axis
{
	NSString *name = _sortedKeys[(int)value];
	return [[_dataList objectForKey:name] objectForKey:@"name"];
}


@end

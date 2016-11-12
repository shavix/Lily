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
#import "xAxisValueFormatter.h"
#import <Lily-Bridging-Header.h>


@interface DPRFriendsTransactionsVC () <ChartViewDelegate>

@property (strong, nonatomic) DPRCoreDataHelper *cdHelper;
@property (strong, nonatomic) DPRUser *user;
@property (strong, nonatomic) DPRUIHelper *uiHelper;

@property (strong, nonatomic) NSArray *transactionsByFriends;
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
    
    NSInteger numFriends = self.transactionsByFriends.count;
    
    // insert friends data
    for (int i = 0; i < numFriends; i++)
    {
        NSArray *transactionsArray = self.transactionsByFriends[i];
        NSInteger numTransactions = transactionsArray.count;
        [dataEntries addObject:[[BarChartDataEntry alloc] initWithX:i y:numTransactions]];
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
    xAxis.valueFormatter = [[xAxisValueFormatter alloc] initForChart:_barChartView andArray:self.transactionsByFriends];
    
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

- (void)setupData{
    
    self.cdHelper = [DPRCoreDataHelper sharedModel];
    self.user = [self.cdHelper fetchUser];
    self.transactionsByFriends = [self.cdHelper setupTransactionsByFriendsWithUser:self.user];
    
}

- (void)setupUI{
    
    self.title = @"Friends";
    self.titleLabel.text = @"Number of Transactions";
    self.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];

    self.view.backgroundColor = [UIColor darkColor];
    self.barChartView.backgroundColor = [UIColor darkColor];
    self.topView.backgroundColor = [UIColor darkColor];
    
    self.uiHelper = [[DPRUIHelper alloc] init];
    [self.uiHelper setupBarChartView:_barChartView withTitle:@"Friends"];
	
	// add button
	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(menuShow)];
	self.navigationItem.rightBarButtonItem = addButton;
	
	[_uiHelper createMenuWithVC:self andNumButtons:2 andType:@"friends"];

	
}

- (void)menuShow{
	
	[self toggleMenu];
	
}

- (void)sortByName:(UIButton *)sender{
	
}

- (void)sortByValue:(UIButton *)sender{
	
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


@end

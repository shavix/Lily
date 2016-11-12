//
//  DPRFriendsNetIncomeVC.m
//  Lily
//
//  Created by David Richardson on 10/25/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import "DPRFriendsNetIncomeVC.h"
#import "UIColor+CustomColors.h"
#import "DPRTransaction.h"
#import "DPRUser.h"
#import "DPRTarget.h"
#import "DPRUIHelper.h"
#import "DPRCoreDataHelper.h"
#import "xAxisValueFormatter.h"
#import <Lily-Bridging-Header.h>

@interface DPRFriendsNetIncomeVC () <ChartViewDelegate, IChartAxisValueFormatter>

@property (strong, nonatomic) DPRCoreDataHelper *cdHelper;
@property (strong, nonatomic) DPRUser *user;
@property (strong, nonatomic) DPRUIHelper *uiHelper;

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet BarChartView *barChartView;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;

@property (strong, nonatomic) NSArray *transactionsByFriends;
@property (strong, nonatomic) NSMutableArray *dataList;

@end

@implementation DPRFriendsNetIncomeVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setupUI];
    [self setupData];
    [self setDataCount];
    [self setupChart];
    
}

- (void)setDataCount
{
    self.dataList = [[NSMutableArray alloc] init];
    int i = 0;
    // iterate through friends
    for(NSArray *currArr in _transactionsByFriends){
        
        double amountSent = 0;
        double amountReceived = 0;
        
        // iterate through transactions
        for(DPRTransaction *transaction in currArr){
            
            NSNumber *amount = transaction.amount;
            
            if(transaction.isIncoming){
                amountReceived += amount.doubleValue;
            }
            else{
                amountSent += amount.doubleValue;
            }
            
        }
        
        double netIncome = amountReceived - amountSent;
        
        DPRTransaction *transaction = currArr[0];
        
        NSString *title = transaction.target.fullName;
        NSArray *arr = [title componentsSeparatedByString:@" "];
        NSString *firstName = arr[0];
        NSString *name;
        
        if(arr.count > 1){
            NSString *lastName = arr[1];
            NSString *initial = [NSString stringWithFormat:@"%c.", [lastName characterAtIndex:0]];
            name = [NSString stringWithFormat:@"%@ %@", firstName, initial];
        }
        else {
            name = firstName;
        }
        
        [_dataList addObject:@{@"xValue":@(i),
                             @"yValue":@(netIncome),
                              @"xLabel":name}];
                                 
         i++;
        
    }
    
    NSMutableArray<BarChartDataEntry *> *values = [[NSMutableArray alloc] init];
    NSMutableArray<UIColor *> *colors = [[NSMutableArray alloc] init];
    
    UIColor *green = [UIColor colorWithRed:110/255.f green:190/255.f blue:102/255.f alpha:1.f];
    UIColor *red = [UIColor colorWithRed:211/255.f green:74/255.f blue:88/255.f alpha:1.f];
    NSInteger count = _dataList.count;
    
    for (int i = 0; i < count; i++)
    {
        NSDictionary *d = _dataList[i];
        BarChartDataEntry *entry = [[BarChartDataEntry alloc] initWithX:[d[@"xValue"] doubleValue] y:[d[@"yValue"] doubleValue]];
        [values addObject:entry];
        
        // specific colors
        if ([d[@"yValue"] doubleValue] <= 0.f)
        {
            [colors addObject:red];
        }
        else
        {
            [colors addObject:green];
        }
    }
    
    BarChartDataSet *set = set = [[BarChartDataSet alloc] initWithValues:values label:@"Values"];
    set.colors = colors;
    set.valueColors = colors;
    
    BarChartData *data = [[BarChartData alloc] initWithDataSet:set];
    [data setValueFont:[UIFont systemFontOfSize:11.f]];
    
    NSNumberFormatter *axisFormatter = [[NSNumberFormatter alloc] init];
    axisFormatter.maximumFractionDigits = 0;
    axisFormatter.negativePrefix = @"-$";
    axisFormatter.positivePrefix = @"$";
    [data setValueFormatter:[[ChartDefaultValueFormatter alloc] initWithFormatter:axisFormatter]];
    
    data.barWidth = 0.8;
    
    _barChartView.data = data;

}

- (void)setupChart{
    
    _barChartView.delegate = self;

    _barChartView.drawBarShadowEnabled = NO;
    _barChartView.drawValueAboveBarEnabled = YES;
    _barChartView.chartDescription.enabled = NO;
    _barChartView.pinchZoomEnabled = NO;
    _barChartView.drawGridBackgroundEnabled = NO;
    _barChartView.rightAxis.enabled = YES;
    _barChartView.legend.enabled = NO;
    
    _barChartView.drawBordersEnabled = YES;
    _barChartView.borderLineWidth = 1;
    _barChartView.borderColor = [UIColor darkGrayColor];
    
    NSNumberFormatter *axisFormatter = [[NSNumberFormatter alloc] init];
    axisFormatter.minimumFractionDigits = 0;
    axisFormatter.maximumFractionDigits = 1;
    axisFormatter.negativePrefix = @"-$";
    axisFormatter.positivePrefix = @"$";
    
    ChartXAxis *xAxis = _barChartView.xAxis;
    xAxis.labelPosition = XAxisLabelPositionBottom;
    xAxis.labelFont = [UIFont systemFontOfSize:11.f];
    xAxis.drawGridLinesEnabled = YES;
    xAxis.drawAxisLineEnabled = YES;
    xAxis.labelTextColor = [UIColor whiteColor];
    xAxis.granularity = 1.0;
    xAxis.valueFormatter = self;
    xAxis.labelCount = 5;
    
    ChartYAxis *leftAxis = _barChartView.leftAxis;
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
    
    ChartYAxis *rightAxis = _barChartView.rightAxis;
    rightAxis.drawLabelsEnabled = YES;
    rightAxis.labelCount = 10;
    rightAxis.spaceTop = 0.25;
    rightAxis.spaceBottom = 0.25;
    rightAxis.drawAxisLineEnabled = YES;
    rightAxis.drawGridLinesEnabled = YES;
    rightAxis.drawZeroLineEnabled = YES;
    rightAxis.zeroLineColor = UIColor.whiteColor;
    rightAxis.zeroLineWidth = 0.7f;
    rightAxis.valueFormatter = [[ChartDefaultAxisValueFormatter alloc] initWithFormatter:axisFormatter];
    
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
    self.labelTitle.text = @"Net Income";
    self.labelTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)stringForValue:(double)value
                        axis:(ChartAxisBase *)axis
{
    if(value < 0){
        return nil;
    }
    return _dataList[MIN(MAX((int) value, 0), _dataList.count - 1)][@"xLabel"];
}


@end

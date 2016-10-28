//
//  DPRMonthsNetIncomeVC.m
//  Lily
//
//  Created by David Richardson on 10/27/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import "DPRMonthsNetIncomeVC.h"
#import "UIColor+CustomColors.h"
#import "DPRTransaction.h"
#import "DPRUser.h"
#import "DPRTarget.h"
#import "DPRUIHelper.h"
#import "DPRCoreDataHelper.h"
#import "DPRTransactionSingleton.h"
#import <Lily-Bridging-Header.h>

@interface DPRMonthsNetIncomeVC () <ChartViewDelegate, IChartAxisValueFormatter>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet BarChartView *barChartView;
@property (weak, nonatomic) IBOutlet UIView *topView;

@property (strong, nonatomic) DPRCoreDataHelper *cdHelper;
@property (strong, nonatomic) DPRUser *user;
@property (strong, nonatomic) DPRUIHelper *uiHelper;
@property (strong, nonatomic) NSArray *transactionsByMonth;
@property (strong, nonatomic) NSMutableArray *months;

@end

@implementation DPRMonthsNetIncomeVC{
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

- (void)setDataCount
{
    
    NSMutableArray<BarChartDataEntry *> *values = [[NSMutableArray alloc] init];
    NSMutableArray<UIColor *> *colors = [[NSMutableArray alloc] init];
    
    UIColor *green = [UIColor colorWithRed:110/255.f green:190/255.f blue:102/255.f alpha:1.f];
    UIColor *red = [UIColor colorWithRed:211/255.f green:74/255.f blue:88/255.f alpha:1.f];
    NSInteger numMonths = 12;
    NSInteger index2 = 0;
    
    // insert friends data
    for (NSInteger i = currMonth; i < numMonths + currMonth; i++)
    {
        NSInteger index = i;
        if(index >= numMonths){
            index -= 12;
        }
        NSDictionary *monthDict = self.transactionsByMonth[index];
        NSNumber *netIncome = [monthDict objectForKey:@"netIncome"];
        [values addObject:[[BarChartDataEntry alloc] initWithX:index2++ y:netIncome.integerValue]];
        
        // specific colors
        if ([netIncome doubleValue] < 0.f)
        {
            [colors addObject:red];
        }
        else if([netIncome doubleValue] == 0.f){
            [colors addObject:[UIColor whiteColor]];
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
    
    data.barWidth = 0.9f;
    
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

}

- (void)setupData{
    
    self.cdHelper = [DPRCoreDataHelper sharedModel];
    self.user = [self.cdHelper fetchUser];
    DPRTransactionSingleton *transactionSingleton = [DPRTransactionSingleton sharedModel];
    self.transactionsByMonth = transactionSingleton.transactionsByMonth;
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    currMonth = [components month];
    currYear = [components year];
    
    NSArray *months = @[
                        @"Jan", @"Feb", @"Mar",
                        @"Apr", @"May", @"Jun",
                        @"Jul", @"Aug", @"Sep",
                        @"Oct", @"Nov", @"Dec"
                        ];
    self.months = [[NSMutableArray alloc] init];
    
    for (NSInteger i = currMonth; i < 12 + currMonth; i++){
        NSInteger index = i;
        if(index >= 12){
            index -= 12;
        }
        [self.months addObject:months[index]];
    }
    
}

- (void)setupUI{
    
    self.title = @"Monthly";
    self.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    
    self.view.backgroundColor = [UIColor darkColor];
    self.barChartView.backgroundColor = [UIColor darkColor];
    self.topView.backgroundColor = [UIColor darkColor];
    
    self.uiHelper = [[DPRUIHelper alloc] init];
    [self.uiHelper setupBarChartView:_barChartView withTitle:@"Monthly"];
    
    NSString *title;
    if(currMonth == 12){
        title = [NSString stringWithFormat:@"Net Income (%ld)", currYear];
    }
    else{
        title = [NSString stringWithFormat:@"Net Income (%ld - %ld)", (currYear - 1), currYear];
    }
    self.titleLabel.text = title;
    
}

- (NSString *)stringForValue:(double)value
                        axis:(ChartAxisBase *)axis{
    
    return self.months[(int)value];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
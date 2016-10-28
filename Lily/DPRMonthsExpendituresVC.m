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
@property (strong, nonatomic) NSMutableArray *months;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
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

- (void)setDataCount
{

    NSMutableArray *dataEntries = [[NSMutableArray alloc] init];
    
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
        NSNumber *sent = [monthDict objectForKey:@"sent"];
        [dataEntries addObject:[[BarChartDataEntry alloc] initWithX:index2++ y:sent.integerValue]];
    }
    
    BarChartDataSet *set1 = [[BarChartDataSet alloc] initWithValues:dataEntries label:@"Months"];
    [set1 setColors:ChartColorTemplates.material];
    
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:set1];
    
    BarChartData *data = [[BarChartData alloc] initWithDataSets:dataSets];
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:11.f]];
    [data setValueTextColor:[UIColor whiteColor]];
    
    NSNumberFormatter *axisFormatter = [[NSNumberFormatter alloc] init];
    axisFormatter.maximumFractionDigits = 0;
    axisFormatter.positivePrefix = @"$";
    [data setValueFormatter:[[ChartDefaultValueFormatter alloc] initWithFormatter:axisFormatter]];
    
    data.barWidth = 0.9f;
    
    _barChartView.data = data;
    
}

- (void)setupChart{
    
    _barChartView.delegate = self;
    
    _barChartView.drawBarShadowEnabled = NO;
    _barChartView.drawValueAboveBarEnabled = YES;
    _barChartView.maxVisibleCount = 60;
    
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
        title = [NSString stringWithFormat:@"Expenditures (%ld)", currYear];
    }
    else{
        title = [NSString stringWithFormat:@"Expenditures (%ld - %ld)", (currYear - 1), currYear];
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



@end

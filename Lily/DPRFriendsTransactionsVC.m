//
//  DPRGraphVC.m
//  Lily
//
//  Created by David Richardson on 10/21/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import "DPRFriendsTransactionsVC.h"
#import "UIColor+CustomColors.h"
#import "DPRTransactionSingleton.h"
#import "DPRTransaction.h"
#import "DPRUser.h"
#import "DPRTarget.h"
#import "DPRUIHelper.h"
#import "DPRCoreDataHelper.h"

@interface DPRFriendsTransactionsVC () <ChartViewDelegate>

@property (strong, nonatomic) DPRTransactionSingleton *transactionSingleton;
@property (strong, nonatomic) DPRCoreDataHelper *cdHelper;
@property (strong, nonatomic) DPRUser *user;
@property (strong, nonatomic) DPRUIHelper *uiHelper;

@property (strong, nonatomic) NSArray *transactionsByFriends;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet PieChartView *pieChartView;

@end

@implementation DPRFriendsTransactionsVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setupUI];
    [self setupData];
    [self setupGraph];
    
}

- (void)setupGraph{
    
    
    self.pieChartView.legend.enabled = NO;
    self.pieChartView.delegate = self;
    [self.pieChartView setExtraOffsetsWithLeft:20.f top:0.f right:20.f bottom:0.f];

    [self.pieChartView animateWithYAxisDuration:1.4 easingOption:ChartEasingOptionEaseOutBack];
    
    [self updateChartData];
    
}

- (void)updateChartData
{
    [self setDataCount:10 range:10];
}

- (void)setDataCount:(int)count range:(double)range
{    
    NSMutableArray *entries = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++)
    {
        DPRTransaction *transaction = _transactionsByFriends[i][0];
        NSArray *friendsArray = _transactionsByFriends[i];
        [entries addObject:[[PieChartDataEntry alloc] initWithValue:friendsArray.count label:transaction.target.fullName]];
    }
    
    PieChartDataSet *dataSet = [[PieChartDataSet alloc] initWithValues:entries label:@"Friends by transactions"];
    dataSet.sliceSpace = 2.0;
    
    // add a lot of colors
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    [colors addObjectsFromArray:[UIColor palet]];
    
    dataSet.colors = colors;
    
    dataSet.valueLinePart1OffsetPercentage = 1;
    dataSet.valueLinePart1Length = 0.7;
    dataSet.valueLinePart2Length = 0.3;
    dataSet.valueLineColor = [UIColor whiteColor];
    //dataSet.xValuePosition = PieChartValuePositionOutsideSlice;
    dataSet.yValuePosition = PieChartValuePositionOutsideSlice;
    
    PieChartData *data = [[PieChartData alloc] initWithDataSet:dataSet];
    
    NSNumberFormatter *pFormatter = [[NSNumberFormatter alloc] init];
    pFormatter.numberStyle = NSNumberFormatterPercentStyle;
    pFormatter.maximumFractionDigits = 1;
    pFormatter.multiplier = @1.f;
    pFormatter.percentSymbol = @" %";
    [data setValueFormatter:[[ChartDefaultValueFormatter alloc] initWithFormatter:pFormatter]];
    [data setValueFont:[UIFont boldSystemFontOfSize:12.f]];
    [data setValueTextColor:UIColor.whiteColor];
    
    self.pieChartView.data = data;
    [self.pieChartView highlightValues:nil];

}

- (void)setupData{
    
    self.cdHelper = [DPRCoreDataHelper sharedModel];
    self.user = [self.cdHelper fetchUser];
    self.transactionsByFriends = [self.cdHelper setupTransactionsByFriendsWithUser:self.user];
    
}

- (void)setupUI{
    
    self.view.backgroundColor = [UIColor darkColor];
    self.mainView.backgroundColor = [UIColor darkColor];
    self.pieChartView.backgroundColor = [UIColor darkColor];
    
    self.uiHelper = [[DPRUIHelper alloc] init];
    [self.uiHelper setupPieChartView:self.pieChartView withTitle:@"Friends"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

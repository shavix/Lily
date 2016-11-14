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
#import "DPRChartHelper.h"
#import <Lily-Bridging-Header.h>

@interface DPRMonthsExpendituresVC () <ChartViewDelegate, IChartAxisValueFormatter>

@property (strong, nonatomic) DPRCoreDataHelper *cdHelper;
@property (strong, nonatomic) DPRUser *user;
@property (strong, nonatomic) DPRUIHelper *uiHelper;
@property (strong, nonatomic) DPRChartHelper *chartHelper;
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
    [self setupChartUI];
	
}

- (void)setupData{
	
	self.cdHelper = [DPRCoreDataHelper sharedModel];
	self.user = [self.cdHelper fetchUser];
	self.chartHelper = [[DPRChartHelper alloc] init];
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
	
}

- (void)setDataCount
{
	[_chartHelper dataCountWithKeys:_sortedKeys andDataList:_transactionsByMonth andChartView:_barChartView andType:@"expenditures"];
	
}


- (void)setupUI{
    
    self.title = @"This Year";
    self.labelTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    
    self.view.backgroundColor = [UIColor darkColor];
    self.barChartView.backgroundColor = [UIColor darkColor];
    self.topView.backgroundColor = [UIColor darkColor];
    
    self.uiHelper = [[DPRUIHelper alloc] init];
    [self.uiHelper setupBarChartView:_barChartView withTitle:@"This Year"];
    
    NSString *title;
    if(currMonth == 12){
        title = [NSString stringWithFormat:@"Expenditures (%ld)", (long)currYear];
    }
    else{
        title = [NSString stringWithFormat:@"Expenditures (%ld - %ld)", (currYear - 1), currYear];
    }
    self.labelTitle.text = title;
	
	// add button
	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(menuShow)];
	self.navigationItem.rightBarButtonItem = addButton;
	
	self.buttonList = [_uiHelper createMenuWithVC:self andNumButtons:3 andType:@"months"];
	
	
	// sorted keys
	[self sortByDate:_buttonList[0]];
	
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
	[self hideMenu];
	
	// update data
	[self setDataCount];
	[_barChartView animateWithXAxisDuration:ANIMATE_DURATION yAxisDuration:ANIMATE_DURATION];
	
}

- (void)menuShow{
	
	[self toggleMenu];
	
}

- (void)saveToPhotos{
	UIImageWriteToSavedPhotosAlbum([_barChartView getChartImageWithTransparent:NO], nil, nil, nil);
	[self hideMenu];
	[_uiHelper alertWithMessage:@"Photo saved!" andTitle:@"Success" andVC:self];
}


- (void)setupChartUI{
	
	[_uiHelper setupExpendituresChartView:_barChartView withVC:self];
}

- (NSString *)stringForValue:(double)value
                        axis:(ChartAxisBase *)axis{
	
	NSNumber *index = _sortedKeys[(int)value];

	NSString *month = self.months[index.integerValue];
	NSInteger year;
	NSString *title;
	// find which year to add
	if(index.integerValue >= currMonth){
		year = currYear-1;
	}
	else {
		year = currYear;
	}
	year -= 2000;
	title = [NSString stringWithFormat:@"%@ '%ld", month, (long)year];

	return title;
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

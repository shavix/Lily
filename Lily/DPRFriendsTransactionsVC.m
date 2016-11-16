//
//  DPRFriendsTransactionsVC.m
//  Lily
//
//  Created by David Richardson on 11/14/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import "DPRFriendsTransactionsVC.h"
#import "UIColor+CustomColors.h"
#import "DPRTransaction.h"
#import "DPRUser.h"
#import "DPRTarget.h"
#import "DPRUIHelper.h"
#import "DPRCoreDataHelper.h"
#import "DPRChartHelper.h"
#import <Lily-Bridging-Header.h>

@interface DPRFriendsTransactionsVC () <ChartViewDelegate, IChartAxisValueFormatter>

@property (strong, nonatomic) DPRCoreDataHelper *cdHelper;
@property (strong, nonatomic) DPRUser *user;
@property (strong, nonatomic) DPRUIHelper *uiHelper;
@property (strong, nonatomic) DPRChartHelper *chartHelper;

@property (strong, nonatomic) NSDictionary *transactionsByFriends;
@property (strong, nonatomic) NSDictionary *dataList;
@property (strong, nonatomic) NSArray *sortedKeys;
@property (strong, nonatomic) NSArray *buttonList;

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet BarChartView *barChartView;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;

@end

@implementation DPRFriendsTransactionsVC

- (void)viewDidLoad {
	
	[super viewDidLoad];
	[self setupUI];
	[self setupData];
	[self setDataCount];
	[self setupChartUI];
	
}


- (void)setupData{
	
	self.cdHelper = [DPRCoreDataHelper sharedModel];
	self.user = [self.cdHelper fetchUser];
	self.chartHelper = [[DPRChartHelper alloc] init];
	self.transactionsByFriends = [self.cdHelper setupTransactionsByFriendsWithUser:self.user];
	
	NSMutableDictionary *temp = [[NSMutableDictionary alloc] init];
	
	int index = 0;
	// insert friends data
	for(id name in _transactionsByFriends)
	{
		
		NSDictionary *friend = [_transactionsByFriends objectForKey:name];
		
		// setup name
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
	
	// sorted keys
	[self sortByValue:_buttonList[1]];
	
}


- (void)setDataCount
{
	[_chartHelper dataCountWithKeys:_sortedKeys andDataList:_dataList andChartView:_barChartView andType:@"transactions"];
}

- (void)setupUI{
	
	self.title = @"Friends";
	self.labelTitle.text = @"Transactions";
	self.labelTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
	
	self.view.backgroundColor = [UIColor darkColor];
	self.barChartView.backgroundColor = [UIColor darkColor];
	self.topView.backgroundColor = [UIColor darkColor];
	
	self.uiHelper = [[DPRUIHelper alloc] init];
	[self.uiHelper setupBarChartView:_barChartView withTitle:@"Friends"];
	
	// add button
	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(menuShow)];
	self.navigationItem.rightBarButtonItem = addButton;
	
	self.buttonList = [_uiHelper createMenuWithVC:self andNumButtons:3 andType:@"friends"];
	
	
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
	
	[_uiHelper refreshButtons:_buttonList withButton:sender andVC:self];

	// update data
	[self setDataCount];
	[_barChartView animateWithXAxisDuration:ANIMATE_DURATION_X yAxisDuration:ANIMATE_DURATION_Y];
	
}

- (void)saveToPhotos{
	UIImageWriteToSavedPhotosAlbum([_barChartView getChartImageWithTransparent:NO], nil, nil, nil);
	[self hideMenu];
	[_uiHelper alertWithMessage:@"Photo saved!" andTitle:@"Success" andVC:self];
}


- (void)setupChartUI{
	
	[_uiHelper setupChartView:_barChartView withVC:self andType:@"transactions"];
	
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

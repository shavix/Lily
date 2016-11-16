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
#import "DPRChartHelper.h"
#import <Lily-Bridging-Header.h>

@interface DPRFriendsNetIncomeVC () <ChartViewDelegate, IChartAxisValueFormatter>

@property (strong, nonatomic) DPRCoreDataHelper *cdHelper;
@property (strong, nonatomic) DPRUser *user;
@property (strong, nonatomic) DPRUIHelper *uiHelper;
@property (strong, nonatomic) DPRChartHelper *chartHelper;

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet BarChartView *barChartView;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;

@property (strong, nonatomic) NSDictionary *transactionsByFriends;
@property (strong, nonatomic) NSDictionary *dataList;
@property (strong, nonatomic) NSArray *sortedKeys;
@property (strong, nonatomic) NSArray *buttonList;

@end

@implementation DPRFriendsNetIncomeVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setupUI];
    [self setupData];
    [self setDataCount];
    [self setupChartUI];
    
}

- (void)setDataCount
{
	
	[_chartHelper dataCountWithKeys:_sortedKeys andDataList:_dataList andChartView:_barChartView andType:@"netIncome"];

}

- (void)setupData{
    
    self.cdHelper = [DPRCoreDataHelper sharedModel];
	self.chartHelper = [[DPRChartHelper alloc] init];
    self.user = [self.cdHelper fetchUser];
    self.transactionsByFriends = [self.cdHelper setupTransactionsByFriendsWithUser:self.user];
	
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
		
		NSNumber *netIncome = [friend objectForKey:@"netIncome"];
		
		NSDictionary *info = @{@"xValue":@(index++),
							   @"netIncome":netIncome,
							   @"name":newName};
		[temp setObject:info forKey:name];
		
	}
	
	self.dataList = temp;
	
	// sorted keys
	[self sortByValue:_buttonList[1]];
	
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
		
		NSNumber *aNetIncome = [first objectForKey:@"netIncome"];
		NSNumber *bNetIncome = [second objectForKey:@"netIncome"];
		
		return [bNetIncome compare:aNetIncome];
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
	
	[_uiHelper setupNetIncomeChartView:_barChartView withVC:self];
	
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

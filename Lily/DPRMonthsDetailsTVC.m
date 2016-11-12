//
//  DPRMonthsDetailsTVC.m
//  Lily
//
//  Created by David Richardson on 10/27/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import "DPRMonthsDetailsTVC.h"
#import "DPRCoreDataHelper.h"
#import "DPRUser.h"
#import "DPRFriendsListTableViewCell.h"
#import "DPRTransaction.h"
#import "DPRTarget.h"
#import "DPRTransactionSingleton.h"
#import "DPRMonthsDetailsTableViewCell.h"
#import "DPRUIHelper.h"
#import "UIColor+CustomColors.h"

@interface DPRMonthsDetailsTVC ()

@property (strong, nonatomic) DPRUser *user;
@property (strong, nonatomic) DPRCoreDataHelper *cdHelper;
@property (strong, nonatomic) DPRTransactionSingleton *transactionSingleton;
@property (strong, nonatomic) NSArray *transactionsByMonth;
@property (strong, nonatomic) NSDictionary *friendsData;
@property (strong, nonatomic) NSArray *sortedKeys;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *buttonList;

@end

@implementation DPRMonthsDetailsTVC{
    NSInteger currMonth;
    NSInteger currYear;
    NSArray *months;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupUI];
    [self setupData];
}

- (void)setupData{
    
    self.cdHelper = [DPRCoreDataHelper sharedModel];
    self.user = [self.cdHelper fetchUser];
    self.transactionSingleton = [DPRTransactionSingleton sharedModel];
    self.transactionsByMonth = _transactionSingleton.transactionsByMonth;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    currMonth = [components month];
    currYear = [components year];
    
    months = @[ @"January", @"February", @"March",
				@"April", @"May", @"June",
				@"July", @"August", @"September",
				@"October", @"November", @"December"
				];
	
	// sorted keys
	NSMutableArray *arr = [[NSMutableArray alloc] init];
	for(int i = 0; i < 12; i++){
		NSInteger index = currMonth - i - 1;
		if(index < 0){
			index += 12;
		}
		[arr addObject:[NSNumber numberWithInteger:index]];
	}
	_sortedKeys = arr;
	
}


- (void)setupUI{
    
    self.title = @"Friends";
    self.view.backgroundColor = [UIColor darkColor];
	
	self.tableView.dataSource = self;
	self.tableView.delegate = self;
	
	
	// add button
	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(menuShow)];
	self.navigationItem.rightBarButtonItem = addButton;
	
	[self setupMenu];

	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableTapped:)];
	[self.tableView addGestureRecognizer:tap];
	
}

- (void)setupMenu{
	
	DPRUIHelper *uiHelper = [[DPRUIHelper alloc] init];
	
	// make menu
	CGFloat width = 160;
	CGFloat height = 40;
	CGRect frame = CGRectMake(self.view.frame.size.width - width, -height * 5, width, height * 5);
	UIView *menu = [[UIView alloc] initWithFrame:frame];
	menu.backgroundColor = [UIColor darkishColor];
	menu.layer.zPosition = 990;
	[self.view addSubview:menu];
	self.menu = menu;
	self.menu.hidden = YES;
	
	[uiHelper customizeMenuWithVC:self];
	
	// make buttons
	[self setupButtons];
	
}

- (void)setupButtons{
	
	CGFloat width = 160;
	
	NSMutableArray *buttons = [[NSMutableArray alloc] init];
	for(int i = 0; i < 5; i++){
		
		CGFloat height = 40;
		CGRect frame = CGRectMake(0, i*height, width, height);
		UIButton *button = [[UIButton alloc] initWithFrame:frame];
		button.layer.zPosition = 999;
		button.titleLabel.textColor = [UIColor whiteColor];
		button.titleLabel.font = [UIFont boldSystemFontOfSize:12];
		button.contentEdgeInsets = UIEdgeInsetsMake(-150, 0, -150, 0); //set as you require
		
		
		button.backgroundColor = [UIColor darkishColor];
		
		switch (i) {
			case 0:
				[button setTitle:@"Sort by Date" forState:UIControlStateNormal];
				[button addTarget:self action:@selector(sortByDate:) forControlEvents:UIControlEventTouchDown];
				break;
			case 1:
				[button setTitle:@"Sort by Transactions" forState:UIControlStateNormal];
				[button addTarget:self action:@selector(sortByTransactions:) forControlEvents:UIControlEventTouchDown];
				break;
			case 2:
				[button setTitle:@"Sort by Received" forState:UIControlStateNormal];
				[button addTarget:self action:@selector(sortByReceived:) forControlEvents:UIControlEventTouchDown];
				break;
			case 3:
				[button setTitle:@"Sort by Sent" forState:UIControlStateNormal];
				[button addTarget:self action:@selector(sortBySent:) forControlEvents:UIControlEventTouchDown];
				break;
			case 4:
				[button setTitle:@"Sort by Net Income" forState:UIControlStateNormal];
				[button addTarget:self action:@selector(sortByNetIncome:) forControlEvents:UIControlEventTouchDown];
				break;
		}
		
		[buttons addObject:button];
		
		[self.menu addSubview:button];
		
	}
	
	self.buttonList = buttons;
	
}


- (void)sortTransactionsWithKey:(NSString *)key{
	
	NSSortDescriptor *sortByKey = [NSSortDescriptor sortDescriptorWithKey:key
																 ascending:NO];
	NSArray *sortDescriptors = [NSArray arrayWithObject:sortByKey];
	NSArray *sortedDictionaries = [_transactionsByMonth sortedArrayUsingDescriptors:sortDescriptors];
	NSMutableArray *mutable = [[NSMutableArray alloc] init];
	for(NSDictionary *dict in sortedDictionaries){
		NSNumber *month = [dict objectForKey:@"month"];
		[mutable addObject:month];
	}
	
	_sortedKeys = mutable;
	
	[self.tableView reloadData];
	[self toggleMenu];
}

- (void)sortByDate:(UIButton *)sender{

	// sorted keys
	NSMutableArray *arr = [[NSMutableArray alloc] init];
	for(int i = 0; i < 12; i++){
		NSInteger index = currMonth - i - 1;
		if(index < 0){
			index += 12;
		}
		[arr addObject:[NSNumber numberWithInteger:index]];
	}
	_sortedKeys = arr;
	
	[self.tableView reloadData];
	[self toggleMenu];
	
	for(UIButton *button in _buttonList){
		button.backgroundColor = [UIColor darkishColor];
	}
	sender.backgroundColor = [UIColor grayColor];
}

- (void)sortByTransactions:(UIButton *)sender{
	[self sortTransactionsWithKey:@"transactions"];
	for(UIButton *button in _buttonList){
		button.backgroundColor = [UIColor darkishColor];
	}
	sender.backgroundColor = [UIColor grayColor];
}

- (void)sortByReceived:(UIButton *)sender{
	[self sortTransactionsWithKey:@"received"];
	for(UIButton *button in _buttonList){
		button.backgroundColor = [UIColor darkishColor];
	}
	sender.backgroundColor = [UIColor grayColor];
}

- (void)sortBySent:(UIButton *)sender{
	[self sortTransactionsWithKey:@"sent"];
	for(UIButton *button in _buttonList){
		button.backgroundColor = [UIColor darkishColor];
	}
	sender.backgroundColor = [UIColor grayColor];
}

- (void)sortByNetIncome:(UIButton *)sender{
	[self sortTransactionsWithKey:@"netIncome"];
	for(UIButton *button in _buttonList){
		button.backgroundColor = [UIColor darkishColor];
	}
	sender.backgroundColor = [UIColor grayColor];
}

- (void)menuShow{
	[self toggleMenu];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableTapped:(UITapGestureRecognizer *)tap
{
	[self hideMenu];
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *identifer = @"monthCell";
    DPRMonthsDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];

    // get data
	NSNumber *index = _sortedKeys[indexPath.section];
    NSDictionary *monthDict = _transactionsByMonth[index.integerValue];
	
    NSNumber *transactions = [monthDict objectForKey:@"transactions"];
    NSNumber *sent = [monthDict objectForKey:@"sent"];
    NSNumber *received = [monthDict objectForKey:@"received"];
    NSNumber *netIncome = [monthDict objectForKey:@"netIncome"];
    
    double ni = netIncome.doubleValue;
    if(ni == 0){
        cell.netIncomeAmountLabel.textColor = [UIColor whiteColor];
    }
    else if(ni < 0){
        cell.netIncomeAmountLabel.textColor = [UIColor redColor];
    }
    else{
        cell.netIncomeAmountLabel.textColor = [UIColor lightGreenColor];
    }
    netIncome = [NSNumber numberWithDouble:fabs(ni)];
    
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setPositiveFormat:@"0.00"];
    
    cell.transactionsAmountLabel.text = [NSString stringWithFormat:@"%@", transactions];
    cell.sentAmountLabel.text = [NSString stringWithFormat:@"$%@", [formatter stringFromNumber:sent]];
    cell.receivedAmountLabel.text = [NSString stringWithFormat:@"$%@", [formatter stringFromNumber:received]];
    cell.netIncomeAmountLabel.text = [NSString stringWithFormat:@"$%@", [formatter stringFromNumber:netIncome]];
    
    return cell;
    
}

// section title
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	NSNumber *index = _sortedKeys[section];
    NSString *month = months[index.integerValue];
    NSInteger year = currYear;
    
    if(section >= currMonth){
        year--;
    }
    
    NSString *title = [NSString stringWithFormat:@"%@ %ld", month, year];
    
    return [title uppercaseString];
    
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger rowHeight = 100;
    
    return rowHeight;
    
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    
    //Set the background color of the View
    view.tintColor = [UIColor darkColor];
	view.userInteractionEnabled = NO;

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 12;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}



@end

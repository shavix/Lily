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
@property (strong, nonatomic) DPRUIHelper *uiHelper;
@property (strong, nonatomic) DPRCoreDataHelper *cdHelper;
@property (strong, nonatomic) DPRTransactionSingleton *transactionSingleton;

@property (strong, nonatomic) NSArray *transactionsByMonth;
@property (strong, nonatomic) NSDictionary *friendsData;
@property (strong, nonatomic) NSArray *sortedKeys;
@property (strong, nonatomic) NSArray *buttonList;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

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
	[self sortByDate:_buttonList[0]];
	
}


- (void)setupUI{
    
    self.title = @"This Year";
    self.view.backgroundColor = [UIColor darkColor];
	
	self.tableView.dataSource = self;
	self.tableView.delegate = self;
	
	self.uiHelper = [[DPRUIHelper alloc] init];

	// add button
	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(menuShow)];
	self.navigationItem.rightBarButtonItem = addButton;
	
	[self setupMenu];

	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableTapped:)];
	[self.tableView addGestureRecognizer:tap];
	
	self.myTableView = self.tableView;
	
}

- (void)setupMenu{
	
	
	self.buttonList = [_uiHelper createMenuWithVC:self andNumButtons:5 andType:@"months"];
	
	[self.tableView bringSubviewToFront:self.menu];
	
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	CGRect rect = self.menu.frame;
	rect.origin.y =  scrollView.contentOffset.y;
	
	self.menu.frame = rect;
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
	
	[UIView transitionWithView: self.tableView
					  duration: 0.5f
					   options: UIViewAnimationOptionTransitionCrossDissolve
					animations: ^(void)
	 {
		 [self.tableView reloadData];
	 }
					completion: nil];
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
	
	[UIView transitionWithView: self.tableView
					  duration: 0.5f
					   options: UIViewAnimationOptionTransitionCrossDissolve
					animations: ^(void)
	 {
		 [self.tableView reloadData];
	 }
					completion: nil];
	[self hideMenu];
	
	for(UIButton *button in _buttonList){
		button.backgroundColor = [UIColor darkishColor];
	}
	sender.backgroundColor = [UIColor lightGreenColor];
}

- (void)sortByTransactions:(UIButton *)sender{
	[self sortTransactionsWithKey:@"transactions"];
	[_uiHelper refreshListButtons:_buttonList withButton:sender];
}

- (void)sortByReceived:(UIButton *)sender{
	[self sortTransactionsWithKey:@"received"];
	[_uiHelper refreshListButtons:_buttonList withButton:sender];
}

- (void)sortBySent:(UIButton *)sender{
	[self sortTransactionsWithKey:@"sent"];
	[_uiHelper refreshListButtons:_buttonList withButton:sender];
}

- (void)sortByNetIncome:(UIButton *)sender{
	[self sortTransactionsWithKey:@"netIncome"];
	[_uiHelper refreshListButtons:_buttonList withButton:sender];
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
		cell.netIncomeAverage.textColor = [UIColor whiteColor];
    }
    else if(ni < 0){
		cell.netIncomeAmountLabel.textColor = [UIColor redColor];
		cell.netIncomeAverage.textColor = [UIColor redColor];
    }
    else{
		cell.netIncomeAmountLabel.textColor = [UIColor lightGreenColor];
		cell.netIncomeAverage.textColor = [UIColor lightGreenColor];
    }
    netIncome = [NSNumber numberWithDouble:fabs(ni)];
    
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setPositiveFormat:@"0.00"];
    
    cell.transactionsAmountLabel.text = [NSString stringWithFormat:@"%@", transactions];
    cell.sentAmountLabel.text = [NSString stringWithFormat:@"$%@", [formatter stringFromNumber:sent]];
    cell.receivedAmountLabel.text = [NSString stringWithFormat:@"$%@", [formatter stringFromNumber:received]];
    cell.netIncomeAmountLabel.text = [NSString stringWithFormat:@"$%@", [formatter stringFromNumber:netIncome]];
	
	NSNumber *receivedAverage = [monthDict objectForKey:@"receivedAverage"];
	NSNumber *sentAverage = [monthDict objectForKey:@"sentAverage"];
	cell.receivedAverageLabel.text = [NSString stringWithFormat:@"$%.2f", receivedAverage.doubleValue];
	cell.sentAverageLabel.text = [NSString stringWithFormat:@"$%.2f", sentAverage.doubleValue];
	
	if(transactions == 0){
		cell.netIncomeAverage.text = @"$0.00";
	}
	else{
		double netIncomeAverage = netIncome.doubleValue / transactions.doubleValue;
		cell.netIncomeAverage.text = [NSString stringWithFormat:@"$%.2f",netIncomeAverage];
	}
	
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
    
    NSString *title = [NSString stringWithFormat:@"%@ %ld", month, (long)year];
    
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

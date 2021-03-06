//
//  DPRProfileTVC.m
//  Lily
//
//  Created by David Richardson on 11/16/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import "DPRProfileTVC.h"
#import "DPRUser.h"
#import "DPRCoreDataHelper.h"
#import "DPRPortraitTableViewCell.h"
#import "DPRProfileTransactionTableViewCell.h"
#import "DPRTransaction.h"
#import "DPRUIHelper.h"
#import "DPRTarget.h"
#import "DPRProfileFriendTableViewCell.h"
#import "DPRAggregateTableViewCell.h"
#import "DPRVenmoHelper.h"
#import "DPRDashboardTableViewCell.h"
#import "UIColor+CustomColors.h"
#import "UIFont+CustomFonts.h"
#import <SDWebImage/UIImageView+WebCache.h>

@import SCLAlertView_Objective_C;

@interface DPRProfileTVC ()

@property (strong, nonatomic) DPRUser *user;
@property (strong, nonatomic) DPRCoreDataHelper *cdHelper;
@property (strong, nonatomic) NSDictionary *transactionsByFriends;
@property (strong, nonatomic) SCLAlertView *alertView;
@property (strong, nonatomic) DPRUIHelper *uiHelper;

@end

@implementation DPRProfileTVC{
	NSDictionary *titles;
	NSArray *sectionTitles;
	UIFont *titleFont;
	UIColor *titleColor;
	NSArray *cellIdentifiers;
	NSArray *transactionDataTypes;
	NSArray *transactionTitles;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self setupUI];
	[self setupGlobals];
	[self retrieveData];
}

- (void)retrieveData{
	
	// retrieve user
	self.cdHelper = [DPRCoreDataHelper sharedModel];
	self.user = [self.cdHelper fetchUser];
	
	// store username
	[self storeUsername];
	
	if(_user.transactionList.count < 1){
		[self loadMoreTransactions];
	}
	else{
		[self setupData];
	}
	
}

- (void)setupUI{
	
	self.tabBarController.delegate = self;
	self.navigationController.navigationBar.hidden = NO;
	self.uiHelper = [[DPRUIHelper alloc] init];
	[_uiHelper setupTabUI:self withTitle:@"Profile"];
	self.view.backgroundColor = [UIColor darkColor];
	[self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
	
	[self setupNavButtons];

}

- (void)setupData{
	
	// transactionsByDate & byFriends
	if(_user.transactionList.count > 0){
		[self.cdHelper setupTransactionsByDateWithUser:self.user];
		self.transactionsByFriends = [self.cdHelper setupTransactionsByFriendsWithUser:self.user];
	}
	else{
		[self noTransactions];
	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	NSInteger section = indexPath.section;
	NSInteger row = indexPath.row;
	
	// portrait cell
	if(section == 0){
		DPRPortraitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifiers[0]];
		return [self setupPortraitCell:cell];
	}
	// history
	else if(section == 1){
		DPRAggregateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifiers[1]];
		return [self setupAggregateCell:cell];
	}
	// transactions
	else if(section == 2){
		DPRProfileTransactionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifiers[2]];
		return [self setupTransactionCell:cell withRow:row];
	}
	// friends
	else if(section == 3){
		DPRProfileFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifiers[3]];
		return [self setupFriendCell:cell withRow:row];
	}
	else{
		DPRDashboardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifiers[4]];
		return [self setupDashboardCell:cell];
	}

}


#pragma mark - cell setup

- (DPRPortraitTableViewCell *)setupPortraitCell:(DPRPortraitTableViewCell *)cell{
	cell.image.image = _user.pictureImage;
	cell.title.text = _user.fullName;
	NSString *subtitle = [NSString stringWithFormat:@"@%@",_user.username];
	cell.subtitle.text = subtitle;
	return cell;
}


- (DPRAggregateTableViewCell *)setupAggregateCell:(DPRAggregateTableViewCell *)cell{
	cell.image.image = [UIImage imageNamed:@"calculator"];
	
	NSSet *transactionList = _user.transactionList;
	NSInteger numTransactions = transactionList.count;
	double sent = 0;
	double received = 0;
	double netIncome = 0;
	int numSent = 0;
	int numReceived = 0;
	
	for(DPRTransaction *transaction in transactionList){
		
		double amount = transaction.amount.doubleValue;
		// received
		if(transaction.isIncoming){
			received += amount;
			netIncome += amount;
			numReceived++;
		}
		// sent
		else{
			sent += amount;
			netIncome -= amount;
			numSent++;
		}
	}
	
	NSString *transactionString = [NSString stringWithFormat:@"%ld", (long) numTransactions];
	NSString *sentString = [NSString stringWithFormat:@"$%.2f", sent];
	NSString *receivedString = [NSString stringWithFormat:@"$%.2f", received];
	NSString *netIncomeString = [NSString stringWithFormat:@"$%.2f", netIncome];
	
	cell.transactionsAmountLabel.text = transactionString;
	cell.sentAmountLabel.text = sentString;
	cell.receivedAmountLabel.text = receivedString;
	cell.netIncomeAmountLabel.text = netIncomeString;
	
	// net income label
	if(received > sent){
		cell.netIncomeAmountLabel.textColor = [UIColor lightGreenColor];
		cell.netIncomeAverageLabel.textColor = [UIColor lightGreenColor];
	}
	else{
		cell.netIncomeAmountLabel.textColor = [UIColor redColor];
		cell.netIncomeAverageLabel.textColor = [UIColor redColor];
	}
	
	double average = 0;
	// averages
	if(numSent == 0){
		cell.sentAverageLabel.text = @"$0.00";
	}
	else{
		average = sent/numSent;
		cell.sentAverageLabel.text = [NSString stringWithFormat:@"$%.2f",average];
	}
	// averages
	if(numReceived == 0){
		cell.receivedAverageLabel.text = @"$0.00";
	}
	else{
		average = received/numReceived;
		cell.receivedAverageLabel.text = [NSString stringWithFormat:@"$%.2f",average];
	}
	
	double netIncomeAverage = 0;
	if(numTransactions != 0){
		netIncomeAverage = netIncome / (double) numTransactions;
	}
	cell.netIncomeAverageLabel.text = [NSString stringWithFormat:@"$%.2f", netIncomeAverage];
	return cell;
}

// image
- (DPRProfileTransactionTableViewCell *)setupTransactionCell:(DPRProfileTransactionTableViewCell *)cell withRow:(NSInteger)row {
	
	NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
	DPRTransaction *transaction;
	NSString *title = @"";
	// expenditures
	if(row == 0){
		transaction = [self maxTransactionOfType:@"sent"];
		title = @"By Expenditure";
	}
	// income
	else{
		transaction = [self maxTransactionOfType:@"received"];
		title = @"By Income";
	}
	cell.cellTitle.attributedText = [[NSAttributedString alloc] initWithString:title
																	attributes:underlineAttribute];
	// SDWebImage
	[cell.image sd_setImageWithURL:[NSURL URLWithString:transaction.target.picture_url]
				 placeholderImage:[UIImage imageNamed:@"UserImage"]];
	
	// description
	NSDictionary *lightAttribute = @{NSFontAttributeName: [UIFont fontWithName:@"Helvetica-Light" size:12]};
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:transaction.transactionDescription];
	NSRange range = [transaction.transactionDescription rangeOfString:@"paid"];
	if(range.location == NSNotFound){
		range = [transaction.transactionDescription rangeOfString:@"charged"];
	}
	[attributedString addAttributes:lightAttribute range:range];
	cell.title.attributedText = attributedString;
	
	cell.subtitle.text = transaction.note;
	
	NSString *dateCompleted = [transaction.dateCompletedString lowercaseString];
	// capitalize first letter
	cell.dateLabel.text = [dateCompleted stringByReplacingCharactersInRange:NSMakeRange(0,1)
															  withString:[[dateCompleted substringToIndex:1] capitalizedString]];
	
	// color
	if(transaction.isIncoming) {
		cell.amountLabel.textColor = [UIColor lightGreenColor];
	}
	else{
		cell.amountLabel.textColor = [UIColor redColor];
	}
	// format
	NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
	[formatter setNumberStyle:NSNumberFormatterDecimalStyle];
	[formatter setPositiveFormat:@"0.00"];
	
	cell.amountLabel.text = [NSString stringWithFormat:@"$%@", [formatter stringFromNumber:transaction.amount]];
	cell.cellTitle.textColor = titleColor;
	cell.cellTitle.font = titleFont;
	
	return cell;
}


- (DPRProfileFriendTableViewCell *)setupFriendCell:(DPRProfileFriendTableViewCell *)cell withRow:(NSInteger)row{
	
	NSString *type = transactionDataTypes[row];
	NSString *title = transactionTitles[row];
	NSDictionary *friend = [self maxFriendOfType:type];
	
	// SDWebImage
	NSString *picture_url = [friend objectForKey:@"picture_url"];
	[cell.image sd_setImageWithURL:[NSURL URLWithString:picture_url]
				  placeholderImage:[UIImage imageNamed:@"UserImage"]];
	
	cell.title.text = [friend objectForKey:@"name"];
	
	// amount
	NSNumber *amount = [friend objectForKey:type];
	NSString *amountLabel;
	if([type isEqualToString:@"transactions"]){
		amountLabel = [NSString stringWithFormat:@"%@", amount];
		cell.amountLabel.textColor = [UIColor whiteColor];
	}
	else
		amountLabel = [NSString stringWithFormat:@"$%.2f", amount.doubleValue];
	if([type isEqualToString:@"sent"])
		cell.amountLabel.textColor = [UIColor redColor];
	
	cell.amountLabel.text = amountLabel;
	cell.cellTitle.text = title;
	cell.cellTitle.textColor = titleColor;
	cell.cellTitle.font = titleFont;
	[cell drawLineWithView:self.view];
	
	return cell;
}

- (DPRDashboardTableViewCell *)setupDashboardCell:(DPRDashboardTableViewCell *)cell{
	cell.image.image = [UIImage imageNamed:@"loading"];
	cell.title.text = @"Load transactions";
	cell.subtitle.text = [NSString stringWithFormat:@"Load your most recent transactions.\n(%ld transactions currently loaded)", (long)_user.transactionList.count];
	return cell;
}

- (NSDictionary *)maxFriendOfType:(NSString *)type{
	
	NSString *friendName;
	NSDictionary *maxFriend;
	for(NSString *name in _transactionsByFriends){
		maxFriend = [_transactionsByFriends objectForKey:name];
		friendName = name;
	}
	
	double maxValue = ((NSNumber *)[maxFriend objectForKey:type]).doubleValue;
	for(NSString *name in _transactionsByFriends){
		NSDictionary *friend = [_transactionsByFriends objectForKey:name];
		
		double val = ((NSNumber *)[friend objectForKey:type]).doubleValue;;
		
		if(val > maxValue){
			maxValue = val;
			maxFriend = friend;
			friendName = name;
		}
	}
	
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:maxFriend];
	[dict setObject:friendName forKey:@"name"];
	
	return dict;
}

- (DPRTransaction *)maxTransactionOfType:(NSString *)type{
	
	DPRTransaction *maxTransaction = [_user.transactionList anyObject];
	double maxValue = maxTransaction.amount.doubleValue;
	for(DPRTransaction *transaction in _user.transactionList){
		double amount = transaction.amount.doubleValue;
		// received
		if([type isEqualToString:@"received"]){
			if(transaction.isIncoming){
				if(amount > maxValue){
					maxTransaction = transaction;
					maxValue = amount;
				}
			}
		}
		// sent
		else{
			if(!transaction.isIncoming){
				if(amount > maxValue){
					maxTransaction = transaction;
					maxValue = amount;
				}
			}
		}
	}
	return maxTransaction;
}


- (void)loadMoreTransactions{
	DPRVenmoHelper *venmoHelper = [DPRVenmoHelper sharedModel];
	[venmoHelper loadMoreTransactionsWithVC:self];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if(_user.transactionList.count < 1){
		return 0;
	}
	return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	if(section < 2 || section == 4)
		return 1;
	if(section == 3)
		return 4;
	
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	// portrait && profile
	if(indexPath.section ==0)
		return 120;
	if(indexPath.section == 1)
		return 110;
	if(indexPath.section < 4)
		return 90;
	return 100;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	if(section == 0)
		return 20;
	return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	if(indexPath.section == 4)
		[self loadMoreTransactions];
}


// section title
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	NSString *title = @"";
	if(section != 0)
		title = sectionTitles[section-1];
	return [title uppercaseString];
}


-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
	//Set the background color of the View
	view.tintColor = [UIColor darkColor];
	view.layer.zPosition = -999;
}

- (void)noTransactions{
	// haven't loaded, show notice
	if(!_alertView){
		NSString *message = @"No transactions have been loaded. To continue, press \n\"Load Transactions\"\n(Network connection required)";
		NSString *title = @"Notice";
		self.alertView = [_uiHelper alertWithMessage:message andTitle:title andButtonText:@"Load Transactions" andVC:self.parentViewController];
		[self flipTabs];
		
		// completion
		[_alertView alertIsDismissed:^{
			_alertView = nil;
			[self flipTabs];
			[self loadMoreTransactions];
		}];
	}
}

- (void)setupGlobals{
	titles = [NSDictionary dictionaryWithObjectsAndKeys:
			  @"Transactions:", @"transactions",
			  @"Sent:", @"sent",
			  @"Recieved:", @"received",
			  @"Net Income:", @"netIncome", nil];
	
	sectionTitles = @[@"History",
					  @"Largest Transactions",
					  @"Friends",
					  @"Transactions"];
	
	titleColor = [UIColor whiteColor];
	titleFont = [UIFont helveticaBold13];
	
	cellIdentifiers = @[@"PortraitCell", @"AggregateCell", @"ProfileTransactionCell", @"ProfileFriendCell", @"DashboardCell"];
	transactionDataTypes = @[@"transactions", @"sent", @"received", @"netIncome"];
	transactionTitles = @[@"Most Transactions", @"Highest Total Expenditures", @"Highest Total Income", @"Highest Total Net Income"];
}

- (void)showSettings{
	[self performSegueWithIdentifier:@"settingsSegue" sender:self];
}

- (void)setupNavButtons{
	UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain
																	 target:nil
																	 action:nil];
	[[self navigationItem] setBackBarButtonItem:newBackButton];
	
	UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"settings_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(showSettings)];
	
	settingsButton.tintColor = [UIColor lightGreenColor];
	
	UIFont *customFont = [UIFont fontWithName:@"Helvetica" size:24.0];
	NSDictionary *fontDictionary = @{NSFontAttributeName : customFont};
	[settingsButton setTitleTextAttributes:fontDictionary forState:UIControlStateNormal];
	self.navigationItem.rightBarButtonItem = settingsButton;
}

- (void)flipTabs{
	bool enabled = self.tabBarController.tabBar.items[0].isEnabled;
	for(int i = 0; i < 3; i++)
		self.tabBarController.tabBar.items[i].enabled = !enabled;
}

#pragma mark - data persistence

- (void)storeUsername {
	[[NSUserDefaults standardUserDefaults] setObject:self.user.username forKey:@"DPRUsername"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}



@end

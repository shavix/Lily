//
//  DPRProfileTVC.m
//  Lily
//
//  Created by David Richardson on 11/16/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import "DPRProfileTVC.h"
#import "DPRProfileTableViewCell.h"
#import "DPRUser.h"
#import "DPRCoreDataHelper.h"
#import "DPRPortraitTableViewCell.h"
#import "DPRProfileTransactionTableViewCell.h"
#import "DPRTransaction.h"
#import "DPRTarget.h"
#import "DPRProfileFriendTableViewCell.h"
#import "UIColor+CustomColors.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface DPRProfileTVC ()

@property (strong, nonatomic) DPRUser *user;
@property (strong, nonatomic) DPRCoreDataHelper *cdHelper;
@property (strong, nonatomic) NSDictionary *transactionsByFriends;

@end

@implementation DPRProfileTVC{
	NSDictionary *titles;
	NSArray *sectionTitles;
	
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self setupUI];
	[self setupData];
}

- (void)setupUI{
	self.title = @"Profile";
	self.view.backgroundColor = [UIColor darkColor];
	[self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

- (void)setupData{
	self.cdHelper = [DPRCoreDataHelper sharedModel];
	self.user = [self.cdHelper fetchUser];
	self.transactionsByFriends = [self.cdHelper setupTransactionsByFriendsWithUser:self.user];
	
	titles = [NSDictionary dictionaryWithObjectsAndKeys:
			  @"Transactions:", @"transactions",
			  @"Sent:", @"sent",
			  @"Recieved:", @"received",
			  @"Net Income:", @"netIncome", nil];
	
	sectionTitles = @[@"Information",
					  @"Trends",
					  @"Largest Transactions",
					  @"Friends"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	NSString *profileIdentifier = @"ProfileCell";
	NSString *protraitIdentifier = @"PortraitCell";
	NSString *profileTransactionIdentifier = @"ProfileTransactionCell";
	NSString *friendIdentifier = @"ProfileFriendCell";
	NSInteger section = indexPath.section;
	NSInteger row = indexPath.row;

	// portrait cell
	if(section == 0){
		DPRPortraitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:protraitIdentifier];
		cell.image.image = _user.pictureImage;
		cell.title.text = _user.fullName;
		
		NSString *subtitle = [NSString stringWithFormat:@"@%@",_user.username];
		cell.subtitle.text = subtitle;
		return cell;
	}
	// information
	if(section == 1){
		DPRProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:profileIdentifier];
		
		[cell setupCell];
		return cell;
	}
	// trends
	else if(section == 2){
		DPRProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:profileIdentifier];
		
		[cell setupCell];
		return cell;
	}
	// transactions
	else if(section == 3){
		DPRProfileTransactionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:profileTransactionIdentifier];
		DPRTransaction *transaction;
		// expenditures
		if(row == 0){
			transaction = [self maxTransactionOfType:@"sent"];
			cell.cellTitle.text = @"By Expenditure";
		}
		// income
		else{
			transaction = [self maxTransactionOfType:@"received"];
			cell.cellTitle.text = @"By Income";
		}
		[self setupCell:cell withTransaction:transaction];
		
		return cell;
	}
	// friends
	else{
		DPRProfileFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:friendIdentifier];
		NSDictionary *maxFriend;
		NSString *type;
		// transactions
		if(row == 0){
			type = @"transactions";
			maxFriend = [self maxFriendOfType:type];
			cell.cellTitle.text = @"Most Transactions";
		}
		// expenditures
		else if(row == 1){
			type = @"sent";
			maxFriend = [self maxFriendOfType:type];
			cell.cellTitle.text = @"Highest Expenditures";
		}
		// income
		else if(row == 2){
			type = @"received";
			maxFriend = [self maxFriendOfType:type];
			cell.cellTitle.text = @"Highest Income";
		}
		// net income
		else {
			type = @"netIncome";
			maxFriend = [self maxFriendOfType:type];
			cell.cellTitle.text = @"Highest Net Income";
		}
		[self setupCell:cell withFriend:maxFriend andType:type];
		return cell;
	}

}


#pragma mark - cell setup

- (void)setupCell:(DPRProfileFriendTableViewCell *)cell withFriend:(NSDictionary *)friend andType:(NSString *)type{
	
	// SDWebImage
	NSString *picture_url = [friend objectForKey:@"picture_url"];
	[cell.image sd_setImageWithURL:[NSURL URLWithString:picture_url]
				  placeholderImage:[UIImage imageNamed:@"UserImage"]];
	
	cell.title.text = [friend objectForKey:@"name"];
	cell.subtitle.text = [titles objectForKey:type];
	
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
	
}


// image
- (void)setupCell:(DPRProfileTransactionTableViewCell *)cell withTransaction:(DPRTransaction *)transaction {
	// SDWebImage
	[cell.image sd_setImageWithURL:[NSURL URLWithString:transaction.target.picture_url]
				 placeholderImage:[UIImage imageNamed:@"UserImage"]];
	
	cell.title.text = transaction.transactionDescription;
	cell.subtitle.text = transaction.note;
	
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	if(section == 0 || section == 1)
		return 1;
	if(section == 4)
		return 4;
	
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSInteger section = indexPath.section;
	
	// profile
	if(section == 0){
		return 145;
	}
	
	return 100;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	if(section == 0)
		return 20;
	return 40;
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


@end

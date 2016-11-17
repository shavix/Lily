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
#import "UIColor+CustomColors.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface DPRProfileTVC ()

@property (strong, nonatomic) DPRUser *user;
@property (strong, nonatomic) DPRCoreDataHelper *cdHelper;

@end

@implementation DPRProfileTVC

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
	NSInteger section = indexPath.section;

	// portrait cell
	if(section == 0){
		DPRPortraitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:protraitIdentifier];
		cell.image.image = _user.pictureImage;
		cell.title.text = _user.fullName;
		
		NSString *subtitle = [NSString stringWithFormat:@"@%@",_user.username];
		cell.subtitle.text = subtitle;
		return cell;
	}
	// profile transaction cell
	if(section == 2 || section == 3){
		DPRProfileTransactionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:profileTransactionIdentifier];
		DPRTransaction *transaction;
		// expenditures
		if(section == 2){
			transaction = [self maxTransactionOfType:@"sent"];
			cell.cellTitle.text = @"Largest expenditure";
		}
		// income
		else{
			transaction = [self maxTransactionOfType:@"received"];
			cell.cellTitle.text = @"Largest income";
		}
		[self setupCell:cell withTransaction:transaction];
		
		return cell;
	}
	DPRProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:profileIdentifier];
	
	[cell setupCell];
	
	return cell;
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
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
	return 30;
}


// section title
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	NSString *title = @"";
	
	switch (section) {
		case 1:
			title = @"Information";
			break;
		case 2:
			title = @"Expenditures";
			break;
		case 3:
			title = @"Income";
			break;
		case 4:
			title = @"Net Income";
			break;
		default:
			title = @"";
			break;
	}
	
	return [title uppercaseString];
}


-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
	//Set the background color of the View
	view.tintColor = [UIColor darkColor];
	view.layer.zPosition = -999;
}


@end

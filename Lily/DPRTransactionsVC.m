//
//  DPRTransactionsVC.m
//  Lily
//
//  Created by David Richardson on 6/22/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import "DPRTransactionsVC.h"
#import "DPRTransaction.h"
#import "DPRUIHelper.h"
#import "DPRUser.h"
#import "DPRCoreDataHelper.h"
#import "DPRTarget.h"
#import "DPRTransactionTableViewCell.h"
#import "DPRPortraitTableViewCell.h"
#import "DPRTransactionSingleton.h"
#import "UIColor+CustomColors.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface DPRTransactionsVC()
@property (strong, nonatomic) DPRTransactionSingleton *transactionSingleton;
@property (strong, nonatomic) DPRUser *user;
@end

@implementation DPRTransactionsVC

#pragma mark - on load

- (void)viewDidLoad {
	
	[super viewDidLoad];
	
    [self setupData];
    [self setupUI];
    
}

- (void)setupData {
    self.transactionSingleton = [DPRTransactionSingleton sharedModel];
	DPRCoreDataHelper *cdHelper = [DPRCoreDataHelper sharedModel];
	self.user = [cdHelper fetchUser];
}

- (void)setupUI{
    DPRUIHelper *UIHelper = [[DPRUIHelper alloc] init];
    [UIHelper setupTabUI:self withTitle:@"Transactions"];
	[self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    self.view.backgroundColor = [UIColor darkColor];
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}


#pragma mark - UITableView


// get cell
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* CellIdentifier = @"TransactionCell";
	static NSString *protraitIdentifier = @"PortraitCell";
	NSInteger section = indexPath.section;
	NSInteger row = indexPath.row;

	if(section == 0){
		DPRPortraitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:protraitIdentifier];
		cell.image.image = _user.pictureImage;
		cell.title.text = _user.fullName;
		cell.separatorInset = UIEdgeInsetsZero;
		NSString *subtitle = [NSString stringWithFormat:@"@%@",_user.username];
		cell.subtitle.text = subtitle;
		return cell;
	}

    DPRTransactionTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    
    DPRTransaction *transaction = self.transactionSingleton.transactionsByDate[section - 1][row];

	// description
	NSDictionary *lightAttribute = @{NSFontAttributeName: [UIFont fontWithName:@"Helvetica-Light" size:12]};
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:transaction.transactionDescription];
	NSRange range = [transaction.transactionDescription rangeOfString:@"paid"];
	if(range.location == NSNotFound){
		range = [transaction.transactionDescription rangeOfString:@"charged"];
	}
	[attributedString addAttributes:lightAttribute range:range];
	cell.transactionLabel.attributedText = attributedString;
	
    // noteLabel
    cell.noteLabel.text = transaction.note;
    
    // amount
    [self setupAmountLabel:cell.amountLabel withTransaction:transaction];
    
    // image
    [self setupImageView:cell.cellImage withTransaction:transaction];
    
    return cell;
}


// amountLabel
- (void)setupAmountLabel:(UILabel *)amountLabel withTransaction:(DPRTransaction *)transaction{
    
    // color
    if(transaction.isIncoming) {
        amountLabel.textColor = [UIColor lightGreenColor];
    }
    else{
        amountLabel.textColor = [UIColor redColor];
    }
    // format
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setPositiveFormat:@"0.00"];
    amountLabel.text = [NSString stringWithFormat:@"$%@", [formatter stringFromNumber:transaction.amount]];
}

// image
- (void)setupImageView:(UIImageView *)imageView withTransaction:(DPRTransaction *)transaction {
    // SDWebImage
    [imageView sd_setImageWithURL:[NSURL URLWithString:transaction.target.picture_url]
                 placeholderImage:[UIImage imageNamed:@"UserImage"]];  
}



// section title
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	if(section == 0)
		return @"";
    DPRTransaction *transaction = self.transactionSingleton.transactionsByDate[section - 1][0];
    NSString *title = transaction.dateCompletedString;
    return title;
}

// num rows
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if(section == 0)
		return 1;
    return [self.transactionSingleton.transactionsByDate[section - 1] count];
}


// num sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.transactionSingleton.transactionsByDate count] + 1;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(indexPath.section == 0)
		return 125;
	return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	if(section == 0)
		return 20;
	if(section == 1)
		return 20;
	return 20;
}


@end

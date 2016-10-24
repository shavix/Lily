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
#import "DPRTarget.h"
#import "DPRTransactionTableViewCell.h"
#import "DPRTransactionSingleton.h"
#import "UIColor+CustomColors.h"

@interface DPRTransactionsVC()

@property (strong, nonatomic) DPRTransactionSingleton *transactionSingleton;

@end

@implementation DPRTransactionsVC

#pragma mark - on load

- (void)viewDidLoad {
    
    [self setupData];
    [self setupUI];
    
}

- (void)setupData {
    
    self.transactionSingleton = [DPRTransactionSingleton sharedModel];
    
}

- (void)setupUI{
    
    DPRUIHelper *UIHelper = [[DPRUIHelper alloc] init];
    [UIHelper setupTabUI:self withTitle:@"Transactions"];
    
    self.view.backgroundColor = [UIColor darkColor];

}


#pragma mark - UITableView


// get cell
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* CellIdentifier = @"TransactionCell";
    DPRTransactionTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    DPRTransaction *transaction = self.transactionSingleton.transactionsByDate[section][row];

    // transactionLabel
    cell.transactionLabel.text = transaction.transactionDescription;
    
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
    
    
    // target image
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:transaction.target.picture_url]]];
        
        if(!image){
            image = [UIImage imageNamed:@"UserImage"];
        }
        
        dispatch_sync(dispatch_get_main_queue(), ^(void) {
            imageView.image = image;
        });
    });

    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    DPRTransaction *transaction = self.transactionSingleton.transactionsByDate[section][row];
    
    #warning clean
    NSString *cellText = transaction.note;
    CGSize constraintSize = CGSizeMake(3*self.tableView.frame.size.width/5, MAXFLOAT);
    UIFont *fontText = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
    CGRect labelSize = [cellText boundingRectWithSize:constraintSize options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName: fontText} context:nil];
    
    //return labelSize.size.height + 40;
    return 70;
}


// section title
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    DPRTransaction *transaction = self.transactionSingleton.transactionsByDate[section][0];
    NSString *title = transaction.dateCompletedString;
    
    return title;
    
}

// num rows
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.transactionSingleton.transactionsByDate[section] count];
}

// num sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.transactionSingleton.transactionsByDate count];
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell.backgroundColor = [UIColor charcoalColor];
    
}

@end

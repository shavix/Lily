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

    cell.transactionLabel.text = transaction.transactionDescription;
    cell.noteLabel.text = transaction.note;
    cell.amountLabel.text = [NSString stringWithFormat:@"$%@",transaction.amount];

    return cell;
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


@end

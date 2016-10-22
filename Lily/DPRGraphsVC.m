//
//  DPRGraphsVC.m
//  Lily
//
//  Created by David Richardson on 6/22/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import "DPRGraphsVC.h"
#import "DPRUIHelper.h"
#import "DPRUser.h"
#import "DPRCoreDataHelper.h"
#import "DPRTransactionSingleton.h"
#import "DPRVenmoHelper.h"
#import "DPRGraphTableViewCell.h"

#import "UIColor+CustomColors.h"

@interface DPRGraphsVC()

// data
@property (strong, nonatomic) DPRUser *user;
@property (strong, nonatomic) DPRCoreDataHelper *cdHelper;
@property (strong, nonatomic) DPRTransactionSingleton *transactionSingleton;
@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSArray *transactionsByDate;
@property (strong, nonatomic) NSArray *firstTransactions;


@end

@implementation DPRGraphsVC

#pragma mark - on load

- (void)viewDidLoad {
    
    [self setupUI];
    [self retrieveData];
    [self setupData];
    
}

- (void)setupUI{
    
    DPRUIHelper *UIHelper = [[DPRUIHelper alloc] init];
    [UIHelper setupTabUI:self withTitle:@"Graphs"];
    
    self.view.backgroundColor = [UIColor darkColor];
    
    [self.tableView setContentInset:UIEdgeInsetsMake(30,0,0,0)];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];

    
}


- (void)retrieveData{
    
    // retrieve user
    self.cdHelper = [DPRCoreDataHelper sharedModel];
    self.user = [self.cdHelper fetchUser];
    
    // setup identifier set
    NSMutableSet *identifierSet = [self.cdHelper setupIdentifierSetWithUser:self.user];
    
#warning incomplete
    // retrieve recent transactions
    NSInteger numTransactions = 50;
    DPRVenmoHelper *venmoHelper = [DPRVenmoHelper sharedModel];
    NSArray *tempTransactionsArray = [venmoHelper fetchTransactions:numTransactions];
    
    // organize transactions
    [self.cdHelper insertIntoDatabse:tempTransactionsArray withIdentifierSet:identifierSet andUser:self.user];
    
    // store username
    [self storeUsername];
    
}

- (void)setupData {
    
    // transactionsByDate
    self.transactionSingleton = [DPRTransactionSingleton sharedModel];
    self.transactionSingleton.transactionsByDate = [self.cdHelper setupTransactionsByDateWithUser:self.user];
    
    // firstTransactions
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for(int i = 0; i < self.transactionSingleton.transactionsByDate.count; i++){
        if(tempArray.count >= 3){
            break;
        }
        NSMutableArray *currentDateArray = self.transactionSingleton.transactionsByDate[self.transactionSingleton.transactionsByDate.count - 1];
        for(int j = 0; j < currentDateArray.count; j++){
            [tempArray addObject:currentDateArray[j]];
            if(tempArray.count >= 3){
                break;
            }
        }
    }
    self.firstTransactions = tempArray;
    
}

#pragma mark - TableView

// get cell
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* CellIdentifier = @"GraphCell";
    DPRGraphTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    // FRIENDS
    if(section == 0)
    {
        if(row == 0){
            cell.image.image = [UIImage imageNamed:@"give_money.png"];
            cell.title.text = @"Number of transactions";
            cell.subtitle.text = @"An analysis of who, of your friends, you have the most transactions with on Venmo.";
        }
        else{
            cell.image.image = [UIImage imageNamed:@"money.png"];
            cell.title.text = @"Money exchanged";
            cell.subtitle.text = @"An analysis of who, of your friends, you have sent the most money to on Venmo.";
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger height = self.view.frame.size.height;
    
    NSInteger rowHeight = height/6;
    
    return rowHeight;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}


// section title
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSString *title;
    
    if(section == 0){
        title = @"FRIENDS";
    }
    else{
        title = @"MISCELLANEOUS";
    }
    
    return title;
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell.backgroundColor = [UIColor charcoalColor];
    
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    
    //Set the background color of the View
    view.tintColor = [UIColor darkColor];
    
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor whiteColor]];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    NSInteger numSections = 1;
    
    return numSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger numRows = 2;
    
    return numRows;
}

#pragma mark - data persistence

- (void)storeUsername {
    
    [[NSUserDefaults standardUserDefaults] setObject:self.user.username forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}



@end

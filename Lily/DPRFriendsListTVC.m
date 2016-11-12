//
//  DPRFriendsListTVC.m
//  Lily
//
//  Created by David Richardson on 10/24/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import "DPRFriendsListTVC.h"
#import "DPRCoreDataHelper.h"
#import "DPRUser.h"
#import "DPRFriendsListTableViewCell.h"
#import "DPRTransaction.h"
#import "DPRTarget.h"
#import "DPRUIHelper.h"
#import "UIColor+CustomColors.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface DPRFriendsListTVC ()

@property (strong, nonatomic) DPRUser *user;
@property (strong, nonatomic) DPRCoreDataHelper *cdHelper;
@property (strong, nonatomic) NSArray *transactionsByFriends;
@property (strong, nonatomic) NSDictionary *friendsData;

@end

@implementation DPRFriendsListTVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupUI];
    [self setupData];
    
    
}

- (void)setupData{
        
    self.cdHelper = [DPRCoreDataHelper sharedModel];
    self.user = [self.cdHelper fetchUser];
    self.transactionsByFriends = [self.cdHelper setupTransactionsByFriendsWithUser:self.user];
    [self calculateFriendsData];
    
}

- (void)calculateFriendsData{
    
    NSMutableDictionary *tempFriendsData = [[NSMutableDictionary alloc] init];
    
    // iterate through friends
    for(NSArray *currArr in _transactionsByFriends){
        
        NSInteger amountSent = 0;
        NSInteger amountReceived = 0;
        
        // iterate through transactions
        for(DPRTransaction *transaction in currArr){
            
            NSNumber *amount = transaction.amount;
            
            if(transaction.isIncoming){
                amountReceived += amount.integerValue;
            }
            else{
                amountSent += amount.integerValue;
            }
            
        }
        
        NSInteger netIncome = labs(amountReceived - amountSent);
        NSInteger transactions = currArr.count;
        
        NSDictionary *friend = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSNumber numberWithInteger:transactions], @"transactions",
                                [NSNumber numberWithInteger:amountSent], @"sent",
                                [NSNumber numberWithInteger:amountReceived], @"received",
                                [NSNumber numberWithInteger:netIncome], @"netIncome",
                                nil];
        
        DPRTransaction *transaction = currArr[0];
        
        [tempFriendsData setObject:friend forKey:transaction.target.fullName];
        
    }
    
    self.friendsData = tempFriendsData;
    
}


- (void)setupUI{
    
    self.title = @"Friends";
    self.view.backgroundColor = [UIColor darkColor];
	
	DPRUIHelper *uiHelper = [[DPRUIHelper alloc] init];
	
	// add button
	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(menuShow)];
	self.navigationItem.rightBarButtonItem = addButton;
	
	[uiHelper customizeMenuWithVC:self];
	
}

- (void)menuShow{
	
	[self toggleMenu];
	
}

#pragma mark - UITableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    NSString *identifier = @"friendsCell";
    DPRFriendsListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    NSInteger section = indexPath.section;
    
    DPRTransaction *transaction = self.transactionsByFriends[section][0];
    NSDictionary *friendData = [self.friendsData objectForKey:transaction.target.fullName];
    
    // format
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setPositiveFormat:@"0.00"];

    
    cell.transactionsAmountLabel.text = [NSString stringWithFormat:@"%@", [friendData objectForKey:@"transactions"]];
    cell.sentAmountLabel.text = [NSString stringWithFormat:@"$%@", [formatter stringFromNumber:[friendData objectForKey:@"sent"]]];
    cell.receivedAmountLabel.text = [NSString stringWithFormat:@"$%@", [formatter stringFromNumber:[friendData objectForKey:@"received"]]];
    cell.netIncomeAmountLabel.text = [NSString stringWithFormat:@"$%@", [formatter stringFromNumber:[friendData objectForKey:@"netIncome"]]];
    
    NSNumber *sentAmount = [friendData objectForKey:@"sent"];
    NSNumber *receivedAmount = [friendData objectForKey:@"received"];
    NSInteger netIncome = receivedAmount.integerValue - sentAmount.integerValue;
    if(netIncome < 0){
        cell.netIncomeAmountLabel.textColor = [UIColor redColor];
    }
    else{
        cell.netIncomeAmountLabel.textColor = [UIColor lightGreenColor];
    }
    
    [cell.userImage sd_setImageWithURL:[NSURL URLWithString:transaction.target.picture_url]
                 placeholderImage:[UIImage imageNamed:@"UserImage"]];
    
    return cell;
}

// section title
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSArray *currentFriend = self.transactionsByFriends[section];
    DPRTransaction *transaction = currentFriend[0];
    
    return [transaction.target.fullName uppercaseString];
    
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
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.transactionsByFriends.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

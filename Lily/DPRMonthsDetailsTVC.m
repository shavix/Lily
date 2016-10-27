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
#import "UIColor+CustomColors.h"

@interface DPRMonthsDetailsTVC ()

@property (strong, nonatomic) DPRUser *user;
@property (strong, nonatomic) DPRCoreDataHelper *cdHelper;
@property (strong, nonatomic) DPRTransactionSingleton *transactionSingleton;
@property (strong, nonatomic) NSArray *transactionsByMonth;
@property (strong, nonatomic) NSDictionary *friendsData;

@end

@implementation DPRMonthsDetailsTVC{
    NSInteger currMonth;
    NSInteger currYear;
    NSMutableArray *months;
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
    
    NSArray *tempMonths = @[
                        @"January", @"February", @"March",
                        @"April", @"May", @"June",
                        @"July", @"August", @"September",
                        @"October", @"November", @"December"
                        ];
    months = [[NSMutableArray alloc] init];
    
    for (NSInteger i = currMonth - 1; i >= currMonth - 12; i--){
        NSInteger index = i;
        if(index < 0){
            index += 12;
        }
        [months addObject:tempMonths[index]];
    }
    
}


- (void)setupUI{
    
    self.title = @"Friends";
    self.view.backgroundColor = [UIColor darkColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *identifer = @"monthCell";
    DPRMonthsDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];

    // get data
    NSInteger section = indexPath.section;
    NSInteger index = currMonth - section - 1;
    if(index < 0){
        index += 12;
    }
    
    NSDictionary *monthDict = _transactionsByMonth[index];
    
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
    
    NSString *month = months[section];
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
    
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor whiteColor]];
    
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

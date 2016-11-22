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
@property (strong, nonatomic) DPRUIHelper *uiHelper;
@property (strong, nonatomic) NSDictionary *transactionsByFriends;
@property (strong, nonatomic) NSArray *sortedKeys;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *buttonList;

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
	
	[self sortByName:_buttonList[0]];

}


- (void)setupUI{
    
    self.title = @"Friends";
    self.view.backgroundColor = [UIColor darkColor];
	
	self.tableView.dataSource = self;
	self.tableView.delegate = self;

	// add button
	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(menuShow)];
	self.navigationItem.rightBarButtonItem = addButton;
	
	[self setupMenu];
	
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableTapped:)];
	[self.tableView addGestureRecognizer:tap];

	self.myTableView = self.tableView;

}

- (void)setupMenu{
	
	self.uiHelper = [[DPRUIHelper alloc] init];

	self.buttonList = [_uiHelper createMenuWithVC:self andNumButtons:5 andType:@"friends"];

}

- (void)sortTransactionsWithKey:(NSString *)key{
	NSArray *keys = [self.transactionsByFriends allKeys];
	NSArray *sortedKeys = [keys sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
		
		if([key isEqualToString:@"names"]){
			return [a compare:b];
		}
		
		NSDictionary *first = [self.transactionsByFriends objectForKey:a];
		NSDictionary *second = [self.transactionsByFriends objectForKey:b];
		
		NSNumber *aTransactions = [first objectForKey:key];
		NSNumber *bTransactions = [second objectForKey:key];
		
		return [bTransactions compare:aTransactions];
	}];
	
	_sortedKeys = sortedKeys;
	[UIView transitionWithView: self.tableView
					  duration: 0.5f
					   options: UIViewAnimationOptionTransitionCrossDissolve
					animations: ^(void)
	 {
		 [self.tableView reloadData];
	 }
					completion: nil];
	[self hideMenu];
}

- (void)sortByName:(UIButton *)sender{
	[self sortTransactionsWithKey:@"names"];
	[_uiHelper refreshListButtons:_buttonList withButton:sender];
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

#pragma mark - UITableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    NSString *identifier = @"friendsCell";
    DPRFriendsListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    NSInteger section = indexPath.section;
    
	NSString *name = [_sortedKeys objectAtIndex:section];
    NSDictionary *friendData = [self.transactionsByFriends objectForKey:name];
    
    // format
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setPositiveFormat:@"0.00"];

    
    cell.transactionsAmountLabel.text = [NSString stringWithFormat:@"%@", [friendData objectForKey:@"transactions"]];
    cell.sentAmountLabel.text = [NSString stringWithFormat:@"$%@", [formatter stringFromNumber:[friendData objectForKey:@"sent"]]];
    cell.receivedAmountLabel.text = [NSString stringWithFormat:@"$%@", [formatter stringFromNumber:[friendData objectForKey:@"received"]]];
	
	// netincome
	NSString *netIncomeString = [NSString stringWithFormat:@"$%@", [formatter stringFromNumber:[friendData objectForKey:@"netIncome"]]];
	cell.netIncomeAmountLabel.text = [netIncomeString stringByReplacingOccurrencesOfString:@"-" withString:@""];

	
    NSNumber *sentAmount = [friendData objectForKey:@"sent"];
    NSNumber *receivedAmount = [friendData objectForKey:@"received"];
    double netIncome = receivedAmount.doubleValue - sentAmount.doubleValue;
    if(netIncome < 0){
		cell.netIncomeAmountLabel.textColor = [UIColor redColor];
		cell.netIncomeAverageLabel.textColor = [UIColor redColor];
    }
	else if(netIncome == 0){
		cell.netIncomeAmountLabel.textColor = [UIColor whiteColor];
		cell.netIncomeAverageLabel.textColor = [UIColor whiteColor];
	}
    else{
		cell.netIncomeAmountLabel.textColor = [UIColor lightGreenColor];
		cell.netIncomeAverageLabel.textColor = [UIColor lightGreenColor];
    }
	
	// averages
	cell.sentAverageLabel.text = [NSString stringWithFormat:@"$%@", [formatter stringFromNumber:[friendData objectForKey:@"sentAverage"]]];
	cell.receivedAverageLabel.text = [NSString stringWithFormat:@"$%@", [formatter stringFromNumber:[friendData objectForKey:@"receivedAverage"]]];
	NSNumber *numTransactions = [friendData objectForKey:@"transactions"];
	if(numTransactions == 0){
		cell.netIncomeAverageLabel.text = @"$0.00";
	}
	else{
		double netIncomeAverage = fabs(netIncome / numTransactions.doubleValue);
		cell.netIncomeAverageLabel.text = [NSString stringWithFormat:@"$%.2f", netIncomeAverage];
	}
	// picture
	NSString *picture_url = [friendData objectForKey:@"picture_url"];
    [cell.userImage sd_setImageWithURL:[NSURL URLWithString:picture_url]
                 placeholderImage:[UIImage imageNamed:@"UserImage"]];
    
    return cell;
}

// section title
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
	NSString *name = [_sortedKeys objectAtIndex:section];
	
    return [name uppercaseString];
    
}

- (void)tableTapped:(UITapGestureRecognizer *)tap
{
	[self hideMenu];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	CGRect rect = self.menu.frame;
	rect.origin.y =  scrollView.contentOffset.y;
	
	self.menu.frame = rect;
}
#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger rowHeight = 100;
    
    return rowHeight;
    
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
	
	view.userInteractionEnabled = NO;
    
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

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
    [self calculateFriendsData];
	
	
	NSMutableArray *tempArr = [[NSMutableArray alloc] init];
	for(int i = 0 ;i < _transactionsByFriends.count; i ++){
		DPRTransaction *transaction = self.transactionsByFriends[i][0];
		[tempArr addObject:transaction.target.fullName];
	}
	self.sortedKeys = tempArr;
    
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
		
		DPRTransaction *transaction = currArr[0];
		NSString *picture_url = transaction.target.picture_url;
        
        NSInteger netIncome = amountReceived - amountSent;
        NSInteger transactions = currArr.count;
        
        NSDictionary *friend = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSNumber numberWithInteger:transactions], @"transactions",
                                [NSNumber numberWithInteger:amountSent], @"sent",
                                [NSNumber numberWithInteger:amountReceived], @"received",
                                [NSNumber numberWithInteger:netIncome], @"netIncome",
								picture_url, @"picture_url",
                                nil];
        
		
        [tempFriendsData setObject:friend forKey:transaction.target.fullName];
        
    }
    
    self.friendsData = tempFriendsData;
    
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

	
}

- (void)setupMenu{
	
	DPRUIHelper *uiHelper = [[DPRUIHelper alloc] init];

	// make menu
	CGFloat width = 160;
	CGFloat height = 60;
	CGRect frame = CGRectMake(self.view.frame.size.width - width, -height * 4, width, height * 4);
	UIView *menu = [[UIView alloc] initWithFrame:frame];
	menu.backgroundColor = [UIColor darkishColor];
	menu.layer.zPosition = 990;
	[self.view addSubview:menu];
	self.menu = menu;
	self.menu.hidden = YES;
	
	[uiHelper customizeMenuWithVC:self];

	// make buttons
	[self setupButtons];
	
}

- (void)setupButtons{
	
	CGFloat width = 160;
	
	NSMutableArray *buttons = [[NSMutableArray alloc] init];
	for(int i = 0; i < 4; i++){
		
		CGFloat height = 60;
		CGRect frame = CGRectMake(0, i*height, width, height);
		UIButton *button = [[UIButton alloc] initWithFrame:frame];
		button.layer.zPosition = 999;
		button.titleLabel.textColor = [UIColor whiteColor];
		button.titleLabel.font = [UIFont boldSystemFontOfSize:12];
		button.contentEdgeInsets = UIEdgeInsetsMake(-150, 0, -150, 0); //set as you require


			button.backgroundColor = [UIColor darkishColor];
		
		switch (i) {
			case 0:
				[button setTitle:@"Sort by Transactions" forState:UIControlStateNormal];
				[button addTarget:self action:@selector(sortByTransactions:) forControlEvents:UIControlEventTouchDown];
				break;
			case 1:
				[button setTitle:@"Sort by Received" forState:UIControlStateNormal];
				[button addTarget:self action:@selector(sortByReceived:) forControlEvents:UIControlEventTouchDown];
				break;
			case 2:
				[button setTitle:@"Sort by Sent" forState:UIControlStateNormal];
				[button addTarget:self action:@selector(sortBySent:) forControlEvents:UIControlEventTouchDown];
				break;
			case 3:
				[button setTitle:@"Sort by Net Income" forState:UIControlStateNormal];
				[button addTarget:self action:@selector(sortByNetIncome:) forControlEvents:UIControlEventTouchDown];
				break;
		}
		
		[buttons addObject:button];
		
		[self.menu addSubview:button];
		
	}
	
	self.buttonList = buttons;
	
}

- (void)sortTransactionsWithKey:(NSString *)key{
	NSArray *keys = [self.friendsData allKeys];
	NSArray *sortedKeys = [keys sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
		
		NSDictionary *first = [self.friendsData objectForKey:a];
		NSDictionary *second = [self.friendsData objectForKey:b];
		
		NSNumber *aTransactions = [first objectForKey:key];
		NSNumber *bTransactions = [second objectForKey:key];
		
		return [bTransactions compare:aTransactions];
	}];
	
	_sortedKeys = sortedKeys;
	[self.tableView reloadData];
	[self toggleMenu];
}

- (void)sortByTransactions:(UIButton *)sender{
	[self sortTransactionsWithKey:@"transactions"];
	for(UIButton *button in _buttonList){
		button.backgroundColor = [UIColor darkishColor];
	}
	sender.backgroundColor = [UIColor grayColor];
}

- (void)sortByReceived:(UIButton *)sender{
	[self sortTransactionsWithKey:@"received"];
	for(UIButton *button in _buttonList){
		button.backgroundColor = [UIColor darkishColor];
	}
	sender.backgroundColor = [UIColor grayColor];
}

- (void)sortBySent:(UIButton *)sender{
	[self sortTransactionsWithKey:@"sent"];
	for(UIButton *button in _buttonList){
		button.backgroundColor = [UIColor darkishColor];
	}
	sender.backgroundColor = [UIColor grayColor];
}

- (void)sortByNetIncome:(UIButton *)sender{
	[self sortTransactionsWithKey:@"netIncome"];
	for(UIButton *button in _buttonList){
		button.backgroundColor = [UIColor darkishColor];
	}
	sender.backgroundColor = [UIColor grayColor];
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
    NSDictionary *friendData = [self.friendsData objectForKey:name];
    
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
    NSInteger netIncome = receivedAmount.integerValue - sentAmount.integerValue;
    if(netIncome < 0){
        cell.netIncomeAmountLabel.textColor = [UIColor redColor];
    }
    else{
        cell.netIncomeAmountLabel.textColor = [UIColor lightGreenColor];
    }
	
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

//
//  DPRDashboardVC.m
//  Lily
//
//  Created by David Richardson on 6/22/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import "DPRDashboardVC.h"
#import "DPRUIHelper.h"
#import "DPRUser.h"
#import "DPRCoreDataHelper.h"
#import "DPRTransactionSingleton.h"
#import "DPRVenmoHelper.h"
#import "DPRDashboardTableViewCell.h"
#import "DPRFriendsExpendituresVC.h"
#import "DPRAnalysisListTVC.h"
#import "UIColor+CustomColors.h"

// number of transactions to fetch from server
#define NUM_TRANSACTIONS 10000

@import SwiftSpinner;

@interface DPRDashboardVC()

// data
@property (strong, nonatomic) DPRUser *user;
@property (strong, nonatomic) DPRCoreDataHelper *cdHelper;
@property (strong, nonatomic) DPRUIHelper *uiHelper;
@property (strong, nonatomic) DPRTransactionSingleton *transactionSingleton;
@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSArray *transactionsByDate;


@end

@implementation DPRDashboardVC


- (void)viewDidLoad {
    
    [self setupUI];
    [self retrieveData];
    [self setupData];
    
}


#pragma mark - Data

- (void)retrieveData{
    
    // retrieve user
    self.cdHelper = [DPRCoreDataHelper sharedModel];
    self.user = [self.cdHelper fetchUser];

    // store username
    [self storeUsername];
    
}

- (void)setupData {
    
    // transactionsByDate
    self.transactionSingleton = [DPRTransactionSingleton sharedModel];
    NSArray *results = [self.cdHelper setupTransactionsByDateWithUser:self.user];
    self.transactionSingleton.transactionsByDate = results[0];
    self.transactionSingleton.transactionsByMonth = results[1];
    
}



#pragma mark - UI

- (void)setupUI{
	
	self.tabBarController.delegate = self;
	
	self.uiHelper = [[DPRUIHelper alloc] init];
	[_uiHelper setupTabUI:self withTitle:@"Dashboard"];
	
	self.view.backgroundColor = [UIColor darkColor];
	
	[self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
	
	UIBarButtonItem *newBackButton =
	[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain
									target:nil
									action:nil];
	[[self navigationItem] setBackBarButtonItem:newBackButton];
	
	UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"settings_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(showSettings)];
	
	settingsButton.tintColor = [UIColor lightGreenColor];
	
	UIFont *customFont = [UIFont fontWithName:@"Helvetica" size:24.0];
	NSDictionary *fontDictionary = @{NSFontAttributeName : customFont};
	[settingsButton setTitleTextAttributes:fontDictionary forState:UIControlStateNormal];
	self.navigationItem.rightBarButtonItem = settingsButton;
}

- (void)showSettings{
	[self performSegueWithIdentifier:@"settingsSegue" sender:self];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
	
	NSUInteger count =	_user.transactionList.count;
	
	// check transactions have loaded
	if(count < 1){
		
		[self noTransactions];
		[self deselectCell];
		
		return false;
		
	}
	
	return true;
	
}

- (void)loadMoreTransactions{
	
	// swiftspinner
	[SwiftSpinner showing:0 title:@"loading transactions..." animated:YES];
	
	// setup identifier set
	NSMutableSet *identifierSet = [self.cdHelper setupIdentifierSetWithUser:self.user];
	
	// retrieve recent transactions
	DPRVenmoHelper *venmoHelper = [DPRVenmoHelper sharedModel];
	
	// background thread
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {

		NSArray *tempTransactionsArray = [venmoHelper fetchTransactions:NUM_TRANSACTIONS];
		
		
		// transactions loaded
		dispatch_async(dispatch_get_main_queue(), ^{
			// organize transactions
			[self.cdHelper insertIntoDatabse:tempTransactionsArray withIdentifierSet:identifierSet andUser:self.user];
			[self setupData];
			
			// update UI
			[SwiftSpinner hide:nil];
			[self deselectCell];
			[self.tableView reloadData];
		});
		
	});
	
	
}

- (void)noTransactions{
	// haven't loaded, show notice
	NSString *message = @"No transactions have been loaded!\nTo load transactions, press \"load transactions\" at the bottom of the page (network connection required).";
	NSString *title = @"Notice";
	[_uiHelper alertWithMessage:message andTitle:title andVC:self.parentViewController];
}

#pragma mark - TableView

- (void)deselectCell{
	
	NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
	DPRDashboardTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
	cell.selected = false;
	
}

- (void)segueCheckWithIdentifier:(NSString *)identifier{

	if([self shouldPerformSegueWithIdentifier:identifier sender:self]){
		[self performSegueWithIdentifier:identifier sender:self];
	}

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
	
	if([segue.identifier isEqualToString:@"analysisSegue"]){
		DPRAnalysisListTVC *analysisListTVC = segue.destinationViewController;
		NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
		if(indexPath.section == 0){
			analysisListTVC.pageType = @"Friends";
		}
		else{
			analysisListTVC.pageType = @"This Year";
		}
	}
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger section = indexPath.section;
	
	// NOT TRANSACTIONS
	if(section != 2){
		[self segueCheckWithIdentifier:@"analysisSegue"];
	}

    // TRANSACTIONS
    else{
		[self loadMoreTransactions];
    }
	
	
}

// get cell
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* CellIdentifier = @"GraphCell";
    DPRDashboardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSInteger section = indexPath.section;
	
	
	if(section == 0){
		cell.image.image = [UIImage imageNamed:@"friends"];
		cell.title.text = @"Friends";
		cell.subtitle.text = @"Analyses on your financial habits with friends.";
	}
	else if(section == 1){
		cell.image.image = [UIImage imageNamed:@"monthlyDetails"];
		cell.title.text = @"This Year";
		cell.subtitle.text = @"Analyses on your financial habits over the last year on a monthly basis.";
	}
    // TRANSACTIONS
    else if(section == 2)
    {
		cell.image.image = [UIImage imageNamed:@"loading"];
		cell.title.text = @"Load transactions";
		cell.subtitle.text = [NSString stringWithFormat:@"Load more transactions beyond your most recent (%ld transactions currently loaded).", _user.transactionList.count];
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger rowHeight = 100;
    
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
    else if(section == 1){
        title = @"THIS YEAR";
    }
    else{
        title = @"TRANSACTIONS";
    }
    
    return title;
    
}


-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    
    //Set the background color of the View
    view.tintColor = [UIColor darkColor];
    view.layer.zPosition = -999;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	return 1;
	
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{

	if(_user.transactionList.count < 1){
		self.tabBarController.selectedIndex = 0;
		[self noTransactions];
	}
	
}
#pragma mark - data persistence

- (void)storeUsername {
    
    [[NSUserDefaults standardUserDefaults] setObject:self.user.username forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}



@end

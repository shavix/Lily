//
//  DPRAnalysisListTVC.m
//  Lily
//
//  Created by David Richardson on 11/13/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import "DPRAnalysisListTVC.h"
#import "DPRUIHelper.h"
#import "DPRUser.h"
#import "DPRCoreDataHelper.h"
#import "DPRTransactionSingleton.h"
#import "DPRVenmoHelper.h"
#import "DPRAnalysisListTableViewCell.h"
#import "DPRFriendsExpendituresVC.h"
#import "UIColor+CustomColors.h"

@interface DPRAnalysisListTVC ()

// data
@property (strong, nonatomic) DPRUser *user;
@property (strong, nonatomic) DPRCoreDataHelper *cdHelper;
@property (strong, nonatomic) DPRUIHelper *uiHelper;
@property (strong, nonatomic) DPRTransactionSingleton *transactionSingleton;
@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSArray *transactionsByDate;

@end

@implementation DPRAnalysisListTVC{
	NSArray *sectionNames;
	NSArray *segueIdentifiers;
	NSArray *sectionSubtitles;
	NSArray *sectionImageNames;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
	[self setupUI];
	[self setupGlobals];
	
}

#pragma mark - UI

- (void)setupUI{
	self.title = _pageType;
	self.view.backgroundColor = [UIColor darkColor];
	[self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if(section == 0){
		return 4;
	}
	else{
		return 1;
	}
}

// get cell
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
	static NSString* CellIdentifier = @"AnalysisCell";
	DPRAnalysisListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	NSInteger section = indexPath.section;
	NSInteger row = indexPath.row;
	
	NSString *subtitle;
	// CHARTS
	if(section == 0){
		if([_pageType isEqualToString:@"Friends"]){
			subtitle = sectionSubtitles[2 * row];
		}
		else{
			subtitle = sectionSubtitles[2 * row + 1];
		}
		cell.image.image = [UIImage imageNamed:sectionImageNames[row]];
	}
	// LISTS
	else if(section == 1)
	{
		cell.image.image = [UIImage imageNamed:@"friendDetails"];
		if([_pageType isEqualToString:@"Friends"]){
			subtitle = sectionSubtitles[10];
		}
		else{
			subtitle = sectionSubtitles[11];
		}
	}
	
	// subtitle
	cell.subtitle.text = subtitle;

	// title
	NSInteger index = section * (sectionNames.count-1) + row;
	cell.title.text = [NSString stringWithFormat:@"%@ -", _pageType];
	cell.title2.textColor = [UIColor lightGreenColor];
	cell.title2.text = [NSString stringWithFormat:@"%@",sectionNames[index]];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	
	NSInteger row = indexPath.row;
	NSInteger section = indexPath.section;
	
	NSString *segueIdentifier;
	 // FRIENDS
	 if([_pageType isEqualToString:@"Friends"]){
		 // GRAPHS
		 if(section == 0){
			 segueIdentifier = segueIdentifiers[row];
		 }
		 // LISTS
		 else{
			 segueIdentifier = segueIdentifiers[4];
		 }
	 }
	 // THIS YEAR
	 else{
		 // GRAPHS
		 if(section == 0){
			 segueIdentifier = segueIdentifiers[row + 5];
		 }
		 // LISTS
		 else{
			 segueIdentifier = segueIdentifiers[9];
		 }
	 }
	[self performSegueWithIdentifier:segueIdentifier sender:self];
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 100;	
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 40;
}


// section title
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	NSString *title;
	if(section == 0){
		title = @"Charts";
	}
	else{
		title = @"Lists";
	}
	return [title uppercaseString];
}


-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
	view.tintColor = [UIColor darkColor];
	view.layer.zPosition = -999;
}

- (void)setupGlobals{
	sectionNames = @[@"Transactions", @"Expenditures", @"Income", @"Net Income", @"Full Details"];
	segueIdentifiers = @[@"friendsTransactionsSegue",
						 @"friendsExpendituresSegue",
						 @"friendsIncomeSegue",
						 @"friendsNetIncomeSegue",
						 @"friendsDetailsSegue",
						 @"monthsTransactionsSegue",
						 @"monthsExpendituresSegue",
						 @"monthsIncomeSegue",
						 @"monthsNetIncomeSegue",
						 @"monthsDetailsSegue"
							];
	sectionSubtitles = @[@"A graphical analysis of your transaction frequency with friends.",
						 @"A graphical analysis of your transaction frequency over the last year on a monthly basis.",
						 @"A graphical analysis of your expenditures with friends.",
						 @"A graphical analysis of your expenditures over the last year on a monthly basis.",
						 @"A graphical analysis of your income from friends.",
						 @"A graphical analysis of your income over the last year on a monthly basis.",
						 @"A graphical analysis of your net income with friends.",
						 @"A graphical analysis of your net income over the last year on a monthly basis.",
						 @"All financial information on your transaction history with friends.",
						 @"All your financial information over the last year on a monthly basis.",
						 @"All financial information on your transaction history with friends.",
						 @"All your financial information over the last year on a monthly basis."];
	
	sectionImageNames = @[@"handshake",@"payment", @"businessman", @"monthlyIncome"];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}


@end

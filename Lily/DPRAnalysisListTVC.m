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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
	[self setupUI];
	[self setupData];
	
}

- (void)setupData {
	
	sectionNames = @[@"Expenditures", @"Net Income", @"Full Details"];
	
}

#pragma mark - UI

- (void)setupUI{
	

	self.title = _pageType;
	
	self.view.backgroundColor = [UIColor darkColor];
	
	[self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
	
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if(section == 0){
		return 2;
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
		if(row == 0){
			cell.image.image = [UIImage imageNamed:@"payment"];
			if([_pageType isEqualToString:@"Friends"]){
				subtitle = @"A graphical analysis of your expenditures with friends.";
			}
			else{
				subtitle = @"A graphical analysis of your expenditures over the last year on a monthly basis.";
			}
		}
		// NET INCOME
		else if(row == 1){
			cell.image.image = [UIImage imageNamed:@"monthlyIncome"];
			if([_pageType isEqualToString:@"Friends"]){
				subtitle = @"A graphical analysis of your expenditures with friends.";
			}
			else{
				subtitle = @"A graphical analysis of your net income over the last year on a monthly basis.";
			}
		}
	}
	// LISTS
	else if(section == 1)
	{
		cell.image.image = [UIImage imageNamed:@"friendDetails"];
		if([_pageType isEqualToString:@"Friends"]){
			subtitle = @"All financial information between you and your friends.";
		}
		else{
			subtitle = @"All your financial information over the last year on a monthly basis.";
		}
	}
	
	// subtitle
	cell.subtitle.text = subtitle;

	// title
	NSInteger index = section * 2 + row;
	cell.title.text = _pageType;
	cell.title.textColor = [UIColor lightGreenColor];
	cell.title2.text = [NSString stringWithFormat:@"- %@",sectionNames[index]];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	
	NSInteger section = indexPath.row;
	
	 // FRIENDS
	 if([_pageType isEqualToString:@"Friends"]){
		// transactions
		if(section == 0){
			[self performSegueWithIdentifier:@"friendsExpendituresSegue" sender:self];
		}
		// net income
		else if(section == 1){
			[self performSegueWithIdentifier:@"friendsNetIncomeSegue" sender:self];
		}
		// full details
		else if(section == 2){
			[self performSegueWithIdentifier:@"friendsDetailsSegue" sender:self];
		}
	 }
	 // THIS YEAR
	 else if([_pageType isEqualToString:@"This Year"]){
		// expenditures
		if(section == 0){
			[self performSegueWithIdentifier:@"monthsExpendituresSegue" sender:self];
		}
		// net income
		else if(section == 1){
			[self performSegueWithIdentifier:@"monthsNetIncomeSegue" sender:self];
		}
		// full details
		else if(section == 2){
			[self performSegueWithIdentifier:@"monthsDetailsSegue" sender:self];
		}
	 }
	 
	
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
	
	//Set the background color of the View
	view.tintColor = [UIColor darkColor];
	view.layer.zPosition = -999;
	
}

@end

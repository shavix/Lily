//
//  DPRGraphsVC.m
//  Lily
//
//  Created by David Richardson on 6/22/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import "DPRGraphListVC.h"
#import "DPRUIHelper.h"
#import "DPRUser.h"
#import "DPRCoreDataHelper.h"
#import "DPRTransactionSingleton.h"
#import "DPRVenmoHelper.h"
#import "DPRGraphTableViewCell.h"
#import "DPRFriendsTransactionsVC.h"
#import "UIColor+CustomColors.h"

#define NUM_TRANSACTIONS 500

@interface DPRGraphListVC()

// data
@property (strong, nonatomic) DPRUser *user;
@property (strong, nonatomic) DPRCoreDataHelper *cdHelper;
@property (strong, nonatomic) DPRUIHelper *uiHelper;
@property (strong, nonatomic) DPRTransactionSingleton *transactionSingleton;
@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSArray *transactionsByDate;


@end

@implementation DPRGraphListVC

#pragma mark - on load

- (void)viewDidLoad {
    
    [self setupUI];
    [self retrieveData];
    [self setupData];
    
}

- (void)setupUI{
    
    self.uiHelper = [[DPRUIHelper alloc] init];
    [_uiHelper setupTabUI:self withTitle:@"Dashboard"];
    
    self.view.backgroundColor = [UIColor darkColor];
    
    //[self.tableView setContentInset:UIEdgeInsetsMake(30,0,0,0)];
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


- (void)retrieveData{
    
    // retrieve user
    self.cdHelper = [DPRCoreDataHelper sharedModel];
    self.user = [self.cdHelper fetchUser];
    
    // setup identifier set
    NSMutableSet *identifierSet = [self.cdHelper setupIdentifierSetWithUser:self.user];
    
#warning PHONE ACQUIRED - incomplete
    // retrieve recent transactions
    DPRVenmoHelper *venmoHelper = [DPRVenmoHelper sharedModel];
    NSArray *tempTransactionsArray = [venmoHelper fetchTransactions:NUM_TRANSACTIONS];
    
    // organize transactions
    [self.cdHelper insertIntoDatabse:tempTransactionsArray withIdentifierSet:identifierSet andUser:self.user];
    
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

#pragma mark - TableView

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
	
	// TRANSACTIONS
	if(section == 0){
		
	}
    // FRIENDS
    else if(section == 1){
        // transactions
        if(row == 0){
            [self performSegueWithIdentifier:@"friendsTransactionsSegue" sender:self];
        }
        // net income
        else if(row == 1){
            [self performSegueWithIdentifier:@"friendsNetIncomeSegue" sender:self];
        }
        // full details
        else if(row == 2){
            [self performSegueWithIdentifier:@"friendsListSegue" sender:self];
        }
    }
    // MONTHLY
    else if(section == 2){
        // expenditures
        if(row == 0){
            [self performSegueWithIdentifier:@"monthsExpendituresSegue" sender:self];
        }
        // net income
        else if(row == 1){
            [self performSegueWithIdentifier:@"monthsNetIncomeSegue" sender:self];
        }
        // full details
        else if(row == 2){
            [self performSegueWithIdentifier:@"monthsDetailsSegue" sender:self];
        }
    }
    

    
}

// get cell
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* CellIdentifier = @"GraphCell";
    DPRGraphTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
	
	
	// TRANSACTIONS
	if(section == 0){
		cell.image.image = [UIImage imageNamed:@"loading"];
		cell.title.text = @"Load transactions";
		cell.subtitle.text = @"Load more transactions beyond your most recent 100 (default setting).";
	}
    // FRIENDS
    else if(section == 1)
    {
        if(row == 0){
            cell.image.image = [UIImage imageNamed:@"handshake.png"];
            cell.title.text = @"Number of Transactions";
            cell.subtitle.text = @"A graphical analysis of your transaction frequency with friends.";
        }
        else if(row == 1){
            cell.image.image = [UIImage imageNamed:@"businessman.png"];
            cell.title.text = @"Net Income";
            cell.subtitle.text = @"A graphical analysis of your net income with friends.";
        }
        else if(row == 2){
            cell.image.image = [UIImage imageNamed:@"details.png"];
            cell.title.text = @"Full details";
            cell.subtitle.text = @"All financial information between you and your friends.";
        }
    }
    // MONTHLY
    else if(section == 2)
    {
        if(row == 0){
            cell.image.image = [UIImage imageNamed:@"payment.png"];
            cell.title.text = @"Expenditures";
            cell.subtitle.text = @"A graphical analysis of your expenditures on a monthly basis.";
        }
        else if(row == 1){
            cell.image.image = [UIImage imageNamed:@"monthlyIncome.png"];
            cell.title.text = @"Net Income";
            cell.subtitle.text = @"A graphical analysis of your net income on a monthly basis.";
        }
        else if(row == 2){
            cell.image.image = [UIImage imageNamed:@"monthlyDetails.png"];
            cell.title.text = @"Full details";
            cell.subtitle.text = @"All your financial information on a monthly basis.";
        }
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
		title = @"TRANSACTIONS";
	}
    else if(section == 1){
        title = @"FRIENDS";
    }
    else{
        title = @"MONTHLY";
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
	
	if(section == 0){
		return 1;
	}
	
    return 3;
}

#pragma mark - data persistence

- (void)storeUsername {
    
    [[NSUserDefaults standardUserDefaults] setObject:self.user.username forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}



@end

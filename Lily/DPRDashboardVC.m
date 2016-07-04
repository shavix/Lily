//
//  DPRDashboardVC.m
//  Lily
//
//  Created by David Richardson on 6/22/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import "DPRDashboardVC.h"
#import "DPRProfileView.h"
#import "DPRBalanceView.h"
#import "DPRTransactionsView.h"
#import "DPRCashFlowView.h"
#import "DPRUIHelper.h"
#import "DPRAppDelegate.h"
#import "DPRCoreDataHelper.h"
#import "DPRVenmoHelper.h"
#import "DPRTransactionSingleton.h"
#import "DPRTransactionTableViewCell.h"
#import "DPRTransaction.h"
#import "DPRTarget.h"
#import "UIColor+CustomColors.h"

@interface DPRDashboardVC()

// IB
@property (weak, nonatomic) IBOutlet UIBarButtonItem *settingsButton;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *profilePictureView;
@property (weak, nonatomic) IBOutlet UILabel *profileNicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *profileNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UIView *profileBorder;
@property (weak, nonatomic) IBOutlet UIView *balanceBorder;
@property (weak, nonatomic) IBOutlet UIView *transactionsBorder;
@property (weak, nonatomic) IBOutlet UIView *cashFlowBorder;
@property (weak, nonatomic) IBOutlet UITableView *transactionTableView;

// 4 UIViews & container view
@property (weak, nonatomic) IBOutlet DPRProfileView *profileView;
@property (weak, nonatomic) IBOutlet DPRBalanceView *balanceView;
@property (weak, nonatomic) IBOutlet DPRTransactionsView *transactionsView;
@property (weak, nonatomic) IBOutlet DPRCashFlowView *cashFlowView;


// data
@property (strong, nonatomic) DPRUser *user;
@property (strong, nonatomic) DPRCoreDataHelper *cdHelper;
@property (strong, nonatomic) DPRTransactionSingleton *transactionSingleton;
@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSArray *transactionsByDate;
@property (strong, nonatomic) NSArray *firstTransactions;

@end

@implementation DPRDashboardVC



#pragma mark - on load

- (void)viewDidLoad {
    
    [self retrieveData];
    [self setupData];
    [self setupUI];
    
}

- (void)retrieveData{
    
    // retrieve user
    self.cdHelper = [DPRCoreDataHelper sharedModel];
    self.user = [self.cdHelper fetchUser];
    
    // setup identifier set
    NSMutableSet *identifierSet = [self.cdHelper setupIdentifierSetWithUser:self.user];
    
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

    // transactionTableView
    self.transactionTableView.dataSource = self;
    self.transactionTableView.delegate = self;
    
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

- (void)setupUI{
    
    DPRUIHelper *UIHelper = [[DPRUIHelper alloc] init];
    [UIHelper setupTabUI:self withTitle:@"Dashboard"];
    
    // views
    [UIHelper setupDashboardViewUI:_profileView];
    [UIHelper setupDashboardViewUI:_balanceView];
    [UIHelper setupDashboardViewUI:_transactionsView];
    [UIHelper setupDashboardViewUI:_cashFlowView];
    
    // colors
    _settingsButton.tintColor = [UIColor lightGreenColor];
    _contentView.backgroundColor = [UIColor lightColor];
    self.profileBorder.backgroundColor = [UIColor lightColor];
    self.balanceBorder.backgroundColor = [UIColor lightColor];
    self.cashFlowBorder.backgroundColor = [UIColor lightColor];
    self.transactionsBorder.backgroundColor = [UIColor lightColor];
    
    [self setupProfileView];
    [self setupBalanceView];
    [self setupTransactionsView];
    [self setupCashFlowView];
    
}



#pragma mark - views

// PROFILE
- (void)setupProfileView{
    
    _profilePictureView.image = _user.pictureImage;
    _profilePictureView.layer.cornerRadius = 10;
    _profileNameLabel.text = _user.fullName;
    _profileNameLabel.textColor = [UIColor lightGreenColor];
    
    NSString *username = [NSString stringWithFormat:@"@%@", _user.username];
    _profileNicknameLabel.text = username;
    _profileNicknameLabel.textColor = [UIColor lightGreenColor];
    _profileNicknameLabel.alpha = 0.8;
    [_profileNicknameLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12.0]];
    
}

// BALANCE
- (void)setupBalanceView{
    
    NSString *balanceStr = [NSString stringWithFormat:@"$%@", _user.balance];
    _balanceLabel.text = balanceStr;
    _balanceLabel.textColor = [UIColor lightGreenColor];
    [_balanceLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14.0]];

}

// CASH FLOW
- (void)setupCashFlowView{
    
}


#pragma mark - IBOutlets

- (IBAction)transactionsButtonClicked:(id)sender {
    
    [self.tabBarController setSelectedIndex:2];
    
}





#pragma mark - Transactions

// TRANSACTIONS
- (void)setupTransactionsView{
    
    [self.transactionTableView setSeparatorInset:UIEdgeInsetsZero];

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:  (NSIndexPath *)indexPath{
    
    static NSString* CellIdentifier = @"TransactionCell";
    DPRTransactionTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    DPRTransaction *transaction = self.firstTransactions[indexPath.row];
    
    // transactionLabel
    cell.transactionLabel.text = transaction.transactionDescription;
    
    // noteLabel
    cell.noteLabel.text = transaction.note;
    
    // amount
    [self setupAmountLabel:cell.amountLabel withTransaction:transaction];
    
    // image
    [self setupImageView:cell.cellImage withTransaction:transaction];
    
    return cell;
    
}


// amountLabel
- (void)setupAmountLabel:(UILabel *)amountLabel withTransaction:(DPRTransaction *)transaction{
    
    // color
    if(transaction.isIncoming) {
        amountLabel.textColor = [UIColor lightGreenColor];
    }
    else{
        amountLabel.textColor = [UIColor redColor];
    }
    
    // format
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setPositiveFormat:@"##.00"];
    
    amountLabel.text = [NSString stringWithFormat:@"$%@", [formatter stringFromNumber:transaction.amount]];
    
}

// image
- (void)setupImageView:(UIImageView *)imageView withTransaction:(DPRTransaction *)transaction {
    
    // user image
    if(transaction.isSender){
        imageView.image = transaction.user.pictureImage;
    }
    // target image
    else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:transaction.target.picture_url]]];
            
            if(!image){
                image = [UIImage imageNamed:@"UserImage"];
            }
            
            dispatch_sync(dispatch_get_main_queue(), ^(void) {
                imageView.image = image;
            });
        });
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    DPRTransaction *transaction = self.firstTransactions[indexPath.row];
    
#warning clean
    NSString *cellText = transaction.note;
    CGSize constraintSize = CGSizeMake(3*self.transactionTableView.frame.size.width/5, MAXFLOAT);
    UIFont *fontText = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
    CGRect labelSize = [cellText boundingRectWithSize:constraintSize options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName: fontText} context:nil];
    
    return labelSize.size.height + 40;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}



#pragma mark - boring

// retrieve AppDelegate's managedObjectContext
- (NSManagedObjectContext *)managedObjectContext {
    return [(DPRAppDelegate *) [[UIApplication sharedApplication] delegate] managedObjectContext];
}



- (void)storeUsername {
    
    [[NSUserDefaults standardUserDefaults] setObject:self.user.username forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}



@end

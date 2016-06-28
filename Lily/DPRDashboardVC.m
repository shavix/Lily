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
#import "UIColor+CustomColors.h"

@interface DPRDashboardVC()

// data
@property (strong, nonatomic) DPRUser *user;
@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;


// IB
@property (weak, nonatomic) IBOutlet UIBarButtonItem *settingsButton;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *profilePictureView;
@property (weak, nonatomic) IBOutlet UILabel *profileNicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *profileNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;

// 4 UIViews & container view
@property (weak, nonatomic) IBOutlet DPRProfileView *profileView;
@property (weak, nonatomic) IBOutlet DPRBalanceView *balanceView;
@property (weak, nonatomic) IBOutlet DPRTransactionsView *transactionsView;
@property (weak, nonatomic) IBOutlet DPRCashFlowView *cashFlowView;

@end

@implementation DPRDashboardVC



#pragma mark - on load

- (void)viewDidLoad {
    
    [self setupData];
    
    [self setupUI];
    
}

- (void)setupData{
    
    // retrieve user
    // check if user exists in core data
    DPRCoreDataHelper *cdHelper = [DPRCoreDataHelper sharedModel];
    self.user = [cdHelper fetchUser];
    
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
    _profileNicknameLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    
}

// BALANCE
- (void)setupBalanceView{
    
    NSString *balanceStr = [NSString stringWithFormat:@"$%@", _user.balance];
    _balanceLabel.text = balanceStr;
    _balanceLabel.textColor = [UIColor lightGreenColor];
    _balanceLabel.font = [UIFont boldSystemFontOfSize:14.0f];

}

// TRANSACTIONS
- (void)setupTransactionsView{
    
}

// CASH FLOW
- (void)setupCashFlowView{
    
}




// retrieve AppDelegate's managedObjectContext
- (NSManagedObjectContext *)managedObjectContext {
    return [(DPRAppDelegate *) [[UIApplication sharedApplication] delegate] managedObjectContext];
}


@end

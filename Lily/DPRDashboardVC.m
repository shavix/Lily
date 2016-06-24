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
#import "DPRUser.h"

#import "UIColor+CustomColors.h"

@interface DPRDashboardVC()

// data
@property (strong, nonatomic) DPRUser *user;

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
    
    self.user = [DPRUser sharedModel];
    
}

- (void)setupUI{
    
    DPRUIHelper *UIHelper = [[DPRUIHelper alloc] init];
    [UIHelper setupTabUI:self withTitle:@"Dashboard"];
    
    // colors
    _settingsButton.tintColor = [UIColor lightGreenColor];
    _contentView.backgroundColor = [UIColor charcoalColor];
    _profileView.backgroundColor = [UIColor lightGreenColor];
    _balanceView.backgroundColor = [UIColor lightGreenColor];
    _transactionsView.backgroundColor = [UIColor lightGreenColor];
    _cashFlowView.backgroundColor = [UIColor lightGreenColor];
    
    [self setupProfileView];
    [self setupBalanceView];
    [self setupTransactionsView];
    [self setupCashFlowView];
    
}



#pragma mark - views

- (void)setupProfileView{
    
    _profilePictureView.image = _user.pictureImage;
    _profileNameLabel.text = _user.displayName;
    
    NSString *username = [NSString stringWithFormat:@"@%@", _user.username];
    _profileNicknameLabel.text = username;
    _profileNicknameLabel.textColor = [UIColor charcoalColor];
    _profileNicknameLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    
}

- (void)setupBalanceView{
    
    NSString *balanceStr = [NSString stringWithFormat:@"$%@", _user.balance];
    _balanceLabel.text = balanceStr;
    _balanceLabel.textColor = [UIColor charcoalColor];
    _balanceLabel.font = [UIFont boldSystemFontOfSize:14.0f];

}

- (void)setupTransactionsView{
    
}

- (void)setupCashFlowView{
    
}






@end

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

#import "UIColor+CustomColors.h"

@interface DPRDashboardVC()

// IB
@property (weak, nonatomic) IBOutlet UIBarButtonItem *settingsButton;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *profileNicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *profileNameLabel;

// 4 UIViews & container view
@property (weak, nonatomic) IBOutlet DPRProfileView *profileView;
@property (weak, nonatomic) IBOutlet DPRBalanceView *balanceView;
@property (weak, nonatomic) IBOutlet DPRTransactionsView *transactionsView;
@property (weak, nonatomic) IBOutlet DPRCashFlowView *cashFlowView;

@end

@implementation DPRDashboardVC



#pragma mark - on load

- (void)viewDidLoad {
    
    [self setupUI];
    
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
    
}

- (void)setupBalanceView{
    
}

- (void)setupTransactionsView{
    
}

- (void)setupCashFlowView{
    
}






@end

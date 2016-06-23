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

// 4 UIViews & container view
@property DPRProfileView *profileView;
@property DPRBalanceView *balanceView;
@property DPRTransactionsView *transactionsView;
@property DPRCashFlowView *cashFlowView;

@end


@implementation DPRDashboardVC


#pragma mark - on load

- (void)viewDidLoad {
    
    [self setupUI];
    
}

- (void)setupUI{
    
    DPRUIHelper *UIHelper = [[DPRUIHelper alloc] init];
    [UIHelper setupTabUI:self withTitle:@"Dashboard"];

}






@end

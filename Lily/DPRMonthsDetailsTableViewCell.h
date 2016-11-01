//
//  DPRMonthsDetailsTableViewCell.h
//  Lily
//
//  Created by David Richardson on 10/27/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DPRMonthsDetailsTableViewCell : UITableViewCell

// UI
@property (weak, nonatomic) IBOutlet UILabel *transactionsAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *receivedAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *sentAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *netIncomeAmountLabel;

@end

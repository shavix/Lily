//
//  DPRMonthsDetailsTableViewCell.m
//  Lily
//
//  Created by David Richardson on 10/27/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import "DPRMonthsDetailsTableViewCell.h"
#import "DPRUIHelper.h"
#import "UIColor+CustomColors.h"

@implementation DPRMonthsDetailsTableViewCell

- (void)awakeFromNib {
	
    [super awakeFromNib];
	
	DPRUIHelper *uiHelper = [[DPRUIHelper alloc] init];
	[uiHelper setupCell:self];
    
    self.backgroundColor = [UIColor charcoalColor];
    self.sentAmountLabel.textColor = [UIColor redColor];
    self.receivedAmountLabel.textColor = [UIColor lightGreenColor];
    
    // fonts
	UIFont *font = [UIFont fontWithName:@"Helvetica-Light" size:14];
	
	self.transactionsAmountLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:14];
    self.sentAmountLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:14];
    self.receivedAmountLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:14];
    self.netIncomeAmountLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:14];

	self.selectionStyle = UITableViewCellSelectionStyleNone;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

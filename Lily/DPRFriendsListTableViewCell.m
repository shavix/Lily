//
//  DPRFriendsListTableViewCell.m
//  Lily
//
//  Created by David Richardson on 10/24/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import "DPRFriendsListTableViewCell.h"
#import "DPRUIHelper.h"
#import "UIFont+CustomFonts.h"
#import "UIColor+CustomColors.h"

@implementation DPRFriendsListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
	
	DPRUIHelper *uiHelper = [[DPRUIHelper alloc] init];
	[uiHelper setupCell:self];

    self.backgroundColor = [UIColor charcoalColor];
    self.sentAmountLabel.textColor = [UIColor redColor];
    self.receivedAmountLabel.textColor = [UIColor lightGreenColor];
    self.userImage.layer.cornerRadius = 50/8;
    self.userImage.clipsToBounds = YES;

    // fonts
	UIFont *font = [UIFont helvetica14];
	self.transactionsAmountLabel.font = font;
	self.sentAmountLabel.font = font;
    self.receivedAmountLabel.font = font;
    self.netIncomeAmountLabel.font = font;

	
	self.selectionStyle = UITableViewCellSelectionStyleNone;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

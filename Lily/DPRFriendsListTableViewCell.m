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
	self.receivedAverageLabel.textColor = [UIColor lightGreenColor];
	self.sentAverageLabel.textColor = [UIColor redColor];

    // fonts
	UIFont *font = [UIFont helveticaBold13];
	self.transactionsAmountLabel.font = font;
	self.sentAmountLabel.font = font;
    self.receivedAmountLabel.font = font;
    self.netIncomeAmountLabel.font = font;
	self.sentAverageLabel.font = font;
	self.receivedAverageLabel.font = font;
	self.netIncomeAverageLabel.font = font;

	font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.0];
	self.receivedLabel.font = font;
	self.sentLabel.font = font;
	self.netIncomeLabel.font = font;
	self.transactionsLabel.font = font;
	self.averageLabel.font = font;

	// average label
	//self.averageLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0];;
	NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
	self.averageLabel.attributedText = [[NSAttributedString alloc] initWithString:@"Average"
																	   attributes:underlineAttribute];
	

	self.selectionStyle = UITableViewCellSelectionStyleNone;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

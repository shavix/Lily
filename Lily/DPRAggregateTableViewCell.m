//
//  DPRAggregateTableViewCell.m
//  Lily
//
//  Created by David Richardson on 11/16/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import "DPRAggregateTableViewCell.h"
#import "DPRUIHelper.h"
#import "UIColor+CustomColors.h"
#import "UIFont+CustomFonts.h"

@implementation DPRAggregateTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
	

	self.backgroundColor = [UIColor charcoalColor];
	self.sentAmountLabel.textColor = [UIColor redColor];
	self.sentAverageLabel.textColor = [UIColor redColor];
	self.receivedAmountLabel.textColor = [UIColor lightGreenColor];
	self.receivedAverageLabel.textColor = [UIColor lightGreenColor];
	self.image.layer.cornerRadius = 70/8;
	self.image.clipsToBounds = YES;
	
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
	self.transactionsLabel.font = font;
	self.sentLabel.font = font;
	self.receivedLabel.font = font;
	self.netIncomeLabel.font = font;
	self.averageLabel.font = font;

	// average label
	NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
	self.averageLabel.attributedText = [[NSAttributedString alloc] initWithString:@"Average"
																	   attributes:underlineAttribute];
	self.title.font = [UIFont helveticaBold13];
	self.title.attributedText = [[NSAttributedString alloc] initWithString:@"Aggregate"
															   attributes:underlineAttribute];
	
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	
	CALayer *topBorder = [CALayer layer];
	topBorder.borderColor = [UIColor lightGrayColor].CGColor;
	topBorder.borderWidth = 1;
	topBorder.frame = CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame) * 2, 1);
	
	CALayer *bottomBorder = [CALayer layer];
	bottomBorder.borderColor = [UIColor lightGrayColor].CGColor;
	bottomBorder.borderWidth = 1;
	bottomBorder.frame = CGRectMake(0, 119, CGRectGetWidth(self.contentView.frame) * 2, 1);
	
	[self.contentView.layer addSublayer:topBorder];
	[self.contentView.layer addSublayer:bottomBorder];
	
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

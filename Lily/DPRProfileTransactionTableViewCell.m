//
//  DPRProfileTransactionTableViewCell.m
//  Lily
//
//  Created by David Richardson on 11/16/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import "DPRProfileTransactionTableViewCell.h"
#import "DPRUIHelper.h"
#import "UIFont+CustomFonts.h"
#import "UIColor+CustomColors.h"

@implementation DPRProfileTransactionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
	
	DPRUIHelper *uiHelper = [[DPRUIHelper alloc] init];
	[uiHelper setupCell:self];
	
	self.image.layer.cornerRadius = 0.75*70/8;
	self.image.clipsToBounds = YES;
	self.backgroundColor = [UIColor charcoalColor];
	
	self.cellTitle.font = [UIFont helveticaBold13];
	self.cellTitle.textColor = [UIColor lightGreenColor];
	self.title.font = [UIFont boldSystemFontOfSize:12];
	self.subtitle.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11];
	self.amountLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
	self.dateLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];

	self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

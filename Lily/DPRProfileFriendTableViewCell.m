//
//  DPRProfileFriendTableViewCell.m
//  Lily
//
//  Created by David Richardson on 11/16/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import "DPRProfileFriendTableViewCell.h"
#import "DPRUIHelper.h"
#import "UIFont+CustomFonts.h"
#import "UIColor+CustomColors.h"

@implementation DPRProfileFriendTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
	
	self.title.font = [UIFont boldSystemFontOfSize:12];
	self.cellTitle.font = [UIFont helveticaBold13];
	self.cellTitle.textColor = [UIColor lightGreenColor];
	self.subtitle.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.0];
	self.backgroundColor = [UIColor charcoalColor];
	self.image.layer.cornerRadius = 70/8;
	self.image.clipsToBounds = YES;
	self.amountLabel.textColor = [UIColor lightGreenColor];
	self.amountLabel.font = [UIFont helveticaBold13];
	DPRUIHelper *uiHelper = [[DPRUIHelper alloc] init];
	[uiHelper setupCell:self];
	
	self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

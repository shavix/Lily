//
//  DPRProfileTableViewCell.m
//  Lily
//
//  Created by David Richardson on 11/16/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import "DPRProfileTableViewCell.h"
#import "DPRUIHelper.h"
#import "UIFont+CustomFonts.h"
#import "UIColor+CustomColors.h"

@implementation DPRProfileTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
	
	self.backgroundColor = [UIColor charcoalColor];
	self.image.layer.cornerRadius = 70/8;
	self.image.clipsToBounds = YES;
	
	self.title.font = [UIFont helveticaBold13];
	self.title.textColor = [UIColor lightGreenColor];
	self.sentLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.0];
	self.receivedLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.0];
	
	CALayer *topBorder = [CALayer layer];
	topBorder.borderColor = [UIColor lightGrayColor].CGColor;
	topBorder.borderWidth = 1;
	topBorder.frame = CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame), 1);
	
	CALayer *bottomBorder = [CALayer layer];
	bottomBorder.borderColor = [UIColor lightGrayColor].CGColor;
	bottomBorder.borderWidth = 1;
	bottomBorder.frame = CGRectMake(0, 119, CGRectGetWidth(self.contentView.frame), 1);
	
	[self.contentView.layer addSublayer:topBorder];
	[self.contentView.layer addSublayer:bottomBorder];
	
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

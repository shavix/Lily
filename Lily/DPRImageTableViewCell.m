//
//  DPRImageTableViewCell.m
//  Lily
//
//  Created by David Richardson on 11/27/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import "DPRImageTableViewCell.h"
#import "UIColor+CustomColors.h"

@implementation DPRImageTableViewCell

- (void)awakeFromNib {
	[super awakeFromNib];
	
	self.backgroundColor = [UIColor darkColor];
	//self.customImageView.layer.cornerRadius = 70/8;
	//self.customImageView.clipsToBounds = YES;
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
	
	// Configure the view for the selected state
}
@end

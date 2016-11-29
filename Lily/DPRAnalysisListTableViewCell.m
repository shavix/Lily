//
//  DPRAnalysisListTableViewCell.m
//  Lily
//
//  Created by David Richardson on 11/13/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import "DPRAnalysisListTableViewCell.h"
#import "DPRUIHelper.h"
#import "UIColor+CustomColors.h"

@implementation DPRAnalysisListTableViewCell

- (void)awakeFromNib {
	[super awakeFromNib];
	
	DPRUIHelper *uiHelper = [[DPRUIHelper alloc] init];
	[uiHelper setupCell:self withHeight:100];
	
	self.title.font = [UIFont boldSystemFontOfSize:14];
	self.title2.font = [UIFont boldSystemFontOfSize:14];
	self.subtitle.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.0];
	self.backgroundColor = [UIColor charcoalColor];
	self.image.layer.cornerRadius = 70/8;
	self.image.clipsToBounds = YES;
	
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

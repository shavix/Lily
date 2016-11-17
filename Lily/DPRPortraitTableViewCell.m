//
//  DPRPortraitTableViewCell.m
//  Lily
//
//  Created by David Richardson on 11/16/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import "DPRPortraitTableViewCell.h"
#import "UIColor+CustomColors.h"

@implementation DPRPortraitTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];


	self.title.font = [UIFont boldSystemFontOfSize:14];
	self.subtitle.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.0];
	self.backgroundColor = [UIColor darkColor];
	self.image.layer.cornerRadius = 70/8;
	self.image.clipsToBounds = YES;
	self.selectionStyle = UITableViewCellSelectionStyleNone;

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

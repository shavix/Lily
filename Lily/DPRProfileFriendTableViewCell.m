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
	self.title.textColor = [UIColor whiteColor];
	self.backgroundColor = [UIColor charcoalColor];
	self.image.layer.cornerRadius = 70/8;
	self.image.clipsToBounds = YES;
	self.amountLabel.textColor = [UIColor lightGreenColor];
	self.amountLabel.font = [UIFont helveticaBold13];
	DPRUIHelper *uiHelper = [[DPRUIHelper alloc] init];
	[uiHelper setupCell:self withHeight:90];
	
	self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)drawLine{
	CGRect titleFrame = self.title.frame;
	CGRect amountFrame = self.amountLabel.frame;
	
	float titleWidth = [self.title.text
					 boundingRectWithSize:self.title.frame.size
					 options:NSStringDrawingUsesLineFragmentOrigin
					 attributes:@{ NSFontAttributeName:self.title.font }
					 context:nil].size.width;
	
	CAShapeLayer *shapelayer = [CAShapeLayer layer];
	UIBezierPath *path = [UIBezierPath bezierPath];
	
	[path moveToPoint:CGPointMake(titleFrame.origin.x, titleFrame.origin.y + titleFrame.size.height)];
	[path addLineToPoint:CGPointMake(amountFrame.origin.x + amountFrame.size.width, titleFrame.origin.y + titleFrame.size.height)];
	UIColor *fill = [UIColor colorWithRed:0.80f green:0.80f blue:0.80f alpha:1.00f];
	shapelayer.strokeStart = 0.0;
	shapelayer.strokeColor = fill.CGColor;
	shapelayer.lineWidth = 2.0;
	shapelayer.lineJoin = kCALineJoinRound;
	shapelayer.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:2],[NSNumber numberWithInt:3 ], nil];
	shapelayer.path = path.CGPath;
	
	[self.layer addSublayer:shapelayer];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

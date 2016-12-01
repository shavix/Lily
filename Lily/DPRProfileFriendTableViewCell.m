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

@interface DPRProfileFriendTableViewCell()

@property (strong, nonatomic) CAShapeLayer *shapelayer;

@end

@implementation DPRProfileFriendTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
	
	self.title.font = [UIFont fontWithName:@"Helvetica" size:12];
	self.title.textColor = [UIColor whiteColor];
	self.backgroundColor = [UIColor charcoalColor];
	self.image.layer.cornerRadius = 70/8;
	self.image.clipsToBounds = YES;
	self.amountLabel.textColor = [UIColor lightGreenColor];
	self.amountLabel.font = [UIFont fontWithName:@"Helvetica" size:18];
	DPRUIHelper *uiHelper = [[DPRUIHelper alloc] init];
	[uiHelper setupCell:self withHeight:90];
	
	self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)prepareForReuse{
	CAShapeLayer *layer = self.shapelayer;
	[layer removeFromSuperlayer];
}

- (void)drawLineWithView:(UIView *)view{
	
	CGSize titleSize = self.title.intrinsicContentSize;
	CGSize amountSize = self.amountLabel.intrinsicContentSize;
	
	NSInteger startX = 75;
	NSInteger finishX = view.frame.size.width - 10 - amountSize.width - 9;
	NSInteger startY = 63;
	self.shapelayer = [CAShapeLayer layer];
	UIBezierPath *path = [UIBezierPath bezierPath];
	
	[path moveToPoint:CGPointMake(startX +  titleSize.width, startY)];
	[path addLineToPoint:CGPointMake(finishX, startY)];
	UIColor *fill = [UIColor colorWithRed:0.80f green:0.80f blue:0.80f alpha:1.00f];
	_shapelayer.strokeStart = 0.0;
	_shapelayer.strokeColor = fill.CGColor;
	_shapelayer.lineWidth = 2.0;
	_shapelayer.lineJoin = kCALineJoinRound;
	_shapelayer.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:2],[NSNumber numberWithInt:3 ], nil];
	_shapelayer.path = path.CGPath;
	[self.layer addSublayer:_shapelayer];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end

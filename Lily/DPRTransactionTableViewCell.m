//
//  DPRTransactionTableViewCell.m
//  Lily
//
//  Created by David Richardson on 6/29/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import "DPRTransactionTableViewCell.h"
#import "UIFont+CustomFonts.h"

@implementation DPRTransactionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
        
    self.cellImage.layer.cornerRadius = 0.75*70/8;
    self.cellImage.clipsToBounds = YES;
    
    self.transactionLabel.font = [UIFont boldSystemFontOfSize:12];
    self.amountLabel.font = [UIFont helveticaBold13];
    self.noteLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
	CALayer *topBorder = [CALayer layer];
	topBorder.borderColor = [UIColor lightGrayColor].CGColor;
	topBorder.borderWidth = 1;
	topBorder.frame = CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame) * 2, 1);
	
	CALayer *bottomBorder = [CALayer layer];
	bottomBorder.borderColor = [UIColor lightGrayColor].CGColor;
	bottomBorder.borderWidth = 1;
	bottomBorder.frame = CGRectMake(0, 69, CGRectGetWidth(self.contentView.frame) * 2, 1);
	
	[self.contentView.layer addSublayer:topBorder];
	[self.contentView.layer addSublayer:bottomBorder];
	
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}






@end

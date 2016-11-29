//
//  DPRTransactionTableViewCell.m
//  Lily
//
//  Created by David Richardson on 6/29/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import "DPRTransactionTableViewCell.h"
#import "DPRUIHelper.h"
#import "UIColor+CustomColors.h"
#import "UIFont+CustomFonts.h"

@implementation DPRTransactionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
        
    self.cellImage.layer.cornerRadius = 0.75*70/8;
    self.cellImage.clipsToBounds = YES;
	self.backgroundColor = [UIColor charcoalColor];
	
    self.transactionLabel.font = [UIFont boldSystemFontOfSize:12];
    self.amountLabel.font = [UIFont helveticaBold13];
    self.noteLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
	
	DPRUIHelper *uiHelper = [[DPRUIHelper alloc] init];
	[uiHelper setupCell:self withHeight:70];
	
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}






@end

//
//  DPRMonthsDetailsTableViewCell.m
//  Lily
//
//  Created by David Richardson on 10/27/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import "DPRMonthsDetailsTableViewCell.h"
#import "UIColor+CustomColors.h"

@implementation DPRMonthsDetailsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor charcoalColor];
    self.sentAmountLabel.textColor = [UIColor redColor];
    self.receivedAmountLabel.textColor = [UIColor lightGreenColor];
    
    // fonts
    self.transactionsAmountLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:14];
    self.sentAmountLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:14];
    self.receivedAmountLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:14];
    self.netIncomeAmountLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:14];
    
    CALayer *topBorder = [CALayer layer];
    topBorder.borderColor = [UIColor lightGrayColor].CGColor;
    topBorder.borderWidth = 1;
    topBorder.frame = CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame), 1);
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.borderColor = [UIColor lightGrayColor].CGColor;
    bottomBorder.borderWidth = 1;
    bottomBorder.frame = CGRectMake(0, 99, CGRectGetWidth(self.contentView.frame), 1);
    
    [self.contentView.layer addSublayer:topBorder];
    [self.contentView.layer addSublayer:bottomBorder];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

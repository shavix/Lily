//
//  DPRTransactionTableViewCell.m
//  Lily
//
//  Created by David Richardson on 6/29/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import "DPRTransactionTableViewCell.h"

@implementation DPRTransactionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.cellImage.layer.cornerRadius = 0.75*70/2;
    self.cellImage.clipsToBounds = YES;
    
    self.transactionLabel.font = [UIFont boldSystemFontOfSize:12];
    self.amountLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
    self.noteLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}






@end

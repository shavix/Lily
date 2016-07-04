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
    // Initialization code
    
    self.cellImage.layer.cornerRadius = self.cellImage.frame.size.width/2;
    self.cellImage.clipsToBounds = YES;
    
    self.noteLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
    self.amountLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

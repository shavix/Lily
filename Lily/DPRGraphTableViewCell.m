//
//  DPRGraphTableViewCell.m
//  Lily
//
//  Created by David Richardson on 10/21/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import "DPRGraphTableViewCell.h"

@implementation DPRGraphTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.title.font = [UIFont boldSystemFontOfSize:14];
    self.subtitle.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.0];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  DPRProfileTableViewCell.h
//  Lily
//
//  Created by David Richardson on 11/16/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DPRProfileTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *subtitle;

- (void)setupCell;

@end

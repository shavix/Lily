//
//  DPRAnalysisListTableViewCell.h
//  Lily
//
//  Created by David Richardson on 11/13/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DPRAnalysisListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *subtitle;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *title2;

@end

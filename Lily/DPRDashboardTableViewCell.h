//
//  DPRDashboardTableViewCell.h
//  Lily
//
//  Created by David Richardson on 10/21/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DPRDashboardTableViewCell : UITableViewCell


// UI
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *subtitle;

// properties
@property (weak, nonatomic) NSNumber *height;

@end

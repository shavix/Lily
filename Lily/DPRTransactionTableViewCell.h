//
//  DPRTransactionTableViewCell.h
//  Lily
//
//  Created by David Richardson on 6/29/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DPRTransactionTableViewCell : UITableViewCell

// UI
@property (weak, nonatomic) IBOutlet UIImageView *cellImage;
@property (weak, nonatomic) IBOutlet UILabel *transactionLabel;
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;

@end

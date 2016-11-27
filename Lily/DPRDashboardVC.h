//
//  DPRDashboardVC.h
//  Lily
//
//  Created by David Richardson on 6/22/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import <UIKit/UIKit.h>

// number of transactions to fetch from server
#define NUM_TRANSACTIONS 10000

@interface DPRDashboardVC : UITableViewController <UITabBarControllerDelegate>


- (void)setupData;

@end

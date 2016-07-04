//
//  DPRUIHelper.m
//  Lily
//
//  Created by David Richardson on 6/23/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import "DPRUIHelper.h"
#import "UIColor+CustomColors.h"

@implementation DPRUIHelper

- (void)setupTabUI:(UIViewController *)viewController withTitle:(NSString *)title{

    // setup navigationController
    viewController.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    viewController.navigationController.navigationBar.translucent = NO;
    viewController.navigationController.navigationBar.topItem.title = title;
    [viewController.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor lightGreenColor]}];
    // setup viewController
    viewController.view.backgroundColor = [UIColor lightColor];
    
}

- (void)setupDashboardViewUI:(UIView *)view {
    
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 5;
    
}

@end

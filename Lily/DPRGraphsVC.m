//
//  DPRGraphsVC.m
//  Lily
//
//  Created by David Richardson on 6/22/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import "DPRGraphsVC.h"
#import "DPRUIHelper.h"

#import "UIColor+CustomColors.h"

@implementation DPRGraphsVC

#pragma mark - on load

- (void)viewDidLoad {
    
    [self setupUI];
    
}

- (void)setupUI{
    
    DPRUIHelper *UIHelper = [[DPRUIHelper alloc] init];
    [UIHelper setupTabUI:self withTitle:@"Graphs"];
    
}




@end

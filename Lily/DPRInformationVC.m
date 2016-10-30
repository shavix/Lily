//
//  DPRInformationVC.m
//  Lily
//
//  Created by David Richardson on 10/30/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import "DPRInformationVC.h"
#import "DPRContentHelper.h"
#import "UIColor+CustomColors.h"

@interface DPRInformationVC ()

@property (strong, nonatomic) DPRContentHelper *contentHelper;

@property (weak, nonatomic) IBOutlet UITextView *textView;
@end

@implementation DPRInformationVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setupData];
    [self setupUI];
    
}

- (void)setupData{
    
    self.contentHelper = [[DPRContentHelper alloc] init];
    
}

- (void)setupUI{
    
    self.view.backgroundColor = [UIColor darkColor];
    self.title = _pageType;
    
    self.textView.text = [_contentHelper contentTextWithPageType:_pageType];
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

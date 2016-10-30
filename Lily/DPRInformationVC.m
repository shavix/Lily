//
//  DPRInformationVC.m
//  Lily
//
//  Created by David Richardson on 10/30/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import "DPRInformationVC.h"
#import "DPRContentHelper.h"
#import "DPRUIHelper.h"
#import "UIColor+CustomColors.h"

@interface DPRInformationVC ()

@property (strong, nonatomic) DPRContentHelper *contentHelper;
@property (strong, nonatomic) DPRUIHelper *uiHelper;

@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;
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
    self.uiHelper = [[DPRUIHelper alloc] init];
}

- (void)setupUI{
    
    self.view.backgroundColor = [UIColor darkColor];
    self.title = _pageType;
    
    
    // about
    if([_pageType isEqualToString:@"About"]){
        NSString *text = [_contentHelper contentTextWithPageType:_pageType];
        self.bottomLabel.text = text;
        self.bottomLabel.textColor = [UIColor blackColor];
    }
    // help
    else if([_pageType isEqualToString:@"Help"]){
        self.textView.hidden = YES;
        self.bottomLabel.hidden = YES;
        [self alertWithMessage:@"Would you like help notifications?" andTitle:@"Help"];
    }
    // licenses
    else{
        self.textView.text = [_contentHelper contentTextWithPageType:_pageType];
    }
    
}


- (void) alertWithMessage:(NSString *)message andTitle:(NSString *)title {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [_uiHelper notificationsStatus:@"y"];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [_uiHelper notificationsStatus:@"n"];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

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
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *lilyButton;

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
	_bottomLabel.hidden = YES;
	_facebookButton.hidden = YES;
	_label.hidden = YES;
	_lilyButton.hidden = YES;
	
    // about
    if([_pageType isEqualToString:@"About"]){
		[self setupAboutPage];
    }
    // help
    else if([_pageType isEqualToString:@"Help"]){
        self.textView.attributedText = [_contentHelper helpContent];
    }
    // licenses
    else{
        self.textView.text = [_contentHelper contentTextWithPageType:_pageType];
    }
    self.textView.textAlignment = NSTextAlignmentJustified;

}

- (void)setupAboutPage{
	
	// text
	NSString *text = [_contentHelper contentTextWithPageType:_pageType];
	_bottomLabel.hidden = NO;
	_lilyButton.hidden = NO;
	self.bottomLabel.text = text;
	self.bottomLabel.textColor = [UIColor whiteColor];
	_textView.backgroundColor = [UIColor darkColor];
	_label.hidden = NO;
	_label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:28];
	
	// button
	_facebookButton.hidden = NO;
	_facebookButton.layer.cornerRadius = 5;
	_facebookButton.clipsToBounds = YES;
	
}


// open facebook page in safari
- (IBAction)facebookPressed:(id)sender {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/ShavidApps.Lily/"]];
}

// open lily page in safari
- (IBAction)lilyButtonPressed:(id)sender {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.drich.us/lily.html"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

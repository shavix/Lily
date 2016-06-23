//
//  DPRWalkthroughVC.m
//  Lily
//
//  Created by David Richardson on 6/22/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import "DPRWalkthroughVC.h"
#import "DPRVenmoHelper.h"
#import "DPRUser.h"

@interface DPRWalkthroughVC()

@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) NSString *accessToken;

@end

@implementation DPRWalkthroughVC


#pragma mark - UIViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self EAIntro];
    
}

- (void)webRequest {
    
    self.webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    _webView.delegate = self;
    
    // access payment history
    NSString *paymentURL=@"https://api.venmo.com/v1/oauth/authorize?client_id=3213&scope=access_payment_history%20access_profile%20access_balance&response_type=token";
    NSURL *nsurl=[NSURL URLWithString:paymentURL];
    
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
    [_webView loadRequest:nsrequest];
    [self.view addSubview:_webView];
    
}

#pragma mark - EAIntro

// perform web request when intro finishes
- (void)introDidFinish:(EAIntroView *)introView wasSkipped:(BOOL)wasSkipped{
    
    self.navigationController.navigationBarHidden = NO;
    
    [self webRequest];
    
}


- (void)EAIntro {
    
    self.navigationController.navigationBarHidden = YES;
    
    EAIntroPage *page1 = [EAIntroPage page];
    page1.title = @"Lily";
    page1.desc = @"The world's first Venmo financial manager.";
    page1.bgImage = [UIImage imageNamed:@"bg1"];
    page1.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title1"]];
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.title = @"Analytics";
    page2.desc = @"Lily delivers in-depth data analytics on all your previous transactions";
    page2.bgImage = [UIImage imageNamed:@"bg2"];
    page2.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title2"]];
    
    EAIntroPage *page3 = [EAIntroPage page];
    page3.title = @"Free";
    page3.desc = @"Lily is free forver. No ads. No subscription fees.";
    page3.bgImage = [UIImage imageNamed:@"bg3"];
    page3.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title3"]];
    
    EAIntroPage *page4 = [EAIntroPage page];
    page4.title = @"Let's start!";
    page4.desc = @"Simply enter your Venmo credentials on the next page and start managing!";
    page4.bgImage = [UIImage imageNamed:@"bg4"];
    page4.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title4"]];
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:@[page1,page2,page3,page4]];
    
    [intro setDelegate:self];
    
    [intro showInView:self.view animateDuration:0.3];
    
}


#pragma mark - UIWebView

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    // get substring
    NSString *URLString = [[request URL] absoluteString];
    NSLog(@"url string = %@\n", URLString);
    NSString *firstPartOfURL = [URLString substringToIndex:22];
    
    // if web redirect - get access token
    if ([firstPartOfURL isEqualToString:@"http://www.google.com/"]) {
        
        _accessToken = [URLString substringFromIndex:23];
        NSArray *temp = [_accessToken componentsSeparatedByString:@"="];
        _accessToken = temp[1];
        
        // store access token to NSUserDefaults
        [self storeAccessToken];
        
        [self signedIn];
        
    }
    return YES;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    NSLog(@"DONE");
    
}

#pragma mark - Sign In

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

- (void)signedIn {
    
    // create user
    DPRVenmoHelper *venmoHelper = [[DPRVenmoHelper alloc] init];
    NSDictionary *userInformation = [venmoHelper userInformationWithAccessToken:_accessToken];
    DPRUser *user = [DPRUser sharedModel];
    [user userInformation:userInformation andAccessToken:_accessToken];
    
    // segue to home page
    self.navigationController.navigationBarHidden = YES;

}


#pragma mark - accessToken

- (void)storeAccessToken {
    
    [[NSUserDefaults standardUserDefaults] setObject:_accessToken forKey:@"accessToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}





@end

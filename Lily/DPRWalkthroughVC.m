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
#import "DPRUser.h"
#import "DPRCoreDataHelper.h"
#import "DPRAppDelegate.h"
#import "UIColor+CustomColors.h"

@interface DPRWalkthroughVC()

@property (strong, nonatomic) UIWebView *webView;

@property (weak, nonatomic) DPRVenmoHelper *venmoHelper;
@property (weak, nonatomic) DPRCoreDataHelper *cdHelper;
@property (strong, nonatomic) NSString *accessToken;
@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;

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


#pragma mark - UIWebView

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    // get substring
    NSString *URLString = [[request URL] absoluteString];
	
	// already have access token, do nothing
	if(_accessToken){
		
		// if web redirect - get access token
		if ([URLString rangeOfString:@"webview-auth"].location != NSNotFound) {
			
			// store access token to NSUserDefaults
			[self storeAccessToken];
			[self signedIn];
		}

	}
	else{
	
		// redirect via google.com
		if ([URLString rangeOfString:@"google.com"].location != NSNotFound) {
			_accessToken = [URLString substringFromIndex:23];
		}
		
		// if web redirect - get access token
		if ([URLString rangeOfString:@"webview_auth"].location != NSNotFound) {
	
			NSArray *temp = [_accessToken componentsSeparatedByString:@"="];
			_accessToken = temp[1];
			
			// store access token to NSUserDefaults
			[self storeAccessToken];
			[self signedIn];
		}
		
	}
    return YES;
}

#pragma mark - Sign In

- (void)signedIn {
    
    // retrieve user information
	NSDictionary *userInformation = [self retrieveInformation];
    
	[self checkCoreDataWithUserInformation:userInformation];
    DPRUser *user = [_cdHelper fetchUser];
    
    // create new user - insert into Core Data
    if(!user){
		[self createUser:user withInformation:userInformation andAccessToken:_accessToken];
    }
	
	// set picture for singleton
    NSString *pictureURL = [[userInformation objectForKey:@"user"] objectForKey:@"profile_picture_url"];
    user.pictureImage = [_venmoHelper fetchProfilePictureWithImageURL:pictureURL];
    
    // venmo helper managedobjectcontext
    _venmoHelper.managedObjectContext = self.managedObjectContext;

	[self goToDashboard];
	
}

- (NSDictionary *)retrieveInformation{
	
	self.venmoHelper = [DPRVenmoHelper sharedModel];
	_venmoHelper.accessToken = self.accessToken;
	
	return [_venmoHelper fetchUserInformation];
}

- (void)checkCoreDataWithUserInformation:(NSDictionary *)userInformation{
	// check if user exists in core data
	self.cdHelper = [DPRCoreDataHelper sharedModel];
	NSString *username = [[userInformation objectForKey:@"user"] objectForKey:@"username"];
	_cdHelper.username = username;
}

- (void)createUser:(DPRUser *)user withInformation:(NSDictionary *)userInformation andAccessToken:(NSString *)accessToken{
	// create new user - insert into Core Data
	user = [NSEntityDescription insertNewObjectForEntityForName:@"DPRUser" inManagedObjectContext:self.managedObjectContext];
	[user userInformation:userInformation andAccessToken:accessToken];
	
	NSError *error = nil;
	[self.managedObjectContext save:&error];
	if(error){
		// handle error
	}
}

- (void)goToDashboard{
	// segue to home page
	self.navigationController.navigationBarHidden = YES;
	[self performSegueWithIdentifier:@"signedInSegue" sender:self];
}

#pragma mark - EAIntro

// perform web request when intro finishes
- (void)introDidFinish:(EAIntroView *)introView wasSkipped:(BOOL)wasSkipped{
	self.navigationController.navigationBarHidden = NO;
	[self webRequest];
}


- (void)EAIntro {
	
	// ui settings
	self.navigationController.navigationBarHidden = YES;
	CGRect frame = CGRectMake(0, self.view.frame.size.height/8, self.view.frame.size.width/2, self.view.frame.size.width/2);
	CGFloat height = self.view.frame.size.height/6;
	UIColor *backgroundColor = [UIColor darkishColor];
	
	EAIntroPage *page1 = [EAIntroPage page];
	page1.title = @"Lily";
	page1.desc = @"The world's first Venmo financial manager.";
	//page1.bgImage = [UIImage imageNamed:@"bg1"];
	page1.bgColor = backgroundColor;
	page1.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"presentation"]];
	page1.titleIconView.frame = frame;
	page1.titleIconPositionY = height;
	
	EAIntroPage *page2 = [EAIntroPage page];
	page2.title = @"Analytics";
	page2.desc = @"Lily delivers in-depth data analytics on all your previous transactions";
	//page2.bgImage = [UIImage imageNamed:@"bg2"];
	page2.bgColor = backgroundColor;
	page2.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"graph"]];
	page2.titleIconView.frame = frame;
	page2.titleIconPositionY = height;
	
	EAIntroPage *page3 = [EAIntroPage page];
	page3.title = @"Free";
	page3.desc = @"Lily is free forver. No ads. No subscription fees.";
	//page3.bgImage = [UIImage imageNamed:@"bg3"];
	page3.bgColor = backgroundColor;
	page3.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"free"]];
	page3.titleIconView.frame = frame;
	page3.titleIconPositionY = height;
	
	EAIntroPage *page4 = [EAIntroPage page];
	page4.title = @"Let's start!";
	page4.desc = @"Simply enter your Venmo credentials on the next page and start managing!";
	//page4.bgImage = [UIImage imageNamed:@"bg4"];
	page4.bgColor = backgroundColor;
	page4.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"athletics"]];
	page4.titleIconView.frame = frame;
	page4.titleIconPositionY = height;
	
	EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:@[page1,page2,page3,page4]];
	
	[intro setDelegate:self];
	
	[intro showInView:self.view animateDuration:0.3];
	
}


#pragma mark - accessToken

- (void)storeAccessToken {
	
    [[NSUserDefaults standardUserDefaults] setObject:_accessToken forKey:@"accessToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

// retrieve AppDelegate's managedObjectContext
- (NSManagedObjectContext *)managedObjectContext {
    return [(DPRAppDelegate *) [[UIApplication sharedApplication] delegate] managedObjectContext];
}





@end

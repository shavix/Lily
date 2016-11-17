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
#import "Reachability.h"
#import "UIColor+CustomColors.h"
#import "UIFont+CustomFonts.h"

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
			NSArray *temp = [URLString componentsSeparatedByString:@"="];
			_accessToken = temp[1];
			// sign in
			[self signedIn];
		}
		
		// if web redirect - get access token
		else if ([URLString rangeOfString:@"webview_auth"].location != NSNotFound) {
			NSArray *temp = [URLString componentsSeparatedByString:@"="];
			_accessToken = temp[1];
			// sign in
			[self signedIn];
		}
		
	}
    return YES;
}

#pragma mark - Sign In

- (void)signedIn {
	
	// store access token to NSUserDefaults
	[self storeAccessToken];
	
    // retrieve user information
	NSDictionary *userInformation = [self retrieveInformation];
    
	[self checkCoreDataWithUserInformation:userInformation];
    DPRUser *user = [_cdHelper fetchUser];
    
    // create new user - insert into Core Data
    if(!user){
		user = [self createUser:user withInformation:userInformation andAccessToken:_accessToken];
    }
	
	// set picture for singleton
    NSString *imageURL = [[userInformation objectForKey:@"user"] objectForKey:@"profile_picture_url"];
	user.pictureImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
    
    // venmo helper managedobjectcontext
    _venmoHelper.managedObjectContext = self.managedObjectContext;

	[self setupDashboard];
	
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

- (DPRUser *)createUser:(DPRUser *)user withInformation:(NSDictionary *)userInformation andAccessToken:(NSString *)accessToken{
	// create new user - insert into Core Data
	user = [NSEntityDescription insertNewObjectForEntityForName:@"DPRUser" inManagedObjectContext:self.managedObjectContext];
	[user userInformation:userInformation andAccessToken:accessToken];
	
	NSError *error = nil;
	[self.managedObjectContext save:&error];
	if(error){
		// handle error
	}
	return user;
}

- (void)setupDashboard{
	
	// change status bar style back
	[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

	// segue to home page
	self.navigationController.navigationBarHidden = YES;
	UIStoryboard *aStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
	UITabBarController *tabBarController = [aStoryboard instantiateViewControllerWithIdentifier:@"tabBarController"];

	[self presentViewController:tabBarController animated:YES completion:nil];
}

#pragma mark - EAIntro

// perform web request when intro finishes
- (void)introDidFinish:(EAIntroView *)introView wasSkipped:(BOOL)wasSkipped{
	self.navigationController.navigationBarHidden = NO;
	[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
	[self webRequest];
}


- (void)EAIntro {
	
	// ui settings
	self.navigationController.navigationBarHidden = YES;
	CGRect frame = CGRectMake(0, self.view.frame.size.height/8, self.view.frame.size.width/2, self.view.frame.size.width/2);
	CGFloat height = self.view.frame.size.height/4;
	UIColor *backgroundColor = [UIColor darkishColor];
	
	EAIntroPage *page1 = [EAIntroPage page];
	page1.title = @"Lily";
	page1.desc = @"The world's first financial manager for all your Venmo transactions.";
	page1.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"money_suitcase_circular"]];
	
	EAIntroPage *page2 = [EAIntroPage page];
	page2.title = @"Analytics";
	page2.desc = @"Lily delivers in-depth data analytics on all your Venmo transactions.";
	page2.bgColor = backgroundColor;
	page2.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bars-chart"]];
	
	EAIntroPage *page3 = [EAIntroPage page];
	page3.title = @"Let's start!";
	page3.desc = @"Simply sign in to your Venmo account on the next page and start managing!";
	page3.bgColor = backgroundColor;
	page3.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"athletics"]];
	
	NSArray *pages = @[page1,page2,page3];
	for(EAIntroPage *page in pages){
		page.bgColor = backgroundColor;
		
		// title
		page.titleFont = [UIFont helveticaBold32];
		page.descFont = [UIFont helvetica20];
		page.titleIconView.frame = frame;
		page.titleIconPositionY = height;
		page.descSideMargin = 40;
		page.descPositionY += 60;
	}
	
	EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:pages];
	
	[intro setDelegate:self];
	
	[intro showInView:self.view animateDuration:0.3];
	
}


#pragma mark - accessToken

- (void)storeAccessToken {
	
    [[NSUserDefaults standardUserDefaults] setObject:_accessToken forKey:@"DPRAccessToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

// retrieve AppDelegate's managedObjectContext
- (NSManagedObjectContext *)managedObjectContext {
    return [(DPRAppDelegate *) [[UIApplication sharedApplication] delegate] managedObjectContext];
}





@end

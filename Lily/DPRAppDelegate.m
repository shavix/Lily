//
//  AppDelegate.m
//  Lily
//
//  Created by David Richardson on 6/22/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import "DPRAppDelegate.h"
#import "DPRVenmoHelper.h"
#import "DPRUser.h"
#import "DPRWalkthroughVC.h"
#import "DPRUser.h"
#import "DPRCoreDataHelper.h"
#import "UIColor+CustomColors.h"

@interface DPRAppDelegate ()

@property (strong, nonatomic) DPRVenmoHelper *venmoHelper;
@property (strong, nonatomic) DPRCoreDataHelper *cdHelper;

@end

@implementation DPRAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];

	[self uiSettings];
	[self setupData];

    // check if user is logged in
    NSString *accessToken = [[NSUserDefaults standardUserDefaults]stringForKey:@"accessToken"];
    NSString *username = [[NSUserDefaults standardUserDefaults]stringForKey:@"username"];
    self.venmoHelper.accessToken = accessToken;
    NSDictionary *userInformation = [self.venmoHelper fetchUserInformation];
    
    // authorized - start login
    if(userInformation){
        [self createLoginWithInformation:userInformation andAccessToken:accessToken];
    }
    // not authorized
    else{

		// search core data
		self.cdHelper.username = username;
		DPRUser *user = [self.cdHelper fetchUser];
		
		// no accesstoken, no user in core data - walkthrough
		if(!user){
			[self goToWalkthrough];
		}
		// no accesstoken, user in core data - skip walkthrough
		else{
			[self goToDashboard];
		}
    }
    return YES;
}


- (void)createLoginWithInformation:(NSDictionary *)userInformation andAccessToken:(NSString *)accessToken {
    
    // create user
    _venmoHelper.managedObjectContext = _managedObjectContext;

    // check if user exists in core data
    NSString *username = [[userInformation objectForKey:@"user"] objectForKey:@"username"];
    self.cdHelper.username = username;
    DPRUser *user = [self.cdHelper fetchUser];
    
    if(!user){
		[self createUser:user withInformation:userInformation andAccessToken:accessToken];
    }
	
	// set picture for singleton
	NSString *imageURL = [[userInformation objectForKey:@"user"] objectForKey:@"profile_picture_url"];
	user.pictureImage = user.pictureImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
	
	[self goToDashboard];
    
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
	// set root view controller
	UIStoryboard *aStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
	UITabBarController *tabBarController = [aStoryboard instantiateViewControllerWithIdentifier:@"tabBarController"];
	
	self.window.rootViewController = tabBarController;
	[self.window makeKeyAndVisible];
}

- (void)goToWalkthrough{
    // set venmoViewController as initialViewController
    UIStoryboard *aStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    DPRWalkthroughVC *vc = [aStoryboard instantiateViewControllerWithIdentifier:@"walkthroughVC"];
    UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = navCtrl;
    [self.window makeKeyAndVisible];
}

- (void)uiSettings{
	// initial settings
	[[UITabBar appearance] setTintColor:[UIColor lightGreenColor]];
	[[UITabBar appearance] setBarTintColor:[UIColor darkishColor]];
	[[UILabel appearance] setFont:[UIFont fontWithName:@"Helvetica-Light" size:14.0]];
	[[UILabel appearance] setTextColor:[UIColor whiteColor]];
	[[UINavigationBar appearance] setTintColor:[UIColor lightGreenColor]];
	[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
	[[UILabel appearanceWhenContainedInInstancesOfClasses:@[[UITableViewHeaderFooterView class]]] setTextColor:[UIColor whiteColor]];
}

- (void)setupData{
	self.cdHelper = [DPRCoreDataHelper sharedModel];
	self.venmoHelper = [DPRVenmoHelper sharedModel];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "edu.usc.Lily" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Lily" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Lily.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


#pragma mark - application states

- (void)applicationWillResignActive:(UIApplication *)application {
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


@end

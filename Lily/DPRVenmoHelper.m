//
//  DPRVenmoHelper.m
//  Lily
//
//  Created by David Richardson on 6/22/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import "DPRVenmoHelper.h"
#import "DPRTransaction.h"
#import "DPRCoreDataHelper.h"
#import "DPRProfileTVC.h"

@import SwiftSpinner;

@implementation DPRVenmoHelper

#pragma mark - User

// make call to get user information
- (NSDictionary *)fetchUserInformation {
    
    NSString *urlString = [NSString stringWithFormat:@"https://api.venmo.com/v1/me?access_token=%@", self.accessToken];
	
	id json = [self makeNetworkCallWithURLString:urlString];
    
    NSDictionary *userInformation = [json objectForKey:@"data"];
	
    return userInformation;
    
}

- (NSArray *)fetchTransactions:(NSInteger)count {
	
	NSString *urlString = [NSString stringWithFormat:@"https://api.venmo.com/v1/payments?access_token=%@&limit=%ld", self.accessToken, (long)count];
	
	id json = [self makeNetworkCallWithURLString:urlString];
	
	// create transactions objects
	NSArray *tempTransactionsArray = [json objectForKey:@"data"];
	
	return tempTransactionsArray;
}

- (id)makeNetworkCallWithURLString:(NSString *)urlString{
	
	// setup request
	NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
	[urlRequest setHTTPMethod:@"GET"];
	NSURL *url = [NSURL URLWithString:urlString];
	NSError *error = nil;
	NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
	
	// check error
	if (error)
	{
		NSLog(@"%s: dataWithContentsOfURL error: %@", __FUNCTION__, error);
		return nil;
	}
	
	// return json data
	id json = [NSJSONSerialization JSONObjectWithData: data options:NSJSONReadingMutableContainers error: &error];
	return json;

}

- (void)loadMoreTransactionsWithVC:(UITableViewController *)vc{
	
	DPRCoreDataHelper *cdHelper = [DPRCoreDataHelper sharedModel];
	DPRUser *user = [cdHelper fetchUser];
	// swiftspinner
	[SwiftSpinner showing:0 title:@"loading transactions..." animated:YES];
	
	// setup identifier set
	NSMutableSet *identifierSet = [cdHelper setupIdentifierSet];
	
	// retrieve recent transactions
	DPRVenmoHelper *venmoHelper = [DPRVenmoHelper sharedModel];
	
	// background thread
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
		
		NSArray *tempTransactionsArray = [venmoHelper fetchTransactions:NUM_TRANSACTIONS];
		
		// transactions loaded
		dispatch_async(dispatch_get_main_queue(), ^{
			// organize transactions
			[cdHelper insertIntoDatabse:tempTransactionsArray withIdentifierSet:identifierSet andUser:user];

			// Profile
			DPRProfileTVC *pvc = (DPRProfileTVC *)vc;
			[pvc setupData];
		
			// update UI
			[SwiftSpinner hide:nil];
			
			// deselect cell
			NSIndexPath *indexPath = [vc.tableView indexPathForSelectedRow];
			UITableViewCell *cell = [vc.tableView cellForRowAtIndexPath:indexPath];
			cell.selected = false;
			
			[vc.tableView reloadData];
		});
		
	});
	
}


#pragma mark - Init

// shared instance
+ (instancetype)sharedModel {
	
	static DPRVenmoHelper *_sharedModel = nil;
	
	static dispatch_once_t onceToken;
	
	dispatch_once (&onceToken, ^{
		_sharedModel = [[self alloc] init];
	});
	return _sharedModel;
	
}

@end

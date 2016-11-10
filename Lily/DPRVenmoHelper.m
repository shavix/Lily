//
//  DPRVenmoHelper.m
//  Lily
//
//  Created by David Richardson on 6/22/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import "DPRVenmoHelper.h"
#import "DPRTransaction.h"

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

// network call to get profile picture
- (UIImage *)fetchProfilePictureWithImageURL:(NSString *)imageURL {
	return [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
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

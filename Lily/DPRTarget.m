//
//  DPRTarget.m
//  Lily
//
//  Created by David Richardson on 7/3/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import "DPRTarget.h"
#import "DPRTransaction.h"

@implementation DPRTarget

// Insert code here to add functionality to your managed object subclass

- (void)addInformation:(NSDictionary *)information {
	
	NSString *display_name = [information objectForKey:@"display_name"];
	NSString *username = [information objectForKey:@"username"];
	NSString *picture_url = [information objectForKey:@"profile_picture_url"];
	
	if(display_name != (id)[NSNull null])
		self.fullName = display_name;
	else
		self.fullName = @"";
	
	if(username != (id)[NSNull null])
		self.username = username;
	else
		self.username = @"";
	
	if(picture_url != (id)[NSNull null])
		self.picture_url = picture_url;
	else
		self.picture_url = @"https://s3.amazonaws.com/venmo/no-image.gif";
	
}

@end

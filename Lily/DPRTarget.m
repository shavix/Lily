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
    
    self.fullName = [information objectForKey:@"display_name"];
    self.username = [information objectForKey:@"username"];
    self.picture_url = [information objectForKey:@"profile_picture_url"];
    
}

@end

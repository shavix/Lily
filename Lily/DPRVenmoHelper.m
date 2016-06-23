//
//  DPRVenmoHelper.m
//  Lily
//
//  Created by David Richardson on 6/22/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import "DPRVenmoHelper.h"

@implementation DPRVenmoHelper


// make call to get user information
- (NSDictionary *)userInformationWithAccessToken:(NSString *)accessToken {
    
    NSString *urlString = [NSString stringWithFormat:@"https://api.venmo.com/v1/me?access_token=%@", accessToken];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [urlRequest setHTTPMethod:@"GET"];
    NSURL *url = [NSURL URLWithString:urlString];
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
    
    if (error)
    {
        NSLog(@"%s: dataWithContentsOfURL error: %@", __FUNCTION__, error);
        return nil;
    }
    
    id json = [NSJSONSerialization JSONObjectWithData: data options:NSJSONReadingMutableContainers error: &error];
    
    NSDictionary *userInformation = [json objectForKey:@"data"];
    
    
    return userInformation;
    
}


@end

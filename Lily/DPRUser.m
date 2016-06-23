//
//  DPRUser.m
//  Lily
//
//  Created by David Richardson on 6/22/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import "DPRUser.h"

@implementation DPRUser

#pragma mark - model

- (void)userInformation:(NSDictionary *)userInformation andAccessToken:(NSString *)accessToken{
    
    
    NSDictionary *userInfo = [userInformation objectForKey:@"user"];
    
    self.firstName = [userInfo objectForKey:@"first_name"];
    self.lastName = [userInfo objectForKey:@"last_name"];
    self.displayName = [userInfo objectForKey:@"display_name"];
    self.username = [userInfo objectForKey:@"username"];
    //self.dateJoined = [userInfo objectForKey:@"date_joined"];
    self.pictureURL = [userInfo objectForKey:@"profile_picture_url"];
    self.accessToken = accessToken;
    
    NSString *balanceString = [userInformation objectForKey:@"balance"];
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *balance = [f numberFromString:balanceString];
    self.balance = balance;
    
    self.transactions = [[NSMutableArray alloc] init];
    
}


- (id)init {
    
    self = [super init];
    
    return self;
    
}

// shared instance
+ (instancetype)sharedModel {
    
    static DPRUser *_sharedModel = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once (&onceToken, ^{
        _sharedModel = [[self alloc] init];
    });
    return _sharedModel;
    
}


#pragma mark - override

- (NSString *)description {
    return [NSString stringWithFormat: @"User: firstName = %@ \rlastName = %@ \rfullName = %@ \rusername = %@ \rpictureURL = %@", _firstName, _lastName, _displayName, _username, _pictureURL];
}




/*
 - (void)memberSince {
 
 
 NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
 formatter.numberStyle = NSNumberFormatterDecimalStyle;
 
 NSArray *dates = [_dateJoined componentsSeparatedByString:@"-"];
 NSNumber *year = [formatter numberFromString:dates[0]];
 
 NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
 NSArray *months = [dateFormatter monthSymbols];
 NSNumber *month = [formatter numberFromString:dates[1]];
 NSString *monthString = months[[month integerValue] - 1];
 
 self.memberSinceString = [NSString stringWithFormat:@"%@ %@", monthString, year];
 
 }
*/

@end

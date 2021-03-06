//
//  DPRUser.m
//  Lily
//
//  Created by David Richardson on 6/28/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import "DPRUser.h"
#import "DPRTransaction.h"


@implementation DPRUser

#pragma mark - model

- (void)userInformation:(NSDictionary *)userInformation andAccessToken:(NSString *)accessToken {
    
    NSDictionary *userInfo = [userInformation objectForKey:@"user"];
    
    self.fullName = [userInfo objectForKey:@"display_name"];
    self.username = [userInfo objectForKey:@"username"];
    self.accessToken = accessToken;
    
    NSString *balanceString = [userInformation objectForKey:@"balance"];
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *balance = [f numberFromString:balanceString];
    self.balance = balance;
    
}


@end


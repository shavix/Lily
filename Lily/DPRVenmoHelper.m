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



#pragma mark - User

// make call to get user information
- (NSDictionary *)fetchUserInformation {
    
    NSString *urlString = [NSString stringWithFormat:@"https://api.venmo.com/v1/me?access_token=%@", self.accessToken];
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

// network call to get profile picture
- (UIImage *)fetchProfilePictureWithImageURL:(NSString *)imageURL {
    
    // load UIImage
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
    
    return image;
    
}



#pragma mark - Transactions

- (void)fetchTransactions:(NSInteger)count withIdentifierSet:(NSMutableSet *)identifierSet andUser:(DPRUser *)user{
    
    NSString *urlString = [NSString stringWithFormat:@"https://api.venmo.com/v1/payments?access_token=%@&limit=%ld", self.accessToken, (long)count];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [urlRequest setHTTPMethod:@"GET"];
    NSURL *url = [NSURL URLWithString:urlString];
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
    if (error)
    {
        NSLog(@"%s: dataWithContentsOfURL error: %@", __FUNCTION__, error);
        return;
    }
    
    id json = [NSJSONSerialization JSONObjectWithData: data options:NSJSONReadingMutableContainers error: &error];
    
    // create transactions objects
    NSArray *tempTransactionsArray = [json objectForKey:@"data"];
    
    for(NSDictionary *info in tempTransactionsArray){
        
        NSString *status = [info objectForKey:@"status"];
        // valid transaction
        if([status isEqualToString:@"settled"]){
            
            NSString *identifier = [info objectForKey:@"id"];
            
            // unique - add to database
            if(![identifierSet containsObject:identifier]){
                
                // create transaction
                DPRTransaction *newTransaction = [NSEntityDescription insertNewObjectForEntityForName:@"DPRTransaction" inManagedObjectContext:self.managedObjectContext];
                [newTransaction addInformation:info withUserFullName:user.fullName];
                
                [user addTransactionListObject:newTransaction];
                // add to identifierSet & user
                [identifierSet addObject:identifier];
                
            }
        }
    }
    
    // add to core data
    error = nil;
    // always save managedObjectContext
    [self.managedObjectContext save:&error];
    
    if(error){
        // handle error
    }
    
}

@end

//
//  DPRCoreDataHelper.m
//  Lily
//
//  Created by David Richardson on 6/27/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import "DPRCoreDataHelper.h"
#import "DPRAppDelegate.h"
#import "DPRTransaction.h"

@interface DPRCoreDataHelper()

@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;

@end

@implementation DPRCoreDataHelper

- (DPRUser *)fetchUser{
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"DPRUser"];
    NSError *error = nil;
    NSArray *users = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    NSLog(@"NUM USERS = %ld", (long) users.count);

    // no users
    if(error || users.count == 0){
        return nil;
    }
    // check if user is in the array
    else {
        for(DPRUser *user in users){
            if([user.username isEqualToString:self.username]){
                return user;
            }
        }
    }
    return nil;
}

// populate identifierSet
- (NSMutableSet *)setupIdentifierSetWithUser:(DPRUser *)user{
    
    NSMutableSet *identifierSet = [[NSMutableSet alloc] init];
    
    for(DPRTransaction *transaction in user.transactionList){
        [identifierSet addObject:transaction.identifier];
    }
    
    return identifierSet;
    
}

// shared instance
+ (instancetype)sharedModel {
    
    static DPRCoreDataHelper *_sharedModel = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once (&onceToken, ^{
        _sharedModel = [[self alloc] init];
    });
    return _sharedModel;
    
}

// retrieve AppDelegate's managedObjectContext
- (NSManagedObjectContext *)managedObjectContext {
    return [(DPRAppDelegate *) [[UIApplication sharedApplication] delegate] managedObjectContext];
}

@end

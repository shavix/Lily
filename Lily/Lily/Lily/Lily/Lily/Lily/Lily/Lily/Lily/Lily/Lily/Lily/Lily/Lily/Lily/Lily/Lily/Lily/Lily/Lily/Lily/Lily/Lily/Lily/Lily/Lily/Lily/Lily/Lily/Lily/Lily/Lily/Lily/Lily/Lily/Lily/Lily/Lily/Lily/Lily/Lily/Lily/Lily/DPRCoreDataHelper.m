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


// user
- (DPRUser *)fetchUser{
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"DPRUser"];
    NSError *error = nil;
    NSArray *users = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];

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

- (void)insertIntoDatabse:(NSArray *)tempTransactionsArray withIdentifierSet:(NSMutableSet *)identifierSet andUser:(DPRUser *)user {
    
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
     NSError *error = nil;
     // always save managedObjectContext
     [self.managedObjectContext save:&error];
     
     if(error){
     // handle error
     }
    
}

// transactionsByDate
- (NSArray *)setupTransactionsByDateWithUser:(DPRUser *)user{
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"dateCompleted" ascending:NO];
     NSArray *tempTransactionsByDate = [user.transactionList sortedArrayUsingDescriptors:@[sortDescriptor]];
    
    NSMutableArray *transactionsByDate = [[NSMutableArray alloc] init];
    [transactionsByDate addObject:[[NSMutableArray alloc] init]];

    for(DPRTransaction *transaction in tempTransactionsByDate){
        
        NSMutableArray *currentDateArray = transactionsByDate[transactionsByDate.count - 1];
        
        // current date is empty
        if(currentDateArray.count == 0) {
            [currentDateArray addObject:transaction];
        }
        // check if correct date
        else {
            DPRTransaction *currentDateTransaction = currentDateArray[0];
            
            // correct date
            if([transaction.dateCompletedString isEqualToString:currentDateTransaction.dateCompletedString]) {
                [currentDateArray addObject:transaction];
            }
            // next date
            else {
                
                NSMutableArray *newDateArray = [[NSMutableArray alloc] init];
                [newDateArray addObject:transaction];
                [transactionsByDate addObject:newDateArray];
            }
        }
        
    }
    
    return transactionsByDate;
    
}



#pragma mark - unimportant

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

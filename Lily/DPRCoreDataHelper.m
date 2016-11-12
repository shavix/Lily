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
#import "DPRTarget.h"

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
             newTransaction.user = user;
             [newTransaction createTransactionDescription];
             
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

- (void)updateMonthDataWithTransaction:(DPRTransaction *)transaction andMonth:(NSMutableDictionary *)monthDict{
    
    double transactionAmount = transaction.amount.doubleValue;
    
    // transactions
    NSNumber *transactions = [monthDict objectForKey:@"transactions"];
    NSInteger amount = transactions.integerValue + 1;
    [monthDict setValue:@(amount) forKey:@"transactions"];
    
    // sent
    if(!transaction.isIncoming){
        NSNumber *sent = [monthDict objectForKey:@"sent"];
        [monthDict setValue:@(sent.doubleValue + transactionAmount) forKey:@"sent"];
        
        // netIncome
        NSNumber *netIncome = [monthDict objectForKey:@"netIncome"];
        [monthDict setValue:@(netIncome.doubleValue - transactionAmount) forKey:@"netIncome"];
    }
    
    // received
    else{
        NSNumber *received = [monthDict objectForKey:@"received"];
        [monthDict setValue:@(received.doubleValue + transactionAmount) forKey:@"received"];
        
        // netIncome
        NSNumber *netIncome = [monthDict objectForKey:@"netIncome"];
        [monthDict setValue:@(netIncome.doubleValue + transactionAmount) forKey:@"netIncome"];
    }
    
}


// transactionsByDate & transactionsByMonth
- (NSArray *)setupTransactionsByDateWithUser:(DPRUser *)user{
    
    // get current date
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger currMonth = [components month];
    NSInteger currYear = [components year];
    
    // get core data transactions
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"dateCompleted" ascending:NO];
     NSArray *coreDataTransactions = [user.transactionList sortedArrayUsingDescriptors:@[sortDescriptor]];
    
    // transactionsByDate
    NSMutableArray *transactionsByDate = [[NSMutableArray alloc] init];
    [transactionsByDate addObject:[[NSMutableArray alloc] init]];
    
    
    // transactionsByMonth
    NSMutableArray *transactionsByMonth = [[NSMutableArray alloc] init];
    for(int i = 0; i < 12; i++){
        [transactionsByMonth addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        @(i), @"month",
                                        @(0), @"transactions",
                                        @(0), @"sent",
                                        @(0), @"received",
                                        @(0), @"netIncome",
                                       nil]];
    }

    // iterate over all transactions
    for(DPRTransaction *transaction in coreDataTransactions){
        
        // TRANSACTIONSBYMONTH
        NSDate *date = transaction.dateCompleted;
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear fromDate:date];
        NSInteger tMonth = components.month;
        NSInteger tYear = components.year;
        
        // good
        if(tYear == currYear){
            [self updateMonthDataWithTransaction:transaction andMonth:[transactionsByMonth objectAtIndex:tMonth-1]];
        }
        // last year
        else if(tYear == currYear - 1){
            // good
            if(tMonth > currMonth){
                [self updateMonthDataWithTransaction:transaction andMonth:[transactionsByMonth objectAtIndex:tMonth-1]];
            }
        }
                
        
        // TRANSACTIONSBYDATE
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
    
    NSMutableArray *results = [[NSMutableArray alloc] init];
    [results addObject:transactionsByDate];
    [results addObject:transactionsByMonth];
    
    return results;
    
}

- (NSDictionary *)setupTransactionsByFriendsWithUser:(DPRUser *)user{
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"target.fullName" ascending:NO];
    NSArray *tempTransactionsByFriends = [user.transactionList sortedArrayUsingDescriptors:@[sortDescriptor]];
    
    NSMutableArray *transactionsByFriends = [[NSMutableArray alloc] init];
    [transactionsByFriends addObject:[[NSMutableArray alloc] init]];

    for(DPRTransaction *transaction in tempTransactionsByFriends){

        NSMutableArray *currentFriendArray = transactionsByFriends[transactionsByFriends.count - 1];
        
        // current friend is empty
        if(currentFriendArray.count == 0){
            [currentFriendArray addObject:transaction];
        }
        // check if correct friend
        else {
            DPRTransaction *currentFriendTransaction = currentFriendArray[0];
            
            // correct friend
            if([transaction.target.fullName isEqualToString:currentFriendTransaction.target.fullName]){
                [currentFriendArray addObject:transaction];
            }
            // next friend
            else {
                NSMutableArray *newFriendArray = [[NSMutableArray alloc] init];
                [newFriendArray addObject:transaction];
                [transactionsByFriends addObject:newFriendArray];
            }
        }
    }
	
	NSMutableDictionary *tempFriendsData = [[NSMutableDictionary alloc] init];
	
	// iterate through friends
	for(NSArray *currArr in transactionsByFriends){
		
		NSInteger amountSent = 0;
		NSInteger amountReceived = 0;
		
		// iterate through transactions
		for(DPRTransaction *transaction in currArr){
			
			NSNumber *amount = transaction.amount;
			
			if(transaction.isIncoming){
				amountReceived += amount.integerValue;
			}
			else{
				amountSent += amount.integerValue;
			}
			
		}
		
		DPRTransaction *transaction = currArr[0];
		NSString *picture_url = transaction.target.picture_url;
		
		NSInteger netIncome = amountReceived - amountSent;
		NSInteger transactions = currArr.count;
		
		NSDictionary *friend = [NSDictionary dictionaryWithObjectsAndKeys:
								[NSNumber numberWithInteger:transactions], @"transactions",
								[NSNumber numberWithInteger:amountSent], @"sent",
								[NSNumber numberWithInteger:amountReceived], @"received",
								[NSNumber numberWithInteger:netIncome], @"netIncome",
								picture_url, @"picture_url",
								nil];
		
		
		[tempFriendsData setObject:friend forKey:transaction.target.fullName];
		
	}
	
    return tempFriendsData;
	
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

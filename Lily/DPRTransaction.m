//
//  DPRTransaction.m
//  Lily
//
//  Created by David Richardson on 7/3/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import "DPRTransaction.h"
#import "DPRTarget.h"
#import "DPRUser.h"
#import "DPRAppDelegate.h"

@interface DPRTransaction()

@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;

@end

@implementation DPRTransaction

// initialize with transaction information
- (void)addInformation:(NSDictionary *)information withUserFullName:(NSString *)fullName {
    
    if(self) {
        
        NSString *action = [information objectForKey:@"action"];
        self.amount = [information objectForKey:@"amount"];
        self.note = [information objectForKey:@"note"];
        self.status = [information objectForKey:@"status"];
        self.identifier = [information objectForKey:@"id"];
        
        [self parseDatesWithInformation:information];
        
        // venmo sender
        NSDictionary *senderInformation = [information objectForKey:@"actor"];
        NSString *senderName = [senderInformation objectForKey:@"display_name"];
        
        // venmo receiver
        NSDictionary *receiverInformation = [[information objectForKey:@"target"] objectForKey:@"user"];
        
        NSDictionary *targetInformation;
        
        // if user is sender
        if([senderName isEqualToString:fullName]) {
            if([action isEqualToString:@"charge"]) {
                self.isIncoming = [NSNumber numberWithBool:YES];
            }
            else {
                self.isIncoming = false;
            }
            self.isSender = [NSNumber numberWithBool:YES];
            targetInformation = receiverInformation;
        }
        // if user is receiver
        else {
            if([action isEqualToString:@"charge"]) {
                self.isIncoming = false;
            }
            else {
                self.isIncoming = [NSNumber numberWithBool:YES];
            }
            self.isSender = false;
            targetInformation = senderInformation;
        }
        
        // create target
        DPRTarget *target = [NSEntityDescription insertNewObjectForEntityForName:@"DPRTarget" inManagedObjectContext:self.managedObjectContext];
        [target addInformation:targetInformation];
        self.target = target;
        
        NSError *error = nil;
        [self.managedObjectContext save:&error];
        if(error){
            // handle error
        }
        
    }
    
}

- (void)createTransactionDescription {
    
    // sender
    if(self.isSender) {
        // charge
        if(self.isIncoming) {
            self.transactionDescription = [NSString stringWithFormat:@"%@ charged %@", self.user.fullName, self.target.fullName];
        }
        // pay
        else {
            self.transactionDescription = [NSString stringWithFormat:@"%@ paid %@", self.user.fullName, self.target.fullName];
        }
    }
    // receiver
    else {
        // pay
        if(self.isIncoming) {
            self.transactionDescription = [NSString stringWithFormat:@"%@ paid %@", self.target.fullName, self.user.fullName];
        }
        // charge
        else {
            self.transactionDescription = [NSString stringWithFormat:@"%@ charged %@", self.target.fullName, self.user.fullName];
        }
    }
    
}

- (void)parseDatesWithInformation:(NSDictionary *)information {
    
    NSArray *months = @[@"January", @"February", @"March", @"April", @"May", @"June", @"July", @"August", @"September", @"October", @"November", @"December"];
    
    // date strings
    NSString *dateCreatedString = [information objectForKey:@"date_created"];
    NSString *dateCompletedString = [information objectForKey:@"date_completed"];
    
    // date formatter
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    // get date
    NSDate *theDate = nil;
    NSError *error = nil;
    if (![dateFormatter getObjectValue:&theDate forString:dateCreatedString range:nil error:&error]) {
        NSLog(@"Date '%@' could not be parsed: %@", dateCreatedString, error);
    }
    // set date created
    self.dateCreated = theDate;
    
    // if transaction is not yet complete - dateCompletedString = nil
    if(![dateCompletedString isEqual:[NSNull null]]){
        // get date
        theDate = nil;
        error = nil;
        if (![dateFormatter getObjectValue:&theDate forString:dateCompletedString range:nil error:&error]) {
            NSLog(@"Date '%@' could not be parsed: %@", dateCompletedString, error);
        }
        // set date completed
        self.dateCompleted = theDate;
        
        NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:self.dateCompleted];
        
        NSString *dateCompletedMonth = months[dateComponents.month - 1];
        
        self.dateCompletedString = [[NSString stringWithFormat:@"%@ %ld, %ld", dateCompletedMonth, dateComponents.day, dateComponents.year] uppercaseString];
    }
    
}


// retrieve AppDelegate's managedObjectContext
- (NSManagedObjectContext *)managedObjectContext {
    return [(DPRAppDelegate *) [[UIApplication sharedApplication] delegate] managedObjectContext];
}



@end

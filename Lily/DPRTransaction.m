//
//  DPRTransaction.m
//  Lily
//
//  Created by David Richardson on 6/28/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import "DPRTransaction.h"
#import "DPRUser.h"

@implementation DPRTransaction

// initialize with transaction information
- (void)addInformation:(NSDictionary *)information withUserFullName:(NSString *)fullName {
    
    if(self) {
        
        NSString *action = [information objectForKey:@"action"];
        self.amount = [information objectForKey:@"amount"];
        self.note = [information objectForKey:@"note"];
        self.status = [information objectForKey:@"status"];
        self.identifier = [information objectForKey:@"id"];
        
        // venmo sender
        NSDictionary *senderInformation = [information objectForKey:@"actor"];
        NSString *senderName = [senderInformation objectForKey:@"display_name"];
        
        
        // venmo receiver
        NSDictionary *receiverInformation = [[information objectForKey:@"target"] objectForKey:@"user"];
        NSString *receiverName = [receiverInformation objectForKey:@"display_name"];
        
        // if user is sender
        if([senderName isEqualToString:fullName]) {
            if([action isEqualToString:@"charge"]) {
                self.isIncoming = [NSNumber numberWithBool:YES];
            }
            else {
                self.isIncoming = false;
            }
            self.isSender = [NSNumber numberWithBool:YES];
            self.targetName = receiverName;
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
            self.targetName = senderName;
        }
        
    }
    
}

- (void)parseDatesWithInformation:(NSDictionary *)information {
    
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
        self.isComplete = [NSNumber numberWithBool:YES];
        // get date
        theDate = nil;
        error = nil;
        if (![dateFormatter getObjectValue:&theDate forString:dateCompletedString range:nil error:&error]) {
            NSLog(@"Date '%@' could not be parsed: %@", dateCompletedString, error);
        }
        // set date completed
        self.dateCompleted = theDate;
        
        #warning potentially add this in core data
        //self.dateCompletedString = [[NSString stringWithFormat:@"%@ %ld, %ld", _monthCompleted, _dateCompleted.day, _dateCompleted.year] uppercaseString];
    }
    else {
        self.isComplete = [NSNumber numberWithBool:NO];
    }
    
}


@end

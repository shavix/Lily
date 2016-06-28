//
//  DPRTransaction.m
//  Lily
//
//  Created by David Richardson on 6/27/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import "DPRTransaction.h"
#import "DPRUser.h"

@implementation DPRTransaction

// initialize with transaction information
- (id)initWithInformation:(NSDictionary *)information {
    
    self = [super init];
    
    DPRUser *user = [DPRUser sharedModel];
    
    if(self) {
        
        NSString *action = [information objectForKey:@"action"];
        self.amount = [information objectForKey:@"amount"];
        self.note = [information objectForKey:@"note"];
        self.status = [information objectForKey:@"status"];
        
        // dates
        [self parseDatesWithInformation:information];
        
        // direction
        self.direction = [[NSString alloc] init];
        
        // category
        self.category = @"Other";
        
        // venmo sender
        NSDictionary *senderInformation = [information objectForKey:@"actor"];
        NSString *senderName = [senderInformation objectForKey:@"display_name"];

        
        // venmo receiver
        NSDictionary *receiverInformation = [[information objectForKey:@"target"] objectForKey:@"user"];
        NSString *receiverName = [receiverInformation objectForKey:@"display_name"];
        
        // if user is sender
        if([senderName isEqualToString:user.displayName]) {
            if([action isEqualToString:@"charge"]) {
                self.isIncoming = true;
            }
            else {
                self.isIncoming = false;
            }
            self.isSender = true;
            self.targetName = receiverName;
        }
        // if user is receiver
        else {
            if([action isEqualToString:@"charge"]) {
                self.isIncoming = false;
            }
            else {
                self.isIncoming = true;
            }
            self.isSender = false;
            self.targetName = senderName;
        }
        
    }
    
    return self;
    
}


- (void)parseDatesWithInformation:(NSDictionary *)information {

    
}




@end
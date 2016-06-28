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
- (id)initWithInformation:(NSDictionary *)information {
    
    self = [super init];
    
    DPRUser *user = [DPRUser sharedModel];
    
    if(self) {
        
        NSString *action = [information objectForKey:@"action"];
        self.amount = [information objectForKey:@"amount"];
        self.note = [information objectForKey:@"note"];
        self.status = [information objectForKey:@"status"];
        
        // venmo sender
        NSDictionary *senderInformation = [information objectForKey:@"actor"];
        NSString *senderName = [senderInformation objectForKey:@"display_name"];
        
        
        // venmo receiver
        NSDictionary *receiverInformation = [[information objectForKey:@"target"] objectForKey:@"user"];
        NSString *receiverName = [receiverInformation objectForKey:@"display_name"];
        
        // if user is sender
        if([senderName isEqualToString:user.fullName]) {
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
    
    return self;
    
}


@end

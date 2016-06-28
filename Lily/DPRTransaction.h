//
//  DPRTransaction.h
//  Lily
//
//  Created by David Richardson on 6/27/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DPRTransaction : NSObject

- (id)initWithInformation:(NSDictionary *)information;

@property (strong, nonatomic) NSNumber *amount;
@property (strong, nonatomic) NSString *note;
@property (strong, nonatomic) NSString *category;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSString *targetName;
@property BOOL isIncoming;
@property BOOL isComplete;
@property BOOL isSender;
// Date
@property (strong, nonatomic) NSDate *dateCreated;
@property (strong, nonatomic) NSDate *dateCompleted;
@property (strong, nonatomic) NSString *direction;

@end

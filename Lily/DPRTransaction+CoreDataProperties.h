//
//  DPRTransaction+CoreDataProperties.h
//  Lily
//
//  Created by David Richardson on 7/3/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "DPRTransaction.h"

NS_ASSUME_NONNULL_BEGIN

@interface DPRTransaction (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *amount;
@property (nullable, nonatomic, retain) NSDate *dateCompleted;
@property (nullable, nonatomic, retain) NSString *dateCompletedString;
@property (nullable, nonatomic, retain) NSDate *dateCreated;
@property (nullable, nonatomic, retain) NSString *identifier;
@property (nullable, nonatomic, retain) NSNumber *isIncoming;
@property (nullable, nonatomic, retain) NSNumber *isSender;
@property (nullable, nonatomic, retain) NSString *note;
@property (nullable, nonatomic, retain) NSString *status;
@property (nullable, nonatomic, retain) NSString *transactionDescription;
@property (nullable, nonatomic, retain) DPRUser *user;
@property (nullable, nonatomic, retain) DPRTarget *target;

@end

NS_ASSUME_NONNULL_END

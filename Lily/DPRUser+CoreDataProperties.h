//
//  DPRUser+CoreDataProperties.h
//  Lily
//
//  Created by David Richardson on 6/28/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "DPRUser.h"

NS_ASSUME_NONNULL_BEGIN

@interface DPRUser (CoreDataProperties)

// properties
@property (nullable, nonatomic, retain) NSString *username;
@property (nullable, nonatomic, retain) NSString *accessToken;
@property (nullable, nonatomic, retain) NSString *fullName;
@property (nullable, nonatomic, retain) NSNumber *balance;
@property (nullable, nonatomic, retain) id pictureImage;
@property (nullable, nonatomic, retain) NSSet<DPRTransaction *> *transactionList;

@end

@interface DPRUser (CoreDataGeneratedAccessors)

// methods
- (void)addTransactionListObject:(DPRTransaction *)value;
- (void)removeTransactionListObject:(DPRTransaction *)value;
- (void)addTransactionList:(NSSet<DPRTransaction *> *)values;
- (void)removeTransactionList:(NSSet<DPRTransaction *> *)values;

@end

NS_ASSUME_NONNULL_END

//
//  DPRUser+CoreDataProperties.h
//  Lily
//
//  Created by David Richardson on 6/27/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "DPRUser.h"
#import "DPRTransaction.h"

NS_ASSUME_NONNULL_BEGIN

@interface DPRUser (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *username;
@property (nullable, nonatomic, retain) NSSet<DPRTransaction *> *transactionList;

@end

@interface DPRUser (CoreDataGeneratedAccessors)

- (void)addTransactionListObject:(DPRTransaction *)value;
- (void)removeTransactionListObject:(DPRTransaction *)value;
- (void)addTransactionList:(NSSet<DPRTransaction *> *)values;
- (void)removeTransactionList:(NSSet<DPRTransaction *> *)values;

@end

NS_ASSUME_NONNULL_END

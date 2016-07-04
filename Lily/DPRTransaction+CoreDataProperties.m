//
//  DPRTransaction+CoreDataProperties.m
//  Lily
//
//  Created by David Richardson on 7/3/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "DPRTransaction+CoreDataProperties.h"

@implementation DPRTransaction (CoreDataProperties)

@dynamic amount;
@dynamic dateCompleted;
@dynamic dateCompletedString;
@dynamic dateCreated;
@dynamic identifier;
@dynamic isIncoming;
@dynamic isSender;
@dynamic note;
@dynamic status;
@dynamic transactionDescription;
@dynamic user;
@dynamic target;

@end

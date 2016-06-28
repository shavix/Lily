//
//  DPRTransaction+CoreDataProperties.m
//  Lily
//
//  Created by David Richardson on 6/28/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "DPRTransaction+CoreDataProperties.h"

@implementation DPRTransaction (CoreDataProperties)

@dynamic amount;
@dynamic dateCompleted;
@dynamic dateCreated;
@dynamic isComplete;
@dynamic isIncoming;
@dynamic isSender;
@dynamic note;
@dynamic status;
@dynamic targetName;
@dynamic identifier;
@dynamic user;

@end

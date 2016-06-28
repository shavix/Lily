//
//  DPRUser+CoreDataProperties.m
//  Lily
//
//  Created by David Richardson on 6/27/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "DPRUser+CoreDataProperties.h"

@implementation DPRUser (CoreDataProperties)

@dynamic username;
@dynamic accessToken;
@dynamic fullName;
@dynamic balance;
@dynamic pictureURL;
@dynamic transactionList;

@end

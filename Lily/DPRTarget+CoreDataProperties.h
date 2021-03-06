//
//  DPRTarget+CoreDataProperties.h
//  Lily
//
//  Created by David Richardson on 7/3/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "DPRTarget.h"

NS_ASSUME_NONNULL_BEGIN

@interface DPRTarget (CoreDataProperties)

// properties
@property (nullable, nonatomic, retain) NSString *username;
@property (nullable, nonatomic, retain) NSString *picture_url;
@property (nullable, nonatomic, retain) NSString *fullName;
@property (nullable, nonatomic, retain) DPRTransaction *transaction;

@end

NS_ASSUME_NONNULL_END

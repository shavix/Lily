//
//  DPRTransaction.h
//  Lily
//
//  Created by David Richardson on 7/3/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DPRTarget, DPRUser;

NS_ASSUME_NONNULL_BEGIN

@interface DPRTransaction : NSManagedObject

// methods
- (void)addInformation:(NSDictionary *)information withUserFullName:(NSString *)fullName;
- (void)createTransactionDescription;

@end

NS_ASSUME_NONNULL_END

#import "DPRTransaction+CoreDataProperties.h"

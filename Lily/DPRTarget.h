//
//  DPRTarget.h
//  Lily
//
//  Created by David Richardson on 7/3/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DPRTransaction;

NS_ASSUME_NONNULL_BEGIN

@interface DPRTarget : NSManagedObject

// methods
- (void)addInformation:(NSDictionary *)information;

@end

NS_ASSUME_NONNULL_END

#import "DPRTarget+CoreDataProperties.h"

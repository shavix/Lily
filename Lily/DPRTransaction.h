//
//  DPRTransaction.h
//  Lily
//
//  Created by David Richardson on 6/27/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DPRUser;

NS_ASSUME_NONNULL_BEGIN

@interface DPRTransaction : NSManagedObject

- (id)initWithInformation:(NSDictionary *)information;

@end

NS_ASSUME_NONNULL_END

#import "DPRTransaction+CoreDataProperties.h"

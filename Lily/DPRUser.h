//
//  DPRUser.h
//  Lily
//
//  Created by David Richardson on 6/27/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DPRTransaction;

NS_ASSUME_NONNULL_BEGIN

@interface DPRUser : NSManagedObject

// methods
+ (instancetype)sharedModel;
- (void)userInformation:(NSDictionary *)userInfo andAccessToken:(NSString *)accessToken;

@end

NS_ASSUME_NONNULL_END

#import "DPRUser+CoreDataProperties.h"

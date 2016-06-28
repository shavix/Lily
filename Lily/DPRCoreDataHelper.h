//
//  DPRCoreDataHelper.h
//  Lily
//
//  Created by David Richardson on 6/27/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DPRUser+Customization.h"

@interface DPRCoreDataHelper : NSObject

+ (instancetype)sharedModel;
- (DPRUser *)fetchUser;

@property (strong, nonatomic) NSString *username;

@end

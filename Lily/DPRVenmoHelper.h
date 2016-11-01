//
//  DPRVenmoHelper.h
//  Lily
//
//  Created by David Richardson on 6/22/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DPRUser.h"
#import <UIKit/UIKit.h>

@interface DPRVenmoHelper : NSObject


// properties
@property (strong, nonatomic) NSString *accessToken;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

// methods
- (NSDictionary *)fetchUserInformation;
- (UIImage *)fetchProfilePictureWithImageURL:(NSString *)imageURL;
- (NSArray *)fetchTransactions:(NSInteger)count;
+ (instancetype)sharedModel;

@end

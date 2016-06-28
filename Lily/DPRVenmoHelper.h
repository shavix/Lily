//
//  DPRVenmoHelper.h
//  Lily
//
//  Created by David Richardson on 6/22/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DPRVenmoHelper : NSObject

@property (strong, nonatomic) NSString *accessToken;

// venmo calls
- (NSDictionary *)fetchUserInformation;

// network calls
- (UIImage *)fetchProfilePictureWithImageURL:(NSString *)imageURL;

- (void)fetchTransactions:(NSInteger)count;

+ (instancetype)sharedModel;

@end

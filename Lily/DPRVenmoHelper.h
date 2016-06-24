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

// venmo calls
- (NSDictionary *)userInformationWithAccessToken:(NSString *)accessToken;

// network calls
- (UIImage *)profilePictureWithImageURL:(NSString *)imageURL;


@end

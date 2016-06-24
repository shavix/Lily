//
//  DPRUser.h
//  Lily
//
//  Created by David Richardson on 6/22/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DPRUser : NSObject

// methods
+ (instancetype)sharedModel;
- (void)userInformation:(NSDictionary *)userInfo andAccessToken:(NSString *)accessToken;

// properties
@property (strong, nonatomic) NSString *accessToken;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *displayName;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSNumber *balance;
@property (strong, nonatomic) NSString *pictureURL;
@property (strong, nonatomic) NSMutableArray *transactions;
@property (strong, nonatomic) UIImage *pictureImage;

//@property (strong, nonatomic) NSString *dateJoined;


@end

//
//  DPRCoreDataHelper.h
//  Lily
//
//  Created by David Richardson on 6/27/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DPRUser.h"

@interface DPRCoreDataHelper : NSObject

// properties
@property (strong, nonatomic) NSString *username;

// methods
+ (instancetype)sharedModel;
- (DPRUser *)fetchUser;
- (NSMutableSet *)setupIdentifierSet;
- (void)insertIntoDatabse:(NSArray *)tempTransactionsArray withIdentifierSet:(NSMutableSet *)identifierSet andUser:(DPRUser *)user;
- (NSArray *)setupTransactionsByDateWithUser:(DPRUser *)user;
- (NSDictionary *)setupTransactionsByFriendsWithUser:(DPRUser *)user;

@end

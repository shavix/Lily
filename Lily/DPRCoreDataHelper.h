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

@property (strong, nonatomic) NSString *username;

+ (instancetype)sharedModel;
- (DPRUser *)fetchUser;
- (NSMutableSet *)setupIdentifierSetWithUser:(DPRUser *)user;
- (void)insertIntoDatabse:(NSArray *)tempTransactionsArray withIdentifierSet:(NSMutableSet *)identifierSet andUser:(DPRUser *)user;
- (NSArray *)setupTransactionsByDateWithUser:(DPRUser *)user;
- (NSArray *)setupTransactionsByFriendsWithUser:(DPRUser *)user;

@end

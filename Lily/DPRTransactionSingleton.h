//
//  DPRTransactionSingleton.h
//  Lily
//
//  Created by David Richardson on 7/2/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DPRTransactionSingleton : NSObject

// properties
@property (strong, nonatomic) NSArray *transactionsByDate;
@property (strong, nonatomic) NSArray *transactionsByMonth;

// methods
+ (instancetype)sharedModel;

@end

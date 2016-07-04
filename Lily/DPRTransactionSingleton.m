//
//  DPRTransactionSingleton.m
//  Lily
//
//  Created by David Richardson on 7/2/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import "DPRTransactionSingleton.h"

@implementation DPRTransactionSingleton

#pragma mark - Init

// shared instance
+ (instancetype)sharedModel {
    
    static DPRTransactionSingleton *_sharedModel = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once (&onceToken, ^{
        _sharedModel = [[self alloc] init];
    });
    return _sharedModel;
    
}

@end

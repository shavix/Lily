//
//  SortingAlgorithmTests.m
//  Lily
//
//  Created by David Richardson on 12/14/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DPRUser.h"
#import "DPRTransactionSingleton.h"
#import "DPRTransaction.h"
#import "DPRAppDelegate.h"
#import "DPRCoreDataHelper.h"

@interface SortingAlgorithmTests : XCTestCase

@end

@implementation SortingAlgorithmTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSetupTransactionsByDate{
	
	
	
	// create transactions
	NSManagedObjectContext *managedObjectContext = [(DPRAppDelegate *) [[UIApplication sharedApplication] delegate] managedObjectContext];
	// create transaction
	DPRTransaction *transaction = [NSEntityDescription insertNewObjectForEntityForName:@"DPRTransaction" inManagedObjectContext:managedObjectContext];
	NSDictionary *information = [NSDictionary dictionaryWithObjectsAndKeys:
								 @"sample action", @"action",
								 @(8.75), @"amount",
								 @"sample note", @"note",
								 @"sample status", @"status",
								 @"10312903123", @"id",
								 [NSDictionary dictionaryWithObjectsAndKeys:
								  @"sample_display_name", @"display_name",
								  nil], @"actor",
								 @"2016-12-14T03:02:02",@"date_created",
								 @"2016-12-14T03:02:02",@"date_completed",
								 [NSDictionary dictionaryWithObjectsAndKeys:
								  [NSDictionary dictionaryWithObjectsAndKeys:
								   @"sample display name",@"display_name",
								   @"sample username", @"username",
								   @"", @"profile_picture_url",
								   nil],@"user",
								  nil], @"target",
								 nil];
	[transaction addInformation:information withUserFullName:@"davidpr"];
	
	NSSet *set = [NSSet setWithObject:transaction];
	NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
							  [NSDictionary dictionaryWithObjectsAndKeys:
							   @"sample_username",@"username",
							   @"sample_display_name", @"display_name",
							   nil], @"user",
							  @"2.32", @"balance",
							  nil];
	DPRUser *user = [NSEntityDescription insertNewObjectForEntityForName:@"DPRUser" inManagedObjectContext:managedObjectContext];
	[user userInformation:userInfo andAccessToken:@"12123123"];
	user.transactionList = set;
	
	
	DPRCoreDataHelper *cdHelper = [[DPRCoreDataHelper alloc] init];
	[cdHelper setupTransactionsByDateWithUser:user];
	
	DPRTransactionSingleton *transactionSingleton = [DPRTransactionSingleton sharedModel];
	NSArray *date = transactionSingleton.transactionsByDate;
	NSArray *month = transactionSingleton.transactionsByMonth;
	
	// assertions
	XCTAssertEqual([date count], 1);
	XCTAssertEqual([month count], 12);
	
	DPRTransaction *sampleTransaction = [[date objectAtIndex:0] objectAtIndex:0];
	XCTAssertEqual(sampleTransaction, transaction);
	
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end

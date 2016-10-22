//
//  DPRGraphVC.m
//  Lily
//
//  Created by David Richardson on 10/21/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import "DPRGraphVC.h"
#import "UIColor+CustomColors.h"
#import "DPRTransactionSingleton.h"
#import "DPRTransaction.h"
#import "DPRUser.h"
#import "DPRTarget.h"
#import "DPRCoreDataHelper.h"

@interface DPRGraphVC ()

@property (strong, nonatomic) DPRTransactionSingleton *transactionSingleton;
@property (strong, nonatomic) DPRCoreDataHelper *cdHelper;
@property (strong, nonatomic) DPRUser *user;

@property (strong, nonatomic) NSArray *transactionsByFriends;

@end

@implementation DPRGraphVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setupUI];
    [self setupData];
    [self setupGraph];
    
}

- (void)setupGraph{
    
    for(int i = 0 ; i < self.transactionsByFriends.count; i++){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 40 + 50*i, 400, 40)];
        label.textColor = [UIColor whiteColor];
        
        NSArray *arr = self.transactionsByFriends[i];
        DPRTransaction *transaction = arr[0];
    
        label.text = [NSString stringWithFormat:@"%ld transactions with %@", arr.count, transaction.target.fullName];
        
        [self.view addSubview:label];
    }
    
}

- (void)setupData{
    
    self.cdHelper = [DPRCoreDataHelper sharedModel];
    self.user = [self.cdHelper fetchUser];

    self.transactionSingleton = [DPRTransactionSingleton sharedModel];
    
    if([self.graphType isEqualToString:@"friendsTransactions"]){
        self.transactionsByFriends = [self.cdHelper setupTransactionsByFriendsWithUser:self.user];
    }
    
}

- (void)setupUI{
    
    self.view.backgroundColor = [UIColor darkColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

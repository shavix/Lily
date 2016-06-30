//
//  DPRTransactionsVC.m
//  Lily
//
//  Created by David Richardson on 6/22/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import "DPRTransactionsVC.h"
#import "DPRUIHelper.h"

#import "UIColor+CustomColors.h"

@implementation DPRTransactionsVC

#pragma mark - on load

- (void)viewDidLoad {
    
    [self setupUI];
    
}

- (void)setupUI{
    
    DPRUIHelper *UIHelper = [[DPRUIHelper alloc] init];
    [UIHelper setupTabUI:self withTitle:@"Transactions"];

}


#pragma mark - UITableView


// get cell
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* CellIdentifier = @"TransactionCell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    cell.textLabel.text = @"I'm a UITableViewCell!";
    cell.imageView.image = [UIImage imageNamed:@"MyReallyCoolImage.png"];
    
    return cell;
}




// num rows
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;    //count number of row from counting array hear cataGorry is An Array
}

// num sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


@end

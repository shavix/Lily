//
//  DPRProfileTVC.m
//  Lily
//
//  Created by David Richardson on 11/16/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import "DPRProfileTVC.h"
#import "DPRProfileTableViewCell.h"
#import "DPRUser.h"
#import "DPRCoreDataHelper.h"
#import "UIColor+CustomColors.h"

@interface DPRProfileTVC ()

@property (strong, nonatomic) DPRUser *user;
@property (strong, nonatomic) DPRCoreDataHelper *cdHelper;

@end

@implementation DPRProfileTVC

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self setupUI];
	[self setupData];
}

- (void)setupUI{
	self.title = @"Profile";
	self.view.backgroundColor = [UIColor darkColor];
	[self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

- (void)setupData{
	self.cdHelper = [DPRCoreDataHelper sharedModel];
	self.user = [self.cdHelper fetchUser];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	NSString *identifier = @"ProfileCell";
	DPRProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	
	NSInteger section = indexPath.section;
	
	// profile cell
	if(section == 0){
		cell.image.image = _user.pictureImage;
	}
	else{
		[cell setupCell];
	}
	
	return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSInteger section = indexPath.section;
	
	// profile
	if(section == 0){
		return 200;
	}
	
	return 100;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 40;
}


// section title
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	NSString *title;
	title = @"";
	
	return [title uppercaseString];
}


-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
	//Set the background color of the View
	view.tintColor = [UIColor darkColor];
	view.layer.zPosition = -999;
}


@end

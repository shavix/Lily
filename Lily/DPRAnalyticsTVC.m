//
//  DPRAnalyticsTVC.m
//  Lily
//
//  Created by David Richardson on 11/27/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import "DPRAnalyticsTVC.h"
#import "DPRDashboardTableViewCell.h"
#import "DPRAnalysisListTVC.h"
#import "DPRImageTableViewCell.h"
#import "DPRPortraitTableViewCell.h"
#import "DPRUIHelper.h"
#import "DPRCoreDataHelper.h"
#import "DPRUser.h"
#import "UIColor+CustomColors.h"

@interface DPRAnalyticsTVC ()

@property (strong, nonatomic) DPRUser *user;

@end

@implementation DPRAnalyticsTVC{
	NSArray *sectionNames;
}


- (void)viewDidLoad {
	[super viewDidLoad];
	[self setupUI];
	[self setupData];
}

- (void)setupData {
	sectionNames = @[@"Friends", @"This Year"];
	DPRCoreDataHelper *cdHelper = [DPRCoreDataHelper sharedModel];
	self.user = [cdHelper fetchUser];
}

#pragma mark - UI

- (void)setupUI{
	DPRUIHelper *UIHelper = [[DPRUIHelper alloc] init];
	[UIHelper setupTabUI:self withTitle:@"Analytics"];
	self.view.backgroundColor = [UIColor darkColor];
	[self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}

// get cell
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
	static NSString* cellIdentifier = @"AnalyticsCell";
	static NSString *protraitIdentifier = @"PortraitCell";

	// image cell
	if(indexPath.section == 0){
		DPRPortraitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:protraitIdentifier];
		cell.image.image = _user.pictureImage;
		cell.title.text = _user.fullName;
		NSString *subtitle = [NSString stringWithFormat:@"@%@",_user.username];
		cell.subtitle.text = subtitle;
		return cell;
	}
	
	// analytics cells
	else{
		DPRDashboardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
		
		// friends
		if(indexPath.section == 1){
			cell.image.image = [UIImage imageNamed:@"friends"];
			cell.title.text = @"Friends";
			cell.subtitle.text = @"Analytics on your transaction history with friends.";
		}
		
		// this year
		else if(indexPath.section == 2){
			cell.image.image = [UIImage imageNamed:@"monthlyDetails"];
			cell.title.text = @"This Year";
			cell.subtitle.text = @"Analytics on your transaction history over the last year on a monthly basis.";
		}
		return cell;
	}

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
	
	DPRAnalysisListTVC *analysisListTVC = segue.destinationViewController;
	NSInteger section = [self.tableView indexPathForSelectedRow].section;
	if(section == 1){
		analysisListTVC.pageType = @"Friends";
	}
	else if(section == 2){
		analysisListTVC.pageType = @"This Year";
	}
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	
	if(indexPath.section != 0){
		NSString *segueIdentifier = @"analysisSegue";
		[self performSegueWithIdentifier:segueIdentifier sender:self];
	}
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(indexPath.section == 0){
		return 125;
	}
	return 100;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	if(section == 0)
		return 20;
	return 40;
}


// section title
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	NSString *title = @"";
	if(section == 1){
		title = @"Friends";
	}
	else if(section == 2){
		title = @"This Year";
	}
	
	return [title uppercaseString];
}


-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
	//Set the background color of the View
	view.tintColor = [UIColor darkColor];
	view.layer.zPosition = -999;
}

@end

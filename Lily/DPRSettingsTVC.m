//
//  DPRSettingsTVC.m
//  Lily
//
//  Created by David Richardson on 10/28/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import "DPRSettingsTVC.h"
#import "DPRSettingsTableViewCell.h"
#import "DPRInformationVC.h"
#import "UIColor+CustomColors.h"

@interface DPRSettingsTVC ()

@end

@implementation DPRSettingsTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];

}

- (void)setupUI{
    
    self.view.backgroundColor = [UIColor darkColor];
    self.title = @"Settings";
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"informationSegue"])
    {
        NSIndexPath *indexPath = (NSIndexPath *)sender;
        
        DPRInformationVC *destVC = segue.destinationViewController;

        if(indexPath.section == 0){
            // help
            if(indexPath.row == 0){
                destVC.pageType = @"Help";
            }
            // about
            else if(indexPath.row == 1){
                destVC.pageType = @"About";
            }
        }
        else if(indexPath.section == 1){
            destVC.pageType = @"Licenses";
        }
        
        
    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self performSegueWithIdentifier:@"informationSegue" sender:indexPath];
    
}

#pragma mark - Table view data source

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath{
    
    NSString *identifier = @"SettingsCell";
    
    DPRSettingsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    // INFORMATION
    if(section == 0){
        // help
        if(row == 0){
            cell.title.text = @"Help";
            cell.subtitle.text = @"Information on how to navigate your way around the Lily application and use it effectively.";
            cell.image.image = [UIImage imageNamed:@"help"];
        }
        // about
        else if(row == 1){
            cell.title.text = @"About";
            cell.subtitle.text = @"Information about the creation of the Lily application.";
            cell.image.image = [UIImage imageNamed:@"about"];
        }
    }
    // LEGAL
    else if(section == 1){
        // licenses
        if(row == 0){
            cell.title.text = @"Licenses";
            cell.subtitle.text = @"Legal licenses on external products used in the creation of the Lily application.";
            cell.image.image = [UIImage imageNamed:@"licenses"];
        }
    }
    
    
    return cell;
    
}

// section title
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSString *title;
    
    if(section == 0){
        title = @"INFORMATION";
    }
    else if(section == 1){
        title = @"LEGAL";
    }
    
    return title;
    
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    
    //Set the background color of the View
    view.tintColor = [UIColor darkColor];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger rowHeight = 100;
    
    return rowHeight;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(section == 0){
        return 2;
    }
    else if (section == 1){
        return 1;
    }
    return 0;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

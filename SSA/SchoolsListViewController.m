//
//  SchoolsListViewController.m
//  SSA
//
//  Created by Sunera on 4/30/17.
//  Copyright © 2017 surya. All rights reserved.
//

#import "SchoolsListViewController.h"
#import "ObjectManager.h"

@interface SchoolsListViewController ()

@property (nonatomic, weak) IBOutlet UITableView *tableView;
- (IBAction)addSchoolAction:(id)sender;

@end

@implementation SchoolsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addSchoolAction:(id)sender{
    if ([self.schoolsListViewControllerDelegate respondsToSelector:@selector(addNewSchool)]) {
        [self.schoolsListViewControllerDelegate addNewSchool];
    }
}

- (void)updateSchoolsList{
    [self.tableView reloadData];
}

#pragma -mark UITableView Datasource and Delegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.schoolsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SchoolsListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SchoolsListTableViewCell"];
    SCHOOL_MODEL *school =  [self.schoolsArray objectAtIndex:indexPath.row];
    [cell updateData:school];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
    }
}
@end

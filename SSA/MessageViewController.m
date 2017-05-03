//
//  MessageViewController.m
//  SSA
//
//  Created by Sunera on 4/30/17.
//  Copyright © 2017 surya. All rights reserved.
//

#import "MessageViewController.h"

@interface MessageViewController ()
{
    NSMutableArray *arrayForBool;
    NSArray *kidsArray;
}
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    arrayForBool=[[NSMutableArray alloc]init];
    kidsArray=[[NSArray alloc]initWithObjects:
               @"Satish",
               @"Surya",
               @"Krish",
               nil];
    
    for (int i=0; i<[kidsArray count]; i++) {
        [arrayForBool addObject:[NSNumber numberWithBool:NO]];
    }
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ActivitySectionHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"ActivitySectionHeaderView"];
    
    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark UITableView Delegate and Datasource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if ([[arrayForBool objectAtIndex:section] boolValue]) {
        return section+2;
    }
    else
        return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessagesListTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"MessagesListTableViewCell"];
    [cell.messageFromLabel setText:@"Class teacher"];
    [cell.messageDescriptionLabel setText:@"message description comes here. message description comes here. message description comes here. message description comes here. message description comes here. message description comes here. message description comes here."];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [kidsArray count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    /*************** Close the section, once the data is selected ***********************************/
    [arrayForBool replaceObjectAtIndex:indexPath.section withObject:[NSNumber numberWithBool:NO]];
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
    
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ActivitySectionHeaderView *sectionHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ActivitySectionHeaderView"];
    sectionHeaderView.tag = section;
    /********** Add UITapGestureRecognizer to SectionView   **************/
    
    UITapGestureRecognizer  *headerTapped   = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionHeaderTapped:)];
    [sectionHeaderView addGestureRecognizer:headerTapped];
    
    return  sectionHeaderView;
    
    
}
- (void)sectionHeaderTapped:(UITapGestureRecognizer *)gestureRecognizer{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:gestureRecognizer.view.tag];
    if (indexPath.row == 0) {
        BOOL collapsed  = [[arrayForBool objectAtIndex:indexPath.section] boolValue];
        for (int i=0; i<[kidsArray count]; i++) {
            if (indexPath.section==i) {
                [arrayForBool replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:!collapsed]];
            }
        }
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:gestureRecognizer.view.tag] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
}

@end

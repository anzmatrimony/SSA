//
//  KidsListViewController.m
//  SSA
//
//  Created by Sunera on 5/1/17.
//  Copyright © 2017 surya. All rights reserved.
//

#import "KidsListViewController.h"
#import "ObjectManager.h"

@interface KidsListViewController ()

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIImageView *kidsListImageView;

-(IBAction)addNewKidAction:(id)sender;

@end

@implementation KidsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
    [_kidsListImageView.layer setCornerRadius:20];
    [_kidsListImageView.layer setMasksToBounds:true];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateKidsList{
    [self.tableView reloadData];
}
-(IBAction)addNewKidAction:(id)sender{
    if([self.kidsListViewControllerDelegate respondsToSelector:@selector(addNewKid)]){
        [self.kidsListViewControllerDelegate addNewKid];
    }
}
#pragma -mark UITableView Datasource and Delegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.kidsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KidsListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KidsListTableViewCell"];
    KID_MODEL *kid = [_kidsArray objectAtIndex:indexPath.row];
    [cell updateCellWithData:kid];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
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

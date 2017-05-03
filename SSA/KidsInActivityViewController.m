//
//  KidsInActivityViewController.m
//  SSA
//
//  Created by Sunera on 5/2/17.
//  Copyright © 2017 surya. All rights reserved.
//

#import "KidsInActivityViewController.h"

@interface KidsInActivityViewController ()
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@end

@implementation KidsInActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark UITableView Datasource and Delegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KidsListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KidsListTableViewCell"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
@end

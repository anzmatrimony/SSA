//
//  SchoolsListTableViewCell.h
//  SSA
//
//  Created by Sunera on 4/30/17.
//  Copyright © 2017 surya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ObjectManager.h"

@interface SchoolsListTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *schoolImageView;
@property (nonatomic, weak) IBOutlet UIView *dataView;
@property (nonatomic, weak) IBOutlet UILabel *schoolNameLabel,*schoolAddressLabel,*schoolUidLabel;

- (void)updateData:(SCHOOL_MODEL *)school;
@end

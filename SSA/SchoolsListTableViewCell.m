//
//  SchoolsListTableViewCell.m
//  SSA
//
//  Created by Sunera on 4/30/17.
//  Copyright © 2017 surya. All rights reserved.
//

#import "SchoolsListTableViewCell.h"
#import "Constants.h"

@implementation SchoolsListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_schoolImageView.layer setCornerRadius:45/2];
    [_schoolImageView.layer setMasksToBounds:true];
    [_dataView.layer setBorderWidth:1.0];
    [_dataView.layer setBorderColor:COLOR(221, 225, 227).CGColor];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateData:(SCHOOL_MODEL *)school{
    [_schoolNameLabel setText:school.SchoolName];
    [_schoolAddressLabel setText:school.createdOn];
}
@end

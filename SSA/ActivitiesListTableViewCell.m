//
//  ActivitiesListTableViewCell.m
//  SSA
//
//  Created by Sunera on 5/1/17.
//  Copyright © 2017 surya. All rights reserved.
//

#import "ActivitiesListTableViewCell.h"
#import "Constants.h"

@implementation ActivitiesListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_activityStaticImageView.layer setCornerRadius:40/2];
    [_activityStaticImageView.layer setMasksToBounds:true];
    [_dataView.layer setBorderWidth:1.0];
    [_dataView.layer setBorderColor:COLOR(221, 225, 227).CGColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

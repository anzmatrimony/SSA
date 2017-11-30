//
//  KidsListTableViewCell.m
//  SSA
//
//  Created by Sunera on 5/1/17.
//  Copyright © 2017 surya. All rights reserved.
//

#import "KidsListTableViewCell.h"
#import "Constants.h"

@implementation KidsListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_kidImageView.layer setCornerRadius:45/2];
    [_kidImageView.layer setMasksToBounds:true];
    [_dataView.layer setBorderWidth:1.0];
    [_dataView.layer setBorderColor:COLOR(221, 225, 227).CGColor];
    
    _unreadMessagesCountLabel.layer.cornerRadius = 10;
    _unreadMessagesCountLabel.clipsToBounds = true;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateCellWithData:(KID_MODEL *)kid{
    [_kidNameLabel setText:[NSString stringWithFormat:@"%@ %@",kid.firstName,kid.lastName]];
    [_schoolNameLabel setText:kid.schoolName];
    [_classNameLabel setText:kid.kidClass];
    [_sectionLabel setText:[NSString stringWithFormat:@"SECTION-%@",kid.Section]];
    [_statusLabel setText:[NSString stringWithFormat:@"Status : %@",kid.kidStatus]];
    if(kid.Image != nil && ([kid.Image integerValue] > 0 && [kid.Image integerValue] < 11)){
        [_kidImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"kid%@.jpg",kid.Image]]];
    }else{
        [_kidImageView setImage:[UIImage imageNamed:@"nopic.png"]];
    }
    if ([kid.unreadMessagesCount integerValue] != 0) {
        [_unreadMessagesCountLabel setHidden:false];
        [_unreadMessagesCountLabel setText:kid.unreadMessagesCount];
    }else{
        [_unreadMessagesCountLabel setHidden:true];
    }
}
@end

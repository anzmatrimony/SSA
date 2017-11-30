//
//  KidsListTableViewCellForTeacherTableViewCell.m
//  SSA
//
//  Created by Sunera on 8/5/17.
//  Copyright © 2017 surya. All rights reserved.
//

#import "KidsListTableViewCellForTeacherTableViewCell.h"
#import "Constants.h"

@implementation KidsListTableViewCellForTeacherTableViewCell

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
    
    if ([kid.unreadMessagesCount integerValue] != 0) {
        [_unreadMessagesCountLabel setHidden:false];
        [_unreadMessagesCountLabel setText:kid.unreadMessagesCount];
    }else{
        [_unreadMessagesCountLabel setHidden:true];
    }
}
@end

//
//  KidsListTableViewCellForTeacherTableViewCell.h
//  SSA
//
//  Created by Sunera on 8/5/17.
//  Copyright © 2017 surya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ObjectManager.h"

@interface KidsListTableViewCellForTeacherTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *kidImageView;
@property (nonatomic, weak) IBOutlet UIView *dataView;
@property (nonatomic, weak) IBOutlet UILabel *kidNameLabel,*unreadMessagesCountLabel,*classNameLabel;

- (void)updateCellWithData:(KID_MODEL *)kid;


@end

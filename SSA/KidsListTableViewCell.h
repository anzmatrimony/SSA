//
//  KidsListTableViewCell.h
//  SSA
//
//  Created by Sunera on 5/1/17.
//  Copyright © 2017 surya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ObjectManager.h"

@interface KidsListTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *kidImageView;
@property (nonatomic, weak) IBOutlet UIView *dataView;
@property (nonatomic, weak) IBOutlet UILabel *kidNameLabel,*schoolNameLabel,*unreadMessagesCountLabel,*classNameLabel,*statusLabel,*sectionLabel;

- (void)updateCellWithData:(KID_MODEL *)kid;


@end

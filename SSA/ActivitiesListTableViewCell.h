//
//  ActivitiesListTableViewCell.h
//  SSA
//
//  Created by Sunera on 5/1/17.
//  Copyright © 2017 surya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivitiesListTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIView *dataView;
@property (nonatomic, weak) IBOutlet UILabel *activityLabel,*activityDescriptionLabel;
@property (nonatomic, weak) IBOutlet UIImageView *activityStaticImageView;
@end

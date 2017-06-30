//
//  KidsListViewController.h
//  SSA
//
//  Created by Sunera on 5/1/17.
//  Copyright © 2017 surya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KidsListTableViewCell.h"
@class AppDelegate;

@protocol KidsListViewControllerProtocol <NSObject>

- (void)addNewKid;

@end
@interface KidsListViewController : UIViewController{
    AppDelegate *appDelegate;
}

@property (nonatomic, strong) NSArray *kidsArray;
@property (nonatomic, weak) IBOutlet UIView *addKidBackgroundView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *addKidBackgroundViewHeight;

@property (nonatomic, strong) id<KidsListViewControllerProtocol> kidsListViewControllerDelegate;

- (void)updateKidsList;
@end

//
//  KidsListViewController.h
//  SSA
//
//  Created by Sunera on 5/1/17.
//  Copyright © 2017 surya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KidsListTableViewCell.h"

@protocol KidsListViewControllerProtocol <NSObject>

- (void)addNewKid;

@end
@interface KidsListViewController : UIViewController

@property (nonatomic, weak) NSArray *kidsArray;

@property (nonatomic, strong) id<KidsListViewControllerProtocol> kidsListViewControllerDelegate;

- (void)updateKidsList;
@end

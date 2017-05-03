//
//  AddKidViewController.h
//  SSA
//
//  Created by Sunera on 5/1/17.
//  Copyright © 2017 surya. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddKidViewControllerProtocol <NSObject>

- (void)didKidAdded;

@end
@interface AddKidViewController : UIViewController

@property (nonatomic, strong) id<AddKidViewControllerProtocol> addKidViewControllerDelegate;

@property (nonatomic, assign, getter=isFromKidsListPage) BOOL fromKidsListPage;
@end

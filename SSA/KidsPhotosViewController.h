//
//  KidsPhotosViewController.h
//  SSA
//
//  Created by Nama's on 29/10/17.
//  Copyright © 2017 surya. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KidsPhotosViewControllerProtocol <NSObject>

- (void)didDismiss;
- (void)didSelectKidImage:(NSDictionary *)selectedKidImageDict;

@end

@interface KidsPhotosViewController : UIViewController
{
    NSMutableArray *kidImagesArray;
}
@property (nonatomic, strong) id<KidsPhotosViewControllerProtocol> kidsPhotosViewControllerDelegate;

@end

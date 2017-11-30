//
//  KidsPhotosViewController.m
//  SSA
//
//  Created by Nama's on 29/10/17.
//  Copyright © 2017 surya. All rights reserved.
//

#import "KidsPhotosViewController.h"

@interface KidsPhotosViewController ()
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@end

@implementation KidsPhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"Selct Image"];
    kidImagesArray = [[NSMutableArray alloc] init];
    [self prepareKidImages];
    [self.collectionView reloadData];
    [self addRightBarButton];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addRightBarButton{
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitButton setTitle:@"Cancel" forState:UIControlStateNormal];
    //_slideMenuButton.frame = CGRectMake(0, 0, slidemenuImage.size.width, slidemenuImage.size.height);
    submitButton.frame = CGRectMake(20, 20, 80, 25);
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[_slideMenuButton setTitle:@"Left" forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customBarItem1 = [[UIBarButtonItem alloc] initWithCustomView:submitButton];
    self.navigationItem.rightBarButtonItem = customBarItem1;
}

- (void)cancelAction:(id)sender{
    if ([self.kidsPhotosViewControllerDelegate respondsToSelector:@selector(didDismiss)]) {
        [self.kidsPhotosViewControllerDelegate didDismiss];
    }
}
- (void)prepareKidImages{
    NSDictionary *dict1 = @{@"ImageName" : @"kid1.jpg", @"ImageId" : @"1", @"KidRef" : @"kid1"};
    [kidImagesArray addObject:dict1];
    
    NSDictionary *dict2 = @{@"ImageName" : @"kid2.jpg", @"ImageId" : @"2", @"KidRef" : @"kid2"};
    [kidImagesArray addObject:dict2];
    
    NSDictionary *dict3 = @{@"ImageName" : @"kid3.jpg", @"ImageId" : @"3", @"KidRef" : @"kid3"};
    [kidImagesArray addObject:dict3];
    
    NSDictionary *dict4 = @{@"ImageName" : @"kid4.jpg", @"ImageId" : @"4", @"KidRef" : @"kid4"};
    [kidImagesArray addObject:dict4];
    
    NSDictionary *dict5 = @{@"ImageName" : @"kid5.jpg", @"ImageId" : @"5", @"KidRef" : @"kid5"};
    [kidImagesArray addObject:dict5];
    
    NSDictionary *dict6 = @{@"ImageName" : @"kid6.jpg", @"ImageId" : @"6", @"KidRef" : @"kid6"};
    [kidImagesArray addObject:dict6];
    
    NSDictionary *dict7 = @{@"ImageName" : @"kid7.jpg", @"ImageId" : @"7", @"KidRef" : @"kid7"};
    [kidImagesArray addObject:dict7];
    
    NSDictionary *dict8 = @{@"ImageName" : @"kid8.jpg", @"ImageId" : @"8", @"KidRef" : @"kid8"};
    [kidImagesArray addObject:dict8];
    
    NSDictionary *dict9 = @{@"ImageName" : @"kid9.jpg", @"ImageId" : @"9", @"KidRef" : @"kid9"};
    [kidImagesArray addObject:dict9];
    
    NSDictionary *dict10 = @{@"ImageName" : @"kid10.jpg", @"ImageId" : @"10", @"KidRef" : @"kid10"};
    [kidImagesArray addObject:dict10];
    
    NSDictionary *dict11 = @{@"ImageName" : @"nopic.jpg", @"ImageId" : @"11", @"KidRef" : @"kid11"};
    [kidImagesArray addObject:dict11];
}

# pragma Mark UICollectionView Delegate and Datasource methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return kidImagesArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:100];
    NSDictionary *kidImageDict = [kidImagesArray objectAtIndex:indexPath.row];
    recipeImageView.image = [UIImage imageNamed:[kidImageDict objectForKey:@"ImageName"]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.kidsPhotosViewControllerDelegate respondsToSelector:@selector(didSelectKidImage:)]) {
        [self.kidsPhotosViewControllerDelegate didSelectKidImage:[kidImagesArray objectAtIndex:indexPath.row]];
    }
}

@end

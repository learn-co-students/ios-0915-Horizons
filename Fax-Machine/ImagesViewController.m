////
//  ImagesViewController.m
//  Fax-Machine
//
//  Created by Selma NB on 11/18/15.
//  Copyright © 2015 Flatiron-School. All rights reserved.
//

#import "ImagesViewController.h"
#import "imagesCustomCell.h"

@interface ImagesViewController ()

@property (strong, nonatomic) NSArray *arrayWithImages;
@property (strong, nonatomic) NSArray *arrayWithDescriptions;


@end

@implementation ImagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self imagesCollectionViewController]setDataSource:self];
    [[self imagesCollectionViewController]setDelegate:self];
    
    self.arrayWithImages =[[NSArray alloc]initWithObjects:@"img5.jpg",@"img2.jpg",@"img3.jpg",@"img4.jpg",@"img5.jpg",@"img6.jpg",@"img6.jpg",@"img7.jpg",@"img8.jpg",@"img9.jpg",@"img10.jpg",@"img1.JPG", nil];
    self.arrayWithDescriptions =[[NSArray alloc]initWithObjects:@"♡",@"♡",@"♡",@"♡",@"♡",@"♡",@"♡",@"♡",@"♡",@"♡",@"♡",nil];
    
    
 
}

//DataStore and Delegate Methods

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrayWithImages.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

   imagesCustomCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];

    cell.myImage.image = [UIImage imageNamed:self.arrayWithImages[indexPath.item]];
    //cell.mydiscriptionLabel.text = [NSString stringWithFormat:self.arrayWithDescriptions[indexPath.item]];
    cell.mydiscriptionLabel.textColor= [UIColor whiteColor];
    cell.mydiscriptionLabel.font=[UIFont boldSystemFontOfSize:40.0];
   [[cell mydiscriptionLabel]setText:[self.arrayWithDescriptions objectAtIndex:indexPath.item]];

    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat width = self.view.frame.size.width/2;
    
    
    
    return CGSizeMake(width, width);
    
   // UIImage *image = [self.arrayWithImages objectAtIndex:indexPath.row];
////    //You may want to create a divider to scale the size by the way..
////
////    return CGSizeMake(image.size.width, image.size.height);
//    
//    return CGSizeMake(self.view.frame.size.width/2,self.view.frame.size.height/4);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//setupSegue

@end

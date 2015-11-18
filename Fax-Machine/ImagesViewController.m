//
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
    
    self.arrayWithImages =[[NSArray alloc]initWithObjects:@"img1.JPG",@"img2.jpg",@"img3.jpg",@"img4.jpg",@"img5.jpg", nil];
    self.arrayWithDescriptions =[[NSArray alloc]initWithObjects:@"1",@"2",@"3",@"4",@"5",nil];
    
    
 
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

     //cell.myImage.image = [UIImage imageNamed:@"img2.jpg"];
    cell.myImage.image = [UIImage imageNamed:self.arrayWithImages[indexPath.item]];
     //cell.myImage.image = self.arrayWithImages[indexPath.item];
     // [[cell myImage]setImage:[self.arrayWithImages objectAtIndex:indexPath.row]];
    [[cell mydiscriptionLabel]setText:[self.arrayWithDescriptions objectAtIndex:indexPath.item]];

    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

////
//  ImagesViewController.m
//  Fax-Machine
//
//  Created by Selma NB on 11/18/15.
//  Copyright © 2015 Flatiron-School. All rights reserved.
//

#import "ImagesViewController.h"
#import "imagesCustomCell.h"
#import "ImagesDetailsViewController.h"
#import "DataStore.h"
#import <YYWebImage/YYWebImage.h>
#import "APIConstants.h"
#import <FontAwesomeKit/FontAwesomeKit.h>

@interface ImagesViewController ()

@property (strong, nonatomic) NSArray *arrayWithImages;
@property (strong, nonatomic) NSArray *arrayWithDescriptions;
@property (nonatomic, strong) RESideMenu *sideMenuViewController;
@property (nonatomic, strong) NSMutableArray *downloadedImages;

@property (nonatomic, strong) DataStore *dataStore;

@end

@implementation ImagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self imagesCollectionViewController]setDataSource:self];
    [[self imagesCollectionViewController]setDelegate:self];
    [self.view setBackgroundColor:[UIColor colorWithRed:0.66
                                                  green:0.66
                                                   blue:0.66
                                                  alpha:0.75]];
    
//    self.arrayWithImages =[[NSArray alloc]initWithObjects:@"img5.jpg",@"img2.jpg",@"img3.jpg",@"img4.jpg",@"img5.jpg",@"img6.jpg",@"img6.jpg",@"img7.jpg",@"img8.jpg",@"img9.jpg",@"img10.jpg",@"img1.JPG",@"img5.jpg",@"img2.jpg",@"img3.jpg",@"img4.jpg",@"img5.jpg",@"img6.jpg",@"img6.jpg",@"img7.jpg",@"img8.jpg",@"img9.jpg",@"img10.jpg",@"img1.JPG",nil];
    self.arrayWithDescriptions =[[NSArray alloc]initWithObjects:@"♡",@"♡",@"♡",@"♡",@"♡",@"♡",@"♡",@"♡",@"♡",@"♡",@"♡",@"♡",@"♡",@"♡",@"♡",@"♡",@"♡",@"♡",@"♡",@"♡",@"♡",@"♡",nil];
  
//  self.arrayWithImages = [
  //[self.dataStore fetchUserImagesWithCompletion:^(BOOL complete){
  //

  
  
    FAKFontAwesome *navIcon = [FAKFontAwesome naviconIconWithSize:35];
    FAKFontAwesome *filterIcon = [FAKFontAwesome filterIconWithSize:35];
    self.navigationItem.leftBarButtonItem.image = [navIcon imageWithSize:CGSizeMake(35, 35)];
    self.navigationItem.rightBarButtonItem.image = [filterIcon imageWithSize:CGSizeMake(35, 35)];
    
    self.downloadedImages = [NSMutableArray new];
    self.dataStore = [DataStore sharedDataStore];
    [self.dataStore downloadPicturesToDisplay:20 WithCompletion:^(BOOL complete) {
        if (complete) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.imagesCollectionViewController reloadData];
            }];
        }
    }];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self.imagesCollectionViewController reloadData];
    [self.dataStore.controllers addObject: self];
}

- (RESideMenu *)sideMenuViewController
{
    UIViewController *iter = self.parentViewController;
    while (iter) {
        if ([iter isKindOfClass:[RESideMenu class]]) {
            return (RESideMenu *)iter;
        } else if (iter.parentViewController && iter.parentViewController != iter) {
            iter = iter.parentViewController;
        } else {
            iter = nil;
        }
    }
    return nil;
}


- (IBAction)presentLeftMenu:(id)sender {
    
    [self.sideMenuViewController presentLeftMenuViewController];
}

#pragma Collection view protocal methods

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataStore.downloadedPictures.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
   imagesCustomCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];

    ImageObject *parseImage = self.dataStore.downloadedPictures[indexPath.row];

    NSString *urlString = [NSString stringWithFormat:@"%@%@", IMAGE_FILE_PATH, parseImage.imageID];
    NSURL *url = [NSURL URLWithString:urlString];
    cell.mydiscriptionLabel.text = [NSString stringWithFormat:@"❤️ %@ 🗯 %lu", parseImage.likes, parseImage.comments.count];
    //[self.downloadedImages addObject:url];
    
//    [cell.myImage yy_setImageWithURL:url options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation];
    [cell.myImage yy_setImageWithURL:url placeholder:[UIImage imageNamed:@"placeholder"] options:YYWebImageOptionProgressive completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
        if (from == YYWebImageFromDiskCache) {
            NSLog(@"From Cache!");
        }
    }];
    cell.mydiscriptionLabel.textColor= [UIColor whiteColor];
    cell.mydiscriptionLabel.font=[UIFont boldSystemFontOfSize:16.0];
    
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = self.view.frame.size.width/2;
    return CGSizeMake(width, width);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"photoDetails"])
    {
    
        UICollectionViewCell *cell = (UICollectionViewCell*)sender;
        NSIndexPath *indexPath = [self.imagesCollectionViewController indexPathForCell:cell];
        ImagesDetailsViewController *imageVC = segue.destinationViewController;
        imageVC.image = self.dataStore.downloadedPictures[indexPath.row];
    }
    
}

@end

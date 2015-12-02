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
#import "RESideMenu.h"


@interface ImagesViewController () <RESideMenuDelegate>

@property (strong, nonatomic) NSArray *arrayWithImages;
@property (strong, nonatomic) NSArray *arrayWithDescriptions;
@property (nonatomic, strong) RESideMenu *sideMenuViewController;
//@property (nonatomic, strong) NSMutableArray *downloadedImages;
@property (weak, nonatomic) IBOutlet UICollectionView *imageCollectionView;

@property (nonatomic, strong) DataStore *dataStore;
//@property (nonatomic)NSUInteger *timesThatThisScreenLoaded;
@end

@implementation ImagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    [[self imagesCollectionViewController]setDataSource:self];
    [[self imagesCollectionViewController]setDelegate:self];

    FAKFontAwesome *navIcon = [FAKFontAwesome naviconIconWithSize:35];
    FAKFontAwesome *filterIcon = [FAKFontAwesome filterIconWithSize:35];
    self.navigationItem.leftBarButtonItem.image = [navIcon imageWithSize:CGSizeMake(35, 35)];
    self.navigationItem.rightBarButtonItem.image = [filterIcon imageWithSize:CGSizeMake(35, 35)];
    
    self.dataStore = [DataStore sharedDataStore];
    [self.dataStore downloadPicturesToDisplay:12 WithCompletion:^(BOOL complete) {
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
    if (self.isFavorite) {
        return self.dataStore.favoriteImages.count;
    } else if (self.isUserImageVC){
      return self.dataStore.userPictures.count;
    } else{
        return self.dataStore.downloadedPictures.count;
    }
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
   imagesCustomCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    ImageObject *parseImage;
    if (self.isFavorite) {
        parseImage = self.dataStore.favoriteImages[indexPath.row];
    } else if (self.isUserImageVC){
      parseImage = self.dataStore.userPictures[indexPath.row];
    } else{
        parseImage = self.dataStore.downloadedPictures[indexPath.row];
    }

    NSString *urlString = [NSString stringWithFormat:@"%@%@", IMAGE_FILE_PATH, parseImage.imageID];
    //NSString *urlString = [NSString stringWithFormat:@"%@thumbnail%@", IMAGE_FILE_PATH, parseImage.imageID];
    
    
    NSURL *url = [NSURL URLWithString:urlString];
    cell.mydiscriptionLabel.text = [NSString stringWithFormat:@"❤️ %@ 🗯 %lu", parseImage.likes, parseImage.comments.count];
    //NSLog(@"Image ID: %@", url);
//    [cell.myImage yy_setImageWithURL:url options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation];
    [cell.myImage yy_setImageWithURL:url placeholder:[UIImage imageNamed:@"placeholder"] options:YYWebImageOptionProgressive completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
//        if (from == YYWebImageFromDiskCache) {
//            NSLog(@"From Cache!");
//        }
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
    CGFloat height = self.view.frame.size.height - self.navigationController.navigationBar.bounds.size.height;
    
    return CGSizeMake(width, height/3);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    *targetContentOffset = scrollView.contentOffset; // set acceleration to 0.0
//    float pageHeight = (float)self.imageCollectionView.bounds.size.width;
//    int minSpace = 10;
//    
//    int cellToSwipe = (scrollView.contentOffset.y)/(pageHeight + minSpace) + 0.5; // cell width + min spacing for lines
//    if (cellToSwipe < 0) {
//        cellToSwipe = 0;
//    } else if (cellToSwipe >= self.dataStore.downloadedPictures.count) {
//        cellToSwipe = ((int)self.dataStore.downloadedPictures.count) - 1;
//    }
//    [self.imageCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"photoDetails"])
    {
    
        UICollectionViewCell *cell = (UICollectionViewCell*)sender;
        NSIndexPath *indexPath = [self.imagesCollectionViewController indexPathForCell:cell];
        ImagesDetailsViewController *imageVC = segue.destinationViewController;
        if (self.isFavorite) {
            imageVC.image = self.dataStore.favoriteImages[indexPath.row];
        } else if (self.isUserImageVC) {
          imageVC.image = self.dataStore.userPictures[indexPath.row];
        } else{
            imageVC.image = self.dataStore.downloadedPictures[indexPath.row];
        }
    }
    
}

@end

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
#import "filterViewController.h"
#import "RESideMenu.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <ParseTwitterUtils/ParseTwitterUtils.h>


@interface ImagesViewController () <RESideMenuDelegate>

@property (strong, nonatomic) NSArray *arrayWithImages;
@property (strong, nonatomic) NSArray *arrayWithDescriptions;
@property (nonatomic, strong) RESideMenu *sideMenuViewController;
@property (weak, nonatomic) IBOutlet UICollectionView *imageCollectionView;
@property (nonatomic) CGFloat scrollOffset;

@property (nonatomic)BOOL isFirstTime;
@property (nonatomic, strong) DataStore *dataStore;

@end

@implementation ImagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataStore = [DataStore sharedDataStore];

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"mountains_hd"]];
    
    [[self imagesCollectionViewController]setDataSource:self];
    [[self imagesCollectionViewController]setDelegate:self];
    
    self.scrollOffset = 0;
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

  if ([FBSDKAccessToken currentAccessToken]) {
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields":@"id, name, picture"}]

     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
       if (!error) {
         NSLog(@"fetched user:%@", result);

         
         NSLog(@"result name:%@", result[@"name"]);
         NSLog(@"_________");
         NSString *username = result[@"name"];
         [[PFUser currentUser] setUsername:username];
         [[PFUser currentUser]saveEventually:^(BOOL succeeded, NSError * _Nullable error) {
           NSLog(@"saved");
         }];

         NSString *imageStringOfLoginUser = [[[result valueForKey:@"picture"] valueForKey:@"data"] valueForKey:@"url"];
         NSURL *url = [NSURL URLWithString: imageStringOfLoginUser];

                 
                 NSString *fileName = [NSString stringWithFormat:@"%@profilPic.png", [PFUser currentUser].objectId];
                 NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"upload-profilePic.tmp"];
                 NSLog(@"filepath %@", filePath);
                 NSData *imageData = [NSData dataWithContentsOfURL:url];
                 [imageData writeToFile:filePath atomically:YES];
                 AWSS3TransferManagerUploadRequest *uploadRequest = [AWSS3TransferManagerUploadRequest new];
                 uploadRequest.body = [NSURL fileURLWithPath:filePath];
                 uploadRequest.key = fileName;
                 uploadRequest.contentType = @"image/png";
                 uploadRequest.bucket = @"fissamplebucket";
                 NSLog(@"Profile picture uploadRequest: %@", uploadRequest);
                 
                 [DataStore uploadPictureToAWS:uploadRequest WithCompletion:^(BOOL complete) {
                     NSLog(@"Profile picture upload completed!");
                     [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                     }];
                 }];
                 
             }
         }];
 
       } else if ([PFTwitterUtils isLinkedWithUser:[PFUser currentUser]]){
    NSLog(@"twitter:%@",[PFTwitterUtils twitter].screenName);
    NSString *username  = [PFTwitterUtils twitter].screenName;
     [[PFUser currentUser] setUsername:username];
    }
  
  
  NSString *profileImageUrl = [[PFUser currentUser] objectForKey:@"profile_image_url"];
  
  //  As an example we could set an image's content to the image
  dispatch_async
  (dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^ {
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:profileImageUrl]];
    
    UIImage *image = [UIImage imageWithData:imageData];
    
    dispatch_async(dispatch_get_main_queue(), ^{
      NSLog(@"profile picture: %@ %@",imageData,image);
    });
  });

  

    if (!self.isFiltered) {
    }
    
    //Initial call to fetch images to display
    if (!self.isFiltered && !self.isFirstTime) {
        [[HelperMethods new] parseVerifyEmailWithMessage:@"Please Verify Your Email!" viewController:self];
        self.isFirstTime = YES;
        
        [self.dataStore downloadPicturesToDisplay:12 WithCompletion:^(BOOL complete) {
            if (complete) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [self.imagesCollectionViewController reloadData];
                }];
            }
        }];
    }
}



-(void)viewWillAppear:(BOOL)animated {
    self.isFiltered = NO;

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
  NSString *location;
    if (self.isFavorite) {
        parseImage = self.dataStore.favoriteImages[indexPath.row];
      location = parseImage.location.city;

    } else if (self.isUserImageVC){
      parseImage = self.dataStore.userPictures[indexPath.row];
      location = parseImage.location.city;
    } else{
        parseImage = self.dataStore.downloadedPictures[indexPath.row];
      location = parseImage.location.city;
    }
  
 
    //NSString *urlString = [NSString stringWithFormat:@"%@%@", IMAGE_FILE_PATH, parseImage.imageID];
    NSString *urlString = [NSString stringWithFormat:@"%@thumbnail%@", IMAGE_FILE_PATH, parseImage.imageID];
    
    
    NSURL *url = [NSURL URLWithString:urlString];

    cell.mydiscriptionLabel.text = [NSString stringWithFormat:@"❤️ %@ 🗯 %lu",  parseImage.likes, parseImage.comments.count];
  cell.placeLabel.text = @"HI";
  cell.placeLabel.text = location;

    [cell.myImage yy_setImageWithURL:url placeholder:[UIImage imageNamed:@"placeholder"] options:YYWebImageOptionProgressive completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
//        if (from == YYWebImageFromDiskCache) {
//            NSLog(@"From Cache!");
//        }
    }];
    cell.mydiscriptionLabel.textColor= [UIColor whiteColor];
    cell.mydiscriptionLabel.font=[UIFont boldSystemFontOfSize:16.0];
    
  cell.placeLabel.textColor= [UIColor whiteColor];
  cell.placeLabel.font=[UIFont boldSystemFontOfSize:16.0];
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
    
    //*targetContentOffset = scrollView.contentOffset; // set acceleration to 0.0

//    NSLog(@"Scroll Velocity: %.2f", velocity.y);
//    NSLog(@"Scroll view offset y: %.2f", scrollView.contentOffset.y);
//    NSLog(@"Scroll view content height: %.2f", scrollView.contentSize.height);
//    NSLog(@"Default scroll offset: %.2f", self.scrollOffset);
    
    [UIView animateWithDuration:0.5 animations:^{
        if (velocity.y <= -4) {
            self.navigationController.navigationBarHidden = NO;
            *targetContentOffset = CGPointMake(0, 0);
            self.scrollOffset = scrollView.contentOffset.y;
        }else if (scrollView.contentOffset.y <= 0){
            self.navigationController.navigationBarHidden = NO;
            self.scrollOffset = scrollView.contentOffset.y;
        }else if (fabs(velocity.y) >= 0.5) {
            self.navigationController.navigationBarHidden = YES;
            self.scrollOffset = scrollView.contentOffset.y;
        }else if (scrollView.contentOffset.y < self.scrollOffset){
            self.navigationController.navigationBarHidden = NO;
            self.scrollOffset = scrollView.contentOffset.y;
        }else{
            self.navigationController.navigationBarHidden = NO;
            self.scrollOffset = scrollView.contentOffset.y;
        }
        
        [self.view layoutIfNeeded];
    }];
    
    
    if (scrollView.contentSize.height > self.view.frame.size.height && (scrollView.contentOffset.y*2 + 300) > scrollView.contentSize.height) {
        [self.dataStore downloadPicturesToDisplay:12 WithCompletion:^(BOOL complete) {
            if (complete) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [self.imagesCollectionViewController reloadData];
                }];
            }
        }];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"photoDetails"])
    {
        self.navigationController.navigationBarHidden = NO;
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

-(void)filteringImagesCountryLevel:(NSDictionary *)filterParameters
{
   [[NSOperationQueue mainQueue] addOperationWithBlock:^
   {
      [self.imagesCollectionViewController reloadData]; 
   }];
}


@end

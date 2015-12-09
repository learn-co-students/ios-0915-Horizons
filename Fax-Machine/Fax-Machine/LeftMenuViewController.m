//
//  LeftMenuViewController.m
//  Fax-Machine
//
//  Created by Kevin Lin on 11/20/15.
//  Copyright © 2015 Flatiron-School. All rights reserved.
//

#import "LeftMenuViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "DataStore.h"
#import "ImagesViewController.h"
#import <FontAwesomeKit/FontAwesomeKit.h>
#import "APIConstants.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <YYWebImage/YYWebImage.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "ImagesViewController.h"
#import <SCLAlertView-Objective-C/SCLAlertView.h>

@interface LeftMenuViewController ()

@property (nonatomic, readwrite, strong) UITableView *tableView;
@property (nonatomic, strong) DataStore *store;

@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) UIImage *selectedImage;

@end

@implementation LeftMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //Initiating the image picker controller.
    self.imagePickerController = [UIImagePickerController new];
    self.view.backgroundColor = [UIColor clearColor];
    
    self.store = [DataStore sharedDataStore];
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height - (54 * 8 + 46)) / 2.0f, self.view.frame.size.width, 54 * 8 + 46) style:UITableViewStylePlain];
        
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = NO;
        tableView.backgroundView = nil;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.bounces = NO;
        tableView.scrollsToTop = NO;
        tableView;
    });
    
    [self.view addSubview:self.tableView];
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIStoryboard *uploadImage = [UIStoryboard storyboardWithName:@"ImageUpload" bundle:nil];
    UINavigationController *navController;
    ImagesViewController *imageViewVC = self.store.controllers[0];
    switch (indexPath.row) {
        case 0:
        {
            [self imageUpLoadSource];
            break;
        }
        case 1:
        {
            [self.sideMenuViewController hideMenuViewController];
            navController = [[UINavigationController alloc] initWithRootViewController:self.store.controllers[0]];
            navController.navigationBar.shadowImage = [UIImage new];
            navController.navigationBar.translucent = YES;
            navController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
            imageViewVC.title = @"Home";
            imageViewVC.isFavorite = NO;
            imageViewVC.isUserImageVC = NO;
            imageViewVC.isFollowing = NO;
            imageViewVC.isFiltered = NO;
            
            [self.sideMenuViewController setContentViewController:navController];
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isUserVC"];
            
            break;
        }
        case 2:
        {
            imageViewVC.isFavorite = NO;
            imageViewVC.isUserImageVC = NO;
            
            PFObject *user = PFUser.currentUser;
            if(![[user objectForKey:@"emailVerified"] boolValue] && [user objectForKey:@"email"]!=nil)
            {
                [[HelperMethods new] parseVerifyEmailWithMessage:@"You must Verify your email before you can upload!" viewController:self];
                NSLog(@"It is not verified!");
            }else{
                [self.sideMenuViewController hideMenuViewController];
                imageViewVC.isFavorite = NO;
                imageViewVC.isUserImageVC = NO;
                imageViewVC.isFollowing = NO;
                imageViewVC.isFiltered = NO;
                [self presentViewController:[uploadImage instantiateViewControllerWithIdentifier:@"pickUpload"] animated:YES completion:nil];
            }
            break;
        }
        case 3:
        {
            [self.store.userPictures removeAllObjects];
            navController = [[UINavigationController alloc]initWithRootViewController:imageViewVC];
            navController.navigationBar.shadowImage = [UIImage new];
            navController.navigationBar.translucent = YES;
            navController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
            imageViewVC.title = @"My Images";
            
            [self.store fetchUserImagesWithCompletion:^(BOOL complete) {
                if (complete) {
                    [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                        [self.sideMenuViewController hideMenuViewController];
                        imageViewVC.isUserImageVC = YES;
                        imageViewVC.isFavorite = NO;
                        imageViewVC.isFollowing = NO;
                        imageViewVC.isFiltered = NO;
                      imageViewVC.imagesCount = self.store.userPictures.count;
                        [self.sideMenuViewController setContentViewController:navController];
                        
                    }];
                }
            }];
            break;
        }
        case 4:
        {
            [self.store.favoriteImages removeAllObjects];
            navController = [[UINavigationController alloc] initWithRootViewController:imageViewVC];
            navController.navigationBar.shadowImage = [UIImage new];
            navController.navigationBar.translucent = YES;
            navController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
            imageViewVC.title = @"My Favorites";
            
            [self.store getFavoriteImagesWithSuccess:^(BOOL success) {
                if (success) {
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        [self.sideMenuViewController hideMenuViewController];
                        imageViewVC.isFavorite = YES;
                        imageViewVC.isUserImageVC = NO;
                        imageViewVC.isFollowing = NO;
                        imageViewVC.isFiltered = NO;
                        imageViewVC.imagesCount = self.store.favoriteImages.count;
                        [self.sideMenuViewController setContentViewController:navController];
                    }];
                }
            }];
            break;
        }
        case 5:
        {
            UIStoryboard *followingStoryboard = [UIStoryboard storyboardWithName:@"following" bundle:nil];
            FollowingListTableViewController *desVC = [followingStoryboard instantiateViewControllerWithIdentifier:@"following"];
                    desVC.uhoString= @"Uho, \n it looks like you're not following \n anyone yet!";
            navController = [[UINavigationController alloc] initWithRootViewController:desVC];
            navController.navigationBar.shadowImage = [UIImage new];
            navController.navigationBar.translucent = YES;
            navController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
            
            [self.store getFollowingUsersWithSuccess:^(BOOL success) {
                if (success) {
                  [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                    [self.sideMenuViewController hideMenuViewController];
                    desVC.followingList = self.store.followingList;
                    desVC.sideMenu = self.sideMenuViewController;
                    imageViewVC.isFavorite = NO;
                    imageViewVC.isUserImageVC = NO;
                    imageViewVC.isFollowing = NO;
                    imageViewVC.isFiltered = NO;
                    imageViewVC.imagesCount = self.store.followingList.count;
                    //                    [self presentViewController:navController animated:YES completion:nil];
                    
                    [self.sideMenuViewController setContentViewController:navController];

                  }];

                }
            }];
            break;
        }
        case 6:
        {
            UIStoryboard *followingStoryboard = [UIStoryboard storyboardWithName:@"following" bundle:nil];
            
            FollowingListTableViewController *desVC = [followingStoryboard instantiateViewControllerWithIdentifier:@"following"];
          desVC.uhoString= @"Uho, \n it looks like nobody is following \n you yet!";
            navController = [[UINavigationController alloc] initWithRootViewController:desVC];
            navController.navigationBar.shadowImage = [UIImage new];
            navController.navigationBar.translucent = YES;
            navController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
            
            [self.store getFollowersWithUserId:[PFUser currentUser].objectId success:^(BOOL success) {
                if (success) {
                  [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                    [self.sideMenuViewController hideMenuViewController];
                    desVC.followingList = self.store.followerList;
                    desVC.sideMenu = self.sideMenuViewController;
                    imageViewVC.isFavorite = NO;
                    imageViewVC.isUserImageVC = NO;
                    imageViewVC.isFollowing = NO;
                    imageViewVC.isFiltered = NO;
                    imageViewVC.imagesCount = self.store.followerList.count;

//                    [self presentViewController:navController animated:YES completion:nil];
                    [self.sideMenuViewController setContentViewController:navController];

                  }];

                }
            }];
            break;
        }
        case 7:
        {
            [self.store logoutWithSuccess:^(BOOL success) {
                [self.store.downloadedPictures removeAllObjects];
                [self.store.comments removeAllObjects];
                [self.store.followerList removeAllObjects];
                [self.store.followerList removeAllObjects];
                [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
            }];
            break;
        }
    }
}

#pragma mark -
#pragma mark UITableView Datasource

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!indexPath.row) {
        return 100;
    }
    return 54;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 8;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0) {
        __block NSString *facebookUrl = @"";
        if ([FBSDKAccessToken currentAccessToken]) {
            [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields":@"id, name, picture"}]
             
             startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                 if (!error) {
                     NSLog(@"fetched user:%@", result);
                     facebookUrl = result[@"picture"][@"data"][@"url"];
                     
                 }
             }];
        }
        
        // The profile photo
        static NSString *profileCellIdentifier = @"ProfileCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:profileCellIdentifier];
        
        if(!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:profileCellIdentifier];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectedBackgroundView = [[UIView alloc] init];
            
            UIImageView *ourImageView = [[UIImageView alloc] initWithFrame:CGRectMake(25, 0, 100, 100)];
            ourImageView.layer.cornerRadius = 50;
            ourImageView.layer.masksToBounds = YES;
            ourImageView.layer.borderWidth = 1;
            ourImageView.layer.borderColor = [UIColor blackColor].CGColor;
            ourImageView.tag = 99;
            ourImageView.contentMode = UIViewContentModeScaleAspectFill;
            
            [cell.contentView addSubview:ourImageView];
        }
        
        UIImageView *ourImageView = [cell viewWithTag:99];
        
        if (self.selectedImage){
            ourImageView.image = self.selectedImage;
        }
        //        else if ([FBSDKAccessToken currentAccessToken]) {
        //
        //        }
        else{
            NSString *urlString = [NSString stringWithFormat:@"%@%@profilPic.png", IMAGE_FILE_PATH,[PFUser currentUser].objectId];
            NSURL *profileUrl = [NSURL URLWithString:urlString];
            [ourImageView yy_setImageWithURL:profileUrl placeholder:[UIImage imageNamed:@"profile_placeholder"]];
            //NSLog(@"profile url: %@",profileUrl);
        }
        
        return cell;
    }
    else {
        static NSString *cellIdentifier = @"Cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.backgroundColor = [UIColor clearColor];
            cell.textLabel.font = [UIFont systemFontOfSize:21];
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
            cell.selectedBackgroundView = [[UIView alloc] init];
        }
        
        NSArray *title = @[@"Home", @"Upload", @"My Images", @"Favorites", @"Following", @"Followers", @"Log Out"];
        
        cell.textLabel.text = title[indexPath.row - 1];
        FAKFontAwesome *icon = [FAKFontAwesome new];
        switch (indexPath.row) {
            case 1:
                icon = [FAKFontAwesome homeIconWithSize:24];
                break;
            case 2:
                icon = [FAKFontAwesome uploadIconWithSize:24];
                break;
            case 3:
                icon = [FAKFontAwesome imageIconWithSize:24];
                break;
            case 4:
                icon = [FAKFontAwesome heartIconWithSize:24];
                break;
            case 5:
                icon = [FAKFontAwesome linkIconWithSize:24];
                break;
            case 6:
                icon = [FAKFontAwesome groupIconWithSize:24];
                break;
            case 7:
                icon = [FAKFontAwesome userIconWithSize:24];
                break;
            default:
                break;
        }
        [icon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        cell.imageView.image = [icon imageWithSize:CGSizeMake(24, 24)];
        return cell;
    }
}
  



/**
 *  Creating an alert view to ask for user's input on the image source
 */
- (void)imageUpLoadSource{
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    [alert addButton:@"Camera" actionBlock:^{
        //Setting the pickerDelegate and allow editting.
        self.imagePickerController.delegate = self;
        self.imagePickerController.allowsEditing = YES;
        
        //Setting the source of the image as type Camera.
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:self.imagePickerController animated:YES completion:nil];
    }];
    
    [alert addButton:@"Photo" actionBlock:^{
        self.imagePickerController.delegate = self;
        self.imagePickerController.allowsEditing = YES;
        
        //Setting the source type as Photo library
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.imagePickerController animated:YES completion:nil];
    }];
    
    [alert showInfo:@"Profile Picture" subTitle:@"Please choose where you want to upload your profile picture from." closeButtonTitle:@"Dimiss" duration:0];
}

#pragma mark - UIImage picker protocols
/**
 *  Handling the image after selection is performed.
 *
 *  @param picker The image picker
 *  @param info   Info of the selected image
 */
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    //Below section is for face detection in image with Core Image.
    self.selectedImage = info[UIImagePickerControllerEditedImage];
    [self.tableView reloadData];
    [picker dismissViewControllerAnimated:YES completion:^{
        NSString *fileName = [NSString stringWithFormat:@"%@profilPic.png", [PFUser currentUser].objectId];
        NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"upload-profilePic.tmp"];
        NSLog(@"filepath %@", filePath);
        
        NSData * imageData = UIImagePNGRepresentation(self.selectedImage);
        
        [imageData writeToFile:filePath atomically:YES];
        
        AWSS3TransferManagerUploadRequest *uploadRequest = [AWSS3TransferManagerUploadRequest new];
        uploadRequest.body = [NSURL fileURLWithPath:filePath];
        uploadRequest.key = fileName;
        uploadRequest.contentType = @"image/png";
        uploadRequest.bucket = @"fissamplebucket";
        NSLog(@"Profile picture uploadRequest: %@", uploadRequest);
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [DataStore uploadPictureToAWS:uploadRequest WithCompletion:^(BOOL complete) {
            NSLog(@"Profile picture upload completed!");
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }];
        }];
    }];
}

/**
 *  Dimissing picker view if user cancels image select.
 *
 *  @param picker UIImagePickerCcontroller
 */
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end

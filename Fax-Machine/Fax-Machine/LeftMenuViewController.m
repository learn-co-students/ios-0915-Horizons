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

@interface LeftMenuViewController ()

@property (nonatomic, readwrite, strong) UITableView *tableView;
@property (nonatomic, strong) DataStore *store;

@property (nonatomic, strong) UIAlertController *sourcePicker;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) UIImage *selectedImage;

@end

@implementation LeftMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //Initiating the image picker controller.
    self.imagePickerController = [UIImagePickerController new];
    
    self.store = [DataStore sharedDataStore];
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height - (54 * 6 + 46)) / 2.0f, self.view.frame.size.width, 54 * 6 + 46) style:UITableViewStylePlain];
        
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
            
            imageViewVC.isFavorite = NO;
            
            [self.sideMenuViewController setContentViewController:navController];
            break;
        }
        case 2:
        {
            [self presentViewController:[uploadImage instantiateViewControllerWithIdentifier:@"imageUpload"] animated:YES completion:nil];
            break;
        }
        case 3:
        {
            [self presentViewController:[[UIStoryboard storyboardWithName:@"CollectionView" bundle:nil] instantiateViewControllerWithIdentifier:@"homeViewController"] animated:YES completion:nil];
            break;
        }
        case 4:
        {
            [self.store.favoriteImages removeAllObjects];
            navController = [[UINavigationController alloc] initWithRootViewController:imageViewVC];
            navController.navigationBar.shadowImage = [UIImage new];
            navController.navigationBar.translucent = YES;
            navController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
            [self.store getFavoriteImagesWithSuccess:^(BOOL success) {
                if (success) {
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        [self.sideMenuViewController hideMenuViewController];
                        imageViewVC.isFavorite = YES;
                        [self.sideMenuViewController setContentViewController:navController];
                    }];
                }
            }];
            break;
        }
        case 5:
        {
            [self.store logoutWithSuccess:^(BOOL success) {
                [self.store.downloadedPictures removeAllObjects];
                [self.store.comments removeAllObjects];
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
    return 6;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0) {
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
        
        NSString *path = [[NSUserDefaults standardUserDefaults] objectForKey:@"profilePic"];
        if (path == nil) {
            ourImageView.image = [UIImage imageNamed:@"profile_placeholder"];
        }else if (self.selectedImage){
            ourImageView.image = self.selectedImage;
        }else{
            ourImageView.image = [UIImage imageWithContentsOfFile:path];
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
        
        NSArray *title = @[@"Home", @"Upload", @"My Images", @"Favorites", @"Log Out"];
        
        cell.textLabel.text = title[indexPath.row - 1];
        FAKFontAwesome *icon = [FAKFontAwesome new];
        switch (indexPath.row) {
            case 1:
                icon = [FAKFontAwesome homeIconWithSize:24];
                [icon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
                cell.imageView.image = [icon imageWithSize:CGSizeMake(24, 24)];
                break;
            case 2:
                icon = [FAKFontAwesome uploadIconWithSize:24];
                [icon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
                cell.imageView.image = [icon imageWithSize:CGSizeMake(24, 24)];
                break;
            case 3:
                icon = [FAKFontAwesome imageIconWithSize:24];
                [icon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
                cell.imageView.image = [icon imageWithSize:CGSizeMake(24, 24)];
                break;
            case 4:
                icon = [FAKFontAwesome archiveIconWithSize:24];
                [icon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
                cell.imageView.image = [icon imageWithSize:CGSizeMake(24, 24)];
                break;
            case 5:
                icon = [FAKFontAwesome userIconWithSize:24];
                [icon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
                cell.imageView.image = [icon imageWithSize:CGSizeMake(24, 24)];
                break;
            default:
                break;
        }
        
        return cell;
    }
}


/**
 *  Creating an alert view to ask for user's input on the image source
 */
- (void)imageUpLoadSource{
    
    //UIAlertController to fetch user input
    self.sourcePicker = [UIAlertController alertControllerWithTitle:@"Image Source" message:@"Please choose where you want to pull your image" preferredStyle:UIAlertControllerStyleAlert];
    
    //Setting the Camera source option
    //***Reminder*** camera source does not work in simulator.
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"📷" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //Setting the pickerDelegate and allow editting.
        self.imagePickerController.delegate = self;
        self.imagePickerController.allowsEditing = YES;
        
        //Setting the source of the image as type Camera.
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:self.imagePickerController animated:YES completion:nil];
    }];
    
    //Setting the Photo library as the source of the image
    UIAlertAction *photo = [UIAlertAction actionWithTitle:@"🖼" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        self.imagePickerController.delegate = self;
        self.imagePickerController.allowsEditing = YES;
        
        //Setting the source type as Photo library
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.imagePickerController animated:YES completion:nil];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    //Adding all the actions to the UIAlerController.
    [self.sourcePicker addAction:camera];
    [self.sourcePicker addAction:photo];
    [self.sourcePicker addAction:cancel];
    
    [self presentViewController:self.sourcePicker animated:YES completion:nil];
    
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
        NSData *imageData = UIImagePNGRepresentation(self.selectedImage);
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *profilePicDirectory = [paths objectAtIndex:0];
        NSString *imagePath = [profilePicDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", @"cached"]];
        
        NSLog(@"Writing profile pic to local");
        if (![imageData writeToFile:imagePath atomically:NO]) {
            NSLog(@"Failed to cached!");
        }else{
            NSLog(@"The cached image path is: %@", imagePath);
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:imagePath forKey:@"profilePic"];
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

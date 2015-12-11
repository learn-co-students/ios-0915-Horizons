//
//  FollowingListTableViewController.m
//  Fax-Machine
//
//  Created by Kevin Lin on 12/5/15.
//  Copyright © 2015 Flatiron-School. All rights reserved.
//

#import "FollowingListTableViewController.h"
#import <SCLAlertView-Objective-C/SCLAlertView.h>

@interface FollowingListTableViewController ()

@property (nonatomic, strong) ImagesViewController *imageVC;
@property (weak, nonatomic) IBOutlet UIView *uhoView;
@property (weak, nonatomic) IBOutlet UILabel *uhoLabel;
@property (weak, nonatomic) IBOutlet UILabel *frownFace;

@end

@implementation FollowingListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataStore = [DataStore sharedDataStore];
    self.imageVC = self.dataStore.controllers[0];
    

  self.tableView.backgroundColor = [UIColor clearColor];
    FAKFontAwesome *navIcon = [FAKFontAwesome naviconIconWithSize:35];
    FAKFontAwesome *homeIcon = [FAKFontAwesome homeIconWithSize:35];
    self.navigationItem.leftBarButtonItem.image = [navIcon imageWithSize:CGSizeMake(35, 35)];
    self.navigationItem.rightBarButtonItem.image = [homeIcon imageWithSize:CGSizeMake(35, 35)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
  
  self.uhoLabel.text = self.uhoString;
  FAKIcon *frown = [FAKFontAwesome frownOIconWithSize:40];
  self.frownFace.attributedText = [frown attributedString];
  
  NSArray *array = [[NSArray alloc]init];
  [array sortedArrayUsingSelector:@selector(ascending)];
  
  
  
}

- (IBAction)displayMenu:(id)sender {
    [self.sideMenuViewController presentLeftMenuViewController];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (self.followingList.count == 0) {
    self.uhoView.hidden = NO;
  } else {
    self.uhoView.hidden = YES;
  }
    return self.followingList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FollowingListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"owner" forIndexPath:indexPath];
    
    cell.frame = CGRectMake(0, 0, self.tableView.frame.size.width, 120);
    cell.backgroundColor = [UIColor colorWithWhite:0.95 alpha:0.85];
    if (indexPath.row % 2) {
        cell.backgroundColor = [UIColor colorWithWhite:0.85 alpha:0.85];
    }
    
    PFUser *owner = [self.followingList objectAtIndex:indexPath.row];
    NSString *urlString = [NSString stringWithFormat:@"%@%@profilPic.png", IMAGE_FILE_PATH, owner.objectId];
    NSURL *profileUrl = [NSURL URLWithString:urlString];
    
    UIImageView *ourImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 120, 120)];
    ourImageView.layer.cornerRadius = 60;
    ourImageView.layer.masksToBounds = YES;
    ourImageView.layer.borderWidth = 1;
    ourImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [cell.contentView addSubview: ourImageView];
    
    [ourImageView yy_setImageWithURL:profileUrl placeholder:[UIImage imageNamed:@"profile_placeholder"]];
    NSString *name = [owner.email componentsSeparatedByString:@"@"][0];
    cell.followingListName.text = name;
    cell.followingListName.font = [UIFont systemFontOfSize:20 weight:0.75];
    cell.followingListEmail.text = owner.email;
    NSArray *myImages = owner[@"myImages"];
    cell.followingListNumberOfImages.text = [NSString stringWithFormat:@"Images: %lu", (unsigned long)myImages.count];
    
    cell.followingListTotalLikes.text = @"Followers: 0";
    [self.dataStore getFollowersWithUserId:owner.objectId success:^(BOOL success) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            cell.followingListTotalLikes.text = [NSString stringWithFormat:@"Followers: %lu", (unsigned long)self.dataStore.followerCount];
        }];
    }];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.imageVC.isConnected == -1) {
        SCLAlertView *disconnectionAlert = [[SCLAlertView alloc] initWithNewWindow];
        [disconnectionAlert showError:@"Network Failure" subTitle:@"Sorry you have disconnected from the internet." closeButtonTitle:@"Okay" duration:0];
    }else{
        [self.dataStore.followingOwnerImageList removeAllObjects];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"owner = %@", self.followingList[indexPath.row]];
        
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self.imageVC];
        navController.navigationBar.shadowImage = [UIImage new];
        navController.navigationBar.translucent = YES;
        navController.navigationBar.barStyle = UIBarStyleBlackTranslucent;

        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.dataStore downloadPicturesToDisplay:100 predicate:predicate WithCompletion:^(BOOL complete) {

            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                self.imageVC.isFollowing = complete;
                [self.sideMenu hideMenuViewController];
                [self.sideMenu setContentViewController:navController];
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
        }];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 138;
}


@end

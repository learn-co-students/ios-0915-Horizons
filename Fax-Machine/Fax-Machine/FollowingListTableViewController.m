//
//  FollowingListTableViewController.m
//  Fax-Machine
//
//  Created by Kevin Lin on 12/5/15.
//  Copyright © 2015 Flatiron-School. All rights reserved.
//

#import "FollowingListTableViewController.h"

@interface FollowingListTableViewController ()

@property (nonatomic, strong) ImagesViewController *imageVC;
@property (weak, nonatomic) IBOutlet UIView *uhoView;
@property (weak, nonatomic) IBOutlet UILabel *uhoLabel;

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
}

- (IBAction)displayMenu:(id)sender {
    NSLog(@"Menu tapped");
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

    //NSLog(@"Predicate: %@", self.followingList[indexPath.row]);
    [self.dataStore.followingOwnerImageList removeAllObjects];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"owner = %@", self.followingList[indexPath.row]];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self.imageVC];
    navController.navigationBar.shadowImage = [UIImage new];
    navController.navigationBar.translucent = YES;
    navController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    //NSLog(@"Indexpath: %lu", indexPath.row);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.dataStore downloadPicturesToDisplay:100 predicate:predicate WithCompletion:^(BOOL complete) {
        //[self presentViewController:imageVC animated:YES completion:nil];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            //NSLog(@"Returned images: %lu", self.dataStore.followingOwnerImageList.count);
            self.imageVC.isFollowing = complete;
            [self.sideMenu hideMenuViewController];
            [self.sideMenu setContentViewController:navController];
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 138;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

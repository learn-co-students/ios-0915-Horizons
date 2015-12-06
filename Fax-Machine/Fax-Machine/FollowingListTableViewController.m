//
//  FollowingListTableViewController.m
//  Fax-Machine
//
//  Created by Kevin Lin on 12/5/15.
//  Copyright © 2015 Flatiron-School. All rights reserved.
//

#import "FollowingListTableViewController.h"

@interface FollowingListTableViewController ()

@end

@implementation FollowingListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"mountains_hd"]];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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
    
    UIImageView *ourImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 25, 120, 120)];
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
    cell.followingListNumberOfImages.text = [NSString stringWithFormat:@"Images: %lu", [owner[@"myImages"] count]];
    //cell.followingListTotalLikes.text = [NSString stringWithFormat:@"Total of likes: %@", owner[@"likes"]]
    
    return cell;
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

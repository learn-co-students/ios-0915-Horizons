//
//  FollowingListTableViewCell.h
//  Fax-Machine
//
//  Created by Kevin Lin on 12/5/15.
//  Copyright © 2015 Flatiron-School. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FollowingListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *followingListImageView;
@property (weak, nonatomic) IBOutlet UILabel *followingListName;
@property (weak, nonatomic) IBOutlet UILabel *followingListEmail;
@property (weak, nonatomic) IBOutlet UILabel *followingListNumberOfImages;
@property (weak, nonatomic) IBOutlet UILabel *followingListTotalLikes;

@end
